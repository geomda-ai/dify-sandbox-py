FROM ghcr.io/mamba-org/micromamba:2.1.0-ubuntu24.04

# Activate environment in Dockerfile
ARG MAMBA_DOCKERFILE_ACTIVATE=1

# Copy environment.yaml file
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml

# Install all dependencies using micromamba
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes && \
    rm -rf /tmp/env.yaml

# Set working directory
WORKDIR /app

# Copy application code and startup script
COPY --chown=$MAMBA_USER:$MAMBA_USER app/ ./app/
COPY --chown=$MAMBA_USER:$MAMBA_USER start.sh .

# Make startup script executable
RUN chmod +x start.sh

# Expose port
EXPOSE 8194

# Set the entrypoint and CMD
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["./start.sh"]