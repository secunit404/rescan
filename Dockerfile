FROM python:3.11-slim

# OCI labels for metadata
LABEL org.opencontainers.image.title="Rescan" \
      org.opencontainers.image.description="Plex media library scanner for missing files" \
      org.opencontainers.image.authors="secunit404" \
      org.opencontainers.image.url="https://github.com/secunit404/rescan" \
      org.opencontainers.image.source="https://github.com/secunit404/rescan" \
      org.opencontainers.image.licenses="MIT"

# Set default PUID and PGID
ENV PUID=1000 \
    PGID=1000

WORKDIR /app

# Install dependencies first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY rescan.py .
COPY config-example.ini .

# Create a volume mount point for config
VOLUME /app/config

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends gosu procps tzdata && \
    rm -rf /var/lib/apt/lists/*

# Create entrypoint script
COPY <<EOF /entrypoint.sh
#!/bin/sh
set -e

# Create user with specified PUID/PGID
groupadd -g \${PGID} rescan 2>/dev/null || true
useradd -u \${PUID} -g \${PGID} -m -s /bin/sh rescan 2>/dev/null || true

# Change ownership of app directory
chown -R \${PUID}:\${PGID} /app

# Execute as the specified user
exec gosu \${PUID}:\${PGID} python rescan.py
EOF

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"] 