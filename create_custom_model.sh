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
echo -e "${BOLD}${GREEN}       Custom Ollama Model Creator       ${NC}"
echo -e "${BOLD}==============================================${NC}"
echo ""

# List available base models
echo -e "${BLUE}Available base models:${NC}"
ollama list | tail -n +2 | awk '{print NR ". " $1}'

if [ $? -ne 0 ]; then
  echo -e "${RED}Failed to list models. Make sure Ollama is running.${NC}"
  exit 1
fi

# Get base model selection
echo ""
echo -e "${YELLOW}Select a base model number from the list above:${NC}"
read base_model_num

# Get models again for selection
models=$(ollama list | tail -n +2 | awk '{print $1}')
model_array=()
while IFS= read -r model; do
  model_array+=("$model")
done <<< "$models"

# Validate model number
if ! [[ "$base_model_num" =~ ^[0-9]+$ ]] || [ "$base_model_num" -lt 1 ] || [ "$base_model_num" -gt "${#model_array[@]}" ]; then
  echo -e "${RED}Invalid selection.${NC}"
  exit 1
fi

selected_base="${model_array[$((base_model_num-1))]}"
echo -e "You selected: ${GREEN}$selected_base${NC}"
echo ""

# Get new model name
echo -e "${YELLOW}Enter a name for your custom model (lowercase, no spaces):${NC}"
read custom_name

# Validate name (basic validation)
if ! [[ "$custom_name" =~ ^[a-z0-9\-]+$ ]]; then
  echo -e "${RED}Invalid model name. Use only lowercase letters, numbers, and hyphens.${NC}"
  exit 1
fi

echo ""
echo -e "${YELLOW}What kind of assistant do you want to create?${NC}"
echo "1. General Assistant"
echo "2. Coding Assistant"
echo "3. Writing Assistant"
echo "4. Custom personality/role (define your own)"
read assistant_type

# Define the custom prompt template based on selection
case $assistant_type in
  1)
    echo "Creating a general assistant..."
    system_prompt="You are a helpful, respectful, and honest assistant. Always answer as helpfully as possible, while being safe. Your answers should not include harmful, unethical, racist, sexist, toxic, dangerous, or illegal content. Please ensure that your responses are socially unbiased and positive in nature. If a question does not make any sense, or is not factually coherent, explain why instead of answering something not correct. If you don't know the answer to a question, please don't share false information."
    ;;
  2)
    echo "Creating a coding assistant..."
    system_prompt="You are an expert coding assistant. Provide clean, efficient, and well-documented code examples. Explain complex concepts clearly and help debug issues. Focus on best practices and maintainable solutions. When providing code, format it properly with syntax highlighting when possible. If you don't know something, admit it rather than providing potentially incorrect information."
    ;;
  3)
    echo "Creating a writing assistant..."
    system_prompt="You are a writing assistant with expertise in crafting clear, engaging, and well-structured content. Help with drafting, editing, and improving written work across various formats including essays, articles, stories, emails, and more. Provide suggestions for improving clarity, flow, word choice, and overall impact. When asked, offer creative ideas while respecting the user's voice and intent."
    ;;
  4)
    echo "Creating a custom assistant..."
    echo -e "${YELLOW}Please describe the personality and role of your assistant:${NC}"
    read custom_description
    system_prompt="$custom_description"
    ;;
  *)
    echo -e "${RED}Invalid choice.${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${BLUE}Creating temporary Modelfile...${NC}"

# Create a temporary Modelfile
tmp_modelfile=$(mktemp)
echo "FROM $selected_base" > "$tmp_modelfile"
echo "SYSTEM \"\"\"$system_prompt\"\"\"" >> "$tmp_modelfile"

echo -e "${BLUE}Building your custom model: ${GREEN}$custom_name${NC}"
echo -e "${YELLOW}This might take a few minutes depending on your computer...${NC}"

# Create the model
ollama create "$custom_name" -f "$tmp_modelfile"
build_status=$?

# Clean up
rm "$tmp_modelfile"

if [ $build_status -eq 0 ]; then
  echo -e "${GREEN}✓ Model '$custom_name' created successfully!${NC}"
  echo ""
  echo -e "${BLUE}You can now use your model with:${NC}"
  echo -e "  ${YELLOW}ollama run $custom_name${NC}"
  echo ""
else
  echo -e "${RED}Failed to create the model.${NC}"
  exit 1
fi 