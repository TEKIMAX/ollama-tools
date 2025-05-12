#!/bin/bash

# Text styling
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Fetching available Ollama models..."
# Get models and skip the header line
models=$(ollama list | tail -n +2 | awk '{print $1}')

if [ -z "$models" ]; then
  echo -e "${RED}No models found.${NC}"
  echo -e "${YELLOW}Would you like to pull a recommended model? (y/n)${NC}"
  read pull_model

  if [[ "$pull_model" == "y" ]]; then
    echo -e "${BLUE}Recommended models:${NC}"
    echo "1. gemma3:1b      [vision, smaller size ~1GB]"
    echo "2. mistral-small3.1  [vision, tools, 24GB]"
    echo "3. llama4         [vision, tools, 67GB]"
    echo "4. Other (custom model name)"
    echo ""
    echo -e "${YELLOW}Enter the number of the model to pull:${NC}"
    read model_choice

    case $model_choice in
      1)
        model_name="gemma3:1b"
        ;;
      2)
        model_name="mistral-small3.1"
        ;;
      3)
        model_name="llama4"
        ;;
      4)
        echo -e "${YELLOW}Enter the model name to pull:${NC}"
        read model_name
        ;;
      *)
        echo "Invalid selection."
        echo -e "${BLUE}Visit ${GREEN}https://ollama.ai/library${BLUE} to browse available models.${NC}"
        exit 1
        ;;
    esac

    echo -e "${BLUE}Pulling model ${GREEN}$model_name${BLUE}...${NC}"
    echo -e "${YELLOW}This may take a while depending on your internet connection and the model size.${NC}"
    ollama pull $model_name

    if [ $? -eq 0 ]; then
      echo -e "${GREEN}Model pulled successfully!${NC}"
      # Get updated model list
      models=$(ollama list | tail -n +2 | awk '{print $1}')
    else
      echo -e "${RED}Failed to pull model.${NC}"
      echo -e "${BLUE}Visit ${GREEN}https://ollama.ai/library${BLUE} to browse available models.${NC}"
      exit 1
    fi
  else
    echo -e "${BLUE}Visit ${GREEN}https://ollama.ai/library${BLUE} to browse available models.${NC}"
    exit 0
  fi
fi

# Create an array of model names
model_array=()
while IFS= read -r model; do
  model_array+=("$model")
done <<< "$models"

# Display models with numbers
echo -e "${BLUE}Available models:${NC}"
for i in "${!model_array[@]}"; do
  echo "$((i+1)). ${model_array[$i]}"
done

echo ""
echo -e "${YELLOW}Enter the number of the model to remove, 'a' to remove all models, or 'q' to quit:${NC}"
read selection

if [[ "$selection" == "q" ]]; then
  echo "Exiting without removing any models."
  exit 0
fi

if [[ "$selection" == "a" ]]; then
  echo "You've selected to remove ALL models."
  echo "Are you sure you want to remove all models? This cannot be undone. (y/n)"
  read confirm_all
  
  if [[ "$confirm_all" == "y" ]]; then
    echo "Removing all models..."
    for model in "${model_array[@]}"; do
      echo "Removing $model..."
      ollama rm "$model"
    done
    echo "All models removed."
  else
    echo "Operation cancelled."
  fi
  exit 0
fi

# Validate input
if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt "${#model_array[@]}" ]; then
  echo "Invalid selection. Please run the script again."
  exit 1
fi

# Get the selected model
selected_model="${model_array[$((selection-1))]}"

echo "You selected: $selected_model"
echo "Are you sure you want to remove this model? (y/n)"
read confirm

if [[ "$confirm" == "y" ]]; then
  echo "Removing model $selected_model..."
  ollama rm "$selected_model"
  echo "Model removed."
else
  echo "Operation cancelled."
fi 