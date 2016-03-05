#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D diffuseTex;
uniform sampler2D normalTex;
varying vec2 texCoords;
varying float vAngle;
//varying float vAlpha;//TODO?

uniform vec3 lightPos;
uniform vec4 lightColor;      //light RGBA -- alpha is intensity
uniform vec2 resolution;      //resolution of screen need to know the position of the pixel
uniform vec4 ambientColor;    //ambient RGBA -- alpha is intensity
uniform vec3 falloff;

vec2 rotate(vec2 p, float a)
{
return vec2(p.x * cos(a) - p.y * sin(a), p.x * sin(a) + p.y * cos(a));
}
	
void main(void)
{
	//vec3 texNormal =  texture2D (uNormals, vTexCoord).rgb;
	//vec4 texColor =  texture2D (uColors, vTexCoord).rgba;
	vec3 texNormal =  texture2D (normalTex, texCoords).rgb;
	vec4 texColor =  texture2D (diffuseTex, texCoords).rgba;

	//texColor = texColor * vAlpha;

	vec3 lightDir = vec3(lightPos.x / resolution.x, 1.0 - (lightPos.y / resolution.y), lightPos.z);
	lightDir = vec3(lightDir.xy - (gl_FragCoord.xy / resolution.xy), lightDir.z);

	// vec2 rotated = rotate(vec2(lightDir.x,lightDir.y),vAngle);
	// lightDir.x = rotated.x;
	// lightDir.y = rotated.y;

	float aspectRatio = resolution.x / resolution.y;
	
	float cosR = cos(-vAngle);
	float sinR = sin(-vAngle);
	float lightDirX = lightDir.x;
	lightDir.x = (lightDir.x * cosR - lightDir.y * sinR) * aspectRatio;
	lightDir.y = lightDirX * sinR + lightDir.y * cosR;

	
	float D = length(lightDir);

	vec3 N = normalize(texNormal * 2.0 - 1.0);
	vec3 L = normalize(lightDir);

	vec3 diffuse = (lightColor.rgb * lightColor.a) * max(dot(N, L), 0.0);
	vec3 ambient = ambientColor.rgb * ambientColor.a;
	float attenuation = 1.0 / ( falloff.x + (falloff.y*D) + (falloff.z*D*D) );

	vec3 intensity = ambient + diffuse * attenuation;
	vec3 finalColor = texColor.rgb * intensity;
	gl_FragColor = vec4(finalColor, texColor.a);
}