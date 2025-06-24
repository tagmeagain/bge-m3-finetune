# BGE-M3 Fine-tuning with FlagEmbedding (Official Implementation)

This directory contains the setup for fine-tuning BGE-M3 using the official FlagEmbedding library implementation.

## 🐳 Docker Setup (Recommended)

The easiest way to run this without dependency issues is using Docker.

### Quick Start with Docker

1. **Prerequisites**:
   - Docker installed
   - Docker Compose installed
   - NVIDIA Docker runtime (for GPU support)

2. **Setup and Run**:
   ```bash
   # Quick setup
   ./docker_quick_start.sh
   
   # Or run training directly
   ./run_docker_training.sh
   ```

3. **Available Commands**:
   ```bash
   # Interactive mode (choose training type)
   ./run_docker_training.sh
   
   # Single GPU training
   ./run_docker_training.sh single
   
   # Multi-GPU training
   ./run_docker_training.sh multi
   
   # Manual Docker shell
   docker-compose run --rm bge-m3-training bash
   ```

### Docker Directory Structure

```
.
├── data/                    # Mount your training data here
├── custom_data/            # Mount custom datasets here
├── outputs/                # Training results (persisted)
├── cache/                  # HuggingFace cache (persisted)
└── example_data/           # Example data (built into image)
```

## 🖥️ Local Setup (Alternative)

If you prefer to run locally without Docker:

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Run Training

**Multi-GPU (2 GPUs):**
```bash
./run_flagembedding_training.sh
```

**Single GPU:**
```bash
./run_flagembedding_training_single_gpu.sh
```

## Directory Structure

```
.
├── Dockerfile                          # Docker configuration
├── docker-compose.yml                  # Docker Compose setup
├── .dockerignore                       # Docker ignore file
├── run_docker_training.sh              # Docker training runner
├── docker_quick_start.sh               # Quick start script
├── requirements.txt                    # Python dependencies
├── README.md                           # This file
├── run_flagembedding_training.sh       # Multi-GPU training script
├── run_flagembedding_training_single_gpu.sh # Single-GPU training script
├── ds_stage0.json                      # DeepSpeed configuration
└── example_data/                       # Training data
    ├── retrieval/
    │   └── train.jsonl                 # Query-passage pairs for retrieval
    ├── sts/
    │   └── sts.jsonl                   # Semantic Text Similarity pairs
    ├── classification-no_in_batch_neg/
    │   └── train.jsonl                 # Text classification data
    └── clustering-no_in_batch_neg/
        └── train.jsonl                 # Clustering data
```

## Data Formats

### 1. Retrieval Data (`example_data/retrieval/train.jsonl`)
```json
{"query": "What is machine learning?", "positive": "Machine learning is a subset of AI...", "negative": "The weather is sunny today..."}
```

### 2. STS Data (`example_data/sts/sts.jsonl`)
```json
{"sentence1": "The cat is on the mat", "sentence2": "A feline sits on the carpet", "score": 0.9}
```

### 3. Classification Data (`example_data/classification-no_in_batch_neg/train.jsonl`)
```json
{"text": "This movie is amazing!", "label": "positive"}
```

### 4. Clustering Data (`example_data/clustering-no_in_batch_neg/train.jsonl`)
```json
{"text": "Machine learning algorithms can be supervised or unsupervised.", "label": "ml"}
```

## Configuration

### Training Parameters

- **Model**: BAAI/bge-m3
- **Learning Rate**: 1e-5
- **Epochs**: 4
- **Batch Size**: 2 per device
- **Max Length**: 512 tokens
- **Pooling Method**: CLS token
- **Temperature**: 0.02
- **FP16**: Enabled
- **Gradient Checkpointing**: Enabled

### DeepSpeed Configuration

The `ds_stage0.json` file configures DeepSpeed for:
- FP16 training
- AdamW optimizer
- Warmup learning rate scheduler
- ZeRO stage 0 optimization
- CPU offloading for optimizer states

## Key Features

### 1. Unified Fine-tuning
- Combines multiple tasks (retrieval, STS, classification, clustering)
- Uses M3 knowledge distillation loss
- Self-distillation enabled

### 2. Multi-GPU Training
- Distributed training with torchrun
- Cross-device negative sampling
- DeepSpeed integration for memory efficiency

### 3. Advanced Features
- Knowledge distillation
- Self-distillation
- Unified fine-tuning approach
- Temperature scaling
- Normalized embeddings

## Using Your Own Data

### With Docker

1. **Place your data in the mounted directories**:
   ```bash
   # Copy your data to the data directory
   cp your_data.jsonl ./data/
   
   # Or use custom_data directory
   cp your_data.jsonl ./custom_data/
   ```

2. **Modify the training scripts** to use your data paths:
   ```bash
   # Edit the training scripts to point to your data
   # Update train_data variable in the scripts
   ```

### Without Docker

1. **Replace example data** with your own files
2. **Update training scripts** to point to your data paths
3. **Run training** as usual

## Customization

### Modify Training Data

Replace the example data files with your own:

1. **Retrieval**: Create query-passage pairs with positive/negative examples
2. **STS**: Create sentence pairs with similarity scores (0-1)
3. **Classification**: Create text-label pairs
4. **Clustering**: Create text-label pairs for clustering

### Adjust Hyperparameters

Edit the training script to modify:
- Learning rate
- Batch size
- Number of epochs
- Model parameters
- DeepSpeed configuration

### Single vs Multi-GPU

- **Multi-GPU**: Use `run_flagembedding_training.sh` (requires 2+ GPUs)
- **Single GPU**: Use `run_flagembedding_training_single_gpu.sh`

## Output

The training will create:
- `test_encoder_only_m3_bge-m3/` - Multi-GPU output
- `test_encoder_only_m3_bge-m3_single_gpu/` - Single-GPU output

Each directory contains:
- Model checkpoints
- Training logs
- Configuration files
- Tokenizer files

## Troubleshooting

### Docker Issues

1. **GPU not detected**: Install nvidia-docker2
2. **Out of memory**: Reduce batch size in training scripts
3. **Permission issues**: Check Docker permissions

### Common Issues

1. **Out of Memory**: Reduce batch size or use gradient accumulation
2. **CUDA Issues**: Ensure compatible PyTorch and CUDA versions
3. **DeepSpeed Issues**: Check DeepSpeed installation and configuration
4. **Data Format**: Ensure data follows the expected JSONL format

### Performance Tips

- Use FP16 for faster training
- Enable gradient checkpointing for memory efficiency
- Use DeepSpeed for large models
- Adjust batch size based on available GPU memory

## Comparison with Custom Implementation

This FlagEmbedding approach offers:
- **Official Implementation**: Uses the official FlagEmbedding library
- **Advanced Features**: M3 knowledge distillation, self-distillation
- **Multi-task Training**: Unified fine-tuning across multiple tasks
- **DeepSpeed Integration**: Optimized for large-scale training
- **Docker Support**: No dependency issues, reproducible environment

Choose based on your needs:
- **FlagEmbedding**: For production use with advanced features
- **Docker**: For consistent, dependency-free execution 