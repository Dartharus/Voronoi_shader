import peasy.*;
import controlP5.*;
PShader shader;
PShader shader2;
PShader shader3;
PeasyCam cam;
ControlP5 gui;

float[] seedsX = new float[32];
float[] seedsY = new float[32];
float colour = 0.001;

float tx = 0;
float ty = 1000;

boolean toggleObject = false;

int toggleShader = 0;

void setup(){
  size(800,800,P3D);  
  shader = loadShader("fragShader.glsl","vertexShader.glsl");
  shader2 = loadShader("fragShader2.glsl","vertexShader.glsl");
  shader3 = loadShader("fragShader3.glsl","vertexShader.glsl");

  cam = new PeasyCam(this, 0, 0, 0, 1500);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
  
  gui = new ControlP5(this);
  //add buttons
  gui.addButton("redraw_random").setValue(0).setPosition(width/2-300,0).setSize(100,100);
  gui.addButton("redraw_perlin").setValue(0).setPosition(width/2-200,0).setSize(100,100);
  gui.addButton("toggle_object").setValue(0).setPosition(width/2-100,0).setSize(100,100);
  gui.addButton("reset_light").setValue(0).setPosition(width/2,0).setSize(100,100);
  gui.addButton("toggle_light").setValue(0).setPosition(width/2+100,0).setSize(100,100);
  gui.addButton("toggle_color").setValue(0).setPosition(width/2+200,0).setSize(100,100);
  gui.setAutoDraw(false);

  //first run seed positions are randomed using perlin noise
  for(int i = 0; i < 32; i++)
  {
    seedsX[i] = map(noise(tx),0,1,-0.5,0.5);
    seedsY[i] = map(noise(ty),0,1,-0.5,0.5);
    tx += 1;
    ty += 1;
  }
  //assign seed coordinates to shader
  shader.set("seedsX",seedsX);
  shader.set("seedsY",seedsY);
  shader2.set("seedsX",seedsX);
  shader2.set("seedsY",seedsY);
  shader3.set("seedsX",seedsX);
  shader3.set("seedsY",seedsY);
  //set default shader
  toggleShader = 0;
}

void draw(){
  background(100);
  if(toggleShader == 0)
  {
    shader(shader);
  }
  else if(toggleShader == 1)
  {
    shader(shader2);
  }
  else if(toggleShader == 2)
  {
    shader(shader3);
  }
  
  pointLight(255, 0, 0, mouseX-400, mouseY-400, 1500);
  if(toggleObject == true)
  {
    PShape box = createShape(BOX, 500,500,500);
    box.setStroke(false);
    shape(box);
  }
  else
  {
    PShape sphere = createShape(SPHERE, 400);
    sphere.setStroke(false);
    shape(sphere);
  }
  //color change for animation
  shader.set("colour",colour);
  shader2.set("colour",colour);
  shader3.set("colour",colour);
  colour += 0.001;
  gui();
}
void toggle_object()
{
  toggleObject = !toggleObject;
}
//redraw using random noise
void redraw_random()
{
  colour = 0.001;
  for(int i = 0; i < 32; i++)
  {
    seedsX[i] = random(1)-0.5;
    seedsY[i] = random(1)-0.5;
  }
  shader.set("seedsX",seedsX);
  shader.set("seedsY",seedsY);
  shader2.set("seedsX",seedsX);
  shader2.set("seedsY",seedsY);
  shader3.set("seedsX",seedsX);
  shader3.set("seedsY",seedsY);
}
//redraw using perlin noise
void redraw_perlin()
{
  colour = 0.001;
  for(int i = 0; i < 32; i++)
  {
    seedsX[i] = map(noise(tx),0,1,-0.5,0.5);
    seedsY[i] = map(noise(ty),0,1,-0.5,0.5);
    tx += 1;
    ty += 1;
  }
  shader.set("seedsX",seedsX);
  shader.set("seedsY",seedsY);
  shader2.set("seedsX",seedsX);
  shader2.set("seedsY",seedsY);
  shader3.set("seedsX",seedsX);
  shader3.set("seedsY",seedsY);
}
void toggle_light()
{
  toggleShader = 1;
}
void toggle_color()
{
  toggleShader = 2;
}
void reset_light()
{
  toggleShader = 0;
}
void gui()
{
  cam.beginHUD();
  gui.draw();
  cam.endHUD();
}
//backup keyboard controls
void keyPressed()
{
  if(key == '1')
  {
    colour = 0.001;
    for(int i = 0; i < 32; i++)
    {
      seedsX[i] = random(1)-0.5;
      seedsY[i] = random(1)-0.5;
    }
    shader.set("seedsX",seedsX);
    shader.set("seedsY",seedsY);
    shader2.set("seedsX",seedsX);
    shader2.set("seedsY",seedsY);
    shader3.set("seedsX",seedsX);
    shader3.set("seedsY",seedsY);
  }
  if(key == '2')
  {
    colour = 0.001;
    for(int i = 0; i < 32; i++)
    {
      seedsX[i] = map(noise(tx),0,1,-0.5,0.5);
      seedsY[i] = map(noise(ty),0,1,-0.5,0.5);
      tx += 1;
      ty += 1;
    }
    shader.set("seedsX",seedsX);
    shader.set("seedsY",seedsY);
    shader2.set("seedsX",seedsX);
    shader2.set("seedsY",seedsY);
    shader3.set("seedsX",seedsX);
    shader3.set("seedsY",seedsY);
  }
  if(key == '3')
  {
    toggleObject = !toggleObject;
  }
  if(key == '4')
  {
    toggleShader = 0;
  }
  if(key == '5')
  {
    toggleShader = 1;
  }
  if(key == '6')
  {
    toggleShader = 2;
  }
}
