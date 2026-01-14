/*------------------------------------------------------------------------
    File        : WebRoundTrip
    Purpose     : OpenEdge Web Handler for WEB transport testing
    Syntax      : 
    Description : Handles WEB requests for /_oeping endpoint validation
    Author(s)   : T-Driver Test Framework
    Created     : 
    Notes       : Part of ECS-8 Multi-Transport Validation
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS WebRoundTrip:

    METHOD PUBLIC VOID HandleGet(INPUT request AS OpenEdge.Web.IWebRequest):
        
        DEFINE VARIABLE writer AS OpenEdge.Web.WebResponseWriter NO-UNDO.
        DEFINE VARIABLE responseText AS CHARACTER NO-UNDO.
        
        /* Create response writer */
        writer = NEW OpenEdge.Web.WebResponseWriter().
        
        /* Generate response content */
        responseText = "Round-trip completed for web transport - " + STRING(NOW, "HH:MM:SS") + " - _oeping handler response".
        
        /* Set response headers and content */
        writer:StatusCode = INTEGER(StatusCodeEnum:OK).
        writer:ContentType = "text/html".
        
        /* Write response body */
        writer:Open().
        writer:Write('<html><body><h1>WebRoundTrip Handler</h1>').
        writer:Write('<p>' + responseText + '</p>').
        writer:Write('</body></html>').
        writer:Close().
        
    END METHOD.

END CLASS.