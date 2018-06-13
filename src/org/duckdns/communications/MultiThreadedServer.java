package org.duckdns.communications;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class MultiThreadedServer {
	
	private static MultiThreadedServer instance = new MultiThreadedServer();
	
	Map<Integer, Listener> serviceListeners;
	
	public static MultiThreadedServer getInstance() {
        return instance;
    }
	
	private MultiThreadedServer() {
		log("Starting server");
		serviceListeners = new HashMap<Integer, Listener>();
	}

	protected synchronized void log(String s) {
		System.out.println("[" + new Date() + "] " + s);
	}
	
	protected void log(Object o) {
		log(o.toString());
	}
	
	public Service getService(int port) {
		if (serviceListeners.containsKey(port)) {
			return serviceListeners.get(port).service;
		} 
		return null;
	}
	
	public synchronized void addService(Service service, int port, int maxConnections) throws IOException {
		Integer key = new Integer(port);
		// Check whether a service is already on that port
		if (serviceListeners.get(key) != null) {
			throw new IllegalArgumentException("Port " + port + " already in use.");
		}
		// Create a Listener object to listen for connections on the port	
		Listener listener = new Listener(new ThreadGroup(service.getClass().getName()),port, service, maxConnections);
		serviceListeners.put(key, listener);
		// Log it
		log("Starting service " + service.getClass().getName() + " on port " + port);
		// Start the listener running.
		listener.setDaemon(true);
		listener.start();
	}
	
	public synchronized void removeService(int port) {
	    Integer key = new Integer(port);
	    final Listener listener = (Listener) serviceListeners.get(key);
	    if (listener == null) return;
	    listener.pleaseStop();
	    serviceListeners.remove(key);
	    log("Stopping service " + listener.service.getClass().getName() + " on port " + port);
	  }
	
	public synchronized String displayStatus() {
	    // Display a list of all Services that are being provided
		StringBuffer sb = new StringBuffer();
	    for (Integer port: serviceListeners.keySet()) {
	    	Listener eachListener = serviceListeners.get(port);
	    	sb.append("SERVICE ");
	    	sb.append(eachListener.service.getServiceName());
	    	sb.append(" (");
	    	sb.append(eachListener.service.getClass().getName());
	    	sb.append(") ON PORT ");
	    	sb.append(port);
	    	sb.append(" MAX CONNECTIONS : ");
	    	sb.append(eachListener.maxConnections);
	    	sb.append(" STATUS : ");
	    	sb.append(eachListener.service.getServiceStatus());
	    	sb.append("\n");
	    	for (IncomingConnection c: eachListener.connections) {
	    		sb.append("CONNECTED TO ");
	    		sb.append(c.client.getInetAddress().getHostAddress());
	    		sb.append(":");
	    		sb.append(c.client.getPort());
	    		sb.append(" ON PORT ");
	    		sb.append(c.client.getLocalPort());
	    		sb.append(" FOR SERVICE ");
	    		sb.append(c.service.getClass().getName());
	    		sb.append("\n");
	 	    }
	    }
	    return sb.toString();
	}

	public synchronized String displayStatusHtml() {
		StringBuffer sb = new StringBuffer();
		
		sb.append("<table width=\"100%\">\n<tr>\n");
		sb.append("<td><b>Service</b></td><td><b>Port</b></td><td><b>Status</b></td><td><b>Connections</b></td><td><b>Max</b></td></tr>\n");
		
	    for (Integer port: serviceListeners.keySet()) {
	    	sb.append("<tr>\n");
	    	Listener eachListener = serviceListeners.get(port);
	    	sb.append("<td>");
	    	sb.append(eachListener.service.getServiceName());
	    	sb.append(" (");
	    	sb.append(eachListener.service.getClass().getName());
	    	sb.append(")</td>\n<td>");
	    	sb.append(port);
	    	sb.append("</td>\n<td>");
	    	sb.append(eachListener.service.getServiceStatus());
	    	sb.append("</td>\n<td>");
	    	sb.append(eachListener.connections.size());
	    	sb.append("</td>\n<td>");
	    	sb.append(eachListener.maxConnections);
	    	sb.append("</td>\n</tr>\n");
	    	for (IncomingConnection c: eachListener.connections) {
	    		sb.append("<tr><td align=\"right\"><b>connection</b></td><td colspan=\"4\">");
	    		sb.append(c.client.getInetAddress().getHostAddress());
	    		sb.append(":");
	    		sb.append(c.client.getPort());
	    		sb.append(" -> ");
	    		sb.append(c.client.getLocalPort());
	    		sb.append(" : ");
	    		sb.append(c.service.getClass().getName());
	    		sb.append("</td></tr>");
	 	    }
	    }
	    sb.append("</table>\n");
	    return sb.toString();
	}
		
}
