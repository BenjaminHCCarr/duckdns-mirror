package org.duckdns.communications;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class OutgoingConnection extends Thread {
	Client client;
	Message message;
	Sender sender;
	String host;
	int port;

	public OutgoingConnection(String host, int port, Client client, Message message, Sender sender) {
		super("Client.Connection:" + host + ":" + port);
		this.host = host;
		this.port = port;
		this.client = client;
		this.message = message;
		this.sender = sender;
	}

	public String doSend() {
		String response = "";
		Socket server = null;
		try {
			server = new Socket(this.host, this.port);
			server.setSoTimeout(2000);
			InputStream in = server.getInputStream();
			OutputStream out = server.getOutputStream();
			response = client.send(in, out, message);
		} catch (IOException e) {
			System.out.println(e);
		} finally {
			sender.endConnection(this);
			try {
				server.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return response;
	}
	
	public void run() {
		doSend();
	}

}
