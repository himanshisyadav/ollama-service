# Ollama using Apptainer Containers

Containers provide a way to run software in a portable manner across different environments. OLLAMA offers an official container image on Docker Hub, which serves as a repository for container images.

On Midway3, we use Apptainer to execute containers. The following commands show how to set up the OLLAMA container for use with Midway3 on the cluster.

## 1. Download and Build Apptainer Container 

You can create a `ollama.sif` container by downloading the official pre-built OLLAMA images on Docker Hub and building the container. Use the command below:

```
apptainer build ollama.sif docker://ollama/ollama
```

**Note:** It is best to use the `build` partition on Midway3 for pulling and building containers. 

## 2. Prepare Your Directory Structure

Create the following layout for your project. This structure helps you manage your models and container image effectively.

```
.
├── ollama-apptainer/       # Root Directory
│   ├──  ollama.sif         # Container  
│   ├──  models/            # Pulled models
│   ├── ollama-slurm.sh     # SLURM script to run Ollama on GPU nodes
```

## 3. Run Ollama using SLURM script

You can use the template SLURM script to start the Ollama service on a GPU node

```
sbatch ollama-slurm.sh
```


