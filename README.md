# Linux Homelab

A lightweight Ubuntu Server homelab built on repurposed laptop hardware to develop experience with Linux administration, networking, Docker, monitoring, automation, and troubleshooting.

The project is intentionally built on limited hardware to focus on practical infrastructure fundamentals.

## Current Setup

- Ubuntu Server 26.04 LTS
- Remote administration using OpenSSH
- SSH key-based authentication
- DHCP reservation for a stable LAN address
- UFW host firewall
- Docker Engine and Docker Compose
- Uptime Kuma for service monitoring
- Bash script for system health monitoring
- systemd service and timer automation
- SMART disk health monitoring
- Hardware temperature monitoring

## Architecture

```mermaid
flowchart TD
    Client[Admin Laptop]
    Router[Home Router]
    Server[Ubuntu Homelab Server]
    SSH[OpenSSH]
    Docker[Docker Engine]
    Kuma[Uptime Kuma]
    Timer[systemd Timer]
    Service[Health Check Service]
    Script[Bash Health Script]
    Journal[systemd Journal]

    Client -->|SSH| Server
    Router --> Server

    Server --> SSH
    Server --> Docker
    Docker --> Kuma

    Server --> Timer
    Timer --> Service
    Service --> Script
    Script --> Journal
