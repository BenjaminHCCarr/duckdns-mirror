package org.duckdns.util;

import java.io.Serializable;

public class SessionHolder  implements Serializable {

	private static final long serialVersionUID = -616009221499240779L;
	
	private String email;
	private String ip;
	
	public SessionHolder(String email, String ip) {
		this.email = email;
		this.ip = ip;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

}