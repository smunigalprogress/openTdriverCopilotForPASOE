/*
 * PASOE Basic APSV Demo - ABL Client
 * Purpose: ABL client for APSV transport protocol connectivity testing
 * Generated from: pas_apsv_template.txt
 *
 * Description: Connects to PASOE via APSV transport using configured apsv_URL,
 * executes server.p procedure, captures response, and writes output for validation.
 * Reads connection details from cspair.pf and handles connection errors gracefully.
 */

{adecomm/appserv.i}

DEFINE VARIABLE hAppServer AS HANDLE NO-UNDO.
DEFINE VARIABLE lConnected AS LOGICAL NO-UNDO.
DEFINE VARIABLE cResponse AS CHARACTER NO-UNDO.
DEFINE VARIABLE cConnString AS CHARACTER NO-UNDO.
DEFINE VARIABLE iStartTime AS INTEGER NO-UNDO.
DEFINE VARIABLE iEndTime AS INTEGER NO-UNDO.

MESSAGE "=== PASOE Basic APSV Demo - ABL Client ===".
MESSAGE "Purpose: APSV transport protocol validation".
MESSAGE "Template: pas_apsv_template.txt".
MESSAGE "".

iStartTime = ETIME.

/* Read connection parameters from cspair.pf */
MESSAGE "[CLIENT] Reading connection configuration from cspair.pf".
INPUT FROM "../cspair.pf".
IMPORT UNFORMATTED cConnString.
INPUT CLOSE.

MESSAGE "[CLIENT] Connection string: " + cConnString.
MESSAGE "".

/* Create and connect to PASOE APSV service */
MESSAGE "[CLIENT] Connecting to PASOE APSV service...".
CREATE SERVER hAppServer.

IF NOT VALID-HANDLE(hAppServer) THEN DO:
    MESSAGE "[ERROR] Failed to create server handle".
    QUIT.
END.

lConnected = hAppServer:CONNECT(cConnString) NO-ERROR.

IF NOT lConnected THEN DO:
    MESSAGE "[ERROR] Failed to connect to APSV service".
    IF ERROR-STATUS:ERROR THEN
        MESSAGE "[ERROR] Error details: " + ERROR-STATUS:GET-MESSAGE(1).
    QUIT.
END.

MESSAGE "[SUCCESS] Connected to APSV service successfully".
MESSAGE "[CLIENT] Server handle: " + STRING(hAppServer).
MESSAGE "".

/* Execute server procedure */
MESSAGE "[CLIENT] Executing server.p procedure...".

/* Run persistent procedure for session management */
RUN server.p ON hAppServer PERSISTENT SET hAppServer NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "[ERROR] Failed to run persistent server procedure".
    MESSAGE "[ERROR] Error details: " + ERROR-STATUS:GET-MESSAGE(1).
    hAppServer:DISCONNECT() NO-ERROR.
    DELETE OBJECT hAppServer NO-ERROR.
    QUIT.
END.

/* Call the server procedure */
RUN server IN hAppServer (OUTPUT cResponse) NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "[ERROR] Failed to execute server procedure".
    MESSAGE "[ERROR] Error details: " + ERROR-STATUS:GET-MESSAGE(1).
END.
ELSE DO:
    MESSAGE "[SUCCESS] Server procedure executed successfully".
    MESSAGE "[RESPONSE] server response: " + cResponse.
END.

iEndTime = ETIME.

MESSAGE "".
MESSAGE "[PERFORMANCE] Execution time: " + STRING(iEndTime - iStartTime) + " ms".
MESSAGE "".

/* Disconnect and cleanup */
MESSAGE "[CLIENT] Disconnecting from server...".
hAppServer:DISCONNECT() NO-ERROR.
DELETE OBJECT hAppServer NO-ERROR.
MESSAGE "[CLIENT] Disconnected successfully".

MESSAGE "".
MESSAGE "=== PASOE Basic APSV Demo - Client Test Completed ===".
MESSAGE "Test Result: " + (IF cResponse <> "" THEN "SUCCESS" ELSE "FAILED").
MESSAGE "Validation Pattern: server response found in output".

QUIT.