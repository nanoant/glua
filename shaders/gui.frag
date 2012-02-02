#if __VERSION__ >= 150
out vec4 fragColor;
#else
// compatibility mode
#define in varying
#define texture texture2DRect
#define fragColor gl_FragColor
#endif

uniform sampler2DRect tex;
uniform vec4 color;
uniform bool alphaOnly;

in vec2 fragTexCoord;

void main()
{
	fragColor = alphaOnly ? vec4(color.rgb, color.a * texture(tex, fragTexCoord).a) : color * texture(tex, fragTexCoord);
}
