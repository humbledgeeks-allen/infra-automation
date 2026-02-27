# infra-automation

A collection of automation scripts and operational runbooks for VMware, NetApp, Cisco, and Linux infrastructure management.

## Structure

| Folder | Description |
|--------|-------------|
| [VMware](./VMware) | PowerCLI scripts for ESXi, vCenter, vSAN, NSX, and vLab management |
| [NetApp](./NetApp) | PowerCLI scripts for ONTAP and StorageGRID |
| [Cisco](./Cisco) | Scripts for UCS |
| [Linux](./Linux) | Scripts for Ubuntu servers, Docker, and Synology NAS |
| [Ansible](./Ansible) | Ansible playbooks and roles for VMware, NetApp, and lab automation |

---

### VMware (PowerShell / PowerCLI)

| Subfolder | Description |
|-----------|-------------|
| [VMware/ESXi/Hardening](./VMware/ESXi/Hardening) | ESXi advanced settings hardening (V4 and V6h) |
| [VMware/ESXi/Host-Config](./VMware/ESXi/Host-Config) | Host configuration: NTP, DNS, networking, vSwitch, NFS/iSCSI vmk |
| [VMware/ESXi/NFS](./VMware/ESXi/NFS) | NFS best practices settings and NetApp VIB plugin installation |
| [VMware/vCenter](./VMware/vCenter) | VM deployment and lab restore scripts |
| [VMware/vCenter/vLab](./VMware/vCenter/vLab) | vLab management scripts (PowerShell + Node.js) |
| [VMware/vSAN](./VMware/vSAN) | vSAN automation (in progress) |
| [VMware/NSX](./VMware/NSX) | NSX automation (in progress) |

---

### Ansible

| Subfolder | Description |
|-----------|-------------|
| [Ansible/VMware/Humbled](./Ansible/VMware/Humbled) | HumbledGeeks ESXi, Storage, DC, and vCenter playbooks |
| [Ansible/VMware/HDC](./Ansible/VMware/HDC) | Hybrid Data Center ESXi configuration playbooks |
| [Ansible/NetApp/ONTAP-Learning](./Ansible/NetApp/ONTAP-Learning) | Step-by-step Ansible for NetApp ONTAP tutorial series (00–08) |
| [Ansible/NUCLab](./Ansible/NUCLab) | Full NUC lab automation: ESXi → DC → vCenter → ONTAP Select → Integration |
| [Ansible/LabBuilder](./Ansible/LabBuilder) | Multi-role lab builder with OVF deploy, ISO build, and inventory templates |

---

### NetApp (PowerShell)

| Subfolder | Description |
|-----------|-------------|
| [NetApp/ONTAP](./NetApp/ONTAP) | Cluster setup commands, NFS plugin installation, disk serial references |
| [NetApp/StorageGRID](./NetApp/StorageGRID) | StorageGRID automation (in progress) |

---

### Linux

| Subfolder | Description |
|-----------|-------------|
| [Linux/Ubuntu](./Linux/Ubuntu) | Ubuntu server setup, Docker installation, and Docker Compose configs |
| [Linux/Synology](./Linux/Synology) | Synology NAS backup and sync scripts |

## VS Code

Open this repo in VS Code — recommended extensions will be suggested automatically (`.vscode/extensions.json`). Key extensions: `redhat.ansible`, `ms-vscode.powershell`, `redhat.vscode-yaml`.

## Contributing

Place scripts in the appropriate subfolder and include inline comments describing purpose, author, and date.
