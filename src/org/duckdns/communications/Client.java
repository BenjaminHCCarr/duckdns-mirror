package org.duckdns.communications;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public interface Client {
	public String send(InputStream input, OutputStream output, Message message) throws IOException;		
}
