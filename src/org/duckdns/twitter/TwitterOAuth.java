package org.duckdns.twitter;

import java.util.Map;

import org.json.simple.JSONValue;

public class TwitterOAuth {
	public static TwitterDetails getUserDetails(String responseBody) {
		Map allObj = (Map) JSONValue.parse(responseBody);
		
        if (allObj.containsKey("id_str") && allObj.containsKey("name")) {
        	
        	TwitterDetails tw = new TwitterDetails();
        	
        	tw.setTwitterName((String) allObj.get("name"));
        	tw.setTwitterId((String) allObj.get("id_str"));
        	
        	return tw;
        } 
        
        return null;
	}
}
