# servioticy-deployer

REQUIREMENTS:

* This folder and all its contents need to be accessible on all machines of the cluster following the same FS path.
* The servioticy repository (containing all files to be installed) needs to be populated before starting the installation process. It needs to be accessible in all machines of the cluster in the same FS path (possibly being replicated in different scratch folders)
* The installation path needs to be local to each machine (local disks), but accessible through the same FS path.
* The machine files MUST list IPs instead of hostnames
