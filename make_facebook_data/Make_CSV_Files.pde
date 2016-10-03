
class make_file {
 
  facebookData FB_data;
  PrintWriter file;
   
  int Factor = 1000;
  
  PrintWriter Videos,Texts,Photos,My_texts,Links,Photo_File,All_posts_file,profile_file;


  make_file(facebookData data, String All_Post_File_name){
    
    
      file = createWriter(All_Post_File_name); 

      FB_data = data;

    
  }
  
  

 
  // contructor class
  make_file(String V_Fname,String T_Fname,String MT_Faname, String L_fname, String P_fname, String photo_file, String all_posts,String profile){
    
      
      Videos       = createWriter(V_Fname);
      
      Texts        = createWriter(T_Fname);
      
      My_texts     = createWriter(MT_Faname);

      Links        = createWriter(L_fname); 

      Photos       = createWriter(P_fname);
      
      Photo_File   = createWriter(photo_file);
      
      All_posts_file = createWriter(all_posts);
      
      profile_file    = createWriter(profile);
  }
  
  void make_photo_files(){
    
        Photo_File.flush(); // Writes the remaining data to the file

  }
  
  
  void make_Post_Type_lines(){
    
    String Title_line = "All Posts" + "\t" + "Likes" + "\t" + "Comments" + "\t" + "Post_Type_ID";
 
    String link_line = "Links" + "\t" + FB_data.get_links_likes_count() + "\t"+ FB_data.get_links_comment_count()+ "\t" + 1; 
    
    String video_line = "Video" + "\t" + FB_data.get_video_likes_count() + "\t"+ FB_data.get_video_comment_count()+ "\t"+ 2; 

    String text_line = "Others" + "\t" + FB_data.get_Texts_likes_count() + "\t"+ FB_data.get_Texts_comment_count()+ "\t"+ 3; 
    
    String photo_line = "Photos" + "\t" + FB_data.get_photo_likes_count() + "\t"+ FB_data.get_photo_comment_count()+ "\t"+ 4; 
    
    String my_text_line = "MyPosts" + "\t" + FB_data.get_My_Text_likes_count() + "\t"+ FB_data.get_My_Text_comment_count()+"\t"+ 5;
  

    // insert lines to file
    file.println(Title_line); 
    file.println(link_line); 
    file.println(video_line); 
    file.println(text_line); 
    file.println(photo_line); 
    file.println(my_text_line); 

    // finish inserting
    file.flush(); // Writes the remaining data to the file

  }
  
  
 
  
  void make_file_headers(){
    
      Videos.println("Videos"+"\t"+"likes"+"\t"+"comments" +"\t"+"post_id");   
      
      Texts.println("Other Posts"+"\t"+"likes"+"\t"+"comments"+"\t"+"post_id");      
      
      My_texts.println("My Posts"+"\t"+"likes"+"\t"+"comments"+"\t"+"post_id");   

      Links.println("Links"+"\t"+"likes"+"\t"+"comments"+"\t"+"post_id");      

      Photos.println("Photos"+"\t"+"likes"+"\t"+"comments"+"\t"+"post_id");     
    
      profile_file.println("Profile_id"+"\t"+"username");
      
      
      String my_photo_line = "Post_id" +"\t" + "Post_Type"  + "\t" + "L/C" +"\t" + "UserId" + "\t" + "PostText";

      Photo_File.println(my_photo_line);
      Photo_File.flush(); // Writes the remaining data to the file
   
      // Make header to file
      String header = "Post_Id" + "\t" + "post_story";
          
      // write on the file
      All_posts_file.println(header);
   
      
  }

  void finalize_files(){
    
      
      Videos.flush();   
      
      Texts.flush();      
      
      My_texts.flush();   

      Links.flush();      

      Photos.flush();     
    
      All_posts_file.flush();
     
      profile_file.flush();

  }
  

   PrintWriter get_video_file(){
    
    return Videos;
  
  }

  PrintWriter get_photo_file(){
    
    return Photos;
  
  }
    
    PrintWriter get_photo_line(){
      
     return Photo_File;
      
    }
    
    PrintWriter get_link_file(){
    
    return Links;
  
  }
    
    PrintWriter get_text_file(){
    
    return Texts;
  
  }
    
    PrintWriter get_my_text_file(){
    
    return My_texts;
  
  }
   
    PrintWriter get_all_post_file(){
      
      return All_posts_file;
    }
    
     PrintWriter get_profile_file(){
      
      return profile_file;
    }
  
}