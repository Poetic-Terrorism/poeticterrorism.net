shader_type canvas_item;

// ▼▼▼ 修正箇所：Godot 4.x で画面を取得するために必要な宣言を追加 ▼▼▼
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
// ▲▲▲▲▲▲

// --- パラメータ設定 ---
// スキャンラインの密度
uniform float scanline_count : hint_range(100.0, 2000.0) = 600.0;
// スキャンラインの濃さ
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.3;

// 画面の湾曲具合
uniform float curvature : hint_range(0.0, 0.2) = 0.03;
// 画面端の暗さ（ビネット効果）
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.2;


// 画面を湾曲させる関数
vec2 curve(vec2 uv) {
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) * curvature), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) * curvature), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}

void fragment() {
    // 1. 画面の湾曲を適用したUV座標を計算
    vec2 warped_uv = curve(UV);
    
    // 2. 元の画面の色を取得
    vec4 color = texture(SCREEN_TEXTURE, warped_uv);

    // 湾曲によって画面外にはみ出た部分を黒くする
    if (warped_uv.x < 0.0 || warped_uv.x > 1.0 || warped_uv.y < 0.0 || warped_uv.y > 1.0) {
        color = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // --- スキャンライン処理 ---
        float scanline = sin(warped_uv.y * scanline_count * 3.14159 * 2.0);
        scanline = smoothstep(0.5, 1.0, scanline * 0.5 + 0.5);
        color.rgb *= mix(1.0, scanline, 1.0 - scanline_opacity);
        
        // --- ビネット処理 ---
        float vignette = distance(warped_uv, vec2(0.5));
        color.rgb *= 1.0 - (vignette * vignette_opacity);
    }
    
    COLOR = color;
}