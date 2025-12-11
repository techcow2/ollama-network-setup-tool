# Ollama LAN Exposer for Windows

This script is a **convenience tool** that automatically configures your Windows Ollama installation to be accessible by other devices on your local network (LAN or Wi-Fi).

## How to Use

1.  Save the script content as `expose_ollama.bat`.
2.  **Right-click** the file and select **Run as Administrator**. (Required for firewall changes).

## What It Does

The script performs the following tasks:

* Sets the necessary environment variable (`OLLAMA_HOST=0.0.0.0`) to listen on all network interfaces.
* Configures the Windows Firewall to allow incoming TCP traffic on the default Ollama port (`11434`).
* Attempts to stop and restart the Ollama application to apply the changes immediately.
* Displays your local IP address for easy connection by other devices.
* **Prompts the user to restart the PC** for guaranteed environment variable application.

## Important Note

Always run this script with **Administrator privileges**.
