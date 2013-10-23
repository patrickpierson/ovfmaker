ovfmaker is a simple script made for viewing an Ovirt/RHEV export directory, then once a vm name is chosen an ovf
is generated in the /tmp directory for movement to another Ovirt/RHEV cluster to be imported via the Ovirt/RHEV
image upload utilities.

run with ./ovfmaker /path/to/export/directory vm_name

image is saved to /tmp/vm_name.ovf
