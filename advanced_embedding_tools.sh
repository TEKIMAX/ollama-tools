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

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo -e "${YELLOW}Installing jq for JSON processing...${NC}"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install jq
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sudo apt-get install -y jq || sudo yum install -y jq
  else
    echo -e "${RED}Please install jq manually: https://stedolan.github.io/jq/download/${NC}"
    exit 1
  fi
fi

# Check if any embedding models are available
check_embedding_models() {
  models=$(ollama list | grep -i embed)
  if [ -z "$models" ]; then
    echo -e "${YELLOW}No embedding models found.${NC}"
    echo -e "${BLUE}Embedding models are required for text vectorization and similarity searches.${NC}"
    echo -e "${YELLOW}Would you like to pull a recommended embedding model? (y/n)${NC}"
    read pull_model

    if [[ "$pull_model" == "y" ]]; then
      echo -e "${BLUE}Recommended embedding models:${NC}"
      echo "1. nomic-embed-text (Recommended for general purpose)"
      echo "2. all-minilm (Lightweight embedding model)"
      echo "3. e5-small-v2 (Good balance of performance and size)"
      echo "4. bge-small-en-v1.5 (Optimized for English text)"
      echo "5. gte-base (General Text Embeddings model)"
      echo "6. Other (custom model name)"
      echo ""
      echo -e "${YELLOW}Enter the number of the embedding model to install:${NC}"
      read model_choice

      case $model_choice in
        1) model_name="nomic-embed-text" ;;
        2) model_name="all-minilm" ;;
        3) model_name="e5-small-v2" ;;
        4) model_name="bge-small-en-v1.5" ;;
        5) model_name="gte-base" ;;
        6) 
          echo -e "${YELLOW}Enter the name of the embedding model:${NC}"
          read model_name
          ;;
        *)
          echo -e "${RED}Invalid selection.${NC}"
          echo -e "${BLUE}Visit ${GREEN}https://ollama.ai/library${BLUE} to browse available models.${NC}"
          return 1
          ;;
      esac

      echo -e "${BLUE}Pulling model ${GREEN}$model_name${BLUE}...${NC}"
      echo -e "${YELLOW}This may take a while depending on your internet connection...${NC}"
      ollama pull $model_name

      if [ $? -eq 0 ]; then
        echo -e "${GREEN}Embedding model installed successfully!${NC}"
        echo -e "${YELLOW}Press any key to continue...${NC}"
        read -n 1
        return 0
      else
        echo -e "${RED}Failed to pull embedding model.${NC}"
        echo -e "${BLUE}Visit ${GREEN}https://ollama.ai/library${BLUE} to browse available models.${NC}"
        return 1
      fi
    else
      return 1
    fi
  fi
  return 0
}

clear
echo -e "${BOLD}==============================================${NC}"
echo -e "${BOLD}${GREEN}       Advanced Embedding Tools       ${NC}"
echo -e "${BOLD}==============================================${NC}"
echo ""

# Check for embedding models at startup
check_embedding_models
if [ $? -ne 0 ]; then
  echo -e "${RED}No embedding models available. Exiting.${NC}"
  exit 1
fi

show_main_menu() {
  clear
  echo -e "${BOLD}==============================================${NC}"
  echo -e "${BOLD}${GREEN}       Advanced Embedding Tools       ${NC}"
  echo -e "${BOLD}==============================================${NC}"
  echo ""
  echo -e "${YELLOW}Please select an option:${NC}"
  echo "1. Install embedding model"
  echo "2. Generate embeddings for text"
  echo "3. Compare similarity between texts"
  echo "4. Batch process embeddings"
  echo "5. Exit"
  echo ""
  echo -e "${YELLOW}Enter your choice:${NC}"
  read menu_choice
  
  case $menu_choice in
    1) install_embedding_model ;;
    2) generate_embeddings ;;
    3) compare_similarity ;;
    4) batch_process ;;
    5) exit 0 ;;
    *) 
      echo -e "${RED}Invalid choice.${NC}"
      echo -e "${YELLOW}Press any key to continue...${NC}"
      read -n 1
      show_main_menu
      ;;
  esac
}

install_embedding_model() {
  echo ""
  echo -e "${BLUE}===== Install Embedding Model =====${NC}"
  
  # List of popular embedding models
  echo -e "${YELLOW}Available embedding models:${NC}"
  echo "1. nomic-embed-text (Recommended for general purpose)"
  echo "2. all-minilm (Lightweight embedding model)"
  echo "3. e5-small-v2 (Good balance of performance and size)"
  echo "4. bge-small-en-v1.5 (Optimized for English text)"
  echo "5. gte-base (General Text Embeddings model)"
  echo "6. Custom model (enter model name)"

  echo ""
  echo -e "${YELLOW}Enter the number of the embedding model to install:${NC}"
  read model_num

  # Set the model name based on selection
  case $model_num in
    1) model_name="nomic-embed-text" ;;
    2) model_name="all-minilm" ;;
    3) model_name="e5-small-v2" ;;
    4) model_name="bge-small-en-v1.5" ;;
    5) model_name="gte-base" ;;
    6) 
      echo -e "${YELLOW}Enter the name of the embedding model:${NC}"
      read model_name
      ;;
    *)
      echo -e "${RED}Invalid choice.${NC}"
      echo -e "${YELLOW}Press any key to return to the main menu${NC}"
      read -n 1
      show_main_menu
      return
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
  else
    echo -e "${RED}Failed to install the embedding model.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  echo -e "${YELLOW}Press any key to return to the main menu${NC}"
  read -n 1
  show_main_menu
}

generate_embeddings() {
  echo ""
  echo -e "${BLUE}===== Generate Embeddings =====${NC}"
  
  # Get list of models
  echo -e "${YELLOW}Fetching available models...${NC}"
  models=$(ollama list | grep -i embed | awk '{print NR ". " $1}')
  
  if [ -z "$models" ]; then
    echo -e "${RED}No embedding models found. Please install one first.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Display available models
  echo -e "${BLUE}Available embedding models:${NC}"
  echo "$models"
  
  echo ""
  echo -e "${YELLOW}Select model number:${NC}"
  read embed_model_num
  
  # Get models again for selection
  model_array=()
  while IFS= read -r model; do
    model_name=$(echo $model | awk '{print $2}')
    model_array+=("$model_name")
  done <<< "$(ollama list | grep -i embed)"
  
  # Validate model number
  if ! [[ "$embed_model_num" =~ ^[0-9]+$ ]] || [ "$embed_model_num" -lt 1 ] || [ "$embed_model_num" -gt "${#model_array[@]}" ]; then
    echo -e "${RED}Invalid selection.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  selected_model="${model_array[$((embed_model_num-1))]}"
  echo -e "You selected: ${GREEN}$selected_model${NC}"
  
  # Get text to embed
  echo ""
  echo -e "${YELLOW}Enter text to generate embeddings for:${NC}"
  read text_to_embed
  
  if [ -z "$text_to_embed" ]; then
    echo -e "${RED}Text cannot be empty.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Generate embeddings using API
  echo ""
  echo -e "${BLUE}Generating embeddings...${NC}"
  
  response=$(curl -s -X POST http://localhost:11434/api/embeddings \
    -d "{\"model\":\"$selected_model\",\"prompt\":\"$text_to_embed\"}")
  
  # Check if response contains embeddings
  if echo "$response" | jq -e '.embedding' >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Embeddings generated successfully!${NC}"
    
    # Count dimensions
    dimensions=$(echo "$response" | jq '.embedding | length')
    echo -e "${BLUE}Vector dimensions: ${GREEN}$dimensions${NC}"
    
    # Ask if user wants to see the embeddings
    echo ""
    echo -e "${YELLOW}Do you want to see the embedding vector? (y/n)${NC}"
    read show_vector
    
    if [[ "$show_vector" == "y" ]]; then
      echo ""
      # Show first 10 dimensions as preview
      preview=$(echo "$response" | jq '.embedding[:10]')
      echo -e "${BLUE}First 10 dimensions (of $dimensions):${NC}"
      echo "$preview"
      
      # Ask if user wants to save embeddings to file
      echo ""
      echo -e "${YELLOW}Save embeddings to file? (y/n)${NC}"
      read save_to_file
      
      if [[ "$save_to_file" == "y" ]]; then
        filename="embedding_$(date +%s).json"
        echo "$response" > "$filename"
        echo -e "${GREEN}✓ Embeddings saved to $filename${NC}"
      fi
    fi
  else
    echo -e "${RED}Failed to generate embeddings.${NC}"
    echo "API response:"
    echo "$response"
  fi
  
  echo ""
  echo -e "${YELLOW}Press any key to return to the main menu${NC}"
  read -n 1
  show_main_menu
}

# Function to calculate cosine similarity
calc_cosine_similarity() {
  local vec1="$1"
  local vec2="$2"
  
  # Use jq to calculate dot product, magnitudes, and cosine similarity
  similarity=$(jq -n \
    --argjson vec1 "$vec1" \
    --argjson vec2 "$vec2" \
    '
    # Dot product
    def dot(a; b): reduce range(0; a|length) as $i (0; . + (a[$i] * b[$i]));
    
    # Magnitude (Euclidean norm)
    def mag(a): sqrt(reduce a[] as $x (0; . + ($x * $x)));
    
    # Cosine similarity
    dot($vec1; $vec2) / (mag($vec1) * mag($vec2))
    ')
  
  echo "$similarity"
}

compare_similarity() {
  echo ""
  echo -e "${BLUE}===== Compare Text Similarity =====${NC}"
  
  # Get list of models
  echo -e "${YELLOW}Fetching available models...${NC}"
  models=$(ollama list | grep -i embed | awk '{print NR ". " $1}')
  
  if [ -z "$models" ]; then
    echo -e "${RED}No embedding models found. Please install one first.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Display available models
  echo -e "${BLUE}Available embedding models:${NC}"
  echo "$models"
  
  echo ""
  echo -e "${YELLOW}Select model number:${NC}"
  read embed_model_num
  
  # Get models again for selection
  model_array=()
  while IFS= read -r model; do
    model_name=$(echo $model | awk '{print $2}')
    model_array+=("$model_name")
  done <<< "$(ollama list | grep -i embed)"
  
  # Validate model number
  if ! [[ "$embed_model_num" =~ ^[0-9]+$ ]] || [ "$embed_model_num" -lt 1 ] || [ "$embed_model_num" -gt "${#model_array[@]}" ]; then
    echo -e "${RED}Invalid selection.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  selected_model="${model_array[$((embed_model_num-1))]}"
  echo -e "You selected: ${GREEN}$selected_model${NC}"
  
  # Get first text
  echo ""
  echo -e "${YELLOW}Enter first text:${NC}"
  read text1
  
  if [ -z "$text1" ]; then
    echo -e "${RED}Text cannot be empty.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Get second text
  echo ""
  echo -e "${YELLOW}Enter second text:${NC}"
  read text2
  
  if [ -z "$text2" ]; then
    echo -e "${RED}Text cannot be empty.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Generate embeddings for both texts
  echo ""
  echo -e "${BLUE}Generating embeddings and comparing...${NC}"
  
  # First text embedding
  response1=$(curl -s -X POST http://localhost:11434/api/embeddings \
    -d "{\"model\":\"$selected_model\",\"prompt\":\"$text1\"}")
  
  # Second text embedding
  response2=$(curl -s -X POST http://localhost:11434/api/embeddings \
    -d "{\"model\":\"$selected_model\",\"prompt\":\"$text2\"}")
  
  # Check if responses contain embeddings
  if echo "$response1" | jq -e '.embedding' >/dev/null 2>&1 && echo "$response2" | jq -e '.embedding' >/dev/null 2>&1; then
    # Extract embedding vectors
    vec1=$(echo "$response1" | jq '.embedding')
    vec2=$(echo "$response2" | jq '.embedding')
    
    # Calculate similarity
    similarity=$(calc_cosine_similarity "$vec1" "$vec2")
    
    # Format to percentage with 2 decimal places
    percentage=$(echo "$similarity * 100" | bc -l | xargs printf "%.2f")
    
    echo ""
    echo -e "${GREEN}✓ Similarity score: ${BOLD}${percentage}%${NC}"
    
    # Interpret the similarity
    if (( $(echo "$similarity > 0.9" | bc -l) )); then
      echo -e "${BLUE}Interpretation: ${GREEN}Very high similarity${NC}"
    elif (( $(echo "$similarity > 0.7" | bc -l) )); then
      echo -e "${BLUE}Interpretation: ${GREEN}High similarity${NC}"
    elif (( $(echo "$similarity > 0.5" | bc -l) )); then
      echo -e "${BLUE}Interpretation: ${YELLOW}Moderate similarity${NC}"
    elif (( $(echo "$similarity > 0.3" | bc -l) )); then
      echo -e "${BLUE}Interpretation: ${YELLOW}Low similarity${NC}"
    else
      echo -e "${BLUE}Interpretation: ${RED}Very low similarity${NC}"
    fi
  else
    echo -e "${RED}Failed to generate embeddings.${NC}"
  fi
  
  echo ""
  echo -e "${YELLOW}Press any key to return to the main menu${NC}"
  read -n 1
  show_main_menu
}

batch_process() {
  echo ""
  echo -e "${BLUE}===== Batch Process Embeddings =====${NC}"
  echo -e "${YELLOW}This feature allows you to process multiple texts at once.${NC}"
  
  # Get list of models
  echo -e "${YELLOW}Fetching available models...${NC}"
  models=$(ollama list | grep -i embed | awk '{print NR ". " $1}')
  
  if [ -z "$models" ]; then
    echo -e "${RED}No embedding models found. Please install one first.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Display available models
  echo -e "${BLUE}Available embedding models:${NC}"
  echo "$models"
  
  echo ""
  echo -e "${YELLOW}Select model number:${NC}"
  read embed_model_num
  
  # Get models again for selection
  model_array=()
  while IFS= read -r model; do
    model_name=$(echo $model | awk '{print $2}')
    model_array+=("$model_name")
  done <<< "$(ollama list | grep -i embed)"
  
  # Validate model number
  if ! [[ "$embed_model_num" =~ ^[0-9]+$ ]] || [ "$embed_model_num" -lt 1 ] || [ "$embed_model_num" -gt "${#model_array[@]}" ]; then
    echo -e "${RED}Invalid selection.${NC}"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  selected_model="${model_array[$((embed_model_num-1))]}"
  echo -e "You selected: ${GREEN}$selected_model${NC}"
  
  # Create a temp file for text input
  tmp_file=$(mktemp)
  
  echo ""
  echo -e "${YELLOW}You will now enter texts to process. Type 'done' on a new line when finished.${NC}"
  echo -e "${YELLOW}Enter text (one per line):${NC}"
  
  # Read multiple lines of text until user types 'done'
  while true; do
    read input_line
    
    if [ "$input_line" = "done" ]; then
      break
    fi
    
    echo "$input_line" >> "$tmp_file"
  done
  
  # Check if file is empty
  if [ ! -s "$tmp_file" ]; then
    echo -e "${RED}No texts entered.${NC}"
    rm "$tmp_file"
    echo -e "${YELLOW}Press any key to return to the main menu${NC}"
    read -n 1
    show_main_menu
    return
  fi
  
  # Count number of texts
  text_count=$(wc -l < "$tmp_file")
  echo ""
  echo -e "${BLUE}Processing ${GREEN}$text_count${BLUE} texts...${NC}"
  
  # Create output file
  output_file="batch_embeddings_$(date +%s).json"
  echo "[" > "$output_file"
  
  first_item=true
  line_num=0
  
  # Process each line
  while IFS= read -r line; do
    line_num=$((line_num + 1))
    echo -e "${BLUE}Processing text $line_num of $text_count...${NC}"
    
    # Generate embeddings
    response=$(curl -s -X POST http://localhost:11434/api/embeddings \
      -d "{\"model\":\"$selected_model\",\"prompt\":\"$line\"}")
    
    if echo "$response" | jq -e '.embedding' >/dev/null 2>&1; then
      # Add comma for all but first item
      if [ "$first_item" = true ]; then
        first_item=false
      else
        echo "," >> "$output_file"
      fi
      
      # Extract embedding and create JSON object with text and embedding
      embedding=$(echo "$response" | jq '.embedding')
      echo "{\"text\": $(jq -n --arg text "$line" '$text'), \"embedding\": $embedding}" >> "$output_file"
    else
      echo -e "${RED}Failed to generate embedding for text $line_num.${NC}"
    fi
  done < "$tmp_file"
  
  # Close JSON array
  echo "]" >> "$output_file"
  
  # Clean up
  rm "$tmp_file"
  
  echo ""
  echo -e "${GREEN}✓ Batch processing complete!${NC}"
  echo -e "${BLUE}Output saved to: ${GREEN}$output_file${NC}"
  
  echo ""
  echo -e "${YELLOW}Press any key to return to the main menu${NC}"
  read -n 1
  show_main_menu
}

# Start the program by showing the main menu
show_main_menu 