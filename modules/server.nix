{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    server = {
      immich = {
        enable = lib.mkEnableOption "Enable baremetal immich via nixpkgs";
      };
      vaultwarden = {
        enable = lib.mkEnableOption "Enable vaultwarden via nixpkgs";
      };
      proxy = {
        enable = lib.mkEnableOption "Enable traefik reverse proxy";
        domain = lib.mkOption {
          type = lib.types.str;
          default = "lunau.xyz";
          description = "Base domain for all services";
        };
      };
      dockge = {
        enable = lib.mkEnableOption "Enable Dockge container management";
        port = lib.mkOption {
          type = lib.types.port;
          default = 5001;
          description = "Port for Dockge service";
        };
      };
      karakeep = {
        enable = lib.mkEnableOption "Enable Karakeep bookmarks service";
        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "Port for Karakeep service";
        };
      };
    };
  };
  
  config = lib.mkMerge [
    # Basic service configuration
    {
      services.immich = lib.mkIf config.server.immich.enable {
        enable = true;
      };
      
      services.vaultwarden = lib.mkIf config.server.vaultwarden.enable {
        enable = true;
      };
      
      services.bitwarden-directory-connector-cli.domain = lib.mkIf config.server.vaultwarden.enable "vault.lunau.xyz";
    }
    
    # Proxy configuration
    (lib.mkIf config.server.proxy.enable {
      # Enable Docker
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };
      
      # Create the docker-compose file for Traefik, Authentik and services
      system.activationScripts.setupDocker = {
        text = ''
          mkdir -p /etc/docker-compose/proxy
          
          cat > /etc/docker-compose/proxy/docker-compose.yml << 'EOF'
          version: '3'

          networks:
            proxy:
              external: false

          services:
            traefik:
              image: traefik:latest
              container_name: traefik
              restart: unless-stopped
              security_opt:
                - no-new-privileges:true
              ports:
                - 80:80
                - 443:443
              volumes:
                - /etc/traefik:/etc/traefik
                - /var/run/docker.sock:/var/run/docker.sock:ro
              command:
                - --global.sendanonymoususage=false
                - --entrypoints.web.address=:80
                - --entrypoints.websecure.address=:443
                - --api.dashboard=true
                - --api.insecure=false
                - --log.level=INFO
                - --providers.docker=true
                - --providers.docker.exposedbydefault=false
                - --providers.file.directory=/etc/traefik
                - --providers.file.watch=true
                - --entrypoints.web.http.redirections.entrypoint.to=websecure
                - --entrypoints.web.http.redirections.entrypoint.scheme=https
                - --certificatesresolvers.letsencrypt.acme.tlschallenge=true
                - --certificatesresolvers.letsencrypt.acme.email=admin@${config.server.proxy.domain}
                - --certificatesresolvers.letsencrypt.acme.storage=/etc/traefik/acme.json
              networks:
                - proxy
              labels:
                - traefik.enable=true
                - traefik.http.routers.traefik.rule=Host(`proxy.${config.server.proxy.domain}`)
                - traefik.http.routers.traefik.entrypoints=websecure
                - traefik.http.routers.traefik.service=api@internal
                - traefik.http.routers.traefik.tls.certresolver=letsencrypt
                - traefik.http.routers.traefik.middlewares=authentik@file
            
            # PostgreSQL for Authentik
            postgres:
              image: postgres:13
              container_name: postgres
              restart: unless-stopped
              environment:
                POSTGRES_PASSWORD: authentik_postgres
                POSTGRES_USER: authentik
                POSTGRES_DB: authentik
              volumes:
                - postgres_data:/var/lib/postgresql/data
              networks:
                - proxy
              healthcheck:
                test: ["CMD-SHELL", "pg_isready -U authentik"]
                start_period: 20s
                interval: 30s
                retries: 5
                timeout: 5s
            
            # Redis for Authentik
            redis:
              image: redis:alpine
              container_name: redis
              restart: unless-stopped
              command: --save 60 1 --loglevel warning
              volumes:
                - redis_data:/data
              networks:
                - proxy
              healthcheck:
                test: ["CMD-SHELL", "redis-cli ping | grep PONG"]
                interval: 10s
                timeout: 3s
                retries: 3
            
            # Authentik Server
            authentik-server:
              image: ghcr.io/goauthentik/server:2025.4.1
              container_name: authentik-server
              restart: unless-stopped
              command: server
              environment:
                AUTHENTIK_REDIS__HOST: redis
                AUTHENTIK_POSTGRESQL__HOST: postgres
                AUTHENTIK_POSTGRESQL__USER: authentik
                AUTHENTIK_POSTGRESQL__NAME: authentik
                AUTHENTIK_POSTGRESQL__PASSWORD: authentik_postgres
              env_file:
                - /etc/authentik/env
              volumes:
                - authentik_media:/media
                - authentik_templates:/templates
              networks:
                - proxy
              depends_on:
                - postgres
                - redis
              labels:
                - traefik.enable=true
                - traefik.http.routers.authentik.rule=Host(`auth.${config.server.proxy.domain}`)
                - traefik.http.routers.authentik.entrypoints=websecure
                - traefik.http.routers.authentik.tls.certresolver=letsencrypt
                - traefik.http.services.authentik.loadbalancer.server.port=9000
            
            # Authentik Worker
            authentik-worker:
              image: ghcr.io/goauthentik/server:2025.4.1
              container_name: authentik-worker
              restart: unless-stopped
              command: worker
              environment:
                AUTHENTIK_REDIS__HOST: redis
                AUTHENTIK_POSTGRESQL__HOST: postgres
                AUTHENTIK_POSTGRESQL__USER: authentik
                AUTHENTIK_POSTGRESQL__NAME: authentik
                AUTHENTIK_POSTGRESQL__PASSWORD: authentik_postgres
              env_file:
                - /etc/authentik/env
              volumes:
                - authentik_media:/media
                - authentik_templates:/templates
              networks:
                - proxy
              depends_on:
                - postgres
                - redis
                - authentik-server
            
            # Dockge service - container management UI
            dockge:
              image: louislam/dockge:latest
              container_name: dockge
              restart: unless-stopped
              volumes:
                - /var/run/docker.sock:/var/run/docker.sock
                - dockge_data:/app/data
                - dockge_stacks:/app/stacks
              networks:
                - proxy
              labels:
                - traefik.enable=true
                - traefik.http.routers.dockge.rule=Host(`dockge.${config.server.proxy.domain}`)
                - traefik.http.routers.dockge.entrypoints=websecure
                - traefik.http.routers.dockge.tls.certresolver=letsencrypt
                - traefik.http.services.dockge.loadbalancer.server.port=5001
                - traefik.http.routers.dockge.middlewares=authentik@file
            
            # Karakeep bookmarks service
            karakeep:
              image: ghcr.io/ioki/karakeep:latest
              container_name: karakeep
              restart: unless-stopped
              volumes:
                - karakeep_data:/app/data
              networks:
                - proxy
              labels:
                - traefik.enable=true
                - traefik.http.routers.karakeep.rule=Host(`bookmarks.${config.server.proxy.domain}`)
                - traefik.http.routers.karakeep.entrypoints=websecure
                - traefik.http.routers.karakeep.tls.certresolver=letsencrypt
                - traefik.http.services.karakeep.loadbalancer.server.port=3000
                - traefik.http.routers.karakeep.middlewares=authentik@file

          volumes:
            postgres_data:
            redis_data:
            authentik_media:
            authentik_templates:
            dockge_data:
            dockge_stacks:
            karakeep_data:
          EOF
          
          # Create Traefik config directory and files
          mkdir -p /etc/traefik
          
          # Create Authentik middleware configuration
          cat > /etc/traefik/authentik.toml << 'EOF'
          [http.middlewares]
            [http.middlewares.authentik.forwardAuth]
              address = "http://authentik-server:9000/outpost.goauthentik.io/auth/traefik"
              trustForwardHeader = true
              authResponseHeaders = [
                "X-Authentik-Username",
                "X-Authentik-Groups",
                "X-Authentik-Email",
                "X-Authentik-Name",
                "X-Authentik-Uid"
              ]
          EOF
          
          # Create Authentik env directory and sample file if it doesn't exist
          mkdir -p /etc/authentik
          
          if [ ! -f /etc/authentik/env ]; then
            echo "# Generate a key with: openssl rand -base64 36" > /etc/authentik/env
            echo "AUTHENTIK_SECRET_KEY=CHANGE_THIS_KEY_BEFORE_STARTING" >> /etc/authentik/env
            echo "AUTHENTIK_ERROR_REPORTING__ENABLED=false" >> /etc/authentik/env
            chmod 600 /etc/authentik/env
          fi
        '';
      };
      
      # Create systemd service to manage the Docker Compose stack
      systemd.services.proxy-stack = {
        description = "Proxy stack with Traefik, Authentik, and services";
        wantedBy = [ "multi-user.target" ];
        requires = [ "docker.service" ];
        after = [ "docker.service" ];
        
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "/etc/docker-compose/proxy";
          ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
          ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
          TimeoutStartSec = "0";
        };
      };
      
      # Open firewall ports
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    })
  ];
}
