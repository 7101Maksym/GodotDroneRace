extends Button

# Максимальный (исходный) размер шрифта
@export var max_font_size: int = 32
# Минимальный размер, ниже которого шрифт не будет опускаться
@export var min_font_size: int = 12

# Буфер безопасности в пикселях (чтобы буквы точно не съедались)
@export var safety_margin: float = 8.0

# Флаг для предотвращения бесконечной рекурсии
var is_updating: bool = false

# Переопределяем свойство text для автоматического перерасчета
@export var text_auto_shrink: String:
	set(value):
		text = value
		update_font_size()

func _ready() -> void:
	clip_text = true
	# Сигнал resized нужен, если кнопка меняет размер в контейнере
	resized.connect(update_font_size)
	# Первичный расчет
	update_font_size()

func update_font_size() -> void:
	# Если расчет уже идет, или нода не готова, или нет текста — выходим
	if is_updating or not is_node_ready() or text.is_empty():
		return
		
	# Включаем блокировку
	is_updating = true
	
	var current_size = max_font_size
	add_theme_font_size_override("font_size", current_size)
	
	# Получаем объект шрифта
	var font = get_theme_font("font")
	
	# Вычисляем доступную ширину для текста внутри кнопки
	var available_width = size.x - get_total_padding()
	
	# ВАЖНО: Получаем локализованный текст для правильного расчета длины
	var localized_text = tr(text)
	
	# Предотвращаем зацикливание, если ширина кнопки стала нулевой или отрицательной в контейнере
	if available_width > 0:
		# Цикл уменьшает шрифт, используя локализованный текст + добавляет safety_margin
		while font.get_string_size(localized_text, alignment, -1, current_size).x + safety_margin > available_width:
			current_size -= 1
			if current_size <= min_font_size:
				current_size = min_font_size
				break
	else:
		current_size = min_font_size
			
	# Применяем финальный подогнанный размер
	add_theme_font_size_override("font_size", current_size)
	
	# Выключаем блокировку
	is_updating = false

# Функция для точного расчета свободной ширины с учетом стилей и иконок
func get_total_padding() -> float:
	var total_padding: float = 0.0
	
	# Учитываем внутренние отступы StyleBox (Theme Overrides или текущая тема)
	var current_style = get_theme_stylebox("normal")
	if current_style:
		total_padding += current_style.content_margin_left + current_style.content_margin_right
		
	# Учитываем ширину иконки и расстояние от нее до текста, если она есть
	if icon:
		total_padding += icon.get_width()
		total_padding += get_theme_constant("h_separation")
		
	return total_padding

# Пересчитываем размер шрифта при смене языка в игре
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_font_size()
