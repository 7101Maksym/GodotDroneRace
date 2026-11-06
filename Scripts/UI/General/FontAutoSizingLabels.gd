extends Label

# Максимальный (исходный) размер шрифта
@export var max_font_size: int = 32
# Минимальный размер, ниже которого шрифт не будет опускаться
@export var min_font_size: int = 12

# Переопределяем встроенное свойство text, чтобы при его изменении вызывался перерасчет
@export var text_auto_shrink: String:
	set(value):
		text = ""
		text = value
		update_font_size()

func _ready() -> void:
	clip_text = true 
	
	# Сигнал resized оставляем — он нужен, если сам Label растягивается контейнером
	resized.connect(update_font_size)
	
	# Запускаем первичный расчет
	update_font_size()

func update_font_size() -> void:
	# Проверяем, готова ли нода внутри дерева сцены, чтобы избежать ошибок при старте
	if not is_node_ready() or text.is_empty():
		return
		
	var current_size = max_font_size
	add_theme_font_size_override("theme_override_font_sizes/font_size", current_size)
	
	# Получаем объект шрифта
	var font = get_theme_font("font")
	
	# Цикл уменьшает шрифт, пока текст шире, чем сам прямоугольник Label
	while font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, current_size).x > size.x:
		current_size -= 1
		if current_size <= min_font_size:
			current_size = min_font_size
			break
			
	# Применяем финальный подогнанный размер
	add_theme_font_size_override("font_size", current_size)
