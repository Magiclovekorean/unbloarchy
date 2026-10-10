# Security

Unbloarchy takes security extremely seriously. This is meant to be an operating system that you can use to do _Real Work_ in the _Real World_. Where losing a laptop can't lead to a security emergency. So here's what we do:

1. *Full-disk encryption is mandatory*: This is the most important step to securing the physical protection of your data. If your computer is lost or stolen, the data is fully encrypted using standard LUKS (Linux Unified Key Setup).
2. *Firewall is enabled by default*: All incoming traffic is blocked by default except for port 53317 for [LocalSend](https://localsend.org/). Even ssh is off until you turn it on via _Setup > Security > SSHD_, which opens port 22 (rate limited against brute force) as part of the setup. We even lock down Docker access using the [ufw-docker](https://github.com/chaifeng/ufw-docker) setup to prevent that your containers are accidentally exposed to the world.
3. *Arch always have the latest updates*: Arch, the underlying distro that Unbloarchy is built on, is a rolling distribution. This means that any security vulnerability that's discovered and patched in any package is quickly available for install using `unbloarchy-update`. You're always running the latest, most secure versions of everything that way.
4. *Packages come from Arch and upstream Omarchy*: The default install uses Arch's core/extra/multilib repositories and the Omarchy package repository and mirror, which Unbloarchy currently depends on. A few optional installs, such as third-party browsers, pull from the AUR; the base install does not.
5. *New USB devices require approval*: Unbloarchy trusts the USB devices present during installation, then blocks newly connected accessories until you approve them. This keeps an unknown accessory from reaching a matching kernel driver merely because it claims a supported device identity.
6. *Verify downloads*: Check ISO checksums and signatures against the release information from the project that published them. Unbloarchy currently depends on upstream Unbloarchy signing and package infrastructure; those services are operated by upstream, not by Unbloarchy.


## USB Device Authorization

USB device authorization is enabled by default. Unbloarchy uses USBGuard to trust the devices connected during installation and block USB devices it has not seen before. When a device is blocked, click the persistent notification and choose whether to allow it once, always allow it, or keep it blocked.

**Always allow this device** trusts the same device identity across USB ports and hubs, including after reboot. Changes to its identity still require approval. A hub may need its own approval before devices connected through it become available.

Older approvals can be tied to a port or hub. Run `unbloarchy-setup-security-usb-authorization --review-existing` to review connected devices and confirm which should be trusted on any port. Existing rules are preserved. For a disconnected device, reconnect it and choose **Always allow this device** if prompted.

On a preinstalled machine that asks you to create your account at first boot, USB protection starts at the end of that setup. It trusts the devices connected then, so your keyboard works throughout account setup even if it differs from the installer's keyboard.

You can turn the protection off from _Remove > Security > USB Device Authorization_. _Setup > Security > USB Device Authorization_ turns it back on with the existing trusted-device policy.

Only approve hardware you recognize. A malicious USB device can forge the manufacturer, model, serial number, and device class shown during review. Permanent approval is a convenience for accessories you control, not proof of the device's identity.

The policy protects devices connected after USBGuard starts during boot. It does not replace operating-system and driver security updates, and USB devices needed before the service starts, such as a keyboard used to unlock an encrypted disk, remain governed by the kernel's boot-time policy.

For machines whose disk unlock and recovery never depend on any USB devices, _Setup > Security > USB at Boot_ can extend the block to the beginning of kernel boot. Unbloarchy adds every currently connected device to USBGuard's trusted policy, sets `usbcore.authorized_default=0`, and updates current and Limine snapshot boot entries. The trusted policy applies only once USBGuard starts: even a trusted USB keyboard remains unavailable at an earlier encrypted-disk password prompt.

Older snapshots created before USBGuard was installed and enabled keep all USB disabled even after startup, including keyboards, network adapters, and storage. Trusting the devices connected now does not make them available in those snapshots. Enable boot-time protection only if you can unlock and recover the machine without any USB devices. _Remove > Security > USB at Boot_ restores the normal early-boot behavior while keeping USBGuard active after startup.

With Secure Boot enabled, changing USB boot protection requires access to your signing keys and enough free space on the system drive for a temporary copy of the boot files. If signing fails, Unbloarchy restores the previous boot files and settings. If an image uses a custom measured-boot policy or multiple boot profiles, rebuild it with its original signing setup before retrying.

## Changing your passwords

You have two passwords on an encrypted install: the one that unlocks the drive at boot, and the one you log in and `sudo` with. Both can be changed under _Update > Password_ in the Unbloarchy menu — _Drive Encryption_ for the first, _User_ for the second. Setup makes them the same. Changing the drive password asks for the current one first, so have it handy. If a change is interrupted, run _Drive Encryption_ again: it asks for the password that unlocks the drive now and finishes the change.

## Passing on a machine you've already used

If you're handing your machine over to someone else, you don't have to reinstall it. Run _Setup > Reset Computer_ in the Unbloarchy menu, type `reset` to confirm, and reboot. That wipes every user account and everything in `/home`, throws away all the packages and system changes you made since installation, and clears the machine's identity — network connections, host keys, and all. What comes back up is the setup wizard from the first boot, ready for its new owner to enter their own name, password, and encryption password.

It works by restoring the baseline snapshot the installer takes, so it's only available on machines installed from the Unbloarchy ISO. And on a drive without encryption, a reset is deletion rather than a secure erase, so if the data was sensitive, do a fresh install instead.

## Passwordless sudo

Sometimes you want `sudo` to stop asking, most often when an AI agent is doing a long stretch of system work for you. _Setup > Security > Passwordless Sudo_ asks how long to allow access: **15 minutes**, **1 Hour**, **1 Day**, or **Permanently**. A red warning icon appears beside the other menu bar indicators while access is active. Click it or run the command again to turn access off. You can also pass your own number of minutes (from 1 to 1440) with `unbloarchy-sudo-passwordless 30`, or use `unbloarchy-sudo-passwordless permanent`.

Timed access expires automatically, including immediately after resuming from a suspend that crossed the deadline. Restarting the computer ends it early. Permanent access survives reboots and stays enabled until you disable it.

Updating or removing Unbloarchy's settings package ends any temporary grant before its expiry support changes. If the command reports an authorization or cleanup error, resolve it before trying to enable another grant; an error does not mean passwordless access is inactive.

Be clear-eyed about this one: while it's on, anything running as your user can do anything as root without being asked. That's the whole point, and it's also the whole risk.

## Signing Keys

The upstream Omarchy signing key currently used for package and ISO signatures is `40DFB630FF42BCFFB047046CF0134EE680CAC571` ([verify it at OpenPGP.org](https://keys.openpgp.org/search?q=pkgs%40omarchy.org)). The upstream `omarchy-keyring` package contains the key. Unbloarchy has not established an independent signing-key infrastructure; verify each release using the checksum and signature information published by its distributor.

For upstream ISO releases, the detached signature is available by adding `.sig` to the ISO URL, for example `https://iso.omarchy.org/omarchy-x.x.x.iso.sig`. Upstream publishes the ISO under its own name, so the filename keeps the `omarchy-` prefix even when the contents come from a Unbloarchy release.


## Thunderbolt device authorization

Unbloarchy requires approval before connecting new Thunderbolt and USB4 PCIe accessories on controllers that support authorization. Devices connected during initial setup are trusted. New devices show a persistent notification with **Allow once**, **Always allow this device**, and **Keep blocked**. Trusted devices reconnect automatically, including while the screen is locked. IOMMU memory protection stays enabled; it does not count as consent to load a device's driver.

On controllers in secure mode, permanent approval also saves the accessory's authentication key. If a connected accessory has no saved key during initial setup, Unbloarchy defers Thunderbolt protection and keeps the previous Bolt behavior so your keyboard and storage remain usable. A **Finish Thunderbolt protection setup** notification explains how to continue: keep input available independently of Thunderbolt, safely disconnect the accessories, enable protection, then reconnect and approve each one. Losing a previously saved secure key requires a new explicit approval; Unbloarchy does not silently create a replacement key while restoring trusted devices.

_Setup > Security > Thunderbolt_ enables protection. _Remove > Security > Thunderbolt_ restores the previous Bolt behavior, which may automatically approve new devices when IOMMU protection is available. Re-enabling keeps your saved trust list. Unbloarchy never disconnects active storage when changing these settings.

When you remove protection, devices enrolled by Unbloarchy for permanent approval reconnect through Bolt's automatic policy, keeping their secure keys. Devices with a manual Bolt policy from before setup retain that policy. Bolt also resumes managing firmware boot allowlists for automatically approved devices. Keep all Thunderbolt controllers connected during removal so Unbloarchy can restore their settings if the change fails.

Firmware can authorize PCIe accessories before Linux runs. A controller configured with security mode `none` bypasses software approval; select user authorization or secure authorization in its firmware settings. Unbloarchy reports these limitations instead of claiming that the controller is protected. Existing firmware boot allowlists can also authorize devices early. USB accessories attached through a dock require separate USB authorization.

Approval does not repair a vulnerable driver. Device names and identifiers can be forged; secure connection keys are used where Bolt and the hardware support them.

_Setup > Security > Thunderbolt Boot_ can clear and verify supported firmware boot allowlists. It captures connected accessories for authorization after Linux starts, prevents Bolt from repopulating those allowlists from automatic device policies, and retains the previous lists for _Remove > Security > Thunderbolt Boot_. This option requires every controller to be connected and to expose a boot allowlist in `user` or `secure` mode. Other hardware needs firmware settings instead; Unbloarchy cannot verify those settings automatically.

Enable this only if you can unlock and recover without any Thunderbolt accessories. Even a trusted keyboard or disk may remain unavailable until the policy service starts. Older snapshots and other operating systems can restore their own firmware permissions. A failed change restores the previous settings when possible; an incomplete restoration retains recovery data. Reconnect the original controllers and run `unbloarchy setup security thunderbolt-boot recover` to retry that recovery.

If enabling or removing device authorization fails and reports incomplete restoration, run `unbloarchy setup security thunderbolt-authorization recover` before trying again. This restores the configuration and service state saved before that change.
