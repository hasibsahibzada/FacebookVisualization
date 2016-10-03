
class FB_Button {
    PVector 
    c,                   //center of the button
    textPosition;        //origin of text
    float 
    bRad1,bRad2,bRad3;   //radiuses
    String 
    buttonText;          //legend
    
    //CONSTRUCTOR
    FB_Button(float centerX,float centerY,float textY,float bRad2,String buttonText) {
      c= new PVector(centerX,centerY);
      this.bRad2=bRad2;
      bRad3=bRad2+3f;    //size of hover ellipse
      this.buttonText=buttonText;
      textPosition=new PVector(c.x-(textWidth(buttonText)*2),c.y+(textWidth(buttonText)/6));
    }

    //METHODS
    void display(boolean currentB) {
      if (currentB){
        fill(#cccccc);
        ellipse(c.x,c.y,bRad3,bRad3);     //hover
      }
      fill(colores[1]);                   //first we draw the total value ellipse, that'll be covered partially by male ellipse-- thus this is female ellipse
      ellipse(c.x,c.y,bRad2,bRad2); 
      
      fill(TEXT_COLOR);
      text(buttonText,textPosition.x,textPosition.y);
    }
    
    boolean hover(int mX,int mY){
      return  dist(mX,mY,c.x,c.y)<=bRad2?true:false;
    }
 }