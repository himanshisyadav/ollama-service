#!/bin/bash

#SBATCH --job-name=ollama-server
#SBATCH --account=rcc-staff
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --time=00:20:00
#SBATCH --output=./SLURM_logs/ollama_%j.out
#SBATCH --error=./SLURM_logs/ollama_%j.err

# Load modules
module load python/miniforge-25.3.0

PORT=11434
DEFAULT_MODEL="mistral:latest"  # Set your preferred default model

# Get the compute node hostname for connection info
COMPUTE_NODE=$(hostname)

echo "🖥️ Running on compute node: $COMPUTE_NODE"
echo "🆔 SLURM Job ID: $SLURM_JOB_ID"

echo "🔧 Activating conda environment 'ollama'..."

# Activate the conda environment
source activate ollama

if [ $? -ne 0 ]; then
    echo "❌ Failed to activate conda environment 'ollama'. Exiting."
    exit 1
fi

echo "✅ Conda environment 'ollama' activated."

# Start the OLLAMA server in the background
if pgrep -f "ollama serve" > /dev/null; then
    echo "🦙 Ollama server is already running."
else
    echo "🔧 Starting Ollama server..."
    ollama serve &
fi

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

# Run the default model to verify everything is working
# echo "🤖 Running default model '$DEFAULT_MODEL' to verify setup..."
ollama run $DEFAULT_MODEL Why do we eat? > output.txt || { echo "❌ Error: Ollama failed."; exit 1; }
 

