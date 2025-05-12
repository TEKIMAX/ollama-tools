#!/bin/bash

# Text styling
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
  echo -e "${RED}Ollama is not installed or not in your PATH.${NC}"
  echo "Please install Ollama from https://ollama.ai/download"
  exit 1
fi

clear
echo -e "${BOLD}==============================================${NC}"
echo -e "${BOLD}${GREEN}       Ollama Embedding Model Installer       ${NC}"
echo -e "${BOLD}==============================================${NC}"
echo ""

echo -e "${BLUE}This script will help you install embedding models for Retrieval Augmented Generation (RAG).${NC}"
echo -e "${BLUE}Embedding models convert text to numerical vectors for semantic search and similarity.${NC}"
echo ""

# List of popular embedding models
echo -e "${YELLOW}Available embedding models:${NC}"
echo "1. nomic-embed-text (Recommended for general purpose)"
echo "2. all-minilm (Lightweight embedding model)"
echo "3. e5-small-v2 (Good balance of performance and size)"
echo "4. bge-small-en-v1.5 (Optimized for English text)"
echo "5. gte-base (General Text Embeddings model)"

echo ""
echo -e "${YELLOW}Enter the number of the embedding model to install:${NC}"
read model_num

# Set the model name based on selection
case $model_num in
  1)
    model_name="nomic-embed-text"
    ;;
  2)
    model_name="all-minilm"
    ;;
  3)
    model_name="e5-small-v2"
    ;;
  4)
    model_name="bge-small-en-v1.5"
    ;;
  5)
    model_name="gte-base"
    ;;
  *)
    echo -e "${RED}Invalid choice.${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${BLUE}Installing ${GREEN}$model_name${BLUE}...${NC}"
echo -e "${YELLOW}This might take a few minutes depending on your internet connection...${NC}"

# Pull the model
ollama pull $model_name
status=$?

if [ $status -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✓ Successfully installed $model_name!${NC}"
  echo ""
  echo -e "${BLUE}You can now use this embedding model in your RAG applications.${NC}"
  echo ""
  echo -e "${YELLOW}Example code (Python with LlamaIndex):${NC}"
  echo -e "```python"
  echo -e "from llama_index.embeddings.ollama import OllamaEmbedding"
  echo -e ""
  echo -e "# Initialize the embedding model"
  echo -e "embed_model = OllamaEmbedding(model_name=\"$model_name\")"
  echo -e ""
  echo -e "# Use the embedding model"
  echo -e "embeddings = embed_model.get_text_embedding(\"Your text here\")"
  echo -e "```"
  echo ""
  echo -e "${YELLOW}Example code (JavaScript with LangChain):${NC}"
  echo -e "```javascript"
  echo -e "import { OllamaEmbeddings } from \"langchain/embeddings/ollama\";"
  echo -e ""
  echo -e "// Initialize the embedding model"
  echo -e "const embeddings = new OllamaEmbeddings({"
  echo -e "  model: \"$model_name\","
  echo -e "  baseUrl: \"http://localhost:11434\", // Adjust if needed"
  echo -e "});"
  echo -e ""
  echo -e "// Use the embedding model"
  echo -e "const result = await embeddings.embedQuery(\"Your text here\");"
  echo -e "```"
else
  echo -e "${RED}Failed to install the embedding model.${NC}"
  exit 1
fi 