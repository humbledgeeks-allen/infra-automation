# infra-automation

A collection of automation scripts and operational runbooks for VMware, NetApp, and Cisco infrastructure management.

## Structure

| Folder | Description |
|--------|-------------|
| [VMware](./VMware) | Scripts for ESXi, vCenter, vSAN, and NSX |
| [NetApp](./NetApp) | Scripts for ONTAP and StorageGRID |
| [Cisco](./Cisco) | Scripts for UCS |
| [Linux](./Linux) | Scripts for Ubuntu servers, Docker, and Synology NAS |

### VMware

| Subfolder | Description |
|-----------|-------------|
| [VMware/ESXi/Hardening](./VMware/ESXi/Hardening) | ESXi advanced settings hardening (V4 and V6h) |
| [VMware/ESXi/Host-Config](./VMware/ESXi/Host-Config) | Host configuration: NTP, DNS, networking, vSwitch, NFS/iSCSI vmk |
| [VMware/ESXi/Host-Config/data](./VMware/ESXi/Host-Config/data) | CSV input files used by multi-host configuration scripts |
| [VMware/ESXi/NFS](./VMware/ESXi/NFS) | NFS best practices, NetApp VIB installation and binary |
| [VMware/vCenter](./VMware/vCenter) | VM deployment and lab restore scripts |
| [VMware/vSAN](./VMware/vSAN) | vSAN automation (in progress) |
| [VMware/NSX](./VMware/NSX) | NSX automation (in progress) |

### NetApp

| Subfolder | Description |
|-----------|-------------|
| [NetApp/ONTAP](./NetApp/ONTAP) | Cluster setup commands, NFS plugin installation, disk serial references |
| [NetApp/StorageGRID](./NetApp/StorageGRID) | StorageGRID automation (in progress) |

### Linux

| Subfolder | Description |
|-----------|-------------|
| [Linux/Ubuntu](./Linux/Ubuntu) | Ubuntu server setup, Docker installation, and Docker Compose configs |
| [Linux/Synology](./Linux/Synology) | Synology NAS backup and sync scripts |

## Contributing

Please place scripts in the appropriate subfolder and include inline comments describing what each script does.
