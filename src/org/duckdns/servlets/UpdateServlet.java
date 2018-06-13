package org.duckdns.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashSet;
import java.util.Set;
import java.util.StringTokenizer;

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

public class UpdateServlet extends javax.servlet.http.HttpServlet {

	private static final long serialVersionUID = -1;
	private static final Log LOG = LogFactory.getLog(UpdateServlet.class);

	private ServletContext context;
	
	private Sender s1;
	private Sender s2;
	private Sender s3;
	
	private static final String ROOT_DOMAIN = ".duckdns.org";

	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		context = config.getServletContext();
		LOG.debug("context: " + context);
		s1 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS1_INTERNAL(), 10025, 3, 100, 2000, new SimpleSender());
		s2 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS2_INTERNAL(), 10025, 3, 100, 2000, new SimpleSender());
		s3 = new Sender(EnvironmentUtils.getInstance().getFIXED_IP_NS3_INTERNAL(), 10025, 3, 100, 2000, new SimpleSender());
	}

	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String updateDomains = req.getParameter("domains");
		String token = req.getParameter("token");
		String optionalIp = req.getParameter("ip");
		String optionalIpV6 = req.getParameter("ipv6");
		String verbose = req.getParameter("verbose");
		String txt = req.getParameter("txt");
		boolean doVerbose = false;
		String clear = req.getParameter("clear");
		boolean doClear = false;
		
		if (verbose != null) {
			doVerbose = true;
		}
		
		if (clear != null && clear.equals("true")) {
			doClear = true;
		}
		
		String extraPath = req.getPathInfo();
		if (updateDomains == null && token == null && extraPath != null && extraPath.length() > 0) {
			StringTokenizer st = new StringTokenizer(extraPath,"/");
			int numTokens = st.countTokens();
			if (numTokens > 1) {
				updateDomains = st.nextToken();
				token = st.nextToken();
				if (numTokens > 2) {
					String tmpIp = st.nextToken();
					if (ServletUtils.isIPv6Address(tmpIp)) {
						optionalIpV6 = tmpIp;
					} else {
						optionalIp = tmpIp;
					}
				}
			}
		}
		
		if (updateDomains != null && token != null) {
			
			String message = "";
			if (optionalIp == null && optionalIpV6 == null && txt != null) {
				// UPDATE THE TXT Record
				message = updateTheTxt(req,updateDomains,token,txt,doVerbose, doClear);
			} else {
				message = updateTheDomains(req,updateDomains,token,optionalIp,optionalIpV6,doVerbose,doClear);
			}
			PrintWriter writer = resp.getWriter();
			writer.print(message);
			writer.flush();
			writer.close();
			return;
		}
		
		PrintWriter writer = resp.getWriter();
		writer.print("KO");
		writer.flush();
		writer.close();
		return;
	}

	private String updateTheTxt(HttpServletRequest req, String updateDomains, String token, String txt, boolean doVerbose, boolean doClear) {
		String returnMessage = "KO";
		if (token == null || token.length() == 0) {
			return returnMessage;
		}
		boolean same = true;
		if (updateDomains.length() > 0) {
			int largestPossible = (Domain.MAX_DOMAIN_LENGTH * Domain.MAX_DOMAINS_DONATE) + 9;
			if (updateDomains.length() < largestPossible) {
				// SENSIBLE - KEEP AT IT
				int hasAComma = updateDomains.indexOf(',');
				Set<String> domains = new HashSet<String>();
				if (hasAComma == -1) {
					domains.add(updateDomains);
				} else {
					// MORE THAN ONE
					StringTokenizer st = new StringTokenizer(updateDomains,",");
					while (st.hasMoreTokens()) {
						domains.add(st.nextToken());
					}
				}
				if (domains.size() > 0) {
					
					boolean oneFailed = false;
					for (String domain : domains) {
						boolean isAllowed = true;
						// PROTECTION BLOCK FOR WWW
						if (domain.equals("www")) {
							String requestIP = ServletUtils.getAddressFromRequest(req);
							if (requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS1()) || requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS2()) || requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS3())) {
								LOG.warn("domain update request for " + domain + " from " + ServletUtils.getAddressFromRequest(req)+ " txt now at " + txt);
							} else {
								isAllowed = false;
							}
						}
						if (isAllowed) {
							// STRIP TRAILING ROOT DOMAIN FOR PEOPLE THAT CANNOT FOLLOW INSTRUCTIONS
							if (domain.endsWith(ROOT_DOMAIN)) {
								domain = domain.substring(0,domain.length()-ROOT_DOMAIN.length());
							}
							// DEFAULT TO GOOD
							int txtUpdate = AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED;
							if (doClear) {
								txtUpdate = AmazonDynamoDBDAO.getInstance().domainUpdateTxt("", domain, token);
							} else {
								if (txt != null && txt.length() > 0) {
									txtUpdate = AmazonDynamoDBDAO.getInstance().domainUpdateTxt(txt, domain, token);
								} else {
									txtUpdate = AmazonDynamoDBDAO.UPDATE_RETURN_SAME;
								}
							}
							
							if (txtUpdate == AmazonDynamoDBDAO.UPDATE_RETURN_FAILED) {
								oneFailed = true;
							} else {
								if (txtUpdate == AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED) {
									// COOL expire the DNS CACHE(s)
									s1.send(new SingleLineMessage(domain));
									s2.send(new SingleLineMessage(domain));
									s3.send(new SingleLineMessage(domain));
									same = false;
								}
							}
						} else {
							oneFailed = true;
						}
					}
					if (!oneFailed) {
						if (doVerbose) {
							String extraSame = "UPDATED";
							if (same) {
								extraSame = "NOCHANGE";
							}
							returnMessage = "OK\n"+txt+"\n"+extraSame;
						} else {
							returnMessage = "OK";
						}
					}
				}
			}
		}
		return returnMessage;
	}

	private String updateTheDomains(HttpServletRequest req, String updateDomains, String token, String optionalIp, String optionalIpV6, boolean doVerbose, boolean doClear) {
		String returnMessage = "KO";
		boolean allSame = true;
		if (updateDomains.length() > 0) {
			int largestPossible = (Domain.MAX_DOMAIN_LENGTH * Domain.MAX_DOMAINS_DONATE) + 9;
			if (updateDomains.length() < largestPossible) {
				// SENSIBLE - KEEP AT IT
				int hasAComma = updateDomains.indexOf(',');
				Set<String> domains = new HashSet<String>();
				if (hasAComma == -1) {
					domains.add(updateDomains);
				} else {
					// MORE THAN ONE
					StringTokenizer st = new StringTokenizer(updateDomains,",");
					while (st.hasMoreTokens()) {
						domains.add(st.nextToken());
					}
				}
				String ipv4 = "";
				String ipv6 = "";
				if (domains.size() > 0) {
					if (!doClear) {
						// IF BOTH EMPTY!
						if ((optionalIp == null || optionalIp.length() == 0) && (optionalIpV6 == null || optionalIpV6.length() == 0)) {
							String tmpIp = ServletUtils.getAddressFromRequest(req);
							if (ServletUtils.isIPv6Address(tmpIp)) {
								ipv6 = tmpIp;
							} else {
								ipv4 = tmpIp;
							}
						} else {
							if (optionalIp != null && optionalIp.length() > 0) {
								ipv4 = optionalIp;
							}
							if (optionalIpV6 != null && optionalIpV6.length() > 0) {
								ipv6 = optionalIpV6;
							}
						}
					}
					boolean oneFailed = false;
					for (String domain : domains) {
						boolean isAllowed = true;
						// PROTECTION BLOCK FOR WWW
						if (domain.equals("www")) {
							String requestIP = ServletUtils.getAddressFromRequest(req);
							if (requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS1()) || requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS2()) || requestIP.equals(EnvironmentUtils.getInstance().getFIXED_IP_NS3())) {
								LOG.warn("domain update request for " + domain + " from " + ServletUtils.getAddressFromRequest(req)+ " main site now at " + optionalIp);
							} else {
								isAllowed = false;
							}
						}
						if (isAllowed) {
							// STRIP TRAILING ROOT DOMAIN FOR PEOPLE THAT CANNOT FOLLOW INSTRUCTIONS
							if (domain.endsWith(ROOT_DOMAIN)) {
								domain = domain.substring(0,domain.length()-ROOT_DOMAIN.length());
							}
							// DEFAULT TO GOOD
							int ipv4Update = AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED;
							int ipv6Update = AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED;
							if ((ipv4 != null && ipv4.length() > 0) || doClear) {
								ipv4Update = AmazonDynamoDBDAO.getInstance().domainUpdateIp(ipv4, domain, token, Domain.UPDATER_TYPE_HTTP);
							} else {
								ipv4Update = AmazonDynamoDBDAO.UPDATE_RETURN_SAME;
							}
							if ((ipv6 != null && ipv6.length() > 0) || doClear) {
								ipv6Update = AmazonDynamoDBDAO.getInstance().domainUpdateIpV6(ipv6, domain, token, Domain.UPDATER_TYPE_HTTP);
							} else {
								ipv6Update = AmazonDynamoDBDAO.UPDATE_RETURN_SAME;
							}
							if (ipv4Update == AmazonDynamoDBDAO.UPDATE_RETURN_FAILED || ipv6Update == AmazonDynamoDBDAO.UPDATE_RETURN_FAILED ) {
								oneFailed = true;
							} else {
								if (ipv4Update == AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED || ipv6Update == AmazonDynamoDBDAO.UPDATE_RETURN_UPDATED ) {
									// COOL expire the DNS CACHE(s)
									s1.send(new SingleLineMessage(domain));
									s2.send(new SingleLineMessage(domain));
									s3.send(new SingleLineMessage(domain));
									allSame = false;
								}
							}
						} else {
							oneFailed = true;
						}
					}
					if (!oneFailed) {
						if (doVerbose) {
							String extraSame = "UPDATED";
							if (allSame) {
								extraSame = "NOCHANGE";
							}
							returnMessage = "OK\n"+ipv4+"\n"+ipv6+"\n"+extraSame;
						} else {
							returnMessage = "OK";
						}
					}
				}
			}
		}
		return returnMessage;
	}
}
