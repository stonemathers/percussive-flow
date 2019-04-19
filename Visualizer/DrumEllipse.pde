

private class DrumEllipse extends toxi.geom.Ellipse{
  private color colr;
  private float maxBrightness;
  private float ryMax;
  
  
  DrumEllipse(color colr, float x, float y, float rx, float ryMax){
    super(x, y, rx, 0);
    this.maxBrightness = brightness(colr);
    this.colr = colr;
    this.ryMax = ryMax;
  }
  
  void hit(int velocity){
    //Only change radius if hit makes it larger
    float relativeR = map(velocity, VELOCITY_MIN, VELOCITY_MAX, 0, this.ryMax);
    if(relativeR > this.radius.y){
      this.radius.y = relativeR;
    }
  }
  
  void display(){
    //Set brightness based on radius
    float brightness = map(this.radius.y, 0, this.ryMax * BRIGHTNESS_FACTOR, 0, maxBrightness);
    fill(hue(this.colr), saturation(this.colr), brightness);
    
    //Draw polygon
    beginShape();
    for(Vec2D v: this.toPolygon2D().vertices){
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    
    //Shrink if necessary
    if(this.radius.y > 0){
      this.shrink();
    }
  }
  
  color getColor(){
    return this.colr;
  }
  
  void setColor(color c){
    this.colr = c;
  }
  
  private void shrink(){
    this.radius.y *= SHRINK_FACTOR;
  }
}
