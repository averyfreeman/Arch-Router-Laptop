# disk and snapper setup for router
set -v

# lsblk
# echo "which disk to use?"
# read TARGET
export TARGET="/dev/sdb"

echo "### INSTALLER SCRIPT IS NOT TESTED ###"
read -p "script is not ready to be run yet on its own."
echo "Copy and paste from it so you know what you're doing."
read -p "hit CTRL-C to cancel"
# echo "Disk and partition setup for thin lvm snapshots"
# echo "hit CTRL-C to cancel, enter to continue"
# read -p "this script will wipe ${TARGET} - are you OK with that?"

wipefs -a "${TARGET}"

sgdisk -Z "${TARGET}"
sgdisk -a "${TARGET}"

sgdisk -I -n 1:0:+2048M -t 1:ef00 -c 1:'BOOT_EFI' "${TARGET}"
sgdisk -I -n 2:0:0 -t 2:8300 -c 2:'LVM' "${TARGET}"

pvcreate "${TARGET}2"
vgcreate vg "${TARGET}2"
lvcreate -l 100%FREE -T vg/pool
lvcreate -V 160G  -T vg/root
lvcreate -V 16G  -T vg/swap

mkfs.msdos -F 32 -c 2 -n BOOT_EFI "${TARGET}1"
mkfs.ext4 -L "LVM" /dev/vg/root

mount /dev/vg/root /mnt

pacstrap /mnt base base-devel linux-lts linux-lts-headers \
				linux-firmware lvm2 thin-provisioning-tools snapper \
				firewalld hostapd 

# pacman -S lvm2 thin-provisioning-tools snapper \
#				hostapd firewalld

# if ! [[ -d /boot ]];
# 	then
# 		mkdir -p /boot
# 	else
# 	  mkdir -p /boot/EFI
# fi 

mount "${TARGET}1" /boot 

bootctl install

## end partitioning and filesystem, start snapper config ##

systemctl disable snapper-timeline.timer
systemctl enable snapper-boot.timer
systemctl enable snapper-cleanup.timer

snapper --no-dbus -c root create-config \
				--fstype="lvm(ext4)" /

snapper --no-dbus set-config \
				NUMBER_LIMIT=6 \
				NUMBER_LIMIT_IMPORTANT=3 \
				TIMELINE_CLEANUP=no \
				TIMELINE_CREATE=no \
				TIMELINE_LIMIT_DAILY=2 \
				TIMELINE_LIMIT_HOURLY=1 \
				TIMELINE_LIMIT_WEEKLY=3 \
				TIMELINE_LIMIT_MONTHLY=5 \
				TIMELINE_LIMIT_QUARTERLY=5 \
				TIMELINE_LIMIT_YEARLY=5

snapper --no-dbus list-configs

# snapper should take a snapshot on boot and make sure there's 