# Traefik + Authentik Setup Guide

This guide explains how to set up your proxy stack with Traefik and Authentik for authentication.

## Initial Setup

After applying your NixOS configuration (`sudo nixos-rebuild switch`), you need to:

1. Set up your DNS records:
   - `lunau.xyz` → Your server IP
   - `auth.lunau.xyz` → Your server IP
   - `proxy.lunau.xyz` → Your server IP (for Traefik dashboard)
   - `dockge.lunau.xyz` → Your server IP
   - `bookmarks.lunau.xyz` → Your server IP

2. Generate a secure secret key for Authentik:
   ```bash
   openssl rand -base64 36
   ```

3. Edit the Authentik environment file:
   ```bash
   sudo nano /etc/authentik/env
   ```
   
   Replace the placeholder secret key with the one you generated:
   ```
   AUTHENTIK_SECRET_KEY=your_generated_key_here
   AUTHENTIK_ERROR_REPORTING__ENABLED=false
   ```

4. Start or restart the proxy stack:
   ```bash
   sudo systemctl restart proxy-stack
   ```

## Setting up Authentik

1. Access Authentik at `https://auth.lunau.xyz`

2. Follow the initial setup wizard:
   - Create an admin account
   - Set up your organization
   - Configure the recommended settings

3. After initial setup, create an Outpost for Traefik:
   - Navigate to Admin Interface → Outposts → Create
   - Name: Traefik
   - Type: Proxy
   - Integration: Authentik Embedded Outpost

4. Create an application to protect each service:
   - Navigate to Admin Interface → Applications → Create
   - Name: Dockge
   - Slug: dockge
   - Provider: Create a Forward Auth Provider
   - Authorization flow: default-authentication-flow
   - Save the application

5. Repeat this process for Karakeep (bookmarks) application

## Managing Your Services

- **Traefik Dashboard**: Access at `https://proxy.lunau.xyz` (protected by Authentik)
- **Dockge**: Access at `https://dockge.lunau.xyz` (protected by Authentik)
- **Karakeep Bookmarks**: Access at `https://bookmarks.lunau.xyz` (protected by Authentik)

## Troubleshooting

1. Check logs for the proxy stack:
   ```bash
   sudo docker logs traefik
   sudo docker logs authentik-server
   ```

2. If you need to restart individual services:
   ```bash
   sudo docker restart traefik
   sudo docker restart authentik-server
   ```

3. To view all running containers:
   ```bash
   sudo docker ps
   ```

4. If you need to completely rebuild the stack:
   ```bash
   sudo systemctl restart proxy-stack
   ```

## Adding New Services

To add new services to your proxy:

1. Add the service to your docker-compose.yml file
2. Configure Traefik labels similar to existing services
3. Create a new application in Authentik
4. Rebuild your NixOS configuration

This setup provides a secure, centralized authentication system for all your services using Traefik and Authentik.