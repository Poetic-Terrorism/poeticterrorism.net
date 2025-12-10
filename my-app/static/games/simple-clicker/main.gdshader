shader_type canvas_item;

// ノイズの強さを調整するパラメータ（0.0〜1.0）
uniform float static_amount : hint_range(0.0, 1.0) = 0.5;
// ノイズの色（少し青みがかった白など）
uniform vec4 static_color : source_color = vec4(0.8, 0.9, 1.0, 1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    // 時間経過(TIME)を使ってランダムな値を作る
    float noise = random(UV * TIME);
    
    // ノイズがある部分とない部分を混ぜる
    vec4 final_color = static_color;
    final_color.a = noise * static_amount; // アルファ値（透明度）にノイズを適用
    
    COLOR = final_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
