package org.duckdns.communications;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public interface Service {
	public void serve(InputStream input, OutputStream output) throws IOException;
	public String getServiceName();
	public String getServiceStatus();
}