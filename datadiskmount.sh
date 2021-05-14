#!/bin/bash
lsblk
echo "please enter the device full path (e.g /dev/sdb): "
read newdev
echo "Please enter the vgname : "
read vgnm
echo "Please enter the lvname : "
read lvnm
pvcreate "$newdev"
vgcreate "$vgnm" "$newdev"
pesize=$(pvdisplay $newdev | grep Total | tr -s " " | cut -d " " -f4)   
lvcreate -l "$pesize" -n "$lvnm" "$vgnm"
mkfs.ext4 /dev/"$vgnm"/"$lvnm"
echo -e "\n========== Here is the result for lvdisplay ========== \n"
lvdisplay
echo -e "\n\n"
sleep 1s
echo -e "========== Here is the result for vgdisplay ========== \n"
vgdisplay
echo -e "\n\n"
sleep 1s
echo -e "========== Here is the result for pvdisplay ========== \n"
pvdisplay
echo -e "\n ========================= FINISH ========================="
sleep 1s
echo -e "\n Please enter the absolute path of the mount point you desire to mount or create (e.g /home/user/dir1)"
read mntpnt
echo -e "\n Do you want to create this mount point? (y for creation/n for skipping this step)"
read ans
if [[ $ans == "y" ]]
    then
    echo -e "Creating the mount point $mntpnt \n"
    mkdir -p $mntpnt
    ls -lad $mntpnt
    sleep 2s
fi
echo -e "\n We are adding the mount point to the provided path"
echo -e "\n /dev/mapper/$vgnm-$lvnm      $mntpnt    ext4   defaults 0 0" >> /etc/fstab
mount -a
if [[ "$?" = "" ]]
    then
    echo "The mount point has been added"
    cat /etc/fstab
fi
echo -e "Here is the mount details \n"
df -h | tail -n 1
