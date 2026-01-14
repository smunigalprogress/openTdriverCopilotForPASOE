/*
 * PASOE Basic APSV Demo1 - ABL Client
 * Purpose: ABL client for APSV transport connectivity testing
 * Generated from: pas_apsv_template.txt
 */

{adecomm/appserv.i}

DEFINE VARIABLE hAppServer AS HANDLE NO-UNDO.
DEFINE VARIABLE lConnected AS LOGICAL NO-UNDO.
DEFINE VARIABLE cResponse AS CHARACTER NO-UNDO.
DEFINE VARIABLE cConnString AS CHARACTER NO-UNDO.

MESSAGE "=== PASOE Basic APSV Demo1 - ABL Client ===".
MESSAGE "Purpose: APSV transport protocol validation".

/* Read connection parameters from cspair.pf */
INPUT FROM "cspair.pf".
IMPORT UNFORMATTED cConnString.
INPUT CLOSE.

MESSAGE "Connection string: " + cConnString.

/* Create and connect to PASOE APSV service */
CREATE SERVER hAppServer.
lConnected = hAppServer:CONNECT(cConnString) NO-ERROR.

IF NOT lConnected THEN DO:
    MESSAGE "ERROR: Failed to connect to APSV service".
    IF ERROR-STATUS:ERROR THEN
        MESSAGE "Error details: " + ERROR-STATUS:GET-MESSAGE(1).
    QUIT.
END.

MESSAGE "SUCCESS: Connected to APSV service".

/* Execute server procedure */
RUN server.p ON hAppServer PERSISTENT SET hAppServer.
RUN server IN hAppServer (OUTPUT cResponse) NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "ERROR: Failed to execute server procedure".
    MESSAGE "Error details: " + ERROR-STATUS:GET-MESSAGE(1).
END.
ELSE DO:
    MESSAGE "SUCCESS: server response - " + cResponse.
END.

/* Disconnect and cleanup */
hAppServer:DISCONNECT() NO-ERROR.
DELETE OBJECT hAppServer NO-ERROR.

MESSAGE "=== PASOE Basic APSV Demo1 - Test Completed ===".

QUIT.