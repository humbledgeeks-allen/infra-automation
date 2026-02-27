# Ansible

Ansible playbooks and roles for automating VMware, NetApp, and lab infrastructure.

## Structure

| Folder | Description |
|--------|-------------|
| [VMware/Humbled](./VMware/Humbled) | HumbledGeeks ESXi, Storage, DC, and vCenter playbooks |
| [VMware/HDC](./VMware/HDC) | Hybrid Data Center ESXi playbooks (separate environment/vars) |
| [NetApp/ONTAP-Learning](./NetApp/ONTAP-Learning) | Step-by-step tutorial series: Ansible for NetApp ONTAP (00–08) |
| [NUCLab](./NUCLab) | Complete NUC lab automation suite (ESXi → DC → vCenter → ONTAP Select → Integration) |
| [LabBuilder](./LabBuilder) | Multi-role project for building full lab environments from ISO or OVF |

---

## VMware/Humbled

HumbledGeeks-authored playbooks for VMware environments.

| File | Description |
|------|-------------|
| `01_ESXi_Config.yml` | ESXi host configuration |
| `01_ESXi_Config_Single.yml` | Single-host ESXi configuration |
| `01_ESXi_Config_Inventory.yml` | ESXi config using inventory |
| `01_ESX_ADVC.yaml` | ESXi advanced settings |
| `01_ESXi_Storage.yaml` | ESXi storage configuration |
| `02_DC_Deploy.yml` | Deploy Domain Controller |
| `03_VC_Config.yml` | vCenter configuration |
| `hosts.ini` | Ansible inventory file |
| `vars.yml` | Shared variables |
| `vcenter-properties.yml` | vCenter connection properties |

## VMware/HDC

Hybrid Data Center VMware playbooks (different environment and variable set).

| File | Description |
|------|-------------|
| `01_ESXi_Config.yml` | ESXi host configuration for HDC environment |
| `vars.yml` | HDC-specific variables |

## NetApp/ONTAP-Learning

A numbered tutorial series for learning Ansible with NetApp ONTAP modules.

| Folder | Topic |
|--------|-------|
| `00-Lab Setup` | Lab environment preparation notes |
| `01-Install Ansible` | Ansible installation on CentOS |
| `02-Update NetApp Modules` | Updating NetApp Ansible modules |
| `03-understanding playbooks` | Sample playbook walkthrough |
| `04-First Playbook Example` | Create/delete ONTAP volumes |
| `05-Complete Workflow` | vServer and volume workflow |
| `06-Just the Facts` | Ansible facts and credentials |
| `07-Ansible Vault` | Encrypting secrets with Vault |
| `08-Ansible Roles for ONTAP` | Structured roles for ONTAP cluster setup |

## NUCLab

A complete end-to-end lab automation suite for NUC-based homelab environments.

| File | Description |
|------|-------------|
| `00_MainInstaller.yml` | Master playbook — runs all stages in sequence |
| `01_ESXi_Config.yml` | ESXi host configuration |
| `02_DC_Deploy.yml` / `02_DC_Config.yml` | Active Directory Domain Controller deploy and configure |
| `03_VC_Deploy.yml` / `03_VC_Config.yml` | vCenter Server deploy and configure |
| `04_OTS_Deploy.yml` / `04_OTS_Configure.yml` | ONTAP Select deploy and configure |
| `05_Integration.yml` | Integrate all components |
| `06_Portal.yml` | Portal/dashboard setup |
| `vars.yml` | Lab variables |
| `vcenter-properties.yml` | vCenter connection properties |

## LabBuilder

A comprehensive multi-role Ansible project for building full lab environments.

Supports deploying VMs from ISO (CentOS, Ubuntu, Windows, pfSense, Proxmox, XCP-ng) and from OVF (ESXi, vCenter, ONTAP Select, StorageGRID, vSim, AIQUM).

Key files: `main.yml`, `prep.yml`, `requirements.yml`, `inventories/`, `roles/`, `vars/`
