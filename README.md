# Arch Router Laptop Essentials
---

This is a collection of the most important config files to set up a barebones
router on Arch Linux.  I add the `laptop` part, because I set it up on an old
Thinkpad T520 I'd aleady repurposed as an Active Directory domain server for 
several years at my previous house. 

Actually, the configs are essentially distro-agnostic, but I used Arch.  Everything
here could be adapted for `NetworkManager` (replacing `systemd-networkd` and `hostapd`)
and run on one of those cool new immutable OS like [OpenSUSE Leap Micro](https://get.opensuse.org/leapmicro) to
ensure an even more resillient and hardened setup (I'm definitely trying that
eventually, but this has been working great, so not any time soon).

- Thin-lvm snapshot taken at boot. Limit 5 + 1 (current). Boots `ro`
- initrd set is `kernel-install` + `systemd-networkd` + `mkinitcpio` (KISS)
- Uses `systemd-networkd` for routing.  Includes linux bridge, `br0`, and `VLAN 201` tag for the phone/fiber WAN our provider Centurylink here in Seattle uses (not `ppp`). 
- `firewalld` + `networkd` are leveraged for basic filtering and `NAT` (`masquerade`).
- `hostapd` for `Intel AX201` wireless access point. 

Was really easy to set up and has been surprisingly more reliable than I ever imagined.
Going strong without issue since June of 2023! 
