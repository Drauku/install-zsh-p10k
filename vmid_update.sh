#!/bin/bash

# Check first variable. If present, assign to oldVMID, else request user input
case $1 in
    ''|*[!0-9]*)
        echo "Enter the VMID to change: "
        read -r oldVMID
        ;;
    *[0-9]*)
        oldVMID="$1"
        ;;
esac

case $oldVMID in
    ''|*[!0-9]*)
        echo Bad input, exiting.
        exit
        ;;
    *)
        echo Old VMID - $oldVMID
        ;;
esac

# Check second variable. If present, assign to newVMID, else request user input
case $2 in
    ''|*[!0-9]*)
        echo
        echo "Enter the new VMID: "
        read -r newVMID
        ;;
    *[0-9]*)
        newVMID="$2"
        ;;
esac

case $newVMID in
    ''|*[!0-9]*)
        echo Bad input, exiting.
        exit
        ;;
    *)
        echo New VMID - $newVMID
        ;;
esac
echo

vgNAME="$(lvs --noheadings -o lv_name,vg_name | grep $oldVMID | awk -F ' ' '{print $2}' | uniq -d)"

case $vgNAME in
    "")
        echo Machine not in Volume Group, exiting.
        exit
        ;;
    *)
        echo Volume Group - $vgNAME
        ;;
esac

# for i in $(lvs -a|grep $vgNAME | awk '{print $1}' | grep $oldVMID);
# do lvrename $vgNAME/vm-$oldVMID-disk-"$(echo $i | awk '{print substr($0,length,1)}')" vm-$newVMID-disk-"$(echo $i | awk '{print substr($0,length,1)}')";
# done;
# sed -i "s/$oldVMID/$newVMID/g" /etc/pve/qemu-server/$oldVMID.conf;
# mv /etc/pve/qemu-server/$oldVMID.conf /etc/pve/qemu-server/$newVMID.conf;

echo "VMID update from \"$oldVMID\" to \"$newVMID\" complete!"