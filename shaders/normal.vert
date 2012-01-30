#version 110

uniform int numLights;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec3 lightPosition[gl_MaxLights];

varying vec3 lightDirection[gl_MaxLights]; // light direction vector in tangent space
varying vec3 eyeDirection;                 // eye direction vector in tangent space

attribute vec3 vertex;
attribute vec2 texCoord;
attribute vec3 normal;

// TODO: replace with the precalculated version
vec3 tangent()
{
	vec3 tangent;
	vec3 c1 = cross(gl_Normal, vec3(0.0, 0.0, 1.0));
	vec3 c2 = cross(gl_Normal, vec3(0.0, 1.0, 0.0));
	
	if(length(c1) > length(c2)) {
		tangent = c1;
	} else {
		tangent = c2;
	}
	return normalize(tangent);
}

void main()
{
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1);

	// http://www.ozone3d.net/tutorials/bump_mapping_p4.php
	vec3 n = normalMatrix * normal;
	vec3 t = normalize(normalMatrix * tangent());
	vec3 b = cross(n, t);

	vec3 vertex = vec3(modelViewMatrix * vec4(vertex, 1));
	vec3 tmp;

	for(int i = 0; i < numLights; i++) {
		tmp = lightPosition[i] - vertex;
		lightDirection[i] = vec3(
			dot(tmp, t),
			dot(tmp, b),
			dot(tmp, n));
	}

	tmp = -vertex;
	eyeDirection = vec3(
		dot(tmp, t),
		dot(tmp, b),
		dot(tmp, n));
}
