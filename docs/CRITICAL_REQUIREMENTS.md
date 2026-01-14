# T-Driver Critical Requirements - DO NOT FORGET

## ⚠️ MANDATORY: out/ Directory with Expected Output Files

### The Problem
T-Driver framework validates tests by comparing actual output against expected baseline files stored in the `out/` directory. **Tests without this directory will fail validation.**

### The Requirement
**EVERY T-Driver test MUST include:**

1. **out/ directory** in the test root
2. **Expected output baseline files** matching each transport type tested

### Directory Structure - COMPLETE
```
test_name/
├── test_name                    # Main executable (bash script)
├── pcode/                       # ABL source code
│   ├── server.p                # Server procedures
│   ├── client.p                # Client programs
│   └── *.cls                   # Class files (if needed)
├── properties/                  # Configuration
│   └── openedge.properties     # PASOE properties
├── scripts/                     # Helper scripts (if needed)
└── out/                        # ⚠️ REQUIRED - Expected output baselines
    ├── apsv_client.out         # For APSV transport tests
    ├── rest_client.out         # For REST API tests
    ├── curl_client.out         # For REST/HTTP tests using curl
    ├── soap_client.out         # For SOAP tests
    └── web_client.out          # For WEB handler tests
```

### What Goes in the .out Files?

Expected output files should contain the **expected console output** from test execution, sanitized to remove dynamic values:

#### Example: `out/apsv_client.out`
```
=== PASOE APSV Round-Trip Test - ABL Client ===
Purpose: APSV round-trip communication validation
Test: Full parameter exchange and response validation

[CLIENT] Test request: Hello PASOE Server - Round-Trip Test Request

[CLIENT] Reading connection configuration from cspair.pf
[CLIENT] Connection string: -URL https://localhost:$https_port/apsv -nohostverify

[CLIENT] Connecting to PASOE APSV service...
[SUCCESS] Connected to APSV service successfully

[CLIENT] Executing server.p procedure with parameters...
[SUCCESS] Server procedure executed successfully

[RESPONSE] server response: APSV Round-Trip SUCCESS: Processed request 'Hello PASOE Server - Round-Trip Test Request'
[RESPONSE] Response code: 200

[VALIDATION] Round-trip communication: SUCCESS
[VALIDATION] Request echoed in response: YES
[VALIDATION] Response code valid: YES (200)
[VALIDATION] Timestamp received: YES

[PERFORMANCE] Round-trip execution time:

[CLIENT] Disconnecting from server...
[CLIENT] Disconnected successfully

=== PASOE APSV Round-Trip Test - Client Test Completed ===
Test Result: SUCCESS
Validation Pattern: Round-Trip SUCCESS found in server response
Parameters Exchanged: INPUT (1), OUTPUT (3)
```

### Key Points for Expected Output Files:

1. **Include success markers**: `[SUCCESS]`, `Test Result: SUCCESS`, validation patterns
2. **Remove dynamic values**: 
   - Use `$https_port` instead of actual port numbers
   - Omit timestamps or use placeholders
   - Remove session IDs and unique identifiers
3. **Keep structural markers**: Section headers, test phases, validation steps
4. **Include failure detection patterns**: Error messages if testing error handling

### Checklist Before Generating a Test:

- [ ] Created `out/` directory in test root
- [ ] Created `.out` file for each transport type being tested
- [ ] `.out` file contains expected success patterns
- [ ] `.out` file has dynamic values sanitized/removed
- [ ] `.out` file matches actual client output structure

### Quick Reference by Transport Type:

| Transport | Expected Output File | Contains |
|-----------|---------------------|----------|
| APSV | `out/apsv_client.out` | APSV connection, server procedure execution, response validation |
| REST | `out/rest_client.out` or `out/curl_client.out` | HTTP requests, JSON responses, status codes |
| SOAP | `out/soap_client.out` | SOAP requests, XML responses, WSDL validation |
| WEB | `out/web_client.out` | Web handler responses, HTTP status codes |

### Common Mistakes to Avoid:

❌ Forgetting to create the `out/` directory  
❌ Creating empty `.out` files  
❌ Including actual port numbers/timestamps in expected output  
❌ Missing validation patterns in expected output  
❌ Wrong file naming (must match actual output file names)

### Framework Behavior:

The T-Driver framework:
1. Runs the test and captures actual output to files like `apsv_client.out`
2. Compares actual output against `out/apsv_client.out` (expected baseline)
3. Reports PASS if patterns match, FAIL if mismatches found
4. Uses flexible pattern matching (ignores some whitespace/dynamic values)

## Summary for GitHub Copilot

**When generating ANY T-Driver test:**
1. Always create the `out/` directory
2. Always create expected `.out` baseline files for each transport
3. Populate `.out` files with sanitized expected output
4. This is NOT optional - it's a framework requirement

**Remember: No out/ directory = Test validation will fail**
