# Claude Context - infra-automation

## Project Purpose
This repository contains automation scripts and operational runbooks for VMware, NetApp, and Cisco infrastructure management.

## Owner
- **GitHub**: humbledgeeks-allen
- **Org**: humbledgeeks
- **Blog**: HumbledGeeks.com

## Tech Stack
- PowerShell (VMware, NetApp, Cisco scripts)
- Ansible (infrastructure automation)
- Python (utility scripts)

## Folder Structure
- `VMware/ESXi` - ESXi host management scripts
- `VMware/vCenter` - vCenter Server automation
- `VMware/vSAN` - vSAN cluster management
- `VMware/NSX` - NSX network virtualization
- `NetApp/ONTAP` - ONTAP storage management
- `NetApp/StorageGRID` - StorageGRID object storage
- `Cisco/UCS` - Cisco UCS compute automation

## Guidelines
- All scripts must include inline comments
- Include a header block in each script with: purpose, author, date, version
- Test scripts in lab before committing
- Do not commit credentials or sensitive data
