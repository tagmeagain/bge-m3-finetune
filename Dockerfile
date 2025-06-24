# Use CUDA-enabled PyTorch base image
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV WANDB_MODE=disabled

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install additional dependencies that might be needed
RUN pip install --no-cache-dir \
    ninja \
    packaging \
    wheel \
    setuptools

# Copy the training scripts and data
COPY run_flagembedding_training.sh .
COPY run_flagembedding_training_single_gpu.sh .
COPY ds_stage0.json .

# Make scripts executable
RUN chmod +x run_flagembedding_training.sh
RUN chmod +x run_flagembedding_training_single_gpu.sh

# Copy example data
COPY example_data/ ./example_data/

# Create output directory
RUN mkdir -p /workspace/outputs

# Set default command
CMD ["/bin/bash"] 