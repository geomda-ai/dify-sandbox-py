#!/bin/bash

# Set default pip mirror source
MIRROR_URL=${PIP_MIRROR_URL:-"https://pypi.org/simple"}

# Check and install conda dependencies from environment file
if [ -f "/dependencies/conda-environment.yaml" ]; then
    echo "Conda environment file found, starting to install additional conda dependencies..."
    
    # Install packages from the conda environment file
    micromamba install -y -n base -f /dependencies/conda-environment.yaml
    
    # Clean up to save space
    micromamba clean --all --yes
fi

# Check and install pip dependencies
if [ -f "/dependencies/python-requirements.txt" ]; then
    echo "Pip requirements file found, starting to install additional pip dependencies..."
    echo "Using pip mirror: $MIRROR_URL"
    
    # Use pip explicitly in the base conda environment
    pip install -r /dependencies/python-requirements.txt -i "$MIRROR_URL"
fi

# Start FastAPI application
exec uvicorn app.main:app --host 0.0.0.0 --port 8194