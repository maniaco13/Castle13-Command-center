# Castle 13 Command Ops

A modular, PowerShell-based Command Line Interface designed for managing local infrastructure, WSL environments, and offline AI models. 

## Architecture
- **Core Engine:** Handles global UI themes, navigation, and module routing.
- **Squads:** Independent PowerShell scripts loaded dynamically by the engine. Categorized by System, DevTools, Network, and Security.

## Hardware Stack Integration
Designed to interface with:
- Dell Optiplex 7020 Tower Plus (Proxmox Node)
- HP Elite (Proxmox Node)
- Supermicro X11DPL-i w/ Tesla P40 (Zenith-Beats Host)
- Localhost (Docker / WSL / Ollama)
