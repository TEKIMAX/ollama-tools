#!/bin/bash

echo "Fetching available Ollama models..."
# Get models and skip the header line
models=$(ollama list | tail -n +2 | awk '{print $1}')

if [ -z "$models" ]; then
  echo "No models found."
  exit 0
fi

# Create an array of model names
model_array=()
while IFS= read -r model; do
  model_array+=("$model")
done <<< "$models"

# Display models with numbers
echo "Available models:"
for i in "${!model_array[@]}"; do
  echo "$((i+1)). ${model_array[$i]}"
done

echo ""
echo "Enter the number of the model to remove, 'a' to remove all models, or 'q' to quit:"
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