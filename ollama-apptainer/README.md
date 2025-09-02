# Ollama using Apptainer Containers

Containers provide a way to run software in a portable manner across different environments. Ollama offers an official container image on Docker Hub, which serves as a repository for container images.

On Midway3, we use Apptainer to execute containers. The following commands show how to set up an Ollama container for use on the Midway3 cluster.

## 1. Download and Build Apptainer Container 

You can create a `ollama.sif` container by downloading the official pre-built Ollama images on Docker Hub and building the container.

```
apptainer build ollama.sif docker://ollama/ollama
```

**Note:** It is best to use the `build` partition on Midway3 for pulling images and building containers. 

## 2. Prepare Your Directory Structure

Create the following layout for your project. This structure helps you manage your models and container effectively.

```
.
├── ollama-apptainer/       # Root Directory
│   ├── ollama.sif          # Container  
│   ├── models/             # Pulled models
│   ├── ollama-slurm.sh     # SLURM script to run Ollama on GPU nodes
│   ├── README.md           # This file
```

## 3. Running the Ollama server on Compute Nodes

You can use the template SLURM script to start the Ollama server on a GPU node. Ollama will automatically detect the GPUs available. 

```
sbatch ollama-slurm.sh
```

**Note:** Remember to forward Ollama service port (by default `11434`) to access the server.


