/* server.p - PASOE Server Procedure for Multi-Transport Testing */

DEFINE OUTPUT PARAMETER response_msg AS CHARACTER NO-UNDO.

/* Initialize response message */
response_msg = "Multi-transport validation server response - " + STRING(NOW, "HH:MM:SS").

/* Log server execution */
MESSAGE "Server procedure executed successfully at " + STRING(NOW).

/* Return success message for validation */
response_msg = response_msg + " - APSV connection successful, server.p executed".