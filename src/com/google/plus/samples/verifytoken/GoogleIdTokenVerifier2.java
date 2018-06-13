package com.google.plus.samples.verifytoken;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.security.PublicKey;

import com.google.api.client.auth.openidconnect.IdTokenVerifier;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;

// Remember to remove this class later by making it deprecated
@Deprecated
public class GoogleIdTokenVerifier2 extends GoogleIdTokenVerifier {

    // Add constructors as needed
    public GoogleIdTokenVerifier2(HttpTransport transport, JsonFactory jsonFactory) {
        super(transport, jsonFactory);
    }

    @Override
    public boolean verify(GoogleIdToken googleIdToken) throws GeneralSecurityException, IOException {
        // check the payload
        if (!((IdTokenVerifier)this).verify(googleIdToken)) {
            return false;
        }
        // verify signature
        for (PublicKey publicKey : getPublicKeysManager().getPublicKeys()) {
            try {
                if (googleIdToken.verifySignature(publicKey)) {
                    return true;
                }
            } catch (Exception e) {
                System.err.println("Verify Token:" + e);
            }
        }
        return false;
    }
}