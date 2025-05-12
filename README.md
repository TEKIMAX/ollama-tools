# Ollama Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A collection of utility scripts for managing [Ollama](https://ollama.ai/) models on your local machine. These scripts make it easier for non-technical users to work with Ollama's powerful features.

## 📦 Tools Included

### Basic Tools

#### 🗑️ remove_ollama_models.sh

An interactive script for managing and removing your installed Ollama models.

#### 🤖 create_custom_model.sh

Easily create customized assistant models with specific personalities and capabilities.

#### 📊 install_embedding_model.sh

Simple installation of embedding models for RAG (Retrieval Augmented Generation) applications.

### Advanced Tools

#### 🚀 create_custom_model_advanced.sh

Advanced model creation with support for custom templates and model parameters.

#### 🧠 advanced_embedding_tools.sh

Full-featured embedding suite with batch processing, similarity comparison, and more.

## 🚀 Features

### Basic Features

- **Model Management**: Remove specific or all installed models
- **Easy Customization**: Create custom models with predefined or custom personalities
- **Embedding Support**: Install specialized embedding models for RAG applications
- **User-Friendly Interface**: Interactive CLI with clear prompts and colorful output

### Advanced Features

- **Custom Model Templates**: Define exactly how your model formats responses
- **Model Parameter Tuning**: Fine-tune temperature, top_k, top_p, and context window
- **Embedding Vector Visualization**: View and export generated embedding vectors
- **Text Similarity Analysis**: Compare texts using cosine similarity metrics
- **Batch Processing**: Process multiple texts at once for embedding generation

## 📋 Requirements

- Ollama installed and properly configured ([Ollama installation guide](https://ollama.ai/download))
- Bash shell (included by default on macOS and most Linux distributions)
- (For advanced embedding tools) jq for JSON processing

## 🔧 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/tekimax/ollama-tools.git
   ```

2. Make the scripts executable:
   ```bash
   chmod +x ollama-tools/*.sh
   ```

3. For advanced embedding tools, you'll need `jq` (the script will attempt to install it if missing):
   ```bash
   # macOS
   brew install jq
   
   # Ubuntu/Debian
   sudo apt-get install jq
   
   # CentOS/RHEL
   sudo yum install jq
   ```

## 🔍 Usage

### Basic Tools

#### Remove Ollama Models Script

This script helps you manage your installed Ollama models by providing an easy way to remove them.

```bash
./remove_ollama_models.sh
```

##### Options:

- Enter a **number** to select and remove a specific model
- Enter **'a'** to remove all installed models at once
- Enter **'q'** to quit without removing any models

#### Create Custom Model Script

This script helps you create customized Ollama models with specific personalities or roles.

```bash
./create_custom_model.sh
```

##### Features:

- Select any installed model as your base
- Choose from predefined assistant types:
  - General Assistant
  - Coding Assistant
  - Writing Assistant
- Define your own custom personality and role
- Automatic creation of the model with your specifications

#### Install Embedding Model Script

This script simplifies the installation of embedding models for RAG applications.

```bash
./install_embedding_model.sh
```

##### Features:

- Curated list of popular embedding models
- Shows example code for using the models
- Provides examples for Python (LlamaIndex) and JavaScript (LangChain)

### Advanced Tools

#### Advanced Custom Model Creator

Create models with fine-grained control over model behavior and response format.

```bash
./create_custom_model_advanced.sh
```

##### Advanced Features:

- All basic features from the simple model creator
- Custom prompt templates with placeholders
- Model parameter tuning:
  - Temperature control
  - Top-P and Top-K sampling settings
  - Context window size adjustment
- Preview of the full Modelfile before creation

#### Advanced Embedding Tools

Full-featured suite for working with embeddings.

```bash
./advanced_embedding_tools.sh
```

##### Embedding Features:

- Interactive menu-driven interface
- Install embedding models
- Generate embeddings for text with vector visualization
- Compare similarity between texts with interpretation
- Batch process multiple texts for embedding generation
- Save embeddings to JSON files for later use

## API Compatibility

These tools use the [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md) under the hood and support most API features:

- Model creation with custom Modelfiles
- Template customization with placeholders
- Parameter tuning for model behavior
- Embedding generation and processing

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