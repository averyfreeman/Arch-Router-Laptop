# Arch Router Laptop Essentials
---

This is a collection of the most important config files to set up a barebones router on Arch Linux.  I add the `laptop` part, because I set it up on an old Thinkpad T520 I'd repurposed as an Active Directory domain server several years prior. 

Actually, the configs are essentially distro-agnostic, but I like Arch, so I went with it.  

Everything here could be adapted for `NetworkManager` (replacing `systemd-networkd` and `hostapd`) and run on one of those cool new immutable OS like [OpenSUSE Leap Micro](https://get.opensuse.org/leapmicro) to ensure an even more resillient and hardened setup (I'm definitely trying that
eventually, but this has been working great, so not any time soon).

- Thin-lvm snapshot taken at boot. Limit 5 + 1 (current). Boots `ro`
- initrd set is `kernel-install` + `systemd-networkd` + `mkinitcpio` (KISS)
- Uses `systemd-networkd` for routing.  Includes linux bridge, `br0`, and `VLAN 201` tag for the phone/fiber WAN our provider Centurylink here in Seattle uses (not `ppp`). 
- `firewalld` + `networkd` are leveraged for basic filtering and `NAT` (`masquerade`).
- `hostapd` for `Intel AX201` wireless access point. 

Was really easy to set up and has been surprisingly more reliable than I ever imagined, working without issue since June of 2023.  Not bad for a rolling distro.

### Snapper settings:
---

I wanted to keep the number of snapshots to a minimum to avoid affecting performance, while still providing decent resiliency + rollback options.  

```
[root@router ~]# snapper get-config

Key                      │ Value
─────────────────────────┼──────────
ALLOW_GROUPS             │
ALLOW_USERS              │
BACKGROUND_COMPARISON    │ yes
EMPTY_PRE_POST_CLEANUP   │ yes
EMPTY_PRE_POST_MIN_AGE   │ 3600
FREE_LIMIT               │ 0.2
FSTYPE                   │ lvm(ext4)
NUMBER_CLEANUP           │ yes
NUMBER_LIMIT             │ 6
NUMBER_LIMIT_IMPORTANT   │ 3
NUMBER_MIN_AGE           │ 3600
QGROUP                   │
SPACE_LIMIT              │ 0.5
SUBVOLUME                │ /
SYNC_ACL                 │ no
TIMELINE_CLEANUP         │ no
TIMELINE_CREATE          │ no
TIMELINE_LIMIT_DAILY     │ 2
TIMELINE_LIMIT_HOURLY    │ 1
TIMELINE_LIMIT_MONTHLY   │ 5
TIMELINE_LIMIT_QUARTERLY │ 5
TIMELINE_LIMIT_WEEKLY    │ 3
TIMELINE_LIMIT_YEARLY    │ 5
TIMELINE_MIN_AGE         │ 3600
```

Will probably fork the work they've been doing at OpenSUSE on rollback through `systemd-boot` before I'd fork `grub-btrfs`, but a solution like either of those would certainly be helpful for disaster recovery.
