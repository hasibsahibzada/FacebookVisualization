
// networking stuffs
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
String oscIP   = "127.0.0.1";
int oscPort    = 10000;


import controlP5.*;
Graph graph;                 //this object groups the graph diagram
Controlbutton controlbutton;       //and this one the button interface above
G_table tG;               //this is the group of tables we are going to use
      
color [] colores = {#5E72AA,#5A8DCE};
         
color 
BACKGROUND_COLOR      = #ffffff,     
TEXT_COLOR            = color(255);
int n                 = 6;    //number of tables
int number_of_posts   = 10;
                    
                 
ControlP5 cp5;
 
// define the chart
Chart Posts;



String post_msg = "What was in his Mind ?";
color post_color  = color (0, 102, 153, 100);

// Photo Array
ArrayList <PImage> photo_list;
PImage Users_photo_Fram;
ArrayList <String> users_name;


// update loading gif
PImage[] animation;
boolean updating = false;
String imagePrefix = "./updating/tmp-";
int image_count = 8;
int frame;
void setup(){
  
  size(displayWidth,displayHeight); 
  background(BACKGROUND_COLOR);
  noStroke();
  smooth(); 
  cursor(CROSS); 
  ellipseMode(RADIUS);
  colorMode(HSB);
  
 
  animation = new PImage[image_count];
 
 // updating animation array
   for (int i = 0; i < image_count; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix+i+".gif";
      animation[i] = loadImage(filename);
    }
 
  
  // OSC input port
  oscP5 = new OscP5(this, 10001);
  // OSC output port
  myRemoteLocation = new NetAddress(oscIP, oscPort);

  
   // controlp5 instances
   cp5 = new ControlP5(this);

   // create PIE chart for Post Types
   Posts = cp5.addChart("Posts")
                   .setPosition(250, 100)
                   .setSize(500, 500)
                   .setRange(0, 10)
                   .setView(Chart.PIE)
                   ;
   Posts.getColor().setBackground(color(255, 100));
   Posts.addDataSet("Post_Types");
   Posts.setColors("Post_Types", color(0,0,255) , color(0,255,0) );
   
     
   // make update button
   cp5.addButton("UpdateFacebook")
     .setPosition(displayWidth/2.5,displayHeight/1.63)
     .setSize(200,19);
     
     
   cp5.addSlider("Number_Of_Posts")
     .setPosition(displayWidth/4.5,displayHeight/1.75)
     .setWidth(600)
     .setHeight(20)
     .setRange(10,500) // values can range from big to small as well
     .setValue(20)
     .setNumberOfTickMarks(50)
     .setSliderMode(Slider.FLEXIBLE)
     ;  
     
     
  //constructing objects
  tG  =  new G_table(n);

  graph          = new Graph(tG,width/2.0,height/3,250,18,50000);
  controlbutton  = new Controlbutton(n,displayWidth/8,displayHeight/8,30,tG.getMaxSum(),tG.getSums(),tG.getTitles());
 
  
}

void draw(){
    
      
       fill(0,50); 
       rect(0, 0, width, height);

       setCursor();                    //set the cursor
      if (graph.isShifting()) {       //if we are shifting data shift the radiuses of the current element
        graph.getCurrentElement().shiftTo(graph.getCurrentIndex());
      } 
      graph.displayTodo();                //display the element
      controlbutton.display();           //display the buttons above
   
      if (updating !=true){
   
          show_my_profile();
 
          show_photo();
     }
   
     else {
         // show updating icon
         play_updating_visualization();
         
   
   }
   
    }



void play_updating_visualization(){
 
  frame = (frame+1) % image_count;
  image(animation[frame],displayWidth/2.25,displayHeight/1.5,100,100);
  
}

void show_my_profile(){

  // show post box
   fill(255);
   rect(displayWidth/4.5,displayHeight/1.55,700,80, 9);
   fill(post_color);
   text(post_msg,displayWidth/3.55,displayHeight/1.52,400,60);

   // data column
   String data[][];
   data = new String[1][2];
      
       // open the file
   String[] post_file = loadStrings("./data/profile.tsv"); 
   int file_lenght     = post_file.length;

   data[0] = split(post_file[1],"\t"); 
       
    
   // show profile picture
   
   String photo_path    = "./data/user_photos/" + data[0][1]+".jpg" ;
   
   image(loadImage(photo_path),displayWidth/4.25,displayHeight/1.52); 

}


void show_photo(){
  
  if (graph.photo_list_filled == true){
    
    float x_dir=10,y_dir=height/1.32;
    if(photo_list.size() !=0){

    fill(255);
    textSize(8);
      
    for (int i=0;i<photo_list.size();i++){
      
      Users_photo_Fram = photo_list.get(i);
      // show image
      image(Users_photo_Fram,x_dir,y_dir);
      
      text(users_name.get(i),x_dir,y_dir+60);
      
      if (x_dir < width -100){
         
        x_dir +=80;
         
      }
      else {
 
        x_dir = 10;
        y_dir +=80;
        
      }
    
         
    }
    }
    textSize(12);
    graph.photo_list_filled = false;
    
  }
  
  
}


  public void controlEvent(ControlEvent theEvent) {
    println(theEvent.getController().getName());
  
}
 
  public void UpdateFacebook(int theValue) {
 
    // send request for new data to other processing app
    OscMessage update = new OscMessage("/update_facebook");
    update.add(number_of_posts);
    oscP5.send(update, myRemoteLocation);
    updating = true;

}

void Number_Of_Posts(int Number_Of_Post) {
 number_of_posts = Number_Of_Post;

}


 void oscEvent(OscMessage theMessage) {
     
   // check if the address is correct
     if (theMessage.checkAddrPattern("/completed")==true) {
   
        // check the type tag to be correct 
        if(theMessage.checkTypetag("i")) {
          
           int message_val = theMessage.get(0).intValue();
            if (message_val == 1){
              
              updating = true;
              print("making the tables ...");
              
              // make the tables
               tG=new G_table(n);

               graph          = new Graph(tG,width/2.0,height/3,250,18,50000);
               controlbutton  = new Controlbutton(n,displayWidth/8,displayHeight/8,30,tG.getMaxSum(),tG.getSums(),tG.getTitles());
 
               updating = false;
            }
          
        }
        
     }
     
 }