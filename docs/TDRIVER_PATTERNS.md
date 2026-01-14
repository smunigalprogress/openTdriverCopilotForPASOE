# T-Driver Test Automation Patterns for GitHub Copilot

## Framework Standards

When creating T-Driver tests, ALWAYS follow these patterns:

### 1. Main Executable Structure
```bash
#!/bin/bash

# Test description and purpose
export TESTNAME="test_name_here"

# Handle cygwin environment
if [ "$IS_CYGWIN" = "1" ]; then
    WRKDIR=`cygpath -am $WRKDIR`
    RDLQA=`cygpath -am $RDLQA`
    QA=`cygpath -am $QA`
fi

# Copy files from RDLQA/QA
cp -f $RDLQA/common_funs.sh .
cp -f $QA/openssl.cnf .

# Copy test files
cp -f pcode/*.p .
cp -f pcode/*.cls .
cp -f properties/* .

# Source common functions
. ./common_funs.sh

# Standard PASOE workflow
f_getPorts "apsv http https jmx"
export INSTANCE_NAME="$TESTNAME"
f_createPASOEInstance
f_modifyPASOEInstancePorts
f_startPASOEInstance

# Test logic here

f_stopPASOEInstance
f_freePorts
```

### 2. ABL Server Procedure Pattern
```progress
/* server.p - Description */
DEFINE OUTPUT PARAMETER response_msg AS CHARACTER NO-UNDO.

response_msg = "Server response - " + STRING(NOW, "HH:MM:SS").
MESSAGE "Server procedure executed successfully".
```

### 3. APSV Client Pattern
```progress
/* client.p - APSV Client */
DEFINE VARIABLE hServer AS HANDLE NO-UNDO.
DEFINE VARIABLE response AS CHARACTER NO-UNDO.
DEFINE VARIABLE https_port AS CHARACTER NO-UNDO.

/* Read port from cspair.pf */
INPUT FROM cspair.pf.
IMPORT https_port.
INPUT CLOSE.
https_port = ENTRY(2, https_port, "=").

CREATE SERVER hServer.
hServer:CONNECT("-URL https://localhost:" + https_port + "/apsv -SessionModel Session-managed").

IF hServer:CONNECTED() THEN DO:
    RUN server.p ON hServer (OUTPUT response).
    hServer:DISCONNECT().
END.

DELETE OBJECT hServer.
QUIT.
```

### 4. Directory Structure
```
test_name/
├── test_name                    # Main executable
├── pcode/
│   ├── server.p                # ABL server procedure
│   ├── client.p                # ABL client
│   └── *.cls                   # Class files
├── properties/
│   └── openedge.properties     # Configuration
├── scripts/                    # Additional scripts
└── out/                        # Expected output baselines (REQUIRED)
    ├── apsv_client.out         # Expected APSV client output
    ├── rest_client.out         # Expected REST client output
    ├── soap_client.out         # Expected SOAP client output
    └── web_client.out          # Expected WEB client output
```

### 5. Expected Output Files (out/ Directory) - CRITICAL REQUIREMENT

**⚠️ MANDATORY**: Every T-Driver test MUST include an `out/` directory with expected output files.

The T-Driver framework compares actual test output against expected baseline files in the `out/` directory to determine test success/failure.

#### Required Files:
- **For APSV tests**: `out/apsv_client.out`
- **For REST tests**: `out/rest_client.out` or `out/curl_client.out`
- **For SOAP tests**: `out/soap_client.out`
- **For WEB tests**: `out/web_client.out`
- **For multi-transport tests**: Include all applicable `.out` files

#### Expected Output Content:
The `.out` files should contain:
- Success markers (e.g., "[SUCCESS]", "server response")
- Validation patterns that prove the test worked
- Key response messages (sanitized to remove dynamic values like timestamps, ports)
- Framework messages indicating proper execution

#### Example `out/apsv_client.out`:
```
=== PASOE APSV Test - ABL Client ===
Purpose: APSV transport validation

[CLIENT] Reading connection configuration from cspair.pf
[CLIENT] Connection string: -URL https://localhost:$https_port/apsv

[CLIENT] Connecting to PASOE APSV service...
[SUCCESS] Connected to APSV service successfully

[CLIENT] Executing server.p procedure...
[SUCCESS] Server procedure executed successfully

[RESPONSE] server response:

[VALIDATION] Round-trip communication: SUCCESS

[CLIENT] Disconnecting from server...
[CLIENT] Disconnected successfully

=== Test Completed ===
Test Result: SUCCESS
```

**Note**: Use generic placeholders like `$https_port` for dynamic values, omit actual timestamps/session IDs.

## Key Requirements for Team:

1. **MUST use standard common_funs.sh functions**: f_createPASOEInstance, f_getPorts, etc.
2. **MUST use framework environment variables**: $RDLQA, $QA, $PROEXE, $WRKDIR, etc.
3. **MUST follow standard header format** with test description
4. **MUST copy files from $RDLQA/$QA** at the beginning
5. **MUST create out/ directory with expected output files** - Framework uses these for validation
6. **NO custom logging or verbose output** - keep it concise
7. **ALWAYS include proper cleanup** with f_stopPASOEInstance and f_freePorts

## Context Transfer Instructions:

### For New Copilot Sessions:
1. **Load Context**: Paste content from COPILOT_CONTEXT_TRANSFER.md
2. **Reference Examples**: Point to COPILOT_SESSION_EXAMPLES.md  
3. **Validate Output**: Use framework compliance checklist

### Team Usage Pattern:
"Create a T-Driver test following the patterns in TDRIVER_PATTERNS.md for [test description]"

### Context Persistence:
- Keep TDRIVER_PATTERNS.md, COPILOT_CONTEXT_TRANSFER.md in workspace
- Reference working examples: pasoe_basic_test_JIRAdemo/, pasoe_basic_apsv_demo/
- Use validation checklist from COPILOT_SESSION_EXAMPLES.md