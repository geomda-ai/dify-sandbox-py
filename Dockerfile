FROM ghcr.io/osgeo/gdal:ubuntu-small-3.10.3
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install Node.js and git
RUN apt-get update && \
    apt-get install -y curl git && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs python3-pip python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dependency files
COPY requirements.txt .

# Use uv to install base dependencies to system environment
# Using --break-system-packages to override externally managed Python
RUN uv pip install --system --break-system-packages -r requirements.txt

# Copy application code and startup script
COPY app/ ./app/
COPY start.sh .

# Create dependencies directory
RUN mkdir -p /dependencies

# Set startup script permissions
RUN chmod +x start.sh

# Expose port
EXPOSE 8194

# Use startup script instead of direct uvicorn command
CMD ["./start.sh"]