#ifdef GL_ES
precision highp float;
#endif

attribute vec2 pos;
attribute vec2 tex;
attribute float angle;

varying vec2 texCoords;
varying float vAngle;

uniform mat4 MVP;

void kore() {
	texCoords = tex;
	vAngle = angle;
	gl_Position = MVP * vec4(pos, 0.0, 1.0);
}
