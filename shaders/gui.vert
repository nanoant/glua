#if __VERSION__ < 150
// compatibility mode
#define in  attribute
#define out varying
#endif

uniform mat4 modelViewProjectionMatrix;

in vec3 position;
in vec2 texCoord;

out vec2 fragTexCoord;

void main()
{
	fragTexCoord = texCoord;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1);
}
