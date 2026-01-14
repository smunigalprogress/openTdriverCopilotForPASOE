/*
 * PASOE Basic APSV Demo1 - Server Procedure
 * Purpose: ABL server procedure for APSV transport validation
 * Generated from: pas_apsv_template.txt
 */

PROCEDURE server:
    DEFINE OUTPUT PARAMETER response_msg AS CHARACTER NO-UNDO.
    
    response_msg = "PASOE Basic APSV Demo1: server response successful at " + 
                   STRING(NOW, "99/99/9999 HH:MM:SS") + 
                   " - APSV transport validation ready".
    
    MESSAGE "[SERVER] APSV Demo1 executed - " + response_msg.
    
    RETURN response_msg.
END PROCEDURE.