#!/usr/bin/env bash

# Script to set up SOPS keys for NixOS configuration

# Create the directory
mkdir -p ~/.config/sops/age/

# Check if the key file already exists
if [ -f ~/.config/sops/age/keys.txt ]; then
  echo "Key file already exists at ~/.config/sops/age/keys.txt"
  echo "To regenerate, remove the file first with: rm ~/.config/sops/age/keys.txt"
  exit 0
fi

# Generate a new key
echo "Generating new Age key pair..."
age-keygen -o ~/.config/sops/age/keys.txt

# Extract the public key to display
PUBLIC_KEY=$(grep -oP "public key: \K.*" ~/.config/sops/age/keys.txt)
echo ""
echo "Your public key is: $PUBLIC_KEY"
echo ""
echo "Add this public key to your .sops.yaml file with the following format:"
echo ""
echo "creation_rules:"
echo "  - path_regex: secrets/.*"
echo "    key_groups:"
echo "      - age:"
echo "        - $PUBLIC_KEY"
echo ""
echo "Then you can encrypt your secrets with:"
echo "sops --encrypt --in-place secrets/secrets.yaml"
echo ""
echo "Done! Your SOPS keys are now set up."