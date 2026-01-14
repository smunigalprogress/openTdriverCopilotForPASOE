# T-Driver Quick Reference Card

## 🚨 Copy This Context to New Copilot Sessions

```
I need help with T-Driver test automation for PASOE (Progress Application Server for OpenEdge).

CONTEXT: T-Driver is a framework that uses standard patterns:
- Main executable follows bash script format with standard header
- Uses common_funs.sh functions: f_createPASOEInstance, f_getPorts, f_modifyPASOEInstancePorts, f_startPASOEInstance, f_stopPASOEInstance, f_freePorts
- Uses framework environment variables: $RDLQA, $QA, $PROEXE, $WRKDIR, $IS_CYGWIN, $INSTANCE_NAME
- Standard directory structure: test_name/, pcode/, properties/, scripts/, out/
- ABL server procedures use OUTPUT CHARACTER parameters
- APSV clients use CREATE SERVER/CONNECT pattern with cspair.pf
- Always copy files from $RDLQA/$QA at start
- Always include proper cleanup and port management
- Minimal configuration, no custom logging

REFERENCE EXAMPLES in this package:
- docs/TDRIVER_PATTERNS.md (complete patterns)
- examples/pasoe_basic_test_JIRAdemo/ (multi-transport example)
- examples/pasoe_basic_apsv_demo/ (simple APSV example)

FRAMEWORK REQUIREMENTS:
✅ Use standard common_funs.sh functions
✅ Handle cygwin environment ($IS_CYGWIN)
✅ Copy from $RDLQA/$QA directories
✅ Include proper cleanup (f_stopPASOEInstance, f_freePorts)
✅ Minimal openedge.properties configuration
✅ Standard bash header with test description

❌ NO custom logging or verbose output
❌ NO relative paths or manual configuration  
❌ NO skipping framework environment variables

Please help me create T-Driver tests following these established patterns.
```

## 🎯 Common Request Patterns

- "Create a T-Driver test following TDRIVER_PATTERNS.md for [description]"
- "Create a test like examples/pasoe_basic_test_JIRAdemo for [requirements]"
- "Follow T-Driver framework standards using common_funs.sh functions"
- "Create a T-Driver test based on this YAML: [paste from templates/tdriver_test_spec.yaml]"

## ✅ Validation Checklist

Generated tests should have:
- [ ] Standard bash header with test description
- [ ] common_funs.sh function usage
- [ ] Environment variable handling
- [ ] Proper directory structure (pcode/, properties/, scripts/, out/)
- [ ] **out/ directory with expected output baseline files** ⚠️
- [ ] Framework cleanup and error handling