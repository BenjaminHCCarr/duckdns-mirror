package org.duckdns.communications;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class IncomingConnection extends Thread {
	Socket client;
	Service service;
	Listener listener;

	public IncomingConnection(Socket client, Listener listener) {
		super("Server.Connection:" + client.getInetAddress().getHostAddress() + ":" + client.getPort());
		this.client = client;
		this.listener = listener;
		this.service = listener.service;
	}

	public void run() {
		try {
			InputStream input = client.getInputStream();
			OutputStream output = client.getOutputStream();
			service.serve(input, output);
		} catch (IOException e) {
			// log(e);
		} finally {
			listener.endConnection(this);
		}
	}

}