package org.duckdns.facebook;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONValue;

public class FacebookOAuth {
	
	public static String getUserEmail(String access_token) throws ClientProtocolException, IOException {
		DefaultHttpClient httpclient = new DefaultHttpClient();
        try {
            HttpGet httpget = new HttpGet("https://graph.facebook.com/v2.8/me?fields=id%2Cemail&access_token="+access_token);
            
            HttpResponse response = httpclient.execute(httpget);
            HttpEntity entity = response.getEntity();

            // System.out.println(response.getStatusLine());
            if (entity != null) {
            	// System.out.println("Response content length: " + entity.getContentLength());
                BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
                StringBuilder content = new StringBuilder();
                
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }
                // System.out.println("Response content: " + content.toString());
                Map allObj = (Map) JSONValue.parse(content.toString());
                if (allObj.containsKey("email")) {
	                if (allObj.containsKey("email")) {
	                	return (String) (allObj.get("email"));
	                }
                }
            }
            EntityUtils.consume(entity);
        } finally {
            // When HttpClient instance is no longer needed,
            // shut down the connection manager to ensure
            // immediate deallocation of all system resources
            httpclient.getConnectionManager().shutdown();
        }
        
        return null;
	}
	
	public static void main(String[] args) throws Exception {
		String accessToken = "CAAIW4fZAtgZAcBAMezOC2ZBZCjY0DqcZBXkrK8jOn0v9Mi7wKVP6pAJn2FIRuWV6ntbLGIIq0gJsld7Y4lN3nrQWfZCHyujfHPvLxFFZCxJkcNoZAQYAKBRTCcmrIhqGqilYn99UZCionTgBFjkOUkV2NRi6ISYoPXIpFbcNW7oC0RInGLffYuz1ycnbc1K7uG4ZCkzMLmdbBvZCAZDZD";
		System.out.println("Name is : " + FacebookOAuth.getUserEmail(accessToken));
	}
}
