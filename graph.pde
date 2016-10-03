 //<>//
class Graph {


  String   new_index  = "";

  ArrayList<PImage>   list_of_photos;

  // Class instances
  G_table          tables;       //group of tables
  PolarElement[]      P;            //group of elements
  PolarElement        current;      //current element

  PShape[]            shapes;       //icons for the legend 
  float []            shapesF;      //factor for display the shape with the accurate proportions

  PVector             c;            //center of the diagram

  int 
    L_C                 = 0, 
    Max_Radius          = 0, 
    scalor_steps        = 0, 
    currentIndex        = 0, //index of the current element
    NUM_TABLES, //number of tables/elements
    ROWS, //number of rows
    COLS;                             //number of columns

  float  
    SCALE_FACTOR, //the graphic scale of the diagram  
    ANGLE, //the angle of each sector
    HALF_ANGLE, 
    currentAngle        = 0;          //current angle for displaying the diagram, in order to rotate it  


  color[] 
    sectorColors        = {#5E72AA, #5A8DCE}, // sector colors
    hoverColors;          

  color
    SCALER_COLOR        = #dddddd, 
    HOVER_COLOR         = #9B2A2C, 
    BOTTOM_COLOR        = #ffffff;

  PGraphics           scaler;

  boolean 
    photo_list_filled   = false, 
    sectorHovered       = false, //do we have the mouse on a sector?  
    scaling             = false, //do we have the graphic scale on?
    shifting            = false;      //is the diagram making a transition to other values currently?


  //CONSTRUCTOR
  Graph (G_table tables, float centerX, float centerY, int maxRadius, int scalerSteps, int scalerStepValue) {

    c  = new PVector(centerX, centerY);

    //Tables 
    this.tables        = tables;
    NUM_TABLES         = tables.getN();
    ROWS               = tables.getRows(currentIndex);
    COLS               = tables.getCols(currentIndex);


    Max_Radius         = maxRadius;
    scalor_steps       = scalerSteps;


    //Constants
    ANGLE              = TWO_PI/tables.getRows(currentIndex);
    HALF_ANGLE         = ANGLE/2;

    // load pics and colors
    load_like_comment_pics_colors();

    //Graph Element is the class for only one diagram
    P  =  new PolarElement[NUM_TABLES];

    for (int i=0; i<P.length; i++) {

      //store all the tables in the P Array
      P[i]  =  new PolarElement(tables.get(i), i);
    }


    //current diagram | cause of the transitions
    current  = new PolarElement(tables.get(currentIndex), currentIndex);  

    //Scaler //This tool is the graphic scale behind the diagram. It consists on a serie of ellipses that reflect certain values.
    //So we have scalerSteps (the number of steps), scalerStepValue (the value of each step) and scalerRadiuses (an array holding the diameter of all ellipses)
    //It doesn't change through execution, so we are going to store it on a PGraphics to save some resources

    float coef_calc         = 2*scalerStepValue/ANGLE;
    float[] scalerRadiuses  = new float[scalerSteps];

    for (int i=0; i<scalerRadiuses.length; i++) {
      scalerRadiuses[i]=sqrt(coef_calc*i)*SCALE_FACTOR;
    }

    scaler  = createGraphics(width, height, JAVA2D);
    scaler.beginDraw();
    scaler.background(BACKGROUND_COLOR);
    scaler.smooth();
    scaler.ellipseMode(RADIUS);
    scaler.stroke(SCALER_COLOR);
    scaler.noFill();

    for (int i=0; i<scalerRadiuses.length; i++) {
      scaler.strokeWeight(1.5-i%2);
      scaler.ellipse(c.x, c.y, scalerRadiuses[i], scalerRadiuses[i]);
    }
    scaler.endDraw();
  }

  //METHODS

  // load like and comment pictures
  void load_like_comment_pics_colors() {

    //Colors
    hoverColors        = new color[sectorColors.length];


    for (int i=0; i<2; i++) {

      // set the colors
      hoverColors[i] = sectorColors[i]|0x333300;
    }
  }

  //This method returns the factor that scales the maximum radius found on the tables to a desired maximum radius (to have control of the layout) 
  float getScale (float desired_maxRadius, float sectorAngle, int index) {

    int value=0;
    value = value < tables.get(index).maxRowSum() ? tables.get(index).maxRowSum() : value;   //maximum sum of values in row
    float real_maxRadius = sqrt(2*value/sectorAngle);   //find the real radius related to that value
    return desired_maxRadius/real_maxRadius;           //returns the factor that transform the latter into desired
  }



  //Bunch of get-set methods
  PolarElement getElement (int index) {
    return P[index];
  }

  PolarElement getCurrentElement() {

    return current;
  }


  int  getCurrentIndex() {

    return currentIndex;
  }

  void setCurrentIndex (int newIndex) {

    currentIndex=newIndex;
  }

  boolean isShifting() {

    return shifting;
  }

  void shiftingIs(boolean what) {

    shifting=what;
  }

  void toggleScaler() {

    scaling  =  !scaling;
  }


  // diagram rotation
  void rotateElement (int x, int px, float s) { 

    currentAngle+=(x-px)*s;
  } 

  //display legends 
  void displayLegend(int H, int xL) {

    fill(TEXT_COLOR);
    String Post_types = tables.getRows(currentIndex)+" "+tables.getTitle(currentIndex);
    PImage LC_img = null;
    String statistic  = "";
    float clicks      = 0.0;
    
    if (sectorHovered&&!shifting) { 

      statistic = current.getValueSel();
      
      // compute number of clicks per post / All posts
      if (L_C == 0){clicks = float(statistic) * 3;}      // likes: Post Clicks = likes * 3.103
      else {clicks = float(statistic) * 15;}             // comments: Post Clicks = comments * 14.678

      LC_img = loadImage("./"+L_C+".png");
      
      
      if ((currentIndex!=0 )&& (current.cH !=-1) ) {     // display only when is at different post types 
        current.make_photo_list(currentIndex, L_C, current.getValueSel(), new_index);
        current.show_postMessage(new_index);
      }
    }

    fill(#FFFF00);
    textSize(20);

    // set the title text
    text(Post_types, displayWidth/1.2, displayHeight/10);

  
    // put the like or comment icon here  LC is the index too
    if (LC_img !=null) {
      
      // show amount of likes or comments
      image(LC_img, mouseX+10, mouseY-20,25,25);
      // set the text at mouse location
      fill(#eee8cd);
      text(statistic, mouseX+40, mouseY-5);
      
       // show clicks
      image(loadImage("./click.png"), mouseX+10, mouseY+10,25,25);
      text(clicks, mouseX+30, mouseY+30);
      // reset the text size to 12
      
    } 
    textSize(12);
   
   
  }

  void displayTodo() {

    float new_angle  = TWO_PI/tables.getRows(currentIndex);
    float scal_fac   = getScale(Max_Radius, new_angle, currentIndex);
    float coef_calc  = 2*scalor_steps/new_angle;

    float[] scalerRadiuses=new float[scalor_steps];
    for (int i=0; i<scalerRadiuses.length; i++) {
      scalerRadiuses[i]=sqrt(coef_calc*i)*scal_fac;
    }

    for (int i=0; i<scalerRadiuses.length; i++) {
      scaler.strokeWeight(1.5-i%2);
      scaler.ellipse(c.x, c.y, scalerRadiuses[i], scalerRadiuses[i]);
    }

    if (scaling) image(scaler, 0, 0);
    pushMatrix();
    translate(c.x, c.y);
    rotate(currentAngle);
    current.display();
    popMatrix();
    displayLegend(50, 550);
  }

  //Calculates the radius of the sector, depending the value to represent and the scale factor we set up on Polar constructor
  //Area of a circular sector: ANGLE/2 * RADIUS² || i.e.: an ellipse has PI*R² area (angle:TWO_PI)  
  float calcR(int area, float angulo, int c_index) {
    float  s_f      = getScale(Max_Radius, angulo, c_index);
    // calculate scale_factor first    
    return sqrt(2*area/angulo)*s_f;
  }

  //Polar Element | Internal to graph ////////////////////////////////////////////////////////

  class PolarElement {
    Table      table;    //table related
    Sector[][] sectors;  //bunch of sectors
    int    
      index, //the index of each element inside the array holder
      reachingCount, //when we are shifting the element, this int shows us number of sectors that haven't arrived to 'shifting goal'
      valueSel, //value of a selected sector
      countryValueSel, 
      post_type_id, 
      rH, //the row of a hovered sector
      cH;                  //the column of a hovered sector
    String
      countrySel="";   //...

    //CONSTRUCTOR
    PolarElement (Table table, int index) {
      this.table=table;

      int new_row     = table.getNumRows()-1;
      int new_col     = table.getNumCols();
      float new_angle = TWO_PI/new_row;
      sectors         = new Sector[new_row][new_col];
      this.index      = index; 

      reachingCount    =(new_row*(COLS-1))-1;

      // sectors are overlaped
      for (int i=0; i<new_row; i++) {
        // get the sum of each row in table
        int val  = table.rowSum(i+1);

        sectors[i][COLS-2]=  new Sector(calcR(val, new_angle, index), sectorColors[COLS-2], hoverColors[COLS-2], table.getInt(i+1, COLS-1));

        for (int j=COLS-3; j>=0; j--) {
          sectors[i][j]=new Sector(calcR(val-=table.getInt(i+1, j+2), new_angle, index), sectorColors[j], hoverColors[COLS-2], table.getInt(i+1, j+1));
        }
      }
    }  

    //METHODS
    // the arcs are shown from outside to inside 
    void display() {
      pushMatrix();

      int El_index     = currentIndex;
      int t_row        = tables.get(El_index).getNumRows()-1;
      float new_angle  = TWO_PI/t_row;
      float half_angle = new_angle/2;


      //display sector
      for (int i=0; i<t_row; i++) {                    //for each row of data
        for (int j=COLS-2; j>=0; j--) {               //start outside and go inside
          P[El_index].sectors[i][j].display(rH==i&&cH==j);      //display the sector, telling him if it's hovered
        }    
        //display text 
        rotate(half_angle);
        fill(TEXT_COLOR);
        text(tables.get(El_index).getString(i+1, 0), P[El_index].sectors[i][COLS-2].getRadius()-50, textAscent()*.5);  //display label
        rotate(half_angle);
      }


      popMatrix();
    }



    void show_postMessage(String post_id) {

      // data column
      String data[][];
      data = new String[1][2];


      // open the file
      String[] post_file = loadStrings("./data/posts.tsv"); 
      int file_lenght     = post_file.length;

      for (int i =0; i<file_lenght; i++) {

        data[0] = split(post_file[i], "\t"); 

        if (data[0][0].equals(post_id)) {

          post_color = color(0, 0, 0);
          post_msg = data[0][1];
          break;
        }
      }
    }


    // display pics at down side
    void make_photo_list(int post_type, int LC, String array_size, String post_id) {

      if (photo_list_filled == false) {
        // make photo list
        photo_list = new ArrayList<PImage>(int(array_size));
        users_name = new ArrayList<String>(int(array_size));

        String photo_path    = "./data/user_photos/";


        // data column
        String data[][];
        data = new String[1][4];

        // open the file
        String[] photo_file = loadStrings("./data/photofie.tsv"); 
        int file_lenght     = photo_file.length;

        // fill the array
        for (int i =0; i<file_lenght; i++) {

          if (trim(photo_file[i]).length() == 0) {
            continue;
          }  
          data[0] = split(photo_file[i], "\t"); 

          // query the LC from the file
          if (data[0][0].equals(post_id) && data[0][1].equals(str(post_type)) && data[0][2].equals(str(LC)) ) {
            // get the photo name
            String photo_name = photo_path + data[0][3]+".jpg";

            // put the photo in the array
            photo_list.add(loadImage(photo_name)); 

            // put the name of the user
            users_name.add(data[0][3]);
          }
        }

        // make this not to fill again
        photo_list_filled = true;
      }
    }


    //Hover method | I suppose there's a much clever way of handling the angle, too much exceptions here. Any good idea appreciated//
    void hover(int mX, int mY) {

      int El_index     = currentIndex;
      int t_row        = tables.get(El_index).getNumRows()-1;
      float new_angle  = TWO_PI/t_row;
      //First, we get the row. That'd be really easy, but atan2 returns a hard-to-handle angle
      float hoverAngle=atan2(mY-c.y, mX-c.x);            //atan2 returns angles from 0 to PI and from 0 to -PI
      if (hoverAngle<0) {
        hoverAngle+=TWO_PI; //now we have it from 0 to TWO_PI
      }            

      hoverAngle-=currentAngle;                         //we substract it the current rotation
      if (hoverAngle<currentAngle) {
        hoverAngle+=TWO_PI;
      }
      //once we have the angle we want, we only have to divide it by the sector amplitude   
      rH= floor(hoverAngle/new_angle%100);                   //as 15 triggers an exception, this way we can sort it out    
      float dist_Or= dist(mX, mY, c.x, c.y);
      for (int i=0; i<COLS-1; i++) {

        if (P[currentIndex].sectors[rH][i].getRadius()-dist_Or>0) {     //first positive difference reveals the hovered sector

          cH=i;
          sectorHovered= true;
          valueSel=P[currentIndex].sectors[rH][cH].getValue();
          countrySel=tables.get(currentIndex).getString(rH+1, 0);
          countryValueSel=tables.get(currentIndex).rowSum(rH+1);
          new_index = tables.get(currentIndex).getString(rH+1, 3);

          // shift from one section to other
          if (L_C !=cH && cH !=-1) {

            graph.photo_list_filled = false;
          }
          L_C = cH;      // like or comment column

          break;
        } else {
          cH= -1;
          sectorHovered= false;
          graph.photo_list_filled = false;

          post_msg = "What was in his Mind ?";
          post_color  = color (0, 102, 153, 100);
        }
      }
    }   

    String getValueSel() {
      return nfc(valueSel);
    }

    int get_post_type_id() {
      return post_type_id;
    }

    float getSectorRadius (int sR, int sC) {

      int El_index     = currentIndex;
      return P[El_index].sectors[sR][sC].getRadius();
    }
    int getSectorValue (int sR, int sC) {

      int El_index     = currentIndex;

      return P[El_index].sectors[sR][sC].getValue();
    }

    void setSectorsGoal() {

      // edited
      int El_index     = currentIndex;
      int t_row        = tables.get(El_index).getNumRows()-1;
      float new_angle  = TWO_PI/t_row;

      for (int i=0; i<t_row; i++) {
        for (int j=0; j<COLS-1; j++) {
          P[El_index].sectors[i][j].setNewGoal();
        }
      }
    }

    //This method tells sectors to shift and considers the process over when all they are done
    void shiftTo (int index) {
      // edited
      int El_index     = index;
      int t_row        = tables.get(El_index).getNumRows()-1;
      float new_angle  = TWO_PI/t_row;
      //println(reachingCount);
      for (int i=0; i<t_row; i++) {
        for (int j=0; j<COLS-1; j++) {
          if (!P[El_index].sectors[i][j].hasReached()) {
            P[El_index].sectors[i][j].shiftRadius(P[El_index].getSectorRadius(i, j), 15f, P[El_index].getSectorValue(i, j));
          }
        }
      }
      //println(P[El_index].reachingCount);
      if (P[El_index].reachingCount<=0) {              //if all they are done

        P[El_index].reachingCount=(t_row*(COLS-1))-1;           //so reset the shifting counter
        shifting=false;                    //process is over
      }
    }

    //SECTOR CLASS///////////////////////////////////////////////////////////////////
    class Sector {
      boolean hovered, reached  =  true;
      float sectorRadius;
      int sectorValue;
      color sectorColor, hoverColor;

      //CONSTRUCTOR
      Sector (float sectorRadius, color sectorColor, color hoverColor, int sectorValue) {
        this.sectorRadius= sectorRadius; 
        this.sectorValue = sectorValue;
        this.sectorColor = sectorColor;
        this.hoverColor  = hoverColor;
        hovered=false;
      }

      //METODOS
      int getValue() {

        return sectorValue;
      }   

      void setValue(int newValue) {

        sectorValue  =  newValue;
      }  

      void setNewGoal() {
        reached=false;
      }

      boolean hasReached() {
        return reached;
      }

      float getRadius() {
        return sectorRadius;
      }

      void shiftRadius(float newRadius, float easingFactor, int newValue) {

        float distance  =  newRadius - sectorRadius;   //shift according to distance (easing)

        if (abs(distance)>0.1) {

          sectorRadius+=distance/easingFactor;
        } else {
          sectorValue  = newValue;  //set the reached value
          reached      = true;           
          reachingCount--;       //strike-through one of the list
        }
      }

      boolean isHovered() {
        return hovered;
      }

      void display(boolean hovered) {  

        int El_index     = index;
        int t_row        = tables.get(El_index).getNumRows()-1;
        float new_angle  = TWO_PI/t_row;


        fill(sectorColor);
        if (hovered) fill(hoverColor);

        arc(0, 0, sectorRadius, sectorRadius, 0, new_angle);
      }
    }  //end of SECTOR CLASS
  }    //end of POLAR ELEMENT CLASS
}      //end of POLAR CLASS