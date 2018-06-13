package org.duckdns.communications.messages;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.util.Date;

import org.duckdns.communications.Message;

public class SingleLineMessage implements Message, Serializable {

	private static final long serialVersionUID = 3587556684990258747L;
	
	String message = "";
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	final long createdTimeStamp;
	
	public SingleLineMessage(String message) {
		this.message = message;
		this.createdTimeStamp = new Date().getTime();
	}
	
	public void pushMessage(OutputStream out) throws IOException {
		ObjectOutputStream objectOutput = new ObjectOutputStream(out);
        objectOutput.writeObject(this);
        objectOutput.flush();
	}
	
	public long getMessageCreationTimeStamp() {
		return this.createdTimeStamp;
	}

}