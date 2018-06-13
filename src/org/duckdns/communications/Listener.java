package org.duckdns.communications;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashSet;
import java.util.Set;

public class Listener extends Thread {
	ServerSocket listen_socket;
	int port;
	Service service;
	Set<IncomingConnection> connections;
	int maxConnections;
	ThreadGroup threadGroup;
	volatile boolean stop = false;

	public Listener(ThreadGroup group, int port, Service service,int maxConnections) throws IOException {
		super(group, "duckdns.Listener : " + port + " - " + service.getServiceName());
		listen_socket = new ServerSocket(port);
		listen_socket.setSoTimeout(600000);
		this.port = port;
		this.service = service;
		this.maxConnections = maxConnections;
		this.connections = new HashSet<IncomingConnection>(maxConnections);
		this.threadGroup = group;
	}
	
	protected synchronized void endConnection(IncomingConnection cincomingConnection) {
		connections.remove(cincomingConnection);
	}

	public synchronized void setMaxConnections(int max) {
		maxConnections = max;
	}

	public void pleaseStop() {
		this.stop = true;
		this.interrupt();
		try {
			listen_socket.close();
		} 
		catch (IOException e) {
		}
	}

	public void run() {
		while (!stop) { 
			try {
				Socket client = listen_socket.accept();
				this.addConnection(client);
			} catch (InterruptedIOException e) {
			} catch (IOException e) {
			}
		}
	}

	protected synchronized void addConnection(Socket socket) {
		if (connections.size() >= maxConnections) {
			try {
				PrintWriter out = new PrintWriter(socket.getOutputStream());
				out.print("Connection refused; the server is busy; please try again later.\n");
				out.flush();
				socket.close();
			} catch (IOException e) {
			}
		} else {
			IncomingConnection incomingConnection = new IncomingConnection(socket, this);
			connections.add(incomingConnection);
			incomingConnection.start();
		}
	}

}