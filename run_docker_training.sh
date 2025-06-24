#!/bin/bash

# Docker Training Script for BGE-M3 FlagEmbedding
# This script builds and runs the training in a Docker container

set -e

echo "=== BGE-M3 FlagEmbedding Docker Training ==="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

# Check if NVIDIA Docker runtime is available (for GPU support)
if ! docker info | grep -q nvidia; then
    echo "Warning: NVIDIA Docker runtime not detected. Training will run on CPU only."
    echo "For GPU support, install nvidia-docker2: https://github.com/NVIDIA/nvidia-docker"
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p outputs
mkdir -p cache
mkdir -p data
mkdir -p custom_data

# Build the Docker image
echo "Building Docker image..."
docker-compose build

# Function to run training
run_training() {
    local script_name=$1
    local description=$2
    
    echo ""
    echo "=== Running $description ==="
    echo "Command: $script_name"
    echo ""
    
    # Run the training script inside the container
    docker-compose run --rm bge-m3-training bash -c "
        echo 'Starting $description...'
        echo 'Available GPUs:'
        nvidia-smi || echo 'No GPUs detected'
        echo ''
        echo 'Running: $script_name'
        ./$script_name
    "
}

# Check if user wants to run specific training
if [ "$1" = "single" ]; then
    run_training "run_flagembedding_training_single_gpu.sh" "Single GPU Training"
elif [ "$1" = "multi" ]; then
    run_training "run_flagembedding_training.sh" "Multi-GPU Training"
else
    # Ask user which training to run
    echo ""
    echo "Which training would you like to run?"
    echo "1) Single GPU Training"
    echo "2) Multi-GPU Training"
    echo "3) Interactive Shell (to run commands manually)"
    echo ""
    read -p "Enter your choice (1-3): " choice
    
    case $choice in
        1)
            run_training "run_flagembedding_training_single_gpu.sh" "Single GPU Training"
            ;;
        2)
            run_training "run_flagembedding_training.sh" "Multi-GPU Training"
            ;;
        3)
            echo ""
            echo "Starting interactive shell..."
            echo "You can run the training scripts manually:"
            echo "  ./run_flagembedding_training.sh          # Multi-GPU"
            echo "  ./run_flagembedding_training_single_gpu.sh  # Single GPU"
            echo ""
            docker-compose run --rm bge-m3-training bash
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi

echo ""
echo "=== Training completed! ==="
echo "Check the 'outputs' directory for results."
echo "Model checkpoints will be saved to: ./outputs/" 