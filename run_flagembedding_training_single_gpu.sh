#!/bin/bash

# BGE-M3 Fine-tuning using FlagEmbedding (Single GPU)
# This script runs the official FlagEmbedding fine-tuning implementation

export WANDB_MODE=disabled

train_data="\
    ./example_data/retrieval \
    ./example_data/sts/sts.jsonl \
    ./example_data/classification-no_in_batch_neg \
    ./example_data/clustering-no_in_batch_neg "

# set large epochs and small batch size for testing
num_train_epochs=4
per_device_train_batch_size=2

# set num_gpus to 1 for single GPU
num_gpus=1

if [ -z "$HF_HUB_CACHE" ]; then
    export HF_HUB_CACHE="$HOME/.cache/huggingface/hub"
fi

model_args="\
    --model_name_or_path BAAI/bge-m3 \
    --cache_dir $HF_HUB_CACHE \
"

data_args="\
    --train_data $train_data \
    --cache_path ~/.cache \
    --train_group_size 8 \
    --query_max_len 512 \
    --passage_max_len 512 \
    --pad_to_multiple_of 8 \
    --knowledge_distillation False \
"

training_args="\
    --output_dir ./test_encoder_only_m3_bge-m3_single_gpu \
    --overwrite_output_dir \
    --learning_rate 1e-5 \
    --fp16 \
    --num_train_epochs $num_train_epochs \
    --per_device_train_batch_size $per_device_train_batch_size \
    --dataloader_drop_last True \
    --warmup_ratio 0.1 \
    --gradient_checkpointing \
    --logging_steps 1 \
    --save_steps 1000 \
    --temperature 0.02 \
    --sentence_pooling_method cls \
    --normalize_embeddings True \
    --kd_loss_type m3_kd_loss \
    --unified_finetuning True \
    --use_self_distill True \
    --fix_encoder False \
    --self_distill_start_step 0 \
"

cmd="torchrun --nproc_per_node $num_gpus \
    -m FlagEmbedding.finetune.embedder.encoder_only.m3 \
    $model_args \
    $data_args \
    $training_args \
"

echo "Running command (Single GPU):"
echo $cmd
echo ""
echo "Starting training..."
eval $cmd 