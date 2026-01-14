# REST API Injection Module
# Usage: Include in {{INJECT_POINT:test_execution}} for REST endpoint testing

# Configure REST endpoints
rest_base_url="https://localhost:$https_port/rest"

# POST request with JSON payload
echo "Testing POST endpoint"
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -k -w "\n" \
  -d '{"name":"test_customer","status":"active"}' \
  "$rest_base_url/customers" >> rest_response.out

# GET request with parameters
echo "Testing GET endpoint"
curl -X GET \
  -H "Accept: application/json" \
  -k -w "\n" \
  "$rest_base_url/customers/123" >> rest_response.out

# PUT request for updates
echo "Testing PUT endpoint" 
curl -X PUT \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -k -w "\n" \
  -d '{"name":"updated_customer","status":"inactive"}' \
  "$rest_base_url/customers/123" >> rest_response.out