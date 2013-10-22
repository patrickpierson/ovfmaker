#!/bin/sh
#This script will take in an export directory and print which vms are available for ovf-tar-gz-export
#Then it will convert it to ovf for import into ovirt/rhev.  Execute from export directory containing vms

if [ "$1" == "" ]; then
	#get list of exported vms
	echo "----------------------------------"
	echo "-List of available vms to package-"
	echo "----------------------------------"
	sed -n 's_.*<Name>\(.*\)</Name>.*_\1_p' master/vms/*/*.ovf
    	echo "----------------------------------"
	echo "-Re-run with ovfmasker.sh vm_name-"
    	echo "----------------------------------"

else VM_NAME=$1
	#get location of ovf for specific vm
	VM_OVF_LOC=$(grep -r "$VM_NAME" master/vms/* | cut -d ":" -f 1)
	#get location of image
	VM_IMG_LOC=$(cat $VM_OVF_LOC | grep '<References><File ovf:href="' | cut -d '"' -f 2)
	#add images to location of image
	VM_FIN_IMG_LOC="images/$VM_IMG_LOC"
	#convert to tgz and label as ovf
	echo "Saving $VM_NAME.ovf to /tmp/$VM_NAME.ovf"
	tar czvf /tmp/$VM_NAME.ovf $VM_FIN_IMG_LOC $VM_OVF_LOC
fi
