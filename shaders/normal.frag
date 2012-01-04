#version 110

uniform int numLights;

uniform sampler2D colorTex;
uniform sampler2D normalTex;

varying vec3 lights[gl_MaxLights];  // light direction vector in tangent space
varying vec3 eye;                   // eye direction vector in tangent space

void main()
{
	vec4 texColor  = texture2D(colorTex,  vec2(gl_TexCoord[0].st));
	vec3 texNormal = texture2D(normalTex, vec2(gl_TexCoord[0].st)).xyz;

	vec3  nnormal    = normalize(texNormal * 2.0 - 1.0);
	vec3  neye       = normalize(eye);

	vec3  lightColor = vec3(0, 0, 0);

	for(int i = 0; i < numLights; i++) {
		vec3  nlight     = normalize(lights[i]);
		float idiffuse   = max(dot(nlight, nnormal), 0.0);
		float ispecular  = pow(clamp(dot(-reflect(nlight, nnormal), neye), 0.0, 1.0), gl_FrontMaterial.shininess);

		vec3 diffuse  = gl_FrontLightProduct[i].diffuse.rgb  * idiffuse;
		vec3 specular = gl_FrontLightProduct[i].specular.rgb * ispecular * idiffuse;
		vec3 ambient  = gl_FrontLightProduct[i].ambient.rgb  + gl_FrontLightModelProduct.sceneColor.rgb;

		lightColor += clamp(ambient + diffuse + specular, 0.0, 1.0);
	}
	gl_FragColor = vec4(lightColor * texColor.rgb, texColor.a);
}
