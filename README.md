# infra-automation

A collection of automation scripts and playbooks for VMware, NetApp, Cisco, and Linux infrastructure management. Scripts are organized by **technology domain** first, then by **tool** (PowerShell or Ansible) within each domain.

## Structure

| Folder | Description |
|--------|-------------|
| [VMware/](./VMware) | ESXi, vCenter, NSX, vSAN — PowerShell and Ansible |
| [NetApp/](./NetApp) | ONTAP and StorageGRID — PowerShell and Ansible |
| [NUCLab/](./NUCLab) | End-to-end NUC homelab builder — Ansible |
| [Linux/](./Linux) | Ubuntu and Synology — Shell scripts |
| [Cisco/](./Cisco) | UCS (placeholder) |

---

### VMware

| Subfolder | Tool | Description |
|-----------|------|-------------|
| [VMware/ESXi/PowerShell/Hardening](./VMware/ESXi/PowerShell/Hardening) | PowerShell | ESXi advanced settings hardening (V4 and V6h) |
| [VMware/ESXi/PowerShell/Host-Config](./VMware/ESXi/PowerShell/Host-Config) | PowerShell | Host configuration: NTP, DNS, networking, vSwitch, NFS/iSCSI vmk |
| [VMware/ESXi/PowerShell/NFS](./VMware/ESXi/PowerShell/NFS) | PowerShell | NFS best practices settings and NetApp VIB plugin installation |
| [VMware/ESXi/Ansible/Humbled](./VMware/ESXi/Ansible/Humbled) | Ansible | HumbledGeeks ESXi, Storage, DC, and vCenter playbooks |
| [VMware/ESXi/Ansible/HDC](./VMware/ESXi/Ansible/HDC) | Ansible | Hybrid Data Center ESXi configuration playbooks |
| [VMware/vCenter/PowerShell](./VMware/vCenter/PowerShell) | PowerShell | VM deployment and lab restore scripts |
| [VMware/vCenter/PowerShell/vLab](./VMware/vCenter/PowerShell/vLab) | PowerShell | vLab management suite (30+ scripts + Node.js portal) |
| [VMware/NSX](./VMware/NSX) | — | NSX automation (placeholder) |
| [VMware/vSAN](./VMware/vSAN) | — | vSAN automation (placeholder) |

---

### NetApp

| Subfolder | Tool | Description |
|-----------|------|-------------|
| [NetApp/ONTAP/PowerShell](./NetApp/ONTAP/PowerShell) | PowerShell | Cluster setup, NFS plugin installation, disk serial references |
| [NetApp/ONTAP/Ansible/ONTAP-Learning](./NetApp/ONTAP/Ansible/ONTAP-Learning) | Ansible | Step-by-step Ansible for NetApp ONTAP tutorial series (00–08) |
| [NetApp/StorageGRID](./NetApp/StorageGRID) | — | StorageGRID automation (placeholder) |

---

### NUCLab

| Subfolder | Tool | Description |
|-----------|------|-------------|
| [NUCLab/Ansible](./NUCLab/Ansible) | Ansible | Full NUC lab build: ESXi → DC → vCenter → ONTAP Select → Integration |

---

### Linux

| Subfolder | Tool | Description |
|-----------|------|-------------|
| [Linux/Ubuntu/Shell](./Linux/Ubuntu/Shell) | Shell | Ubuntu server setup, Docker installation, and Docker Compose configs |
| [Linux/Synology/Shell](./Linux/Synology/Shell) | Shell | Synology NAS backup and sync scripts |

---

## VS Code

Open this repo in VS Code — recommended extensions will be suggested automatically (`.vscode/extensions.json`). Key extensions: `redhat.ansible`, `ms-vscode.powershell`, `redhat.vscode-yaml`.

## Contributing

Place scripts in the appropriate `Technology/Component/Tool/` subfolder and include inline comments describing purpose, author, and date.
