
import java.util.*;

public class facebookData{

  
// variables for different posts
  ResponseList <Post> All_Posts;
  
  
  ArrayList <Post> Video_Posts  = new ArrayList<Post>();
  ArrayList <Post> Photo_Posts  = new ArrayList<Post>();
  ArrayList <Post> Text_Posts   = new ArrayList<Post>();
  ArrayList <Post> Link_Posts   = new ArrayList<Post>();
  ArrayList <Post> MyText_Posts = new ArrayList<Post>();


  // file names
    String L_fname            = "../data/1.tsv";
    String V_Fname            = "../data/2.tsv";
    String T_Fname            = "../data/3.tsv";
    String P_fname            = "../data/4.tsv";
    String MT_Faname          = "../data/5.tsv";
    String Photo_file         = "../data/photofie.tsv";
    String All_post_file_name = "../data/posts.tsv";
    String profile            = "../data/profile.tsv";
    String photo_lines        = "";
    
    make_file make_post_files;
  

  // Variables for Number of likes and comments
  int Video_likes   = 0, Video_comments   = 0,video_count=0;
  int Photo_likes   = 0, Photo_comments   = 0,photo_count=0;
  int Text_likes    = 0, Text_comments    = 0,text_count=0;
  int Link_likes    = 0, Link_comments    = 0,link_count=0;
  int MyText_likes  = 0, MyText_comments  = 0,mytext_count=0;


  // create facebook instance
  Facebook FB;
 
  facebookData(Facebook face_book){
   
    FB = face_book;
    
    // make the files
    make_post_files = new make_file(V_Fname,T_Fname,MT_Faname,L_fname,P_fname,Photo_file,All_post_file_name,profile);
    
  }
 
  
  // get user profile
  
  public void make_user_profile() throws FacebookException{
    
      // make line for the file

      User me = FB.getMe();
      String my_name = me.getName();
      String my_id   = me.getId();
      
      make_post_files.get_profile_file().println(my_id + "\t" + my_name);
      
      // save the user profile picture
      save_user_image(my_id,my_name);
  
  }
  
  
  
  // get all the posts
  public void get_posts(int number_of_posts) throws FacebookException{
    
     All_Posts = FB.getPosts(new Reading().limit(number_of_posts));     
    
  }
  
  // get number of posts
  public Integer get_number_of_Posts(){
    
    return All_Posts.size();
    
  }
  
  
  // Analyses posts and seprates it to different sections
  public void Analyse_Posts() throws FacebookException{
 
    
    // make the header files
    make_post_files.make_file_headers();
    
    // make profile file
    make_user_profile();
    
    
    for (int i =0;i< All_Posts.size();i++){
     
      
      Post new_post = All_Posts.get(i);
      
      // get the post id
      String P_id   = new_post.getId(); 
      
      // check for user's post

      String s = new_post.getStory();
      String m = new_post.getMessage();
 
      if (s == null){  // this is users post 
      
        MyText_Posts.add(new_post);
      
        //put the story in the file
        make_post_files.get_all_post_file().println(P_id +"\t"+m);
 
        // compute likes and comments
        compute_Post_likes_Comments(P_id,"my_texts");
        
        
      }
      
      else{ // the user has shared something from somewhere else like (links, photos, videos ..)
     
            String[] Story = split(s, ' ');
            int last_index = Story.length-1;
            
            
            // if link
            if ((Story[last_index]).equals("link.")){
              
              Link_Posts.add(new_post);
              
               //put the story in the file
              make_post_files.get_all_post_file().println(P_id +"\t"+s);
              
              // compute likes and comments
              compute_Post_likes_Comments(P_id,"links");

              
            }
            // if photo
            else if ((Story[last_index]).equals("photo.")){
           
              Photo_Posts.add(new_post);
              
              //put the story in the file
              make_post_files.get_all_post_file().println(P_id +"\t"+s);
              
              
              // compute likes and comments
              compute_Post_likes_Comments(P_id,"photo");

              
            }
            // if video
            else if ((Story[last_index]).equals("video.")){
              
              Video_Posts.add(new_post);
              
              //put the story in the file
              make_post_files.get_all_post_file().println(P_id +"\t"+s);
              
              
             // compute likes and comments
              compute_Post_likes_Comments(P_id,"video");
 
              
            }
            // if other posts
           else if ((Story[last_index]).equals("post.") ){
             
             
             Text_Posts.add(new_post);
             
              //put the story in the file
              make_post_files.get_all_post_file().println(P_id +"\t"+s);

             //compute likes and comments
              compute_Post_likes_Comments(P_id,"texts");
  
             
            }
        
            
        }

    }
    
           make_post_files.finalize_files();
           make_post_files.make_photo_files();

  }
  
   // get the number of all link likes
   public void compute_Post_likes_Comments(String P_Id, String post_type) throws FacebookException{
    
        ResponseList <Like> post_likes;
        ResponseList <Comment> post_comment;

        // Get post likes
        post_likes       = FB.getPostLikes(P_Id);
        post_comment     = FB.getPostComments(P_Id);

        
        // get likes and comment size
        int Like_size     = post_likes.size();
        int comment_size  = post_comment.size();
        
        if (post_type.equals("links")){
        
          save_photo_file(post_likes,post_comment,P_Id,"1");
          
          String link_line =  link_count + "\t" + Like_size + "\t" + comment_size + "\t" + P_Id;
          link_count++;
           // write to specific file
          make_post_files.get_link_file().println(link_line);
   
          // count all the likes
          Link_likes    = Link_likes + Like_size;
          Link_comments = Link_comments +comment_size ;
          
          
        }
        else if (post_type.equals("photo")){

          save_photo_file(post_likes,post_comment,P_Id,"4");

          
          String link_line = photo_count + "\t" + Like_size + "\t" + comment_size + "\t" + P_Id;
          photo_count++;
          // write to specific file
          make_post_files.get_photo_file().println(link_line);
          
          
          // count all the likes
          Photo_likes   = Photo_likes + Like_size;       
          Photo_comments  =  Photo_comments + comment_size;
          
          
        }
        else if (post_type.equals("texts")){
          
          save_photo_file(post_likes,post_comment,P_Id,"3");

          
          String link_line = text_count + "\t" + Like_size + "\t" + comment_size + "\t" + P_Id;
          text_count++;
          // write to specific file
          make_post_files.get_text_file().println(link_line);
          
          // count all the likes

          Text_likes    =  Text_likes + Like_size;
          Text_comments =  Text_comments + comment_size;
          
        }
        
        else if (post_type.equals("video")){

          save_photo_file(post_likes,post_comment,P_Id,"2");

          
          String link_line = video_count + "\t" + Like_size + "\t" + comment_size + "\t" + P_Id;
          video_count++;
          // write to specific file
          make_post_files.get_video_file().println(link_line);
          
          // count all the likes
          Video_likes      = Video_likes  + Like_size;
          Video_comments   = Video_comments  + comment_size;
          
        }
        
        else if (post_type.equals("my_texts")){
          
          save_photo_file(post_likes,post_comment,P_Id,"5");

          
          String link_line = mytext_count + "\t" + Like_size + "\t" + comment_size + "\t" + P_Id;
          mytext_count++;
          
          // write to specific file
          make_post_files.get_my_text_file().println(link_line);
   
          // count all the likes
          MyText_likes    = MyText_likes + Like_size;
          
          MyText_comments = MyText_comments + comment_size;
          
        }
       
        
      }  
  
  
  //void make_user_photo_file (String Line){
   
  //     Photo_File.println(Line);
  //     Photo_File.flush(); // Writes the remaining data to the file
    
    
  //}
  
  void save_photo_file(ResponseList <Like> photo_likes, ResponseList<Comment> photo_comments, String P_Id, String post_type)throws FacebookException{
    
    
     for (int l =0;l <photo_likes.size();l++){  
       
            String user_id = photo_likes.get(l).getId();
            String username = FB.getUser(user_id).getName();

            // make the like line     
            photo_lines = P_Id + "\t" + post_type + "\t" + "0" +"\t" +username;
            make_post_files.get_photo_line().println(photo_lines);
            // make the photo
            save_user_image(user_id,username);
            
        }
        
          for (int l =0;l <photo_comments.size();l++){  

            String username = photo_comments.get(l).getFrom().getName();
            String user_id  = photo_comments.get(l).getFrom().getId();

 
            // make the comment line     
            photo_lines = P_Id + "\t" + post_type + "\t" + "1" +"\t" +username;
            make_post_files.get_photo_line().println(photo_lines);
            // make the photo
            save_user_image(user_id,username);
            
        }
    
    
    
  }
  
  
  void save_user_image (String User_id, String Username) throws  FacebookException{
   
    PImage user_pic;
    
   // make the url
   String url = FB.getPictureURL(User_id).toString();
   // load the pic 
    user_pic = loadImage(url.toString(), "png"); 
      
    String path;
    path = savePath("../data/user_photos/"+Username+".jpg");
    user_pic.save(path);

  }
  
 
     // get videos
   public ArrayList <Post> get_video(){
      return Video_Posts;
  }
   
   public Integer get_video_likes_count(){
      return Video_likes;
  }
  
   public Integer get_video_comment_count(){
      return Video_comments;
  }
   
   
   
   // get photos
   public ArrayList <Post> get_photo(){
      return Photo_Posts; 
  }
   
   public Integer get_photo_likes_count(){
      return Photo_likes;
  }
  
   public Integer get_photo_comment_count(){
      return Photo_comments;
  }
   

   // get my posts
   public ArrayList <Post> get_my_posts(){
      return MyText_Posts; 
  }
  
   public Integer get_My_Text_likes_count(){
      return MyText_likes;
  }
  
   public Integer get_My_Text_comment_count(){
      return MyText_comments;
  }
  
   // get links posts
   public ArrayList <Post> get_links(){
      return Link_Posts; 
  }
  
   public Integer get_links_likes_count(){
      return Link_likes;
  }
  
   public Integer get_links_comment_count(){
      return Link_comments;
  }

   // get text posts
   public ArrayList <Post> get_texts(){
      return Text_Posts; 
  }
  
   public Integer get_Texts_likes_count(){
      return Text_likes;
  }
  
   public Integer get_Texts_comment_count(){
      return Text_comments;
  }
  
  
   }