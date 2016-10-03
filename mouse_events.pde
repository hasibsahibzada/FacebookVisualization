void mouseClicked() {
  
  if (mouseButton==LEFT){ 
    
    // if clicked on the chart
    if (graph.sectorHovered&&!graph.shifting&&graph.currentIndex==0){
      graph.setCurrentIndex(int(graph.new_index));     //set the current element                 
      graph.getCurrentElement().setSectorsGoal();      //make new sectors                                 
      
      controlbutton.select_button(int(graph.new_index));
      graph.shiftingIs(true);                          //shift to new chart
      
    }
    
    // if clicked on the Different post types
    if (controlbutton.isHovered() && !graph.isShifting()){   // If we are on button and coxocombo is not shifting
      graph.setCurrentIndex(controlbutton.setCurrent());     // set the current element                                   
      graph.getCurrentElement().setSectorsGoal();            //make new sectors                           
      graph.shiftingIs(true);                                //shift to new chart
     // print("buttons");
      //
 
  } 
  }
}

void mouseMoved(){
   if (mouseX<controlbutton.getBorder()) {                   // if we are on around buttons
     controlbutton.hover(mouseX,mouseY);                     // if we hover on buttons
   }
   else{                                                     
     graph.getCurrentElement().hover(mouseX,mouseY);        //and check the graphElement hover
 }
}


void setCursor(){                                        //set the appropiate cursor
  if(controlbutton.isHovered() || graph.sectorHovered&&!graph.shifting&&graph.currentIndex==0) { 
    cursor(HAND);
  }else{ 
    cursor(CROSS);
  }
}