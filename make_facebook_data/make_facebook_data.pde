

// networking stuffs
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;


ResponseList <Post> All_Post;

// login to facebook;
Login fb_login;

// facebook instance
Facebook facebook;

void setup(){
  
  
  // configure network
  oscP5 = new OscP5(this,10000);
  myRemoteLocation = new NetAddress("127.0.0.1",10001);

  //request_New_Facebook_data(20);
}

void draw() {
  

  
  
}

 void oscEvent(OscMessage theMessage) {
     
   // check if the address is correct
     if (theMessage.checkAddrPattern("/update_facebook")==true) {
   
        // check the type tag to be correct 
        if(theMessage.checkTypetag("i")) {
          
          int message_val = theMessage.get(0).intValue();
            if (message_val > 0){
              
              println("updating... ",message_val);
              // run the update function
              request_New_Facebook_data(message_val);
              
              
              // send confirmation msg
              
              OscMessage update = new OscMessage("/completed");
              update.add(1);
              oscP5.send(update, myRemoteLocation);
              
            }

        }
       
     }
   
 }


void request_New_Facebook_data(int number_of_posts){
  
  // logins to facebook
   fb_login = new Login();
    
   
   // get facebook instance 
   facebook = fb_login.get_facebook_instance();
 
   // make the facebook get data class
   facebookData FB_data = new facebookData(facebook);
   
  // 
  try{
    // Get all the posts
    FB_data.get_posts(number_of_posts);
  }
  catch(FacebookException e) {
      println(e);
      exit();
  }
  
  // analyse the post types
  
  try{
  
      // analyse all the posts and make the files
      FB_data.Analyse_Posts();
  
  }
  catch (FacebookException e){
      println(e);
      exit();
  }
  
 
  // make file for each post types
  make_file post_types;
  
  String General_Post_File_name = "../data/0.tsv"; 
 

  post_types = new make_file(FB_data,General_Post_File_name);
  
  post_types.make_Post_Type_lines();
  
}