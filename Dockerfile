FROM ghcr.io/mamba-org/micromamba:2.1.0-ubuntu24.04

USER root

# Create dependencies directory for additional requirements
RUN mkdir -p /dependencies && chown $MAMBA_USER:$MAMBA_USER /dependencies

# Copy environment.yaml file
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml

# Install all dependencies from the conda environment and clean up
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes && \
    rm -rf /tmp/env.yaml && \
    find /opt/conda -follow -type f -name '*.a' -delete && \
    find /opt/conda -follow -type f -name '*.js.map' -delete && \
    find /opt/conda -name '__pycache__' -type d -exec rm -rf {} + || true

# Set working directory
WORKDIR /app

# Copy application code and startup script
COPY --chown=$MAMBA_USER:$MAMBA_USER app/ ./app/
COPY --chown=$MAMBA_USER:$MAMBA_USER start.sh .

# Set startup script permissions
RUN chmod +x start.sh

# Expose port
EXPOSE 8194

# Switch back to non-root user
USER $MAMBA_USER

# Set the entrypoint to activate conda and run the startup script
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["./start.sh"]