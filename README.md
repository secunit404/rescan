<div align="center">
  <a href="https://github.com/secunit404/rescan">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="assets/logo.png" width="400">
      <img alt="rescan" src="assets/logo.png" width="400">
    </picture>
  </a>
</div>

<div align="center">
  <a href="https://github.com/secunit404/rescan/stargazers"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/secunit404/rescan?label=Rescan"></a>
  <a href="https://github.com/secunit404/rescan/issues"><img alt="Issues" src="https://img.shields.io/github/issues/secunit404/rescan" /></a>
  <a href="https://github.com/secunit404/rescan/blob/master/LICENSE"><img alt="License" src="https://img.shields.io/github/license/secunit404/rescan"></a>
  <a href="https://github.com/secunit404/rescan/graphs/contributors"><img alt="Contributors" src="https://img.shields.io/github/contributors/secunit404/rescan" /></a>
</div>

<div align="center">
  <p>Keep your Plex libraries in sync with your media files.</p>
</div>

# Rescan

Scan your Plex media libraries for missing files and triggers rescans when needed.<br/>
This is a good once over in case your autoscan tool misses an import or an upgrade from your *arr<br/> 
It can also provide Discord notification summaries.<br/>

<img alt="rescan" src="assets/discord.png" width="400">

## Features

- Scans specified directories for media files
- Checks if files exist in Plex libraries
- Triggers Plex rescans for missing items
- Sends Discord notifications with detailed summaries
- Supports both movie and TV show libraries
- Configurable scan intervals and behavior
- Docker support for easy deployment

## Prerequisites

- Python 3.11 or higher
- Plex Media Server
- Discord webhook URL (for notifications)

## Installation

### Docker (Recommended)

#### Option 1: Use Pre-built Image
```bash
# Create config directory
mkdir -p /opt/rescan

# Copy example config
docker run --rm ghcr.io/secunit404/rescan:latest cat /app/config-example.ini > /opt/rescan/config.ini

# Edit config with your settings
nano /opt/rescan/config.ini

# Run with docker compose
docker compose up -d
```

#### Option 2: Build Locally
1. Clone the repository:
```bash
git clone https://github.com/secunit404/rescan.git
cd rescan
```

2. Copy the example config:
```bash
cp config-example.ini config.ini
```

3. Edit `config.ini` with your settings:
```ini
[plex]
server = http://localhost:32400
token = your_plex_token_here

[scan]
directories = /path/to/your/media/folder

[behaviour]
scan_interval = 5
run_interval = 24
symlink_check = true

[notifications]
enabled = false
discord_webhook_url = your_discord_webhook_url_here
```

4. Run with Docker Compose:
```bash
docker-compose up -d
```

### Using Docker Compose

Create a `docker-compose.yml`:
```yaml
services:
  rescan:
    image: ghcr.io/secunit404/rescan:latest
    container_name: rescan
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=UTC
    volumes:
      - /opt/rescan:/app/config
      - /mnt:/mnt  # Your media directory
```

Then run:
```bash
docker compose up -d
```

## Configuration

All configuration is done via `/opt/rescan/config.ini` (or wherever you mount `/app/config`).

### Plex Settings
- `server`: Your Plex server URL (e.g., http://localhost:32400)
- `token`: Your Plex authentication token ([How to find your token](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/))

### Scan Settings
- `directories`: Comma-separated list of directories to scan
- `scan_interval`: Seconds to wait between Plex rescans (default: 5)
- `run_interval`: Hours between full scans (default: 24)
- `symlink_check`: Enable/disable broken symlink detection (default: false)

### Notification Settings
- `enabled`: Enable/disable Discord notifications (default: false)
- `discord_webhook_url`: Your Discord webhook URL
- `logfile`: Optional log file path (e.g., `/app/config/rescan.log`)

### Environment Variables
- `PUID`: User ID for file permissions (default: 1000)
- `PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: UTC)

## Discord Notifications

The script sends detailed notifications to Discord including:
- Overview of missing items
- Library-specific statistics
- Broken symlinks (if enabled)
- Errors and warnings

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Forked from [Pukabyte/rescan](https://github.com/Pukabyte/rescan) with the following improvements:
- Docker-first architecture with multi-platform support (amd64/arm64)
- GitHub Actions for automated builds
- PUID/PGID support for proper file permissions
- Health checks and graceful shutdown handling
- Better error handling and configuration validation
- Timezone support via environment variable

## Acknowledgments

- [PlexAPI](https://github.com/pkkid/python-plexapi) for Plex server interaction
- [Discord.py](https://github.com/Rapptz/discord.py) for Discord webhook support
- Original author: [Pukabyte](https://github.com/Pukabyte) 