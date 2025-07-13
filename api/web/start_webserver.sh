#!/bin/bash

# Script to build and run the FastAPI web server using Docker

# Set variables
IMAGE_NAME="tradingagents-api-web"
CONTAINER_NAME="tradingagents-api-web-container"
PORT=8000

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t ${IMAGE_NAME} .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Docker image built successfully!${NC}"
else
    echo -e "${RED}Failed to build Docker image${NC}"
    exit 1
fi

# Stop and remove existing container if it exists
echo -e "${YELLOW}Checking for existing container...${NC}"
if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    echo -e "${YELLOW}Stopping and removing existing container...${NC}"
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
fi

# Run the container
echo -e "${YELLOW}Starting container...${NC}"
docker run -d \
    --name ${CONTAINER_NAME} \
    -p ${PORT}:8000 \
    -e SECRET_KEY="${SECRET_KEY:-your-secret-key-here-change-in-production}" \
    ${IMAGE_NAME}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Container started successfully!${NC}"
    echo -e "${GREEN}API is available at: http://localhost:${PORT}${NC}"
    echo -e "${GREEN}API documentation: http://localhost:${PORT}/docs${NC}"
    echo ""
    echo -e "${YELLOW}To view logs:${NC} docker logs -f ${CONTAINER_NAME}"
    echo -e "${YELLOW}To stop:${NC} docker stop ${CONTAINER_NAME}"
else
    echo -e "${RED}Failed to start container${NC}"
    exit 1
fi