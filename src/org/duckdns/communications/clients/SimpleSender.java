package org.duckdns.communications.clients;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;

import org.duckdns.communications.Client;
import org.duckdns.communications.Message;

public class SimpleSender implements Client {

	public String send(InputStream input, OutputStream output, Message message) throws IOException {
		StringBuffer stringBuffer = new StringBuffer();
		try {
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(input));
			message.pushMessage(output);
			String currentLine = bufferedReader.readLine();
			boolean firstItem = true;
			while (currentLine != null) {
				stringBuffer.append(currentLine);
				if (!firstItem) {
					stringBuffer.append("\n");
				} else {
					firstItem = false;
				}
				currentLine = bufferedReader.readLine();
			}
		} finally {
			input.close();
			output.close();
		}
		return stringBuffer.toString();
	}

}
