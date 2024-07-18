# snapper setup for router

wipefs -a /dev/sdb
sgdisk -Z /dev/sdb
sgdisk -a /dev/sdb



pvcreate /dev/sdb3
vgcreate vg /dev/sdb3
lvcreate -l 100%FREE -T vg/pool
lvcreate -V 160G  -T vg/root
lvcreate -V 16G  -T vg/swap

mkfs.ext4 /dev/vg/root

pacman -S lvm2 thin-provisioning-tools snapper

systemctl disable snapper-timeline.timer
systemctl enable snapper-boot.timer
systemctl enable snapper-cleanup.timer

snapper --no-dbus -c root create-config --fstype="lvm(ext4)" /

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

# snapper should take a snapshot on boot and make sure there's 