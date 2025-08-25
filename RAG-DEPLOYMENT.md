# RAG API Deployment Guide for Railway

This guide explains how to deploy the LibreChat RAG API on Railway, including the Vector Database (PostgreSQL with pgvector).

## Prerequisites

- [Railway CLI](https://docs.railway.app/develop/cli) installed and authenticated
- Environment variables for sensitive information (passwords, API keys, etc.)

## Environment Variables

Before deployment, you need to set the following environment variables:

### Required Variables

```bash
# Required environment variables
export POSTGRES_PASSWORD="your_secure_password"
export OPENAI_API_KEY="your_openai_api_key"
export JWT_SECRET="your_jwt_secret"
```

### Optional Variables

```bash
# Optional environment variables (defaults shown)
export POSTGRES_DB="railway"
export POSTGRES_USER="postgres"
export PGDATA="/var/lib/postgresql/data/pgdata"
export RAG_PORT="8000"
export DEBUG_RAG_API="true"
export DB_PORT="5432"
export EMBEDDINGS_PROVIDER="openai"
```

## Configuration Files

The deployment uses the following configuration files:

1. `.env.vectordb` - Vector DB configuration
2. `.env.rag` - RAG API configuration
3. `.env` - Main application configuration
4. `rag.yml` - Docker Compose configuration for local testing

All sensitive information has been replaced with placeholders. You must provide your own values for:

- Database passwords
- API keys (OpenAI, Anthropic, etc.)
- JWT secrets
- Encryption keys

## Deployment Steps

### Option 1: Using the Deployment Script

1. Make the deployment script executable:
   ```bash
   chmod +x railway-deploy.sh
   ```

2. Set the required environment variables:
   ```bash
   export POSTGRES_PASSWORD="your_secure_password"
   export OPENAI_API_KEY="your_openai_api_key"
   export JWT_SECRET="your_jwt_secret"
   ```

3. Run the deployment script:
   ```bash
   ./railway-deploy.sh
   ```

### Option 2: Manual Deployment

1. Deploy Vector DB:
   ```bash
   # Create Vector DB service
   railway service create vectordb
   
   # Set environment variables
   railway vars set \
     PGDATA="/var/lib/postgresql/data/pgdata" \
     POSTGRES_DB="railway" \
     POSTGRES_PASSWORD="your_secure_password" \
     POSTGRES_USER="postgres" \
     --service vectordb
   
   # Deploy Vector DB
   railway up --service vectordb --detach
   ```

2. Deploy RAG API:
   ```bash
   # Create RAG API service
   railway service create rag-api
   
   # Set environment variables
   railway vars set \
     DB_HOST='${RAILWAY_PRIVATE_DOMAIN}' \
     DB_PORT="5432" \
     POSTGRES_DB="railway" \
     POSTGRES_USER="postgres" \
     POSTGRES_PASSWORD="your_secure_password" \
     EMBEDDINGS_PROVIDER="openai" \
     OPENAI_API_KEY="your_openai_api_key" \
     JWT_SECRET="your_jwt_secret" \
     PORT="8000" \
     DEBUG_RAG_API="true" \
     --service rag-api
   
   # Set Docker image
   railway service update rag-api --image ghcr.io/danny-avila/librechat-rag-api-dev:latest
   
   # Configure health check
   railway service update rag-api --healthcheck-path /health --healthcheck-timeout 30s
   
   # Deploy RAG API
   railway up --service rag-api --detach
   ```

## Monitoring and Troubleshooting

- Check deployment status:
  ```bash
  railway status
  ```

- View logs:
  ```bash
  railway logs --service rag-api
  ```

- Test the RAG API health endpoint:
  ```bash
  curl https://<your-railway-domain>/health
  ```

## Connecting the Main App to RAG API

Update your main application's `.env` file to point to the deployed RAG API:

```bash
RAG_API_URL=https://${RAILWAY_PUBLIC_DOMAIN}
EMBEDDINGS_PROVIDER=openai
OPENAI_API_KEY=your_openai_api_key
```

## Security Notes

- Never commit actual secrets or API keys to your repository
- Use environment variables for all sensitive information
- Consider using Railway's secret management for production deployments
