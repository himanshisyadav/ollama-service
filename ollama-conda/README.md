# Ollama using Anaconda Environment

## 1. Creating Anaconda Environment

```
conda create --prefix=/project/PI_NAME/USER/envs/ollama ollama
```

## 2. Creating Symlink

You can create a symlink for conveniently using the environment.

```
ln -s /project2/PI_NAME/USER/envs/ollama ~/.conda/envs/ollama
```

### 3. Downloading Models

You can download open source models on Midway3's login nodes or on the build partition. 

a. Set default location for downloaded models by adding the following to your `~/.bashrc` file. 

```
export OLLAMA_MODELS=/project2/PI_NAME/USER/ollama_models
```

b. Start Ollama server
```
ollama serve &
sleep 10
```

c. Pull a model using the following command. It will store the models downloaded in the models directory in step a. 
```
ollama pull mistral:latest
```

### 4. Running Ollama server on Compute Nodes

You can use the template SLURM script to start the Ollama server on a GPU node. Ollama will automatically detect the GPUs available. 

```
sbatch ollama-slurm.sh
```

**Note:** Remember to forward Ollama service port (by default `11434`) to access the server.

**Note:** If you receive `bind: address already in use` error, then kill the previously running ollama server using:

```
ps -aux | grep
kill <PID>
```