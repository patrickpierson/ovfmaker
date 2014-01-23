#!/bin/sh
#
# Copyright (C) 2013
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# This script will take in an export directory and print which vms are
# available for ovf-tar-gz-export. Then it will convert it to ovf for
# import into ovirt/rhev.  Execute from export directory containing vms.
#
#        master is at: https://github.com/ppiersonbt/ovfmaker
#
# check 1st argument for export directory
if [ "$1" == "" ]; then
        echo "------------------------------------------------------------------------------"
        echo "| An export directory must exist and be specified                            |"
        echo "| Please run again with:                                                     |"
        echo "| ./ovfmaker.sh /path/to/export/directory                                    |"
        echo "| Example:                                                                   |"
        echo "| ./ovfmaker.sh /var/lib/exports/export/f1dbf344-22dc-4642-bc2e-c02e725782bf |"
        echo "------------------------------------------------------------------------------"
        exit 1
fi

EXPORT_DIRECTORY=$1
# check 2nd argument for vmname in export directory;
#   if name does not exist, enumerate all vms available
if [ "$2" == "" ]; then
#get list of exported vms
        echo "--------------------------------------------------------------"
        echo "| List of available vms to package                           |"
        echo "--------------------------------------------------------------"
        sed -n 's_.*<Name>\(.*\)</Name>.*_\1_p' $EXPORT_DIRECTORY/master/vms/*/*.ovf
        echo
        echo "--------------------------------------------------------------"
        echo "| Re-run with ovfmasker.sh /path/to/export/directory vm_name |"
        echo "--------------------------------------------------------------"
        exit 1
fi

VM_NAME=$2
cd $EXPORT_DIRECTORY
#get location of ovf for specific vm
VM_OVF_LOC=$(grep -r1 "<Name>$VM_NAME</Name>" master/vms/* | cut -d ":" -f 1)
#get location of image
VM_IMG_LOC=$(sed 's/>/>\n/g' $VM_OVF_LOC | sed -n 's_.*File ovf:href="\(.*\)\" ovf:id.*_images/\1_p')
VM_IMG_LOC2=""
for f in $VM_IMG_LOC; do VM_IMG_LOC2="$VM_IMG_LOC2 $(dirname $f)"; done

echo "--------------------------------------------------------------"
echo "Saving $VM_NAME.ovf to /tmp/$VM_NAME.ovf"
echo "--------------------------------------------------------------"
#remove old $VM_NAME.ovf is exists
rm /tmp/$VM_NAME.ovf
tar czvf /tmp/$VM_NAME.ovf --directory=$EXPORT_DIRECTORY $VM_IMG_LOC2 $VM_OVF_LOC
echo "--------------------------------------------------------------"
echo "$VM_NAME.ovf has been created"
echo "--------------------------------------------------------------"
#
#        eoj
