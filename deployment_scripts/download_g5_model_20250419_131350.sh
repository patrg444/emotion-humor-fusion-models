#!/usr/bin/env bash
# Script to download the trained model from EC2
SSH_KEY="/Users/patrickgloria/Downloads/gpu-key.pem"
SSH_USER="ubuntu"
SSH_HOST="ubuntu@18.208.166.91"
EC2_PROJECT_PATH="/home/ubuntu/emotion-recognition"

# Find the model directory with timestamp
MODEL_DIR=$(ssh -i $SSH_KEY $SSH_HOST "find $EC2_PROJECT_PATH/models -name 'audio_pooling_with_laughter_*' -type d | sort -r | head -1")
if [ -z "$MODEL_DIR" ]; then
    echo "Error: No model directory found on EC2"
    exit 1
fi

# Extract basename
MODEL_NAME=$(basename "$MODEL_DIR")
echo "Found model: $MODEL_NAME"

# Create local directory
mkdir -p "models/$MODEL_NAME"

# Download model files
echo "Downloading model files..."
scp -i $SSH_KEY "$SSH_HOST:$MODEL_DIR/model_best.h5" "models/$MODEL_NAME/"
scp -i $SSH_KEY "$SSH_HOST:$MODEL_DIR/training_history.json" "models/$MODEL_NAME/"
scp -i $SSH_KEY "$SSH_HOST:$MODEL_DIR/model_info.json" "models/$MODEL_NAME/"
scp -i $SSH_KEY "$SSH_HOST:$MODEL_DIR/test_results.json" "models/$MODEL_NAME/"

echo "Model downloaded to models/$MODEL_NAME/"
