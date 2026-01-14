# T-Driver Copilot Context Package for PASOE Testing

## Quick Start Guide

This package contains everything needed to transfer T-Driver automation knowledge to a new GitHub Copilot instance.

## 📁 Package Contents

### `/docs/` - Core Documentation
- **CRITICAL_REQUIREMENTS.md** - ⚠️ MUST-READ: out/ directory and expected output files requirement
- **COPILOT_CONTEXT_TRANSFER.md** - Essential context to copy-paste into new Copilot sessions
- **TDRIVER_PATTERNS.md** - Complete framework patterns and standards
- **COPILOT_SESSION_EXAMPLES.md** - Example requests and validation checklists
- **TDRIVER_KNOWLEDGE_EXPORT.md** - Complete knowledge transfer guide
- **ENTERPRISE_ROADMAP.md** - Phase 2 enterprise architecture vision
- **PHASE2_IMPLEMENTATION.md** - Advanced injection point system

### `/examples/` - Working Test Cases
- **pasoe_basic_test_JIRAdemo/** - Multi-transport comprehensive test (REST, SOAP, WEB, APSV)
- **pasoe_basic_apsv_demo/** - Simple APSV transport test
- **pasoe_basic_apsv_demo1/** - Template-driven APSV test

### `/templates/` - Template Specifications
- **tdriver_test_spec.yaml** - YAML template for structured test input
- **example_customer_api_spec.yaml** - Complete YAML example
- **pas_apsv_template.txt** - APSV transport template specification
- **pas_basic_template.txt** - Basic PASOE template specification
- **enterprise_templates/** - Phase 2 injection point templates and modules

### `/framework/` - Core Framework Files
- **common_funs.sh** - Standard T-Driver functions

## 🚀 How to Use This Package

### Option 1: Instant Context Transfer (Recommended)
1. Open `/docs/COPILOT_CONTEXT_TRANSFER.md`
2. Copy the entire context block 
3. Paste at the start of your new Copilot conversation
4. Add your specific test requirements

### Option 2: Reference-Based Approach
1. Copy this entire folder to your workspace
2. Ask Copilot: "Create a T-Driver test following patterns in TDRIVER_PATTERNS.md for [your requirements]"
3. Reference working examples as needed

### Option 3: Enterprise Platform Setup
1. Review `/docs/ENTERPRISE_ROADMAP.md` for Phase 2 architecture
2. Use `/templates/enterprise_templates/` for injection point system
3. Follow `/docs/PHASE2_IMPLEMENTATION.md` for advanced features

## ✅ Success Verification

Your Copilot should generate tests with:
- Standard T-Driver header format
- common_funs.sh function usage (f_createPASOEInstance, f_getPorts, etc.)
- Proper environment variable handling ($RDLQA, $QA, etc.)
- Standard directory structure (pcode/, properties/, scripts/, out/)
- **out/ directory with expected output baseline files** ⚠️ CRITICAL
- Framework-compliant cleanup and error handling

## 🎯 Example Usage

### Basic Request:
```
"Create a T-Driver test following the patterns in TDRIVER_PATTERNS.md for PASOE APSV validation with server.p procedure"
```

### Advanced Request:
```
"Create a T-Driver test like pasoe_basic_test_JIRAdemo but for testing authentication endpoints with JSON validation"
```

### Enterprise Request:
```
"Create an enterprise T-Driver test using injection points from enterprise_templates for customer API testing"
```

### YAML-Driven Request:
```
"Create a T-Driver test based on this YAML specification: [paste content from tdriver_test_spec.yaml]"
```
## 📞 Support

If generated tests don't follow T-Driver patterns:
1. Reference `/docs/COPILOT_SESSION_EXAMPLES.md` for validation checklist
2. Point Copilot to specific examples in `/examples/`
3. Emphasize framework compliance requirements
4. **Check for out/ directory with expected output files** - See `CRITICAL_REQUIREMENTS.md`mples/`
3. Emphasize framework compliance requirements

## 🎉 Ready to Go!

This package contains complete T-Driver automation knowledge. Simply copy the folder and start generating framework-compliant PASOE tests with any Copilot instance!