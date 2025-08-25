#!/bin/bash
# Railway Deployment Script for LibreChat RAG API

# Exit on error
set -e

echo "=== LibreChat RAG API Deployment Script ==="
echo "This script will deploy the RAG API to Railway"

# Check if required environment variables are set
required_vars=("POSTGRES_PASSWORD" "OPENAI_API_KEY" "JWT_SECRET")
for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: $var environment variable is not set"
    echo "Please set the following environment variables before running this script:"
    echo "  - POSTGRES_PASSWORD: PostgreSQL database password"
    echo "  - OPENAI_API_KEY: OpenAI API key for embeddings"
    echo "  - JWT_SECRET: Secret for JWT token generation"
    exit 1
  fi
done

# Set default values for optional variables
POSTGRES_DB=${POSTGRES_DB:-railway}
POSTGRES_USER=${POSTGRES_USER:-postgres}
PGDATA=${PGDATA:-/var/lib/postgresql/data/pgdata}
RAG_PORT=${RAG_PORT:-8000}
DEBUG_RAG_API=${DEBUG_RAG_API:-true}
DB_PORT=${DB_PORT:-5432}
EMBEDDINGS_PROVIDER=${EMBEDDINGS_PROVIDER:-openai}

# Step 1: Deploy Vector DB
echo -e "\n=== Step 1: Deploying Vector DB ==="
echo "Deploying PostgreSQL with pgvector extension..."

# Create a new Railway service for Vector DB if it doesn't exist
if ! railway service ls | grep -q "vectordb"; then
  echo "Creating new Vector DB service..."
  railway service create vectordb
fi

# Set environment variables for Vector DB
echo "Setting Vector DB environment variables..."
railway vars set \
  PGDATA="$PGDATA" \
  POSTGRES_DB="$POSTGRES_DB" \
  POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  POSTGRES_USER="$POSTGRES_USER" \
  --service vectordb

# Deploy Vector DB
echo "Deploying Vector DB..."
railway up --service vectordb --detach

echo "Waiting for Vector DB to be ready..."
sleep 30

# Step 2: Deploy RAG API
echo -e "\n=== Step 2: Deploying RAG API ==="

# Create a new Railway service for RAG API if it doesn't exist
if ! railway service ls | grep -q "rag-api"; then
  echo "Creating new RAG API service..."
  railway service create rag-api
fi

# Set environment variables for RAG API
echo "Setting RAG API environment variables..."
railway vars set \
  DB_HOST='${RAILWAY_PRIVATE_DOMAIN}' \
  DB_PORT="$DB_PORT" \
  POSTGRES_DB="$POSTGRES_DB" \
  POSTGRES_USER="$POSTGRES_USER" \
  POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  EMBEDDINGS_PROVIDER="$EMBEDDINGS_PROVIDER" \
  OPENAI_API_KEY="$OPENAI_API_KEY" \
  JWT_SECRET="$JWT_SECRET" \
  PORT="$RAG_PORT" \
  DEBUG_RAG_API="$DEBUG_RAG_API" \
  --service rag-api

# Set Docker image for RAG API
echo "Setting Docker image for RAG API..."
railway service update rag-api --image ghcr.io/danny-avila/librechat-rag-api-dev:latest

# Configure health check
echo "Configuring health check..."
railway service update rag-api --healthcheck-path /health --healthcheck-timeout 30s

# Deploy RAG API
echo "Deploying RAG API..."
railway up --service rag-api --detach

echo -e "\n=== Deployment Complete ==="
echo "Vector DB and RAG API have been deployed to Railway"
echo "You can check the status of your deployments with 'railway status'"
echo "To view logs, use 'railway logs --service rag-api'"
