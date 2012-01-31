#version 150 core

uniform int numLights;

uniform mat4 projectionMatrix;
uniform mat4 lightMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec3 lightPosition[gl_MaxLights];

in vec3 position;
in vec3 normal;
in vec2 texCoord;

out vec3 lightDirection[gl_MaxLights]; // light direction vector in tangent space
out vec3 eyeDirection;                 // eye direction vector in tangent space
out vec2 fragTexCoord;

// TODO: replace with the precalculated version
vec3 tangent()
{
	vec3 tangent;
	vec3 c1 = cross(normal, vec3(0.0, 0.0, 1.0));
	vec3 c2 = cross(normal, vec3(0.0, 1.0, 0.0));
	
	if(length(c1) > length(c2)) {
		tangent = c1;
	} else {
		tangent = c2;
	}
	return normalize(tangent);
}

void main()
{
	fragTexCoord = texCoord;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1);

	// http://www.ozone3d.net/tutorials/bump_mapping_p4.php
	vec3 n = normalMatrix * normal;
	vec3 t = normalize(normalMatrix * tangent());
	vec3 b = cross(n, t);

	vec3 vertex = vec3(modelViewMatrix * vec4(position, 1));
	vec3 tmp;

	for(int i = 0; i < numLights; i++) {
		tmp = (lightMatrix * vec4(lightPosition[i], 1)).xyz - vertex;
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
