package org.duckdns.persona;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONValue;

public class PersonaAuth {
	
	public static String getUserEmail(String assertion, String host, boolean isHttps) throws ClientProtocolException, IOException {
		DefaultHttpClient httpclient = new DefaultHttpClient();
        try {
        	String protoStr = "http";
        	String portStr = "80";
        	if (isHttps) {
        		protoStr = "https";
            	portStr = "443";
        	}
        	ArrayList<NameValuePair> postParameters;
            HttpPost httppost = new HttpPost("https://verifier.login.persona.org/verify");
            postParameters = new ArrayList<NameValuePair>();
            postParameters.add(new BasicNameValuePair("assertion", assertion));
            postParameters.add(new BasicNameValuePair("audience", protoStr+"://"+host+":"+portStr));

            httppost.setEntity(new UrlEncodedFormEntity(postParameters));
            
            HttpResponse response = httpclient.execute(httppost);
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
                	if (allObj.containsKey("status")) {
                		String theStatus = (String) allObj.get("status");
                		if (theStatus.equals("okay")) {
                			EntityUtils.consume(entity);
                			return (String) (allObj.get("email"));
                		}
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
		String assertion = "eyJhbGciOiJSUzI1NiJ9.eyJwdWJsaWMta2V5Ijp7ImFsZ29yaXRobSI6IkRTIiwieSI6IjUxZDgxODllZWRmYWFlNmZiOGZiYzRmZTYxMDYyNmFlY2VhNzMwMjRhM2Y4YmNhZjVjODBmNWMyYjI4NTY2NTkwYzBmYzQzZjg2YWVhY2IxOTYwOWY4MGU5MjA4MWIxZDRmY2JkNjgwMDQ5NTI0YzY0MTQ2ZjMxMjJkY2VjYTM3ZWUwZWYwNGY3MjljZGNmMzFlNTRmZjA4YzNlZjI4MjljYTA0MjhhNzg1NGM3YzkzMGJhM2E5NWFkMzE3MzIwNTRkODNiNDRhY2U5YTNjMjBjZTc2ZmQyM2Y0YzkyMWU4YjRmMjRkMDJiOGU3MzAyMzhhNDZiMzExY2NhOWNmMTAiLCJwIjoiZmY2MDA0ODNkYjZhYmZjNWI0NWVhYjc4NTk0YjM1MzNkNTUwZDlmMWJmMmE5OTJhN2E4ZGFhNmRjMzRmODA0NWFkNGU2ZTBjNDI5ZDMzNGVlZWFhZWZkN2UyM2Q0ODEwYmUwMGU0Y2MxNDkyY2JhMzI1YmE4MWZmMmQ1YTViMzA1YThkMTdlYjNiZjRhMDZhMzQ5ZDM5MmUwMGQzMjk3NDRhNTE3OTM4MDM0NGU4MmExOGM0NzkzMzQzOGY4OTFlMjJhZWVmODEyZDY5YzhmNzVlMzI2Y2I3MGVhMDAwYzNmNzc2ZGZkYmQ2MDQ2MzhjMmVmNzE3ZmMyNmQwMmUxNyIsInEiOiJlMjFlMDRmOTExZDFlZDc5OTEwMDhlY2FhYjNiZjc3NTk4NDMwOWMzIiwiZyI6ImM1MmE0YTBmZjNiN2U2MWZkZjE4NjdjZTg0MTM4MzY5YTYxNTRmNGFmYTkyOTY2ZTNjODI3ZTI1Y2ZhNmNmNTA4YjkwZTVkZTQxOWUxMzM3ZTA3YTJlOWUyYTNjZDVkZWE3MDRkMTc1ZjhlYmY2YWYzOTdkNjllMTEwYjk2YWZiMTdjN2EwMzI1OTMyOWU0ODI5YjBkMDNiYmM3ODk2YjE1YjRhZGU1M2UxMzA4NThjYzM0ZDk2MjY5YWE4OTA0MWY0MDkxMzZjNzI0MmEzODg5NWM5ZDViY2NhZDRmMzg5YWYxZDdhNGJkMTM5OGJkMDcyZGZmYTg5NjIzMzM5N2EifSwicHJpbmNpcGFsIjp7ImVtYWlsIjoic3RldmVuaGFycGVydWtAZ21haWwuY29tIn0sImlhdCI6MTQzMzM0Nzk5OTk2NywiZXhwIjoxNDMzMzUxNjA5OTY3LCJpc3MiOiJnbWFpbC5sb2dpbi5wZXJzb25hLm9yZyJ9.i8EAC0Vd9UPNOWrMcg4gfY_W__QbGtc1ZDBLd--KZE342IhEyGir-IT4rV7fhn4O74xYqq9FywB-Q-WLgWfeLwLOevDxQrhucPRy-FTivqBCTgHwcroStTXYxSJwRDp48tPcCu8VkSuJdhhrXkQC0fN-RSMhgC6t4iyAx_v996y5NIXDGJ6NkQ-mxNmsPKBnElGZXhB0-1RSbDcWc-lWJCnlEosqOiuqIJkYD3c75KjIzzJfETQLGcPoIZGYkwSjB2uWKaJlN08T1rWHQGZwuv-Iqydmn4Nbj0Fzp8Awn3InJhLTTfAwDYT2Cu6X2NIFEOPKj0dPBmNWQPaZntyFDg~eyJhbGciOiJEUzEyOCJ9.eyJleHAiOjE0MzMzNDgxMzA2MTUsImF1ZCI6Imh0dHBzOi8vd3d3LmR1Y2tkbnMub3JnIn0.PXjdRi5qhocaqFIS2kHXjVnwIwC0nFjjWwra_cbyHGQixP1H5s1srg";
		System.out.println("Name is : " + PersonaAuth.getUserEmail(assertion,"www.duckdns.org", true));
	}
}
