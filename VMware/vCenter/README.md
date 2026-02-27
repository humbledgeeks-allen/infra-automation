# VMware / vCenter

Automation scripts for vCenter Server operations and VM deployment.

## Structure

| Folder | Tool | Description |
|--------|------|-------------|
| [PowerShell/](./PowerShell) | PowerShell | VM deployment and lab restore scripts |
| [PowerShell/vLab](./PowerShell/vLab) | PowerShell | vLab management suite — clone, start, stop, catalog, dashboard |

## PowerShell

| File | Description |
|------|-------------|
| `DeployUbuntu.ps1` | Deploy Ubuntu Server VMs via vCenter |
| `Ubuntu_SRV_VM_Deploy.ps1` | Ubuntu Server VM deployment (alternate version) |
| `Restore_LAB_VMs.ps1` | Restore lab VMs from snapshot/backup |
| `vLab/` | Full vLab management tool (30+ scripts + Node.js portal) |
