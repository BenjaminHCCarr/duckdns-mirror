package org.duckdns.servlets;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.duckdns.communications.Sender;
import org.duckdns.communications.clients.SimpleSender;
import org.duckdns.communications.messages.SingleLineMessage;
import org.duckdns.dao.AmazonDynamoDBDAO;
import org.duckdns.dao.model.Domain;
import org.duckdns.util.EnvironmentUtils;
import org.duckdns.util.ServletUtils;
import org.duckdns.util.ValidationUtils;

public class GnuDIPServlet extends javax.servlet.http.HttpServlet {

	private static final long serialVersionUID = -1;
	private static final Log LOG = LogFactory.getLog(GnuDIPServlet.class);
	
	private static final String ROOT_DOMAIN = ".duckdns.org";
	
	private static String ACTION_UPDATE = "0";
	private static String ACTION_OFFLINE = "1";
	private static String ACTION_UPDATE_REPORT = "2";
	
	private static String RESULT_UPDATED = "0";
	private static String RESULT_FAILED = "1";
	private static String RESULT_OFFLINE = "2";
	
	private ServletContext context;
	
	private Sender s1;
	private Sender s2;
	private Sender s3;

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		context = config.getServletContext();
		LOG.debug("context: " + context);
		s1 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS1_INTERNAL(), 10025, 3, 50, 100, new SimpleSender());
		s2 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS2_INTERNAL(), 10025, 3, 50, 100, new SimpleSender());
		s3 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS3_INTERNAL(), 10025, 3, 50, 100, new SimpleSender());
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String salt = req.getParameter("salt");
		String time = req.getParameter("time");
		String sign = req.getParameter("sign");
		String user = req.getParameter("user");
		String domn = req.getParameter("domn");
		String pass = req.getParameter("pass");
		String reqc = req.getParameter("reqc");
		String addr = req.getParameter("addr");
		
		boolean allSame = false;
		boolean success = false;
		
		String detailedMessage = "";

		// DEBUG - we are not out of the woods yet - System.out.println(req.getRequestURI());
		// DEBUG - we are not out of the woods yet - System.out.println(req.getQueryString());
		
		if (salt != null && time != null && sign != null && user != null && domn != null && pass != null && reqc != null) {
			
			String domain = "";
			if (domn.endsWith(".duckdns.org")) {
				int pos = domn.indexOf(".duckdns.org");
				domain = domn.substring(0,pos);
			}
			
			Domain domainObject = checkSaltedUserPassDigestAsBase64(salt, domain, pass);
			if (domainObject != null) {
				// They Pass!
				
				if (reqc.equals(ACTION_OFFLINE)) {
					addr = "0.0.0.0";
				} else if (addr == null || addr.length() == 0) {
					addr = ServletUtils.getAddressFromRequest(req);
				}
				
				if (!domain.equals("www")) {
					
					// STRIP TRAILING ROOT DOMAIN FOR PEOPLE THAT CANNOT FOLLOW INSTRUCTIONS
					if (domain.endsWith(ROOT_DOMAIN)) {
						domain = domain.substring(0,domain.length()-ROOT_DOMAIN.length());
					}
					
					String currentIp = domainObject.getCurrentIp();
					if (addr.equals(currentIp)) {
						allSame = true;
					} else {
						// NOT SAME - Actually hit the DB again
						int result = AmazonDynamoDBDAO.getInstance().domainUpdateIp(addr, domain, domainObject.getAccountToken(), Domain.UPDATER_TYPE_GUNDIP);
						// DEBUG - we are not out of the woods yet - System.out.println("result : " + result);
						if (result == AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED) {
							s1.send(new SingleLineMessage(domain));
							s2.send(new SingleLineMessage(domain));
							s3.send(new SingleLineMessage(domain));
							allSame = false;
						} else if (result == AmazonDynamoDBDAO.UPDATE_RETURN_SAME) {
							allSame = true;
						}
					}
					success = true;
					req.setAttribute("result", RESULT_UPDATED);
				}
				
				if (success) {
					if (allSame) {
						detailedMessage = "Update - same";
						// DEBUG - we are not out of the woods yet - System.out.println("same!!");
					} else {
						// DEBUG - we are not out of the woods yet - System.out.println("notsame!");
						detailedMessage = "Updated to : " + addr;
					}
				}
			} else {
				detailedMessage = "No usertoken for that request";
			}
			
			if (!success) {
				req.setAttribute("result", RESULT_FAILED);
			}
			
			if (reqc.equals(ACTION_OFFLINE) && success) {
				req.setAttribute("result", RESULT_OFFLINE);
			}
			
			if (reqc.equals(ACTION_UPDATE_REPORT) && success) {
				req.setAttribute("addr", addr);
			}
			req.setAttribute("detailedMessage", detailedMessage);
			req.setAttribute("domain", domain);
			req.getRequestDispatcher("/WEB-INF/jsp/gnudip_response.jsp").forward(req, resp);
			return;
		} else {
			detailedMessage = "Not enough info - generating salt";
		}
		
		req.setAttribute("detailedMessage", detailedMessage);
		req.setAttribute("salt", generateSalt());
		req.setAttribute("time", System.currentTimeMillis());
		req.setAttribute("sign", "b33f15c0013e6710f14e4375ce455d17");
		
		req.getRequestDispatcher("/WEB-INF/jsp/gnudip_getsalt.jsp").forward(req, resp);
		return;
	}
	
	private String generateSalt() {
		char[] chars = "abcdefghijklmnopqrstuvwxyz1234567890".toCharArray();
		StringBuilder sb = new StringBuilder();
		Random random = new Random();
		for (int i = 0; i < 10; i++) {
		    char c = chars[random.nextInt(chars.length)];
		    sb.append(c);
		}
		return sb.toString();
	}
	
	private Domain checkSaltedUserPassDigestAsBase64(String salt, String domain, String pass) {
		
		String usersToken = null;
		
		if (!ValidationUtils.isValidSubDomain(domain)) {
			return null;
		}		
		Domain domainObj = AmazonDynamoDBDAO.getInstance().domainGetDomain(domain);
		if (domain == null || domainObj == null || domainObj.getAccountToken() == null ) {
			// HACK - when testing locally comment this
			return null;
		} else {
			usersToken = domainObj.getAccountToken();
		}
		
		// HACK - when testing locally un-comment this
		// usersToken = "a7c4d0ad-114e-40ef-ba1d-d217904a50f2";

		// DEBUG - we are not out of the woods yet - System.out.println("userToken : " + usersToken);
		// DEBUG - we are not out of the woods yet - System.out.println("salt : " + salt);		
		// DEBUG - we are not out of the woods yet - System.out.println("pass : " + pass);


		try {
			byte[] usersPassAsBytes = usersToken.getBytes("UTF-8");
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] usersPassDigest = md.digest(usersPassAsBytes);
			String strUsersPassDigestAsHEX = bytesToHex(usersPassDigest);
			strUsersPassDigestAsHEX = strUsersPassDigestAsHEX.toLowerCase();

			//String strUsersPassDigestAsBase64 = new String(usersPassDigestAsBase64);
			// DEBUG - we are not out of the woods yet - System.out.println("strUsersPassDigestAsHEX " + strUsersPassDigestAsHEX);
			
			String saltedDigest = strUsersPassDigestAsHEX + "." + salt;
			
			byte[] saltedUsersPassDigest = md.digest(saltedDigest.getBytes());
			// DEBUG - we are not out of the woods yet - System.out.println("saltedUsersPassDigest " + new String(saltedUsersPassDigest));
			String strSaltedUsersPassDigestAsBaseHEX = bytesToHex(saltedUsersPassDigest);
			
			//String strSaltedUsersPassDigestAsBase64 = new String(saltedUsersPassDigestAsBase64);
			// DEBUG - we are not out of the woods yet - System.out.println("strSaltedUsersPassDigestAsBaseHEX " + strSaltedUsersPassDigestAsBaseHEX);
			
			if (pass.toLowerCase().equals(strSaltedUsersPassDigestAsBaseHEX.toLowerCase())) {
				return domainObj;
			}
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	final protected static char[] hexArray = "0123456789abcdef".toCharArray();
	public static String bytesToHex(byte[] bytes) {
	    char[] hexChars = new char[bytes.length * 2];
	    for ( int j = 0; j < bytes.length; j++ ) {
	        int v = bytes[j] & 0xFF;
	        hexChars[j * 2] = hexArray[v >>> 4];
	        hexChars[j * 2 + 1] = hexArray[v & 0x0F];
	    }
	    return new String(hexChars);
	}
	
	public static void main(String[] args) {
		
		// http://localhost:8080/duckdns/gnudip/test?salt=z7vejdbppv&time=1394920211638&sign=b33f15c0013e6710f14e4375ce455d17&user=gnudip&pass=1oXQXk1rC58vMMtrHhChEw%3D%3D&domn=test.duckdns.org&reqc=2&addr=
		// SEE http://gnudip2.sourceforge.net/gnudip-www/latest/gnudip/html/protocol.html
		// salt=z7vejdbppv&time=1394920211638&sign=b33f15c0013e6710f14e4375ce455d17&user=gnudip&pass=1oXQXk1rC58vMMtrHhChEw%3D%3D&domn=test.duckdns.org&reqc=0&addr=192.168.0.4
		
		String salt = "02icud6hy";
		String time = "1394920211638";
		String sign = "b33f15c0013e6710f14e4375ce455d17";
		String usersPass = "adb17833-add6-4cae-82ee-addf2e8eb06d";
		
		try {
			byte[] usersPassAsBytes = usersPass.getBytes("UTF-8");
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] usersPassDigest = md.digest(usersPassAsBytes);
			String strUsersPassDigestAsHEX = bytesToHex(usersPassDigest);
			strUsersPassDigestAsHEX = strUsersPassDigestAsHEX.toLowerCase();
			//String strUsersPassDigestAsBase64 = new String(usersPassDigestAsBase64);
			System.out.println("strUsersPassDigestAsHEX " + strUsersPassDigestAsHEX);
			
			String saltedDigest = strUsersPassDigestAsHEX + "." + salt;
			
			byte[] saltedUsersPassDigest = md.digest(saltedDigest.getBytes());
			System.out.println("saltedUsersPassDigest " + new String(saltedUsersPassDigest));
			String strSaltedUsersPassDigestAsBaseHEX = bytesToHex(saltedUsersPassDigest);
			
			//String strSaltedUsersPassDigestAsBase64 = new String(saltedUsersPassDigestAsBase64);
			System.out.println("strSaltedUsersPassDigestAsBaseHEX " + strSaltedUsersPassDigestAsBaseHEX);
			
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
	
}
