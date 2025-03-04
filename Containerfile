FROM registry.access.redhat.com/ubi9/python-311:9.5

USER 0

# Install Python and required dependencies
# RUN dnf -y update --setopt=tsflags=nodocs && \
#     dnf -y install python3 python3-pip && \
#     dnf clean all && \
#     mkdir -p /opt/app-root/bin/docling-serve && \
#     mkdir -p /opt/app-root/bin && \
#     chown -R 1001:0 /opt/app-root

RUN dnf -y update --setopt=tsflags=nodocs && \
    dnf clean all && \
    mkdir -p /opt/app-root/bin/docling_serve && \
    mkdir -p /opt/app-root/bin && \
    chown -R 1001:0 /opt/app-root

# Set up environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=1 \
    HOME=/opt/app-root/bin \
    PATH=/opt/app-root/bin:$PATH

# Switch to non-root user
USER 1001

# Set the working directory for runtime
WORKDIR /opt/app-root/bin

# Copy application code
COPY --chown=1001:0 . .

RUN ls -l /opt/app-root/bin

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /opt/app-root/src

# Expose the port the app will run on
EXPOSE 8888

# Command to run the application
CMD ["python3", "-m", "uvicorn", "docling_serve.app:create_app", "--factory", "--host", "0.0.0.0", "--port", "8888"]