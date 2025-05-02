#!/bin/bash

# Set default pip mirror source
MIRROR_URL=${PIP_MIRROR_URL:-"https://pypi.org/simple"}

# Check and install dependencies
if [ -f "/dependencies/python-requirements.txt" ]; then
    echo "Dependency file found, starting to install additional dependencies..."
    echo "Using pip mirror: $MIRROR_URL"
    uv pip install --system --break-system-packages -r /dependencies/python-requirements.txt -i "$MIRROR_URL"
fi

# Start FastAPI application
exec uvicorn app.main:app --host 0.0.0.0 --port 8194