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
uniform bool alphaMask;

in vec2 fragTexCoord;

void main()
{
	fragColor = alphaMask ? vec4(color.rgb, color.a * texture(tex, fragTexCoord).r) : color * texture(tex, fragTexCoord);
}
