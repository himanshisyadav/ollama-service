#!/bin/bash

#SBATCH --job-name=ollama-server
#SBATCH --account=rcc-staff
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=4
##SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00
#SBATCH --output=./SLURM_logs/ollama_%j.out
#SBATCH --error=./SLURM_logs/ollama_%j.err

# Load modules
module load apptainer/1.4.1

cd $SLURM_SUBMIT_DIR

# Configuration
CONTAINER_IMAGE="./ollama.sif"
INSTANCE_NAME="ollama-$USER-$SLURM_JOB_ID"

HOST_PROJECT_PATH="$PWD"
CONTAINER_PROJECT_PATH="/workspace"

HOST_MODEL_PATH="$HOST_PROJECT_PATH/models"
CONTAINER_MODEL_PATH="$CONTAINER_PROJECT_PATH/models"

PORT=11434
DEFAULT_MODEL="llama2"  # Set your preferred default model

# Get the compute node hostname for connection info
COMPUTE_NODE=$(hostname)

# Unset variables to avoid conflicts
unset ROCR_VISIBLE_DEVICES

echo "🖥️  Running on compute node: $COMPUTE_NODE"
echo "🆔 SLURM Job ID: $SLURM_JOB_ID"

# Start Apptainer instance with GPU and writable tempfs
echo "🚀 Starting Ollama container instance..."

BIND_MOUNTS="/home:/home,/scratch:/scratch,$HOST_PROJECT_PATH:$CONTAINER_PROJECT_PATH,$HOST_MODEL_PATH:$CONTAINER_MODEL_PATH"
echo "🔗 Binding mounts: $BIND_MOUNTS"

apptainer instance start \
    --nv \
    --bind $BIND_MOUNTS \
    $CONTAINER_IMAGE $INSTANCE_NAME || {
    echo "❌ Failed to start Apptainer instance"
    exit 1
}

# Start Ollama serve inside the container in the background
echo "🔧 Starting Ollama server..."
apptainer exec instance://$INSTANCE_NAME \
    bash -c "export OLLAMA_MODELS=$MODEL_PATH && ollama serve &"

# Wait a moment for the server to start
echo "⏳ Waiting for server to initialize..."
sleep 5

echo "🦙 Ollama server is now running at http://$COMPUTE_NODE:$PORT"
echo "🔗 To access from your local machine, use SSH tunneling:"
echo "   ssh -L $PORT:$COMPUTE_NODE:$PORT $USER@midway3.rcc.uchicago.edu"
echo ""
echo "✅ After setting up the tunnel, verify Ollama is running by visiting:"
echo "   http://localhost:$PORT in your local browser"
echo "   You should see: \"Ollama is running\""

# Provide usage instructions
echo ""
echo "📋 Usage options:"
echo "1. Interactive model chat (from this compute node):"
echo "   apptainer exec instance://$INSTANCE_NAME ollama run $DEFAULT_MODEL"
echo ""
echo "2. Get container shell (from this compute node):"
echo "   apptainer shell instance://$INSTANCE_NAME"
echo ""
echo "3. List available models:"
echo "   apptainer exec instance://$INSTANCE_NAME ollama list"
echo ""
echo "4. The instance will stop automatically when the SLURM job ends"

# Keep the job running and the server alive
echo ""
echo "🔄 Server is running... Job will continue until time limit or manual cancellation"
echo "💡 To interact with models, ssh to $COMPUTE_NODE or use srun commands"
echo ""

# # Function to cleanup on exit
# cleanup() {
#     echo "🛑 Cleaning up..."
#     apptainer instance stop $INSTANCE_NAME 2>/dev/null || true
# }
# trap cleanup EXIT

# Keep the job alive and monitor the server
while true; do
    # Check if the instance is still running
    if ! apptainer instance list | grep -q $INSTANCE_NAME; then
        echo "❌ Ollama instance stopped unexpectedly"
        break
    fi
    
    # Check if ollama server is responding
    if ! apptainer exec instance://$INSTANCE_NAME pgrep -f "ollama serve" > /dev/null; then
        echo "❌ Ollama server process died, restarting..."
        apptainer exec instance://$INSTANCE_NAME \
            bash -c "export OLLAMA_MODELS=$MODEL_PATH && ollama serve &"
    fi
    
    sleep 30
done