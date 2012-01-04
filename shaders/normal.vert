#version 110

uniform int numLights;

varying vec3 lights[gl_MaxLights];  // light direction vector in tangent space
varying vec3 eye;                   // eye direction vector in tangent space

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
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

	// http://www.ozone3d.net/tutorials/bump_mapping_p4.php
	vec3 n = gl_NormalMatrix * gl_Normal;
	vec3 t = normalize(gl_NormalMatrix * tangent());
	vec3 b = cross(n, t);

	vec3 vertex = vec3(gl_ModelViewMatrix * gl_Vertex);
	vec3 tmp;

	for(int i = 0; i < numLights; i++) {
		tmp = gl_LightSource[i].position.xyz - vertex;
		lights[i] = vec3(
			dot(tmp, t),
			dot(tmp, b),
			dot(tmp, n));
	}

	tmp = -vertex;
	eye = vec3(
		dot(tmp, t),
		dot(tmp, b),
		dot(tmp, n));
}
