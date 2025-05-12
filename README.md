# Ollama Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of utility scripts for managing [Ollama](https://ollama.ai/) models on your local machine.

## 📦 Tools Included

### 🗑️ remove_ollama_models.sh

An interactive script for managing and removing your installed Ollama models.

## 🚀 Features

- **Interactive Model Selection**: Select specific models from a numbered list
- **Bulk Removal Option**: Remove all installed models at once with a single command
- **Confirmation Prompts**: Prevents accidental removals with confirmation steps
- **User-Friendly Interface**: Simple numbered menu for easy navigation

## 📋 Requirements

- Ollama installed and properly configured ([Ollama installation guide](https://ollama.ai/download))
- Bash shell (included by default on macOS and most Linux distributions)

## 🔧 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/tekimax/ollama-tools.git
   ```

2. Make the scripts executable:
   ```bash
   chmod +x ollama-tools/*.sh
   ```

## 🔍 Usage

### Remove Ollama Models Script

This script helps you manage your installed Ollama models by providing an easy way to remove them.

```bash
./remove_ollama_models.sh
```

#### Options:

- Enter a **number** to select and remove a specific model
- Enter **'a'** to remove all installed models at once
- Enter **'q'** to quit without removing any models

#### Example Walkthrough:

1. When you run the script, it will list all your installed models:
   ```
   Fetching available Ollama models...
   Available models:
   1. mistral-small3.1:latest
   2. qwen3:latest
   3. llama3.1:8b
   4. granite3.1-dense:8b
   5. llama2:latest
   6. llama3.1:latest
   7. deepseek-r1:8b
   8. hf.co/bartowski/Llama-3.2-1B-Instruct-GGUF:Q8_0
   ```

2. You'll then be prompted to make a selection:
   ```
   Enter the number of the model to remove, 'a' to remove all models, or 'q' to quit:
   ```

3. After entering your choice, you'll be asked to confirm:
   ```
   You selected: llama3.1:8b
   Are you sure you want to remove this model? (y/n)
   ```

4. The script will then remove the selected model or exit based on your confirmation.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

- [Ollama](https://ollama.ai/) for providing the amazing tool for running LLMs locally
- All contributors who help improve these tools 