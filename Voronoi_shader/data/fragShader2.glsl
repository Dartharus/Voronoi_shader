#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 resolution;
uniform float time;

uniform float seedsX[32];
uniform float seedsY[32];

uniform float colour;

#define PROCESSING_LIGHT_SHADER
varying vec4 position;
varying vec3 objectCoord;

varying vec3 normalInterp;
varying vec3 vertPos;

uniform int lightCount;
uniform vec4 lightPosition;

const vec3 ambientColor = vec3(0.5, 0.5, 0.5);
const vec3 diffuseColor = vec3(0.5, 0.5, 0.5);
const vec3 specColor = vec3(1.0, 1.0, 1.0);
const float shininess = 16.0;

void main()
{
	float lightR = 0.0;
	float lightG = 0.0;
	float lightB = 0.0;
	
	vec3 normal = normalize(normalInterp);
	vec3 lightDir = normalize(lightPosition.xyz - vertPos);

	float lambertian = max(dot(lightDir,normal), 0.0);
	float specular = 0.0;
	if(lambertian > 0.0) {
		vec3 viewDir = normalize(-vertPos);
		vec3 reflectDir = reflect(-lightDir, normal);
		float specAngle = max(dot(reflectDir, viewDir), 0.0);
		specular = pow(specAngle, shininess/4.0);
	}
	vec3 lightColor = ambientColor +
			lambertian * diffuseColor +
            specular * specColor;

	lightR += lightColor.x;
	lightG += lightColor.y;
	lightB += lightColor.z;
	
	vec2 xy = objectCoord.xy/resolution.xy;
	
    xy.x *= resolution.x/resolution.y;
	
    vec3 color = vec3(.0);	//default setting
	//vec3 color = lightDir;	//different color depending on angle of where the light is
	
	vec2 seeds[32];
	for(int i = 0; i < 32; i++)
	{
		seeds[i] = vec2(seedsX[i],seedsY[i]);
	}
	
	float mindist = lambertian; // point light projects the pattern
	//float mindist = 1.;  // minimum distance default setting
	
    vec2 minpoint;        // minimum position
	
	for (int i = 0; i < 32; i++) {
        float dist = distance(xy, seeds[i]);
        if ( dist < mindist ) {
            // Keep the closer distance
            mindist = dist;

            // Kepp the position of the closer point
            minpoint = seeds[i];
        }
    }
	//color += mindist*2.;
	color.rg = minpoint;
	color -= 1.-step(.001, mindist)-0.5;	//set seed point to black
	
	if(mindist > colour)	//change in color for animation
	{
		color = vec3(0.0,0.0,0.0);
	}
  
    gl_FragColor = vec4(lightR*color.r, lightG*color.g, lightB*color.b, 1.0);
			
}
