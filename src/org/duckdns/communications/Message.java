package org.duckdns.communications;

import java.io.IOException;
import java.io.OutputStream;

public interface Message {
	public void pushMessage(OutputStream outputStream) throws IOException;
	public long getMessageCreationTimeStamp();
}
