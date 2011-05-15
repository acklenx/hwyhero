package com.hwyking.yelp;

/*
Example code based on code from Nicholas Smith at http://imnes.blogspot.com/2011/01/how-to-use-yelp-v2-from-java-including.html
For a more complete example (how to integrate with GSON, etc) see the blog post above.
*/

import org.scribe.builder.ServiceBuilder;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.oauth.OAuthService;

/**
* Example for accessing the Yelp API.
*/
public class Yelp {

	 OAuthService service;
	 Token accessToken;
	
	 /**
	  * Setup the Yelp API OAuth credentials.
	  *
	  * OAuth credentials are available from the developer site, under Manage API access (version 2 API).
	  *
	  * @param consumerKey Consumer key
	  * @param consumerSecret Consumer secret
	  * @param token Token
	  * @param tokenSecret Token secret
	  */
	 public Yelp(String consumerKey, String consumerSecret, String token, String tokenSecret) {
	   this.service = new ServiceBuilder().provider(YelpApi2.class).apiKey(consumerKey).apiSecret(consumerSecret).build();
	   this.accessToken = new Token(token, tokenSecret);
	 }
	
	 /**
	  * Search with term and location.
	  *
	  * @param term Search term
	  * @param latitude Latitude
	  * @param longitude Longitude
	  * @return JSON string response
	  */
	 public String search(String term, double latitude, double longitude) {
	   OAuthRequest request = new OAuthRequest(Verb.GET, "http://api.yelp.com/v2/search");
	   request.addQuerystringParameter("term", term);
	   request.addQuerystringParameter("ll", latitude + "," + longitude);
	   this.service.signRequest(this.accessToken, request);
	   Response response = request.send();
	   return response.getBody();
	 }
	
	 // CLI
	 public static void main(String[] args) {
	   // Update tokens here from Yelp developers site, Manage API access.
	   String consumerKey = "Jcu7PtdgaBtei9jfC1TBCA";
	   String consumerSecret = "kPRgEa9vFQ476gVhHzcYV4h17z0";
	   String token = "kU0A6DSQQDzUx79u5QocCVFfFqRSNtpf";
	   String tokenSecret = "78XXhcpX_7Rif868PniHD-94Djs";
	
	   Yelp yelp = new Yelp(consumerKey, consumerSecret, token, tokenSecret);
	   String response = "";
	try {
		response = yelp.search("burritos", 30.361471, -87.164326);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	   System.out.println(response);
	 }
}