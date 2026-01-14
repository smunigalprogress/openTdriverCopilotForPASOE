# T-Driver Copilot Context Transfer Guide

## Quick Context Setup for New Copilot Sessions

Copy and paste this context block at the start of any new Copilot conversation:

```
I need help with T-Driver test automation for PASOE (Progress Application Server for OpenEdge).

CONTEXT: T-Driver is a framework that uses standard patterns:
- Main executable follows bash script format with standard header
- Uses common_funs.sh functions: f_createPASOEInstance, f_getPorts, f_modifyPASOEInstancePorts, f_startPASOEInstance, f_stopPASOEInstance, f_freePorts
- Uses framework environment variables: $RDLQA, $QA, $PROEXE, $WRKDIR, $IS_CYGWIN, $INSTANCE_NAME
- Standard directory structure: test_name/, pcode/, properties/, scripts/, out/
- CRITICAL: out/ directory MUST contain expected output files (.out) for framework validation
- ABL server procedures use OUTPUT CHARACTER parameters
- APSV clients use CREATE SERVER/CONNECT pattern with cspair.pf
- Always copy files from $RDLQA/$QA at start
- Always include proper cleanup and port management
- Minimal configuration, no custom logging

REFERENCE EXAMPLES in workspace:
- TDRIVER_PATTERNS.md (complete patterns)
- pasoe_basic_test_JIRAdemo/ (multi-transport example)
- pasoe_basic_apsv_demo/ (simple APSV example)

FRAMEWORK REQUIREMENTS:
✅ Use standard common_funs.sh functions
✅ Handle cygwin environment ($IS_CYGWIN)
✅ Copy from $RDLQA/$QA directories
✅ Include proper cleanup (f_stopPASOEInstance, f_freePorts)
✅ Minimal openedge.properties configuration
✅ Standard bash header with test description
✅ ALWAYS create out/ directory with expected output files

❌ NO custom logging or verbose output
❌ NO relative paths or manual configuration  
❌ NO skipping framework environment variables
❌ NO forgetting the out/ directory with baseline files

Please help me create T-Driver tests following these established patterns.
```

## Method 2: Workspace Context Files

Create these files as permanent references:

### A. Context Primer File