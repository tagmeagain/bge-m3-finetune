#!/bin/bash

# Script to update training data paths in the training scripts
# This helps users easily switch from example data to their own data

echo "=== Update Training Data Paths ==="
echo "This script helps you update the training data paths in the training scripts."
echo ""

# Function to update paths in a file
update_paths() {
    local file=$1
    local new_data_path=$2
    
    echo "Updating $file..."
    
    # Create backup
    cp "$file" "${file}.backup"
    
    # Update the train_data variable
    if [[ "$new_data_path" == "example" ]]; then
        # Use example data
        sed -i 's|train_data=".*"|train_data="\\\n    ./example_data/retrieval \\\n    ./example_data/sts/sts.jsonl \\\n    ./example_data/classification-no_in_batch_neg \\\n    ./example_data/clustering-no_in_batch_neg "|' "$file"
    else
        # Use custom data
        sed -i "s|train_data=\".*\"|train_data=\"\\\n    $new_data_path/retrieval \\\n    $new_data_path/sts/sts.jsonl \\\n    $new_data_path/classification-no_in_batch_neg \\\n    $new_data_path/clustering-no_in_batch_neg \"|" "$file"
    fi
    
    echo "✓ Updated $file"
}

# Check if data path is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <data_path>"
    echo ""
    echo "Examples:"
    echo "  $0 ./data                    # Use data from ./data directory"
    echo "  $0 ./custom_data             # Use data from ./custom_data directory"
    echo "  $0 example                   # Use example data"
    echo ""
    echo "Data directory structure should be:"
    echo "  <data_path>/"
    echo "  ├── retrieval/"
    echo "  │   └── train.jsonl"
    echo "  ├── sts/"
    echo "  │   └── sts.jsonl"
    echo "  ├── classification-no_in_batch_neg/"
    echo "  │   └── train.jsonl"
    echo "  └── clustering-no_in_batch_neg/"
    echo "      └── train.jsonl"
    exit 1
fi

DATA_PATH=$1

# Validate data path
if [[ "$DATA_PATH" != "example" ]]; then
    if [ ! -d "$DATA_PATH" ]; then
        echo "Error: Directory '$DATA_PATH' does not exist."
        echo "Please create the directory and add your training data first."
        exit 1
    fi
    
    # Check if required subdirectories exist
    required_dirs=("retrieval" "sts" "classification-no_in_batch_neg" "clustering-no_in_batch_neg")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$DATA_PATH/$dir" ]; then
            echo "Warning: Directory '$DATA_PATH/$dir' does not exist."
            echo "You may need to create it and add training data."
        fi
    done
fi

echo "Updating training scripts to use data from: $DATA_PATH"
echo ""

# Update both training scripts
update_paths "run_flagembedding_training.sh" "$DATA_PATH"
update_paths "run_flagembedding_training_single_gpu.sh" "$DATA_PATH"

echo ""
echo "=== Update Complete! ==="
echo "Training scripts have been updated to use data from: $DATA_PATH"
echo ""
echo "Backup files have been created:"
echo "  - run_flagembedding_training.sh.backup"
echo "  - run_flagembedding_training_single_gpu.sh.backup"
echo ""
echo "To restore original paths, run:"
echo "  cp run_flagembedding_training.sh.backup run_flagembedding_training.sh"
echo "  cp run_flagembedding_training_single_gpu.sh.backup run_flagembedding_training_single_gpu.sh" 