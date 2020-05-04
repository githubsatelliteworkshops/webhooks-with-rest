#!/usr/bin/env pwsh

echo "Copying .env.example to .env..."
Copy-Item -Path "$(pwd)\changelogger\.env.example" -Destination "$(pwd)\changelogger\.env"

echo "Building docker image..."
docker build -t changelogger .
