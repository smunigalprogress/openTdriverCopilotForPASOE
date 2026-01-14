/*
 * PASOE Basic APSV Demo - Server Procedure
 * Purpose: ABL server procedure for APSV transport protocol validation
 * Generated from: pas_apsv_template.txt
 * 
 * Description: Responds to APSV client connections and returns a success message.
 * Includes proper session handling and returns identifiable output for validation.
 */

PROCEDURE server:
    DEFINE OUTPUT PARAMETER response_msg AS CHARACTER NO-UNDO.
    
    /* Generate identifiable response message for validation */
    response_msg = "PASOE Basic APSV Demo: server response successful at " + 
                   STRING(NOW, "99/99/9999 HH:MM:SS") + 
                   " - APSV transport validation ready".
    
    /* Log server execution for debugging */
    MESSAGE "[SERVER] APSV Demo executed - " + response_msg.
    
    /* Additional server-side validation markers */
    MESSAGE "[SERVER] Session ID: " + SESSION:HANDLE:UNIQUE-ID.
    MESSAGE "[SERVER] Transport: APSV".
    MESSAGE "[SERVER] Procedure: server.p".
    
    RETURN response_msg.
END PROCEDURE.