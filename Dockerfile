# Build stage - Use official Caddy builder with xcaddy
FROM caddy:2-builder AS builder

# Build Caddy with Google Cloud DNS plugin
RUN xcaddy build \
    --with github.com/caddy-dns/googleclouddns

# Final stage - Use minimal Caddy alpine image
FROM caddy:2-alpine

# Copy the custom-built Caddy binary from builder stage
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Health check for Caddy
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD caddy version || exit 1

# Default port
EXPOSE 80 443 2019

# Use the default Caddy entrypoint and command
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]