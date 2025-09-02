# Ollama on UChicago RCC Midway3 Cluster

A comprehensive toolkit for deploying and running Ollama (Large Language Models) on the University of Chicago Research Computing Center's Midway3 cluster using multiple deployment methods.

OLLAMA (Omni-Layer Learning Language Acquisition Model) is a platform designed for running open-source large language models (LLMs) directly on your local machine, rather than relying on cloud-based services. This enables users to utilize and develop LLMs easily while maintaining privacy and reducing costs.

## 📁 Repository Structure

```
.
├── ollama-apptainer/        # Apptainer/Singularity deployment
├── ollama-conda/            # Conda environment deployment
└── ollama-source/           # Source-based manual deployment
├── LICENSE                  # License file
├── .gitignore               # Git ignore rules
├── README.md                # This file
```

## 🎯 Overview

This repository provides three different approaches to deploy Ollama on Midway3, each with their own advantages:

- **🐳 Apptainer/Singularity**: Containerized deployment for maximum portability and isolation
- **🐍 Conda**: Python environment-based deployment for easy dependency management
- **⚙️ Source**: Direct source compilation for maximum performance and customization

## 📂 Deployment Options

### 🐳 [`ollama-apptainer/`](./ollama-apptainer/)
**Containerized deployment using Apptainer/Singularity**

- ✅ **Best for**: Production environments, shared clusters, maximum portability
- ✅ **Advantages**: Isolated environment, no dependency conflicts, reproducible
- ❌ **Considerations**: Requires Apptainer/Singularity installation

**Features:**
- Pre-configured for Midway3's GPU partition
- SLURM job scripts with proper resource requests
- SSH tunneling setup for `midway3.rcc.uchicago.edu`
- Automated cleanup and monitoring

### 🐍 [`ollama-conda/`](./ollama-conda/)
**Conda environment-based deployment**

- ✅ **Best for**: Development, testing, interactive work
- ✅ **Advantages**: Integrates with RCC's Anaconda modules, flexible development
- ❌ **Considerations**: Manual dependency management on shared system

**Features:**
- Environment files tested on Midway3
- Compatible with RCC's Python modules

### ⚙️ [`ollama-source/`](./ollama-source/)
**Direct source compilation and installation**

- ✅ **Best for**: Maximum performance, custom builds, latest Ollama features
- ✅ **Advantages**: Native performance on Midway3 hardware, full customization
- ❌ **Considerations**: Manual dependency management, compilation complexity

**Features:**
- Optimized for Midway3 nodes
- CUDA setup for V100 and A100 GPUs
- Custom build flags for performance
- Integration with RCC's development modules

## ⚠️ What's Not Included

This repository provides deployment scripts and configuration files, but does **not** include:

- **Apptainer container images** - You'll need to build or pull these yourself or can use pre-built images available on Midway3
- **Software binaries** - Ollama executables must be downloaded/compiled separately or can use ollama module on Midway3
- **SLURM job files with your specific settings** - Templates provided, but customize for your needs
- **Model files** - Large language models must be downloaded separately via Ollama
- **Personal configuration** - Username, project paths, and resource allocations need customization

Think of this as a **blueprint and toolkit** rather than a ready-to-run package.