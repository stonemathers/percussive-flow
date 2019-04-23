import themidibus.*;
import toxi.color.*;
import toxi.geom.*;
import tracer.*;
import tracer.paths.*;
import tracer.renders.*;
import tracer.easings.*;

// MidiBus
MidiBus myBus;

//Mesh Constants
final float MIN_RADIUS = 16;
final float MIN_CONNECTION_RADIUS = 10;
final float MAX_CONNECTION_RADIUS = 60;
final float MESH_DU = 0.002;
final int MESH_DECREMENT_DELAY = 3;
final int RADIUS_DECREASE = 8;

//Position constants
float SNARE_X;
float SNARE_Y;
float TOM1_X;
float TOM1_Y;
float TOM2_X;
float TOM2_Y;
float FLOOR_TOM_X;
float FLOOR_TOM_Y;
float CRASH_EDGE_X;
float CRASH_EDGE_Y;
float RIDE_EDGE_X;
float RIDE_EDGE_Y;

float KICK_X;
float KICK_Y;

float HH_X;
float HH_Y;
float CRASH_STACK_X;
float CRASH_STACK_Y;
float RIDE_STACK_X;
float RIDE_STACK_Y;


//Size constants
float SNARE_RADIUS_MAX;
float SNARE_RADIUS_MIN;
float TOM_RADIUS_MAX;
float TOM_RADIUS_MIN;
float CRASH_RADIUS_MAX;
float CRASH_RADIUS_MIN;

float KICK_RX;
float KICK_RY;

float HH_RX;
float HH_RY;
float HH_STACK_HEIGHT;
int HH_STACK_NUM;
float CRASH_TOP_RX;
float CRASH_TOP_RY;
float CRASH_STACK_HEIGHT;
int CRASH_STACK_NUM;
float RIDE_TOP_RX;
float RIDE_TOP_RY;
float RIDE_STACK_HEIGHT;
int RIDE_STACK_NUM;

//Color constants
color SNARE_COLOR;
color SNARE_SHOT_COLOR;
color SNARE_RIM_COLOR;
color TOM1_COLOR;
color TOM1_RIM_COLOR;
color TOM2_COLOR;
color TOM2_RIM_COLOR;
color FLOOR_TOM_COLOR;
color FLOOR_TOM_RIM_COLOR;
color CRASH_TOP_COLOR;
color CRASH_EDGE_COLOR;
color RIDE_TOP_COLOR;
color RIDE_EDGE_COLOR;
color HH_TOP_OPEN_COLOR;
color HH_TOP_CLOSED_COLOR;
color HH_EDGE_OPEN_COLOR;
color HH_EDGE_CLOSED_COLOR;
color HH_PEDAL_COLOR;
color KICK_COLOR;

//Noise constants
final int TOM_NOISE = 0;
final int CRASH_NOISE = 80;

//mesh vars
int meshCountdown = MESH_DECREMENT_DELAY;
float currConnectionRadius = MIN_CONNECTION_RADIUS;
float startRadius;
//render
RenderMesh render;
//paths
ArrayList<Point> pts = new ArrayList<Point>();
ArrayList<Path> paths = new ArrayList<Path>();

//Polygon vars
ArrayList<DrumPolygon> polygons = new ArrayList<DrumPolygon>();
int numVertices = 30;

//Pad polygons
DrumPolygon snarePoly, tom1Poly, tom2Poly, floorTomPoly, rideEdgePoly, crashEdgePoly;
DrumEllipse kickPoly;
CymbalEllipseStack rideTopPoly, crashTopPoly, hhPoly;

//style
int bgColor = 0;
int meshcolor = #ffffff;

void settings() {
  fullScreen();
}

void setup() {
  noStroke();
  colorMode(HSB, 100);
  
  rectMode(CENTER);
  myBus = new MidiBus(this, "TD-17", -1);
  float maxDim = Math.max(width, height);
  
  startRadius = maxDim/4;
  
  createPaths(width/2 - startRadius, height/2 - startRadius, startRadius, MIN_RADIUS, true);
  createPaths(width/2 - startRadius, height/2 + startRadius, startRadius, MIN_RADIUS, true);
  createPaths(width/2 + startRadius, height/2 - startRadius, startRadius, MIN_RADIUS, true);
  createPaths(width/2 + startRadius, height/2 + startRadius, startRadius, MIN_RADIUS, true);
  
  createTracers();
  render = new RenderMesh(pts, currConnectionRadius);
  render.setStrokeColor(meshcolor);
  
  initColors();
  initSizes();
  initPositions();
  initPolys();
}

void initColors(){
  SNARE_COLOR = color(0, 95, 87);
  SNARE_SHOT_COLOR = color(97, 83, 100);
  SNARE_RIM_COLOR = color(99, 87, 37);
  TOM1_COLOR = color(54, 100, 66);
  TOM1_RIM_COLOR = color(26, 64, 70);
  TOM2_COLOR = color(55, 100, 45);
  TOM2_RIM_COLOR = color(24, 68, 55);
  FLOOR_TOM_COLOR = color(57, 100, 35);
  FLOOR_TOM_RIM_COLOR = color(22, 78, 35);
  CRASH_TOP_COLOR = color(5, 100, 100);
  CRASH_EDGE_COLOR = color(9, 100, 100);
  RIDE_TOP_COLOR = color(11, 98, 92);
  RIDE_EDGE_COLOR = color(13, 100, 96);
  HH_TOP_OPEN_COLOR = color(17, 100, 100);
  HH_TOP_CLOSED_COLOR = color(13, 100, 100);
  HH_EDGE_OPEN_COLOR = color(17, 100, 100);
  HH_EDGE_CLOSED_COLOR = color(13, 100, 100);
  HH_PEDAL_COLOR = color(17, 100, 100);
  KICK_COLOR = color(68, 66, 45);
}

void initSizes(){
  SNARE_RADIUS_MAX = height * 2 / 9;
  SNARE_RADIUS_MIN = height / 18;
  TOM_RADIUS_MAX = height / 6;
  TOM_RADIUS_MIN = height / 30;
  CRASH_RADIUS_MAX = height * 0.45;
  CRASH_RADIUS_MIN = 0;

  KICK_RX = width / 2;
  KICK_RY = height * 0.25;

  HH_RX = (width - (CRASH_RADIUS_MAX / 2)) / 2;
  HH_RY = height / 45;
  HH_STACK_HEIGHT = HH_RY;
  HH_STACK_NUM = 1;
  CRASH_TOP_RX = width * 0.3;
  CRASH_TOP_RY = HH_RY;
  CRASH_STACK_HEIGHT = height * 0.6;
  CRASH_STACK_NUM = 4;
  RIDE_TOP_RX = CRASH_TOP_RX;
  RIDE_TOP_RY = CRASH_TOP_RY;
  RIDE_STACK_HEIGHT = CRASH_STACK_HEIGHT;
  RIDE_STACK_NUM = CRASH_STACK_NUM;
}

void initPositions(){
  SNARE_X = width / 2;
  SNARE_Y = height * 0.6;
  TOM1_X = width * 0.31;
  TOM1_Y = height * 0.43;
  TOM2_X = width / 2;
  TOM2_Y = height / 4;
  FLOOR_TOM_X = width - TOM1_X;
  FLOOR_TOM_Y = TOM1_Y;
  CRASH_EDGE_X = 0;
  CRASH_EDGE_Y = 0;
  RIDE_EDGE_X = width;
  RIDE_EDGE_Y = 0;
  
  KICK_X = width / 2;
  KICK_Y = height;
  
  HH_X = width / 2;
  HH_Y = (TOM2_Y - TOM_RADIUS_MAX) / 2;
  CRASH_STACK_X = 0;
  CRASH_STACK_Y = height * 0.55;
  RIDE_STACK_X = width - 1;
  RIDE_STACK_Y = CRASH_STACK_Y;
}

void initPolys(){
  snarePoly = new SnarePolygon(SNARE_COLOR, SNARE_X, SNARE_Y, SNARE_RADIUS_MIN, SNARE_RADIUS_MAX);
  
  tom1Poly = new DrumPolygon(TOM1_COLOR, TOM1_X, TOM1_Y, TOM_RADIUS_MIN, TOM_RADIUS_MAX, TOM_NOISE);
  tom2Poly = new DrumPolygon(TOM2_COLOR, TOM2_X, TOM2_Y, TOM_RADIUS_MIN, TOM_RADIUS_MAX, TOM_NOISE);
  floorTomPoly = new DrumPolygon(FLOOR_TOM_COLOR, FLOOR_TOM_X, FLOOR_TOM_Y, TOM_RADIUS_MIN, TOM_RADIUS_MAX, TOM_NOISE);
  crashEdgePoly = new DrumPolygon(CRASH_EDGE_COLOR, CRASH_EDGE_X, CRASH_EDGE_Y, CRASH_RADIUS_MIN, CRASH_RADIUS_MAX, CRASH_NOISE);
  rideEdgePoly = new DrumPolygon(RIDE_EDGE_COLOR, RIDE_EDGE_X, RIDE_EDGE_Y, CRASH_RADIUS_MIN, CRASH_RADIUS_MAX, CRASH_NOISE);
  
  kickPoly = new DrumEllipse(KICK_COLOR, KICK_X, KICK_Y, KICK_RX, KICK_RY);
  
  hhPoly = new CymbalEllipseStack(HH_TOP_OPEN_COLOR, HH_X, HH_Y, HH_RX, HH_RY, HH_STACK_HEIGHT, HH_STACK_NUM);
  crashTopPoly = new CymbalEllipseStack(CRASH_TOP_COLOR, CRASH_STACK_X, CRASH_STACK_Y, CRASH_TOP_RX, CRASH_TOP_RY, CRASH_STACK_HEIGHT, CRASH_STACK_NUM);
  rideTopPoly = new CymbalEllipseStack(RIDE_TOP_COLOR, RIDE_STACK_X, RIDE_STACK_Y, RIDE_TOP_RX, RIDE_TOP_RY, RIDE_STACK_HEIGHT, RIDE_STACK_NUM);
}

void createPaths(float x, float y, float r, float minRadius, boolean skip) {
  if (!skip) {
    Path path = new tracer.paths.Circle(x, y, r);
    path.setFill(false);
    path.setStrokeColor(100);
    paths.add(path);
  }

  float newR = r/2;
  if (newR >= minRadius) {
    float newX = x - newR;
    for (int i=0; i<2; i++) {
      float newY = y - newR;
      for (int j=0; j<2; j++) {
        createPaths(newX, newY, newR, minRadius, false);
        newY += r;
      }
      newX += r;
    }
  }
}

void createTracers() {
  for (Path p : paths) {
    //float speed = random(-du, du);
    float speed = (random(1) < 0.5) ? -MESH_DU : MESH_DU;
    Tracer t = new Tracer(p, random(1), speed, new Easing() {
      public float val(float t) {
        return t;
      }
    });
    pts.add(t);
  }
}

void draw() {
  background(bgColor);
  
  //Decrease min mesh connection radius if countdown elapsed,
  //otherwise decrement counter
  if(meshCountdown > 0){
    meshCountdown--;
  }else{
    currConnectionRadius = Math.max(MIN_CONNECTION_RADIUS, currConnectionRadius - RADIUS_DECREASE); 
    render.setMinDist(currConnectionRadius);
    meshCountdown = MESH_DECREMENT_DELAY;
  }
  
  //draw renders
  render.step();
  render.draw(g);
  
  //Draw polys  
  hhPoly.display();
  crashTopPoly.display();
  rideTopPoly.display();
  tom1Poly.display();
  tom2Poly.display();
  floorTomPoly.display();
  snarePoly.display();
  kickPoly.display();
  crashEdgePoly.display();
  rideEdgePoly.display();
}

void noteOn(int channel, int pitch, int velocity) {
  //Vars
  int incAmount;
  
  //Calculate amount to increase min mesh connection radius
  if(currConnectionRadius < 20){
    incAmount = 12;
  }else if(currConnectionRadius < 30){
    incAmount = 8;
  }else if(currConnectionRadius < 45){
    incAmount = 5;
  }else{
    incAmount = 2;
  }
  
  //Increase min mesh connection radius if not at max
  currConnectionRadius = Math.min(MAX_CONNECTION_RADIUS, currConnectionRadius + incAmount);
  render.setMinDist(currConnectionRadius);
  
  //Update polys
  switch(pitch){
    case SNARE_PITCH: 
      snarePoly.setColor(SNARE_COLOR);
      snarePoly.hit(velocity);
      break;
    
    case SNARE_SHOT_PITCH:
      snarePoly.setColor(SNARE_SHOT_COLOR);
      snarePoly.hit(velocity);
      break;
    
    case SNARE_RIM_PITCH:
      snarePoly.setColor(SNARE_RIM_COLOR);
      snarePoly.hit(velocity);
      break;
      
    case TOM1_PITCH:
      tom1Poly.setColor(TOM1_COLOR);
      tom1Poly.hit(velocity);
      break;
    
    case TOM1_RIM_PITCH:
      tom1Poly.setColor(TOM1_RIM_COLOR);
      tom1Poly.hit(velocity);
      break;
      
    case TOM2_PITCH:
      tom2Poly.setColor(TOM2_COLOR);
      tom2Poly.hit(velocity);
      break;
    
    case TOM2_RIM_PITCH:
      tom2Poly.setColor(TOM2_RIM_COLOR);
      tom2Poly.hit(velocity);
      break;
      
    case FLOOR_TOM_PITCH:
      floorTomPoly.setColor(FLOOR_TOM_COLOR);
      floorTomPoly.hit(velocity);
      break;
    
    case FLOOR_TOM_RIM_PITCH:
      floorTomPoly.setColor(FLOOR_TOM_RIM_COLOR);
      floorTomPoly.hit(velocity);
      break;
      
    case CRASH_EDGE_PITCH:
      crashEdgePoly.hit(velocity);
      break;
      
    case RIDE_EDGE_PITCH:
      rideEdgePoly.hit(velocity);
      break;
      
    case KICK_PITCH:
      kickPoly.hit(velocity);
      break;
      
    case HAT_TOP_OPEN_PITCH:
      hhPoly.setColor(HH_TOP_OPEN_COLOR);
      hhPoly.hit(velocity);
      break;
    
    case HAT_TOP_CLOSED_PITCH:
      hhPoly.setColor(HH_TOP_CLOSED_COLOR);
      hhPoly.hit(velocity);
      break;
    
    case HAT_EDGE_OPEN_PITCH:
      hhPoly.setColor(HH_EDGE_OPEN_COLOR);
      hhPoly.hit(velocity);
      break;
    
    case HAT_EDGE_CLOSED_PITCH:
      hhPoly.setColor(HH_EDGE_CLOSED_COLOR);
      hhPoly.hit(velocity);
      break;
    
    case HAT_PEDAL_PITCH:
      hhPoly.setColor(HH_PEDAL_COLOR);
      hhPoly.hit(velocity);
      break;
      
    case CRASH_TOP_PITCH:
      crashTopPoly.hit(velocity);
      break;
      
    case RIDE_TOP_PITCH:
      rideTopPoly.hit(velocity);
      break;
  }
}
