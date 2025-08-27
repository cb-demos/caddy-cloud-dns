# Caddy with Google Cloud DNS Plugin

A custom Docker image of Caddy with the Google Cloud DNS plugin pre-installed for automatic SSL certificate provisioning via DNS-01 challenges.

## Features

- Based on official Caddy image
- Includes `github.com/caddy-dns/googleclouddns` plugin
- Multi-architecture support (amd64/arm64)
- Alpine Linux base for minimal size

## Usage

### Docker

```bash
docker run -d \
  --name caddy \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/Caddyfile:/etc/caddy/Caddyfile \
  -e GCP_PROJECT=your-project-id \
  cloudbeesdemo/caddy-cloud-dns:latest
```

### Docker Compose

```yaml
services:
  caddy:
    image: cloudbeesdemo/caddy-cloud-dns:latest
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
    environment:
      - GCP_PROJECT=your-project-id

volumes:
  caddy_data:
  caddy_config:
```

### Caddyfile Example

```
example.com {
  tls {
    dns googleclouddns {
      gcp_project your-project-id
    }
  }
  
  reverse_proxy localhost:8000
}
```

## Building

### Local Development
```bash
# Build locally
make build-local

# Build and push multi-arch
make build

# Test image
make test
```

### Automated Builds
This project uses GitHub Actions for automated building and publishing:

- **Push to main**: Builds and pushes `latest` and date-tagged versions
- **Pull requests**: Builds and tests (no push)
- **Manual trigger**: Can be triggered manually via GitHub UI

### Updating
When you need to update (probably every 6 months):
1. Push any change to main branch
2. GitHub Actions automatically builds and pushes both `latest` and today's date tag

Example: `cloudbeesdemo/caddy-cloud-dns:2025.08.27`

## Authentication

The Google Cloud DNS plugin uses Application Default Credentials. Ensure your container has access to GCP credentials through:

- Service account key file mounted as volume
- Metadata service (when running on GCE/GKE)
- Environment variables

