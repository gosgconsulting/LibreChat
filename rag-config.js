/**
 * RAG API Configuration for Railway Deployment
 * 
 * This file contains the configuration needed for deploying the RAG API on Railway.
 * Copy these environment variables to your Railway service configuration.
 */

const ragApiConfig = {
  // Database Configuration
  DB_HOST: "${RAILWAY_PRIVATE_DOMAIN}",
  DB_PORT: "5432",
  POSTGRES_DB: "railway",
  POSTGRES_USER: "postgres",
  POSTGRES_PASSWORD: "T2PPAGOYBSB4XE8P",
  
  // OpenAI Configuration
  EMBEDDINGS_PROVIDER: "openai",
  OPENAI_API_KEY: "j6haIxfE5Qse1vGzuGJYYo8w1nNSy9WVmFdS3Ox2Vlt4YriD0lnXOqgdRcrKdB0FthIPZGQevBT3BlbkFJ-aRpVYoblCcG5RCl2Z0dhtpB6okn_tK5nQ0kqFMfioQ7uPGSSuxJmOjoe3LJBiBcTLXILwvcAA",
  
  // API Configuration
  JWT_SECRET: "${JWT_SECRET}",
  PORT: "8000",
  DEBUG_RAG_API: "true"
};

module.exports = ragApiConfig;
