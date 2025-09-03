# Ollama Setup with Anaconda Environment

This guide walks you through setting up Ollama using an Anaconda environment on the Midway3 cluster.

## 1. Creating the Anaconda Environment

Create a new Anaconda environment with Ollama installed:

```bash
conda create --prefix=/project/PI_NAME/USER/envs/ollama ollama
```

Replace `PI_NAME` and `USER` with your actual principal investigator name and username. Create the parent directory `/project/PI_NAME/USER/envs/` if not created prior to this using:

```bash
mkdir -p /project/PI_NAME/USER/envs/
```

## 2. Creating a Symlink (Optional)

For convenient access to your environment, create a symlink:

```bash
ln -s /project/PI_NAME/USER/envs/ollama ~/.conda/envs/ollama
```

This allows you to activate the environment using:
```bash
source activate ollama
```

## 3. Downloading Models

You can download open-source models on Midway3's login nodes or on the build partition.

### a. Set Model Storage Location

Add the following line to your `~/.bashrc` file to specify where models should be stored:

```bash
export OLLAMA_MODELS=/project/PI_NAME/USER/ollama_models
```

After editing `~/.bashrc`, reload it:
```bash
source ~/.bashrc
```

### b. Start the Ollama Server

```bash
ollama serve &
sleep 10
```

### c. Download a Model

Pull a model using the following command. Models will be stored in the directory specified in step 3a:

```bash
ollama pull mistral:latest
```

You can replace `mistral:latest` with any other available model from the [Ollama library](https://ollama.ai/library).

## 4. Running Ollama Server on Compute Nodes

Use the provided SLURM script template to start the Ollama server on a GPU node:

```bash
sbatch ollama-slurm.sh
```

Ollama will automatically detect and utilize available GPUs on the compute node.

## Important Notes

- **Port Forwarding**: Remember to forward the Ollama service port (default: `11434`) to access the server from your local machine.

- **Address Already in Use Error**: If you encounter a `bind: address already in use` error, kill any previously running Ollama server:
  ```bash
  ps aux | grep ollama
  kill <PID>
  ```
  Replace `<PID>` with the actual process ID from the `ps` command output.

## Usage Examples

Once your server is running, you can interact with Ollama:

```bash
# Chat with a model
ollama run mistral:latest

# List downloaded models
ollama list

# Remove a model
ollama rm mistral:latest
```

## Troubleshooting

- Ensure your environment variables are properly set in `~/.bashrc`
- Verify that the Ollama service is running before attempting to pull or run models
- Check available disk space in your project directory before downloading large models
- Confirm GPU availability on compute nodes if using GPU-accelerated models