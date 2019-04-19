private class CymbalEllipseStack{ 
  private color colr;
  private float maxBrightness;
  private float rxMax;
  private int currEllipse;
  private toxi.geom.Ellipse[] ellipses;
  
  CymbalEllipseStack(color colr, float x, float y, float rxMax, float ry, float totHeight, int numEllipses){
    this.colr = colr;
    this.maxBrightness = brightness(colr);
    this.rxMax = rxMax;
    this.currEllipse = 0;
    this.initEllipses(x, y, ry, totHeight, numEllipses);
  }
  
  void hit(int velocity){
    float relativeR = map(velocity, VELOCITY_MIN, VELOCITY_MAX, 0, this.rxMax);
    
    this.ellipses[currEllipse].setRadii(relativeR, this.ellipses[currEllipse].getRadii().y);
    
    currEllipse = (currEllipse + 1) % ellipses.length;
  }
  
  void display(){
    for(toxi.geom.Ellipse e: ellipses){
      //Set brightness based on radius
      float brightness = map(e.getRadii().x, 0, this.rxMax * BRIGHTNESS_FACTOR, 0, maxBrightness);
      fill(hue(this.colr), saturation(this.colr), brightness);
      
      //Draw polygon
      beginShape();
      for(Vec2D v: e.toPolygon2D().vertices){
        vertex(v.x, v.y);
      }
      endShape(CLOSE);
    }
    
    this.shrink();
  }
  
  color getColor(){
    return this.colr;
  }
  
  void setColor(color c){
    this.colr = c;
  }
  
  private void initEllipses(float x, float y, float ry, float totHeight, int numEllipses){
    ellipses = new toxi.geom.Ellipse[numEllipses];
    
    if(numEllipses > 1){
      float spacing = (totHeight - (ry * 2))/ (numEllipses - 1);    
      float startY = y - (totHeight / 2) + ry;
        
      //Create each Ellipse
      for(int i = 0; i < numEllipses; i++){
        ellipses[i] = new toxi.geom.Ellipse(x, startY + (i * spacing), 0, ry);
      }
    }else{
      for(int i = 0; i < numEllipses; i++){
        ellipses[i] = new toxi.geom.Ellipse(x, y, 0, ry);
      }
    }
  }
  
  private void shrink(){
    for(toxi.geom.Ellipse e: this.ellipses){
      e.setRadii(e.getRadii().x * SHRINK_FACTOR, e.getRadii().y);
    }
  }
  
}
