#!/bin/bash

# Test commands for the Trading Agents API

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

API_URL="http://localhost:8000"

echo -e "${BLUE}=== Trading Agents API Test Commands ===${NC}\n"

# 1. Health check
echo -e "${YELLOW}1. Health Check:${NC}"
echo "curl -X GET ${API_URL}/health"
echo -e "${GREEN}Expected: {\"status\":\"healthy\"}${NC}\n"

# 2. Root endpoint
echo -e "${YELLOW}2. Root Endpoint:${NC}"
echo "curl -X GET ${API_URL}/"
echo -e "${GREEN}Expected: {\"message\":\"Trading Agents API with OAuth2\"}${NC}\n"

# 3. Get token (login)
echo -e "${YELLOW}3. Login (Get Access Token):${NC}"
echo "curl -X POST ${API_URL}/token \\"
echo "  -H \"Content-Type: application/x-www-form-urlencoded\" \\"
echo "  -d \"username=testuser&password=secret\""
echo -e "${GREEN}Expected: {\"access_token\":\"<token>\",\"token_type\":\"bearer\"}${NC}\n"

# 4. Access protected endpoint without token (should fail)
echo -e "${YELLOW}4. Access Protected Route (No Token - Should Fail):${NC}"
echo "curl -X GET ${API_URL}/protected"
echo -e "${RED}Expected: 401 Unauthorized${NC}\n"

# 5. Access protected endpoint with token
echo -e "${YELLOW}5. Access Protected Route (With Token):${NC}"
echo "# First get the token:"
echo "TOKEN=\$(curl -s -X POST ${API_URL}/token \\"
echo "  -H \"Content-Type: application/x-www-form-urlencoded\" \\"
echo "  -d \"username=testuser&password=secret\" | jq -r '.access_token')"
echo ""
echo "# Then use it:"
echo "curl -X GET ${API_URL}/protected \\"
echo "  -H \"Authorization: Bearer \$TOKEN\""
echo -e "${GREEN}Expected: {\"message\":\"Hello testuser, this is a protected route!\"}${NC}\n"

# 6. Get current user info
echo -e "${YELLOW}6. Get Current User Info:${NC}"
echo "curl -X GET ${API_URL}/users/me \\"
echo "  -H \"Authorization: Bearer \$TOKEN\""
echo -e "${GREEN}Expected: User information JSON${NC}\n"

# 7. View API documentation
echo -e "${YELLOW}7. API Documentation:${NC}"
echo "Open in browser: ${API_URL}/docs"
echo "or"
echo "curl -X GET ${API_URL}/openapi.json | jq ."
echo ""

# One-liner test script
echo -e "${BLUE}=== Quick Test Script ===${NC}"
echo -e "${YELLOW}Run this to test all endpoints:${NC}\n"
cat << 'EOF'
#!/bin/bash
API_URL="http://localhost:8000"

# Test health
echo "Testing health endpoint..."
curl -s ${API_URL}/health | jq .

# Get token
echo -e "\nGetting access token..."
TOKEN=$(curl -s -X POST ${API_URL}/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=testuser&password=secret" | jq -r '.access_token')

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    echo "Failed to get token!"
    exit 1
fi

echo "Token obtained successfully!"

# Test protected endpoint
echo -e "\nTesting protected endpoint..."
curl -s -X GET ${API_URL}/protected \
  -H "Authorization: Bearer $TOKEN" | jq .

# Get user info
echo -e "\nGetting user info..."
curl -s -X GET ${API_URL}/users/me \
  -H "Authorization: Bearer $TOKEN" | jq .
EOF