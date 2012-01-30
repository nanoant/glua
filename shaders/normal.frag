#version 110

uniform int numLights;

uniform vec3 lightDiffuse[gl_MaxLights];
uniform vec3 lightSpecular[gl_MaxLights];
uniform vec3 lightAmbient[gl_MaxLights];

uniform vec3 matDiffuse;
uniform vec3 matSpecular;
uniform vec3 matAmbient;
uniform float matShininess;

uniform sampler2D colorTex;
uniform sampler2D normalTex;

varying vec3 lightDirection[gl_MaxLights]; // light direction vector in tangent space
varying vec3 eyeDirection;                 // eye direction vector in tangent space

void main()
{
	vec4 texColor   = texture2D(colorTex,  vec2(gl_TexCoord[0].st));
	vec3 texNormal  = texture2D(normalTex, vec2(gl_TexCoord[0].st)).xyz;

	vec3 nnormal    = normalize(texNormal * 2.0 - 1.0);
	vec3 neye       = normalize(eyeDirection);

	vec3 lightColor = vec3(0, 0, 0);

	for(int i = 0; i < numLights; i++) {
		vec3  nlight     = normalize(lightDirection[i]);
		float idiffuse   = max(dot(nlight, nnormal), 0.0);
		float ispecular  = pow(clamp(dot(-reflect(nlight, nnormal), neye), 0.0, 1.0), matShininess);

		vec3 diffuse     = matDiffuse  * lightDiffuse[i]  * idiffuse;
		vec3 specular    = matSpecular * lightSpecular[i] * ispecular * idiffuse;
		vec3 ambient     = matAmbient  * lightAmbient[i];

		lightColor += clamp(ambient + diffuse + specular, 0.0, 1.0);
	}
	gl_FragColor = vec4(lightColor * texColor.rgb, texColor.a);
}
