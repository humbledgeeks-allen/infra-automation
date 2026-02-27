# VMware/ESXi

PowerCLI automation scripts for ESXi host configuration, hardening, and storage setup.

## Structure

| Folder | Description |
|--------|-------------|
| [Hardening](./Hardening) | Apply recommended security advanced settings to ESXi hosts |
| [Host-Config](./Host-Config) | Configure NTP, DNS, vSwitches, VLANs, vmkernel adapters, NFS/iSCSI |
| [NFS](./NFS) | NetApp NFS best practices settings and VIB plugin installation |

## Hardening

| File | Description |
|------|-------------|
| `ESXi_Hardening_V4.ps1` | V4 – menu-driven, dry-run mode, CSV/vCenter/standalone input, HTML report |
| `ESXi_Hardening_V6h.ps1` | V6h – improved version with themed UI, KPI dashboard, per-setting overrides, set+verify+fallback reliability |

`V6h` is the recommended version for new deployments.

## Host-Config

| File | Description |
|------|-------------|
| `Configure_ESX_Hosts.ps1` | Single-host configuration: NTP, DNS, hardening settings, NFS best practices, vSwitch/port group setup, NFS datastore attach |
| `configure_hosts.ps1` | CSV-driven multi-host version of the above (NFS datastore attachment commented out) |
| `configure_hosts_addon.ps1` | CSV-driven multi-host version with NFS datastore attachment and scratch location active |
| `ESXConfiguration.ps1` | HPE cluster configuration with vDS migration (legacy, 2019) |
| `EnableSSH.ps1` | Enable SSH service on ESXi hosts |
| `data/` | CSV input files for multi-host scripts (`configure_hosts.csv`, `configure_hosts1.csv`, `configure_lab_hosts.csv`) |

## NFS

| File | Description |
|------|-------------|
| `ESXI_NFS_BestPracticesV4.ps1` | Apply NetApp NFS best practice advanced settings (heap, queue depth, heartbeat) |
| `NetAppVIB_Installation.ps1` | Install the NetApp NAS VAAI plugin VIB on ESXi hosts |
| `NetAppNasPlugin_2.0.1-16.vib` | NetApp NAS plugin binary (place on NFS datastore before running install script) |
