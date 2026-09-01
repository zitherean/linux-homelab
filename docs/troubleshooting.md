# Troubleshooting Notes

This document records technical issues encountered while building the homelab and the diagnostic process used to resolve them.

## Ubuntu — No Bootable Device

### Symptoms

Ubuntu Server installation completed successfully, but the system displayed:

`No Bootable Device`

### Investigation

The disk contained a valid Ubuntu installation, suggesting that the problem was related to firmware boot configuration rather than installation failure.

### Root Cause

The Acer UEFI firmware had not registered the Ubuntu EFI bootloader as a trusted executable.

### Resolution

The Ubuntu `shimx64.efi` EFI executable was registered through the firmware interface and added to the boot order.

### Verification

The server subsequently booted normally into Ubuntu Server.

---

## Docker — Permission Denied

### Symptoms

Permission denied while trying to connect to the Docker API

### Investigation

Docker was running, but the current user did not have permission to access the Docker socket.

### Resolution

The account was added to the docker supplementary group:

`sudo usermod -aG docker <username>`

A new login session was started to load the updated group membership.

### Verification

`docker ps`

executed successfully without sudo.

---

## SMART Check — Permission Denied

### Symptoms

The automated health script could not access `/dev/sda`, while a manual SMART test using sudo worked.

### Root Cause

SMART device access requires elevated privileges.

### Resolution

The automated health-check systemd service executes the administrative script with the required permissions.

### Verification

The automated health script executed succesfully.

---
