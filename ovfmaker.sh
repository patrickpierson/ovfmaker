#!/bin/sh
#This program will take in an export directory and print which vms are available for ovf-tar-gz-export
#Then it will convert it to ovf for import into ovirt/rhev

#get list of exported vms
#cat master/vms/*/*.ovf | grep '<Name>' | awk 'BEGIN { FS = "<Name>" } ; { print $2 }' | cut -d "<" -f 1

VM_NAME=$1
#get location of ovf for specific vm
VM_OVF_LOC=$(grep -r "$VM_NAME" master/vms/* | cut -d ":" -f 1)

VM_IMG_LOC=$(cat $VM_OVF_LOC | grep '<References><File ovf:href="' | cut -d '"' -f 2)
VM_FIN_IMG_LOC="images/$VM_IMG_LOC"

tar czvf /root/$VM_NAME.ovf $VM_FIN_IMG_LOC $VM_OVF_LOC
