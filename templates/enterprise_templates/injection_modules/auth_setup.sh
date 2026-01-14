# Authentication Setup Injection Module
# Usage: Include in {{INJECT_POINT:custom_setup}} for authentication configuration

# Bearer Token Authentication
echo "Configuring authentication"
auth_token="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."

# OAuth2 Client Credentials
oauth_client_id="test_client"
oauth_client_secret="test_secret"
oauth_token_url="https://localhost:$https_port/oauth/token"

# Get access token
echo "Obtaining access token"
access_token=$(curl -s -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials&client_id=$oauth_client_id&client_secret=$oauth_client_secret" \
  -k "$oauth_token_url" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -n "$access_token" ]; then
    echo "✓ Access token obtained successfully"
    export AUTH_HEADER="Authorization: Bearer $access_token"
else
    echo "✗ Failed to obtain access token"
    exit 1
fi

# Configure SSL certificates
echo "Configuring SSL certificates"
export SSL_CERT_FILE="./ssl/test_cert.pem"
export SSL_KEY_FILE="./ssl/test_key.pem"

# API Key Authentication (alternative)
api_key="test-api-key-12345"
export API_KEY_HEADER="X-API-Key: $api_key"