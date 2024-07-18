# Arch Router Laptop Essentials
---

If you're curious about how this rather unique project came about, I've written at length about it here:  https://develmonk.com/2024/07/18/running-an-arch-linux-router-for-about-a-year/

This is a collection of the most important config files to set up a barebones router on Arch Linux.  I add the `laptop` part, because I set it up on an old Thinkpad T520 I'd repurposed as an Active Directory domain server several years prior. 

Actually, the configs are essentially distro-agnostic, but I like Arch, so I went with it.  I put it together because throughput was garbage using pfSense no matter what hardware I used for it.  Arch pushes 940Mbps (1Gbps line speed) without even breaking a sweat.  NICs are a Broadcom NetXtreme BCM57762 PCMCIA card and the built-in Intel 82574L

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

### The Future:
--- 

- Short-range plans include either forking the work they've been doing at OpenSUSE on rollback with `systemd-boot`, or forking `grub-btrfs`, as a solution like either of those would certainly be helpful for disaster recovery.

- Medium-term would be adapting the network config for `NetworkManager` (replacing `systemd-networkd` and likely `hostapd` through "internet sharing" feature) for many reasons, but one would be configuring through cockpit and the ease of transitioning to another OS eventually

- Long-term, I imagine I'll run one of those cool new immutable OS like [OpenSUSE Leap Micro](https://get.opensuse.org/leapmicro) etc. to ensure a more resillient and hardened system.  I've definitely got my eye on adapting it to [this immutability OS-meta project](https://github.com/ashos/ashos) already, mostly because then I wouldn't have to leave Arch (I love Arch)

I'm definitely trying all of these eventually, but the router's been working great, so not in any hurry.
