#define PROCESSING_LIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;

varying vec4 col;
varying vec4 position;
varying vec3 objectCoord;

varying vec3 normalInterp;
varying vec3 vertPos;

void main(){

	gl_Position = transform*vertex;
	position = gl_Position;
	objectCoord = vertex.xyz;
	
  vec4 vertPos4 = modelview * vec4(vertex.xyz, 1.0);
  vertPos = vec3(vertPos4) / vertPos4.w;
  normalInterp = vec3(normalMatrix * normal);	
}