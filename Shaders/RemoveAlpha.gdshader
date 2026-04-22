shader_type canvas_item;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    if (col.a > 0.0) {
        col.a = 1.0;
    }
    COLOR = col;
}