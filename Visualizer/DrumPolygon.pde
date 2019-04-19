//Polygon constants
protected final int NUM_VERTICES = 30;
protected final float SHRINK_FACTOR = 0.96;
protected final float BRIGHTNESS_FACTOR = 0.4;

private class DrumPolygon extends Polygon2D{
  protected color colr;
  protected float maxBrightness;
  protected float x;
  protected float y;
  protected float radius;
  protected float minRadius;
  protected float maxRadius;
  protected float maxNoise;
  
  DrumPolygon(color colr, float x, float y, float minR, float maxR, float maxNoise){
    this.colr = colr;
    this.maxBrightness = brightness(colr);
    this.x = x;
    this.y = y;
    this.radius = minR;
    this.minRadius = minR;
    this.maxRadius = maxR;
    this.maxNoise = maxNoise;
    this.setVertices();
  }
  
  /*
  *  Increases poly radius and noise factor depending on velocity of hit
  */
  void hit(int velocity){
    //Only change radius if hit makes it larger
    float relativeR = map(velocity, VELOCITY_MIN, VELOCITY_MAX, this.minRadius, this.maxRadius);
    if(relativeR > this.radius){
      this.radius = relativeR;
      this.setVertices();
    }
  }
  
  void display(){
    //Set brightness based on radius
    float brightness = map(this.radius, this.minRadius, this.maxRadius * BRIGHTNESS_FACTOR, 0, maxBrightness);
    fill(hue(this.colr), saturation(this.colr), brightness);
    
    try{
      //Draw polygon
      beginShape();
      for(Vec2D v: this.vertices){
        vertex(v.x, v.y);
      }
      endShape(CLOSE);
      
      //Shrink if necessary
      if(this.radius > this.minRadius){
        this.shrink();
      }
    }catch(Exception e){
      //Do nothing - this only happens when rolling, so the user won't notice
    }
  }
  
  color getColor(){
    return this.colr;
  }
  
  void setColor(color c){
    this.colr = c;
  }
  
  /*
  * Sets polygon vertices
  */
  private void setVertices(){
    float noiseFact = map(this.radius, this.minRadius, this.maxRadius, 0, this.maxNoise);
    
    this.vertices.clear();
    for(float i = 0; i < NUM_VERTICES; i++){
      this.add(Vec2D.fromTheta(i/NUM_VERTICES*TWO_PI)
                    .scaleSelf(random(-noiseFact, noiseFact) + this.radius)
                    .addSelf(this.x, this.y)
      );
    }
  }
  
  /*
  *  Moves poly a step closer to default shape
  */
  private void shrink(){
    //Smooth
    this.smooth(0.01, 0.05);
    
    //Decrease radius
    this.radius *= SHRINK_FACTOR;
    
    for(Vec2D v: this.vertices){
      v.subSelf(new Vec2D(this.x, this.y))
       .scaleSelf(SHRINK_FACTOR)
       .addSelf(new Vec2D(this.x, this.y));
    }
  }
}
