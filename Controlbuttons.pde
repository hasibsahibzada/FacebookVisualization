
class Controlbutton {
  
  FB_Button[] buttons;
  int 
  B_Radius,                 // button radius
  current    =   0,         // current pressed button 
  currentH   =  -1,         // current hovered button
  bottomBorder;             // Define the button border
  PVector button;           // Center of first button
  color 
  TOP_COLOR  =  0xccffffff; //color for the background of the row  
  boolean   buttonHovered  = false;

  //CONSTRUCTOR
  Controlbutton (int buttonsNumber,int oX,int oY,int Radius,int maxValue,int[] vals,String[] texts) {
    button   =  new PVector(oX,oY);         // make button Vector
    B_Radius =  Radius;                     // get the radius
    buttons  =  new FB_Button[buttonsNumber];  // 
    int sepV =  0;
    for (int i=0;i<buttons.length;i++) {
      float button_size  = map(vals[i],0,maxValue,0,B_Radius);   //size of button
      int sepH           = (B_Radius+10)*2;                      //Horozontal sepration between buttons
      sepV               = int(textAscent()+textDescent()+B_Radius+5);  //separation between buttons and text
      buttons[i]         = new FB_Button(button.x,button.y+(i*sepH),button.y+sepV,button_size,texts[i]);
    }
    bottomBorder  = oX+sepV+20;                                         
  }
  
  //METHODS
  void display(){
    noStroke();
    fill(TOP_COLOR);
    for (int i=0;i<buttons.length;i++) {
      if (current==i) {
        buttons[i].display(true);
        
      }else{
        buttons[i].display(false);
      }
    }
  }
  
  
  void select_button(int button_number){
    
        current  =  button_number;
    
  }
  
  void hover (int mX,int mY){
       
    for (int i=0;i<buttons.length;i++){
      
      if(buttons[i].hover(mX,mY)){
        currentH=i;
        buttonHovered  = true;
        break;
      }
      buttonHovered    = false;
    }
  }
  
  int getBorder(){
    return bottomBorder; 
  }
  boolean isHovered(){
    return buttonHovered; 
  }
  void hoverIs(boolean what){
    buttonHovered=what; 
  }
  int setCurrent(){    
    current  = currentH; 
    return current;
  } 
}