# Updates

Unbloarchy and your packages are kept up to date via _Update > Unbloarchy_ in the Unbloarchy menu (`Super + Space`).

Unbloarchy itself is installed as regular pacman packages from the [upstream Omarchy package repository](https://github.com/omacom-io/omarchy-pkgs), so an update installs [the latest Unbloarchy source release](https://github.com/Magiclovekorean/unbloarchy/releases), runs any pending migrations to get your system in sync with it, and updates system packages from the [upstream Omarchy Arch mirror](https://github.com/omacom-io/omarchy-mirror) and [AUR](https://aur.archlinux.org/) (if you have installed any AUR packages). The package repository and mirror are upstream dependencies, not Unbloarchy-operated services.

When new releases are made, a circle arrow icon will appear to the right of your clock. Click it and the update process will start.

![update-available](images/update-available.webp)

### Four channels

Unbloarchy is updated along four channels: stable, RC, edge, and dev. New installations start on the stable channel, which tracks the [Unbloarchy releases](https://github.com/Magiclovekorean/unbloarchy/releases/), as well as the [upstream stable Omarchy Arch mirror](https://github.com/omacom-io/omarchy-mirror) that's running one month behind the latest, so we can catch any new incompatibilities that require config changes before they cause problems for people.

But if you'd like to help spot those potential issues, you can run on the edge channel. That'll keep your Unbloarchy packages tracking the latest development builds, and lets you update to the latest Arch packages as soon as they're available. You should only do this if you're experienced with Linux, and know how to recover a system that has problems.

Before any new major release, we'll do final validation using the RC channel. If you're interested in helping with final polishing, join the conversation in [Unbloarchy GitHub Discussions](https://github.com/Magiclovekorean/unbloarchy/discussions).

Finally, there's the dev channel, which links Unbloarchy directly to a git checkout of the source code in `~/unbloarchy`, combined with the edge packages. You should only use this channel if you're an experienced Linux user, working directly on Unbloarchy, and willing to tolerate breakage.

You can switch between channels using _Update > Channel_ from the Unbloarchy menu (or `unbloarchy-channel-set` in the terminal).

### Firmware updates

Your packages aren't the only thing that goes stale. Many laptops and peripherals ship BIOS, SSD, and dock firmware through the Linux Vendor Firmware Service, and _Update > Firmware_ in the Unbloarchy menu will fetch and install whatever your hardware has waiting. It installs `fwupd` the first time you run it. Plenty of firmware can only be written during a reboot, so don't be surprised to be asked for one.

### Warning about direct pacman/yay updates

If you're already familiar with Arch, you might be tempted to just run `pacman -Syu` or `yay -Syu` yourself, but if you do that, you'll miss the snapshot, migrations, and configuration updates that Unbloarchy runs together with new packages. That's why Unbloarchy will actually stop a direct system upgrade and point you to `unbloarchy update` instead. (If you really know what you're doing, the guard will tell you how to bypass it for a single transaction.)

### Rolling back bad updates

If you ever have a problem after doing an update, you can rollback your system to the snapshot taken before the update. Just restart and pick the snapshot in the boot loading menu from before you started the update.

![bootloader](images/bootloader.webp)

If somehow your configuration files have been corrupted, you can also perform an Unbloarchy reinstall using `unbloarchy reinstall` in the terminal. This will reinstall all the default Unbloarchy packages, put you on stable and downgrade any packages that are too new, and reset all the configuration files. Note that all your user config changes to the Unbloarchy defaults will be overwritten doing this!
