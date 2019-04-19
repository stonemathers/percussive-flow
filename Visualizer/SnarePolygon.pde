private final float JITTER_FACTOR = 0.03;
private final int SNARE_VERTICES = 100;

private class SnarePolygon extends DrumPolygon{
  SnarePolygon(color colr, float x, float y, float minR, float maxR){
    super(colr, x, y, minR, maxR, 0);
    this.setVertices();
  }
  
  void display(){
    //Set brightness based on radius
    float brightness = map(this.radius, this.minRadius, this.maxRadius * BRIGHTNESS_FACTOR, 0, maxBrightness);
    fill(hue(this.colr), saturation(this.colr), brightness);
    
    try{
      //Draw polygon
      beginShape();
      for(Vec2D v: this.vertices){
        Vec2D jitterV = new Vec2D(v.x - this.x, v.y - this.y).scale(JITTER_FACTOR);
        Vec2D tempV = v.jitter(jitterV);
        vertex(tempV.x, tempV.y);
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
  
  /*
  * Sets polygon vertices
  */
  private void setVertices(){ 
    this.vertices.clear();
    for(float i = 0; i < SNARE_VERTICES; i++){
      this.add(Vec2D.fromTheta(i/SNARE_VERTICES*TWO_PI)
                    .scaleSelf(this.radius)
                    .addSelf(this.x, this.y)
      );
    }
  }
  
  /*
  *  Moves poly a step closer to default shape
  */
  private void shrink(){
    //Decrease radius
    this.radius *= SHRINK_FACTOR;
    for(Vec2D v: this.vertices){
      v.subSelf(new Vec2D(this.x, this.y))
       .scaleSelf(SHRINK_FACTOR)
       .addSelf(new Vec2D(this.x, this.y));
    }  
  }
}
