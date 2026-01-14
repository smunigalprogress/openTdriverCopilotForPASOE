#!/bin/bash

# {{INJECT_POINT:test_description}}
# Enterprise PASOE Test Template with Code Injection Architecture
# {{/INJECT_POINT:test_description}}

export TESTNAME="{{INJECT_POINT:test_name}}"

# Handle cygwin environment
if [ "$IS_CYGWIN" = "1" ]; then
    WRKDIR=`cygpath -am $WRKDIR`
    RDLQA=`cygpath -am $RDLQA`
    QA=`cygpath -am $QA`
fi

# Copy framework files
cp -f $RDLQA/common_funs.sh .
cp -f $QA/openssl.cnf .
cp -f pcode/*.p .
cp -f pcode/*.cls .
cp -f properties/* .

# Source common functions
. ./common_funs.sh

# {{INJECT_POINT:custom_setup}}
# Custom environment configuration and pre-test setup
# Example: Configure authentication, set up mock services, prepare test data
# {{/INJECT_POINT:custom_setup}}

# Get available ports
f_getPorts "apsv http https jmx"

# Set instance name  
export INSTANCE_NAME="$TESTNAME"

# Create and configure PASOE instance
f_createPASOEInstance
f_modifyPASOEInstancePorts

# {{INJECT_POINT:instance_configuration}}
# Custom PASOE instance configuration
# Example: Configure handlers, security settings, custom properties
# {{/INJECT_POINT:instance_configuration}}

# Start PASOE instance
f_startPASOEInstance

# {{INJECT_POINT:test_execution}}
# Main test logic - API calls, procedure executions, validations
# This is where specific test scenarios get injected
# {{/INJECT_POINT:test_execution}}

# {{INJECT_POINT:custom_validation}}
# Specific validation patterns and success criteria
# Example: Response format validation, performance checks, data integrity
# {{/INJECT_POINT:custom_validation}}

# Standard cleanup
echo "Cleaning up test environment"
f_stopPASOEInstance
f_freePorts

echo "Enterprise test execution completed"