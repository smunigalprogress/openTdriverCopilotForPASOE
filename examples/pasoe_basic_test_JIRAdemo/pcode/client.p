/* client.p - APSV Client for Multi-Transport Testing */

DEFINE VARIABLE hServer    AS HANDLE      NO-UNDO.
DEFINE VARIABLE response   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE https_port AS CHARACTER   NO-UNDO.

/* Read HTTPS port from cspair.pf */
INPUT FROM cspair.pf.
IMPORT https_port.
INPUT CLOSE.

/* Extract port number */
https_port = ENTRY(2, https_port, "=").

MESSAGE "Connecting to APSV server on port: " + https_port.

/* Create server handle and connect via APSV */
CREATE SERVER hServer.
hServer:CONNECT("-URL https://localhost:" + https_port + "/apsv -SessionModel Session-managed").

IF hServer:CONNECTED() THEN DO:
    MESSAGE "APSV connection established successfully".
    
    /* Run server procedure */
    RUN server.p ON hServer (OUTPUT response).
    
    MESSAGE "Server response: " + response.
    
    /* Disconnect from server */
    hServer:DISCONNECT().
    MESSAGE "APSV connection closed".
END.
ELSE DO:
    MESSAGE "ERROR: Failed to connect to APSV server".
    response = "APSV connection failed".
END.

/* Clean up */
DELETE OBJECT hServer.

MESSAGE "APSV client test completed - " + response.
QUIT.