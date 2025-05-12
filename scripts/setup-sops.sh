#!/usr/bin/env bash
# Script to set up sops-nix with age for secret management

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up sops-nix with age encryption...${NC}"

# Create directory for age keys
KEYS_DIR="$HOME/.config/sops/age"
if [ ! -d "$KEYS_DIR" ]; then
  echo -e "${BLUE}Creating age keys directory...${NC}"
  mkdir -p "$KEYS_DIR"
fi

# Generate age key if it doesn't exist
KEY_FILE="$KEYS_DIR/keys.txt"
if [ ! -f "$KEY_FILE" ]; then
  echo -e "${BLUE}Generating new age key...${NC}"
  age-keygen -o "$KEY_FILE"
  chmod 600 "$KEY_FILE"
  echo -e "${GREEN}Age key generated at $KEY_FILE${NC}"
else
  echo -e "${GREEN}Age key already exists at $KEY_FILE${NC}"
fi

# Extract public key for .sops.yaml configuration
PUBLIC_KEY=$(age-keygen -y "$KEY_FILE")
echo -e "${BLUE}Your public key:${NC} $PUBLIC_KEY"

# Create .sops.yaml configuration file in the project root
SOPS_CONFIG_FILE="$(git rev-parse --show-toplevel)/.sops.yaml"
cat > "$SOPS_CONFIG_FILE" << EOF
creation_rules:
  - path_regex: secrets/.*\.yaml$
    age: ${PUBLIC_KEY}
EOF

echo -e "${GREEN}Created sops configuration at $SOPS_CONFIG_FILE${NC}"

# Create example secrets.yaml file if it doesn't exist
SECRETS_DIR="$(git rev-parse --show-toplevel)/secrets"
SECRETS_FILE="$SECRETS_DIR/secrets.yaml"

if [ ! -f "$SECRETS_FILE" ]; then
  echo -e "${BLUE}Creating example secrets file...${NC}"
  mkdir -p "$SECRETS_DIR"
  
  # Create unencrypted example first
  cat > "$SECRETS_FILE.plain" << EOF
# NixOS secrets - will be encrypted with sops
tailscale:
  authkey: "tskey-auth-YOUR_TAILSCALE_KEY"

ssh:
  id_ed25519: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    Replace with your actual private key
    -----END OPENSSH PRIVATE KEY-----
  
  known_hosts: |
    Replace with your known_hosts file content
    
network:
  wifi_networks: |
    {
      "home_network": {
        "ssid": "your_home_wifi",
        "psk": "your_wifi_password"
      },
      "work_network": {
        "ssid": "your_work_wifi",
        "psk": "your_work_wifi_password"
      }
    }
EOF
  
  # Encrypt the file with sops
  echo -e "${BLUE}Encrypting secrets file...${NC}"
  sops --encrypt --in-place "$SECRETS_FILE.plain"
  mv "$SECRETS_FILE.plain" "$SECRETS_FILE"
  
  echo -e "${GREEN}Created encrypted secrets file at $SECRETS_FILE${NC}"
  echo -e "${RED}IMPORTANT: Edit this file with real secrets using 'sops $SECRETS_FILE'${NC}"
else
  echo -e "${GREEN}Secrets file already exists at $SECRETS_FILE${NC}"
  echo -e "${BLUE}To edit existing secrets, run:${NC} sops $SECRETS_FILE"
fi

echo -e "\n${GREEN}sops-nix setup complete!${NC}"
echo -e "${BLUE}To use in your NixOS configuration:${NC}"
echo -e "1. Ensure 'secrets.enable = true;' is set in your machine config"
echo -e "2. Access secrets using config.sops.secrets.\"path/to/secret\".path"
echo -e "3. Edit secrets with:${NC} sops $SECRETS_FILE"