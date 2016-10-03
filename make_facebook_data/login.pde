import facebook4j.auth.*;
import facebook4j.internal.http.*;
import facebook4j.internal.json.*;
import facebook4j.internal.logging.*;
import facebook4j.internal.org.json.*;
import facebook4j.conf.*;
import facebook4j.internal.util.*;
import facebook4j.management.*;
import facebook4j.*;
import facebook4j.json.*;
import facebook4j.api.*;

public class Login {

  GetAccessToken gat      = new GetAccessToken();
  AccessToken accessToken = null;
  Facebook facebook;

  // login constructor
  Login(){
    
   // prepare Facebook4J
     ConfigurationBuilder cb = new ConfigurationBuilder();
     cb.setDebugEnabled(true);
     cb.setOAuthAppId(appId);
     cb.setOAuthAppSecret(App_secret);
     cb.setOAuthPermissions(permissions);
  
     facebook = new FacebookFactory(cb.build()).getInstance();


    try {
      accessToken = gat.getAccessToken();
      facebook.setOAuthAccessToken(accessToken);
    } 
    catch(FacebookException e) {
      
      e.printStackTrace();  
  } 
    
  }
  
 
  Facebook get_facebook_instance(){
    
   return facebook;
    
  }

}