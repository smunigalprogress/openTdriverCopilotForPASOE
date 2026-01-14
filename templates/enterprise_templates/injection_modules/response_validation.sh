# Response Validation Injection Module
# Usage: Include in {{INJECT_POINT:custom_validation}} for comprehensive validation

# JSON Response Validation
echo "Validating JSON responses"
if grep -q "customer" rest_response.out; then
    echo "✓ JSON response contains expected customer data"
else
    echo "✗ JSON response validation failed"
    validation_failed=true
fi

# HTTP Status Code Validation
if grep -q "200\|201" rest_response.out; then
    echo "✓ HTTP status code validation passed"
else
    echo "✗ HTTP status code validation failed"
    validation_failed=true
fi

# Performance Validation
response_time=$(grep -o "time_total:[0-9.]*" rest_response.out | cut -d: -f2)
if (( $(echo "$response_time < 1.0" | bc -l) )); then
    echo "✓ Response time acceptable: ${response_time}s"
else
    echo "✗ Response time too slow: ${response_time}s"
    validation_failed=true
fi

# Data Integrity Validation
echo "Validating data integrity"
if grep -q "active\|inactive" rest_response.out; then
    echo "✓ Status field validation passed"
else
    echo "✗ Status field validation failed"
    validation_failed=true
fi

# Summary
if [ "$validation_failed" = true ]; then
    echo "❌ Validation Summary: FAILED"
    exit 1
else
    echo "✅ Validation Summary: PASSED"
fi