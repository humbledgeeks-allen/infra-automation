# VMware / ESXi

Automation scripts and playbooks for ESXi host configuration and hardening.

## Structure

| Folder | Tool | Description |
|--------|------|-------------|
| [PowerShell/Hardening](./PowerShell/Hardening) | PowerShell | ESXi security hardening scripts (V4 and V6h) |
| [PowerShell/Host-Config](./PowerShell/Host-Config) | PowerShell | ESXi host configuration — NTP, DNS, networking, NFS, iSCSI |
| [PowerShell/NFS](./PowerShell/NFS) | PowerShell | NFS best practices and NetApp VIB installation |
| [Ansible/Humbled](./Ansible/Humbled) | Ansible | HumbledGeeks ESXi, Storage, DC, and vCenter playbooks |
| [Ansible/HDC](./Ansible/HDC) | Ansible | Hybrid Data Center ESXi playbooks (separate environment/vars) |

## PowerShell

See [PowerShell/README.md](./PowerShell/README.md) for detailed script descriptions.

**Quick reference:**
- `PowerShell/Hardening/ESXi_Hardening_V6h.ps1` — recommended hardening script (themed UI, KPI dashboard, verify+fallback)
- `PowerShell/Host-Config/configure_hosts_addon.ps1` — recommended multi-host config (CSV-driven, NFS active)
- `PowerShell/NFS/ESXI_NFS_BestPracticesV4.ps1` — NFS best practices script

## Ansible

- `Ansible/Humbled/` — full VMware playbook suite (ESXi config, storage, DC deploy, vCenter config)
- `Ansible/HDC/` — same environment pattern, different site vars
