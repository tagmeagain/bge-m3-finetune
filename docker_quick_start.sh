#!/bin/bash

# Quick Start Script for Docker Training
# This script provides a simple way to get started with Docker training

echo "=== BGE-M3 FlagEmbedding Docker Quick Start ==="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Create directories
echo "Setting up directories..."
mkdir -p outputs cache data custom_data

# Build and run
echo "Building Docker image (this may take a few minutes)..."
docker-compose build

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "To start training, run one of these commands:"
echo ""
echo "1. Interactive mode (recommended for first time):"
echo "   ./run_docker_training.sh"
echo ""
echo "2. Single GPU training:"
echo "   ./run_docker_training.sh single"
echo ""
echo "3. Multi-GPU training:"
echo "   ./run_docker_training.sh multi"
echo ""
echo "4. Manual Docker commands:"
echo "   docker-compose run --rm bge-m3-training bash"
echo ""
echo "=== Directory Structure ==="
echo "  ./data/          - Put your training data here"
echo "  ./custom_data/   - Put your custom datasets here"
echo "  ./outputs/       - Training results will be saved here"
echo "  ./cache/         - HuggingFace cache (auto-created)"
echo ""
echo "=== Next Steps ==="
echo "1. Place your training data in ./data/ or ./custom_data/"
echo "2. Run ./run_docker_training.sh"
echo "3. Check ./outputs/ for results" 