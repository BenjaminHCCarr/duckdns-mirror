package org.duckdns.reddit;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.duckdns.util.EnvironmentUtils;
import org.json.simple.JSONValue;

public class RedditOAuth {
	
	private static final String REDDIT_APP_ID = EnvironmentUtils.getInstance().getRedditAppID();
	private static final String REDDIT_APP_SECRET = EnvironmentUtils.getInstance().getRedditAppSecret();
	
	public static String getUserName(String access_token) throws ClientProtocolException, IOException {
		DefaultHttpClient httpclient = new DefaultHttpClient();
        try {
            HttpGet httpget = new HttpGet("https://oauth.reddit.com/api/v1/me");
            httpget.setHeader("Authorization", "bearer "+access_token+"");
            httpget.addHeader("User-Agent", "DuckDNS Auth");
            
            //System.out.println("executing request" + httpget.getRequestLine());
            HttpResponse response = httpclient.execute(httpget);
            HttpEntity entity = response.getEntity();

            //System.out.println(response.getStatusLine());
            if (entity != null) {
            	//System.out.println("Response content length: " + entity.getContentLength());
                BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
                StringBuilder content = new StringBuilder();
                String line;
                while (null != (line = br.readLine())) {
                    content.append(line);
                }
                //System.out.println(content.toString());
                Map json = (Map) JSONValue.parse(content.toString());
                if (json != null && json.containsKey("name")) {
                	return (String) (json.get("name"));
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
	
	public static String getAccessToken(String code, String redirectUrl) throws ClientProtocolException, IOException {
		DefaultHttpClient httpclient = new DefaultHttpClient();
        try {
            httpclient.getCredentialsProvider().setCredentials(
                    new AuthScope("ssl.reddit.com", 443),
                    new UsernamePasswordCredentials(REDDIT_APP_ID, REDDIT_APP_SECRET));

            HttpPost httppost = new HttpPost("https://ssl.reddit.com/api/v1/access_token");
            
            List <NameValuePair> nvps = new ArrayList <NameValuePair>(3);
            nvps.add(new BasicNameValuePair("code", code));
            nvps.add(new BasicNameValuePair("grant_type", "authorization_code"));
            nvps.add(new BasicNameValuePair("redirect_uri", "https://www.duckdns.org/login"));

            httppost.setEntity(new UrlEncodedFormEntity(nvps));
            httppost.addHeader("User-Agent", "DuckDNS Auth");
            httppost.setHeader("Accept","any;");
       
            // System.out.println("executing request " + httppost.getRequestLine());
            
            HttpResponse response = httpclient.execute(httppost);
            HttpEntity entity = response.getEntity();
            
            //System.out.println(response.getStatusLine());
            if (entity != null) {
            	 BufferedReader br = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
                 StringBuilder content = new StringBuilder();
                 String line;
                 while (null != (line = br.readLine())) {
                     content.append(line);
                 }
                 //System.out.println(content.toString());
                 Map json = (Map) JSONValue.parse(content.toString());
                 if (json.containsKey("access_token")) {
                	 return (String) (json.get("access_token"));
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
		String accessToken = RedditOAuth.getAccessToken("KIOOYr9O88LdjPfIyF9_0m2feAU","https://www.duckdns.org/login");
		System.out.println("Access Token is : " + accessToken);
		System.out.println("Name is : " + RedditOAuth.getUserName(accessToken));
	}
}
