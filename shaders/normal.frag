#version 150 core

uniform int numLights;

uniform vec3 lightDiffuse[gl_MaxLights];
uniform vec3 lightSpecular[gl_MaxLights];
uniform vec3 lightAmbient[gl_MaxLights];

uniform vec3  materialDiffuse;
uniform vec3  materialSpecular;
uniform vec3  materialAmbient;
uniform float materialShininess;

uniform sampler2D colorTex;
uniform sampler2D normalTex;

in vec3 lightDirection[gl_MaxLights]; // light direction vector in tangent space
in vec3 eyeDirection;                 // eye direction vector in tangent space
in vec2 fragTexCoord;

out vec4 fragColor;

void main()
{
	vec4 texColor   = texture(colorTex,  fragTexCoord);
	vec3 normal     = texture(normalTex, fragTexCoord).xyz;

	vec3 nnormal    = normalize(normal * 2.0 - 1.0);
	vec3 neye       = normalize(eyeDirection);

	vec3 lightColor = vec3(0, 0, 0);

	for(int i = 0; i < numLights; i++) {
		vec3  nlight     = normalize(lightDirection[i]);
		float idiffuse   = max(dot(nlight, nnormal), 0.0);
		float ispecular  = pow(clamp(dot(-reflect(nlight, nnormal), neye), 0.0, 1.0), materialShininess);

		vec3 diffuse     = materialDiffuse  * lightDiffuse[i]  * idiffuse;
		vec3 specular    = materialSpecular * lightSpecular[i] * ispecular * idiffuse;
		vec3 ambient     = materialAmbient  * lightAmbient[i];

		lightColor += clamp(ambient + diffuse + specular, 0.0, 1.0);
	}
	fragColor = vec4(lightColor * texColor.rgb, texColor.a);
}
