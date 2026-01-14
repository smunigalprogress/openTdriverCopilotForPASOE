# T-Driver Session Examples for Context Transfer

## Example 1: Basic APSV Test Request
```
User: "Create a T-Driver test for PASOE APSV validation following TDRIVER_PATTERNS.md"

Expected Response: Complete test with:
- Main executable using common_funs.sh
- server.p with OUTPUT CHARACTER parameter  
- client.p with CREATE SERVER/CONNECT
- Minimal openedge.properties
- Standard directory structure (pcode/, properties/, scripts/, out/)
- out/apsv_client.out with expected output baseline
```

## Example 2: Multi-Transport Test Request  
```
User: "Create a T-Driver test like pasoe_basic_test_JIRAdemo for testing REST and APSV protocols"

Expected Response: Test including:
- curl commands for REST endpoint testing
- APSV client for server procedure calls
- WebRoundTrip handler if WEB transport needed
- Validation patterns in out/ directory
```

## Example 3: Template-Based Test Request
```
User: "Create T-Driver test from this specification: [paste template content]"

Expected Response: Framework-compliant implementation with:
- Template requirements mapped to T-Driver patterns
- Standard function usage throughout
- Proper environment variable handling
```

## Context Validation Checklist

When working with new Copilot instances, verify responses include:

### Framework Functions ✅
- [ ] f_getPorts "apsv http https jmx"
- [ ] f_createPASOEInstance
- [ ] f_modifyPASOEInstancePorts  
- [ ] f_startPASOEInstance
- [ ] f_stopPASOEInstance
- [ ] f_freePorts

### Environment Variables ✅
- [ ] $RDLQA and $QA file copying
- [ ] $IS_CYGWIN handling
- [ ] $PROEXE for ABL execution
- [ ] $INSTANCE_NAME for PASOE instance

### Structure Compliance ✅  
- [ ] Standard bash script header
- [ ] Proper directory structure (pcode/, properties/, scripts/, out/)
- [ ] out/ directory with expected output baseline files (*.out)
- [ ] Expected output files for each transport (apsv_client.out, rest_client.out, etc.)
- [ ] Minimal configuration approach
- [ ] Clean error handling and resource cleanup

## Anti-Pattern Detection 🚫

If Copilot suggests these, correct immediately:
- Custom logging functions instead of framework standards
- Hardcoded paths instead of environment variables
- Manual instance creation instead of common_funs.sh
- Verbose output or debugging statements
- Missing cleanup or port management
- **MISSING out/ directory or expected output files** ⚠️ CRITICAL