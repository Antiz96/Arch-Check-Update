# Arch-Update

<p align="center">
  <img width="460" height="300" src="https://github.com/Antiz96/arch-update/assets/53110319/e2374a41-a3e9-43bf-9b12-54f53d18a320">
</p>

[![lang-fr](https://img.shields.io/badge/lang-fr-blue.svg)](https://github.com/Antiz96/arch-update/blob/main/README-fr.md)

## Table of contents

- [Description](#description)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Tips and tricks](#tips-and-tricks)
- [Contributing](#contributing)

## Description

An update notifier/applier for Arch Linux that assists you with important pre/post update tasks and that includes a clickeable systray applet for an easy integration with any panel on any DE/WM.  
Optional support for AUR/Flatpak packages updates and desktop notifications.

Features:

- Includes a clickeable systray applet that dynamically changes to act as an update notifier/applier. Easy to integrate with any panel on any DE/WM.
- Automatic check and listing of every packages available for update.
- Offers to display the latest Arch Linux news before applying updates.
- Automatic check and listing of orphan packages and offers to remove them.
- Automatic check for old and/or uninstalled cached packages and offers to remove them.
- Lists and helps you processing pacnew/pacsave files.
- Automatic check for pending kernel updates requiring a reboot to be applied and offers to do so if there's one.
- Support for both `sudo` and `doas`.
- Optional support for AUR packages (through `yay` or `paru`).
- Optional support for Flatpak packages.
- Optional support for desktop notifications on new available updates.

## Installation

### AUR

Install the [arch-update](https://aur.archlinux.org/packages/arch-update "arch-update AUR package") AUR package.  
Also check [the list of optional dependencies](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=arch-update#n11) you might need or want.

### From Source

Install required dependencies:

```bash
sudo pacman -S --needed pacman-contrib curl htmlq diffutils hicolor-icon-theme python python-pyqt6 qt6-svg glib2
```

Additional optional dependencies you might need or want:

- [yay](https://aur.archlinux.org/packages/yay): AUR Packages support
- [paru](https://aur.archlinux.org/packages/paru): AUR Packages support
- [flatpak](https://archlinux.org/packages/extra/x86_64/flatpak/): Flatpak Packages support
- [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/): Desktop notifications support on new available updates (see <https://wiki.archlinux.org/title/Desktop_notifications>)
- [vim](https://archlinux.org/packages/extra/x86_64/vim/): Default merge program for pacdiff
- [qt6-wayland](https://archlinux.org/packages/extra/x86_64/qt6-wayland/): Systray applet support on Wayland

Download the archive of the [latest stable release](https://github.com/Antiz96/arch-update/releases/latest) and extract it *(alternatively, you can clone this repository via `git clone`)*.

To install `arch-update`, go into the extracted/cloned directory and run the following command:

```bash
sudo make install
```

To uninstall `arch-update`, go into the extracted/cloned directory and run the following command:

```bash
sudo make uninstall
```

## Usage

The usage consist of starting [the systray applet](#the-systray-applet) and enabling [the systemd timer](#the-systemd-timer).

### The systray applet

To start the systray applet automatically at boot, add the `arch-update --tray` command to your auto-start commands/WM config or start/enable the associated systemd service like so:

```bash
systemctl --user enable --now arch-update-tray.service
```

The systray icon will automatically change depending on the current state of your system ('up to date' or 'updates available'). When clicked, it launches `arch-update` via the [arch-update.desktop file](https://github.com/Antiz96/arch-update/blob/main/res/desktop/arch-update.desktop).

The systray applet attempts to read the `arch-update.desktop` file at the below paths and in the following order:

- `$XDG_DATA_HOME/applications/arch-update.desktop`
- `$HOME/.local/share/applications/arch-update.desktop`
- `$XDG_DATA_DIRS/applications/arch-update.desktop`
- `/usr/local/share/applications/arch-update.desktop` <-- Default installation path when installing Arch-Update [from source](#from-source)
- `/usr/share/applications/arch-update.desktop` <-- Default installation path when installing Arch-Update [from the AUR](#AUR)

In case you want/need to customize the `arch-update.desktop` file, copy it in a path that has a higher priority than the default installation path and modify it there (to ensure that your custom `arch-update.desktop` file supersedes the default one and that your modifications are not being overwritten on updates).

### The systemd timer

There is a systemd service (in `/usr/lib/systemd/user/arch-update.service` or in `/usr/local/lib/systemd/user/arch-update.service` if you installed `Arch-Update` [from source](#from-source)) that executes the `check` function when started (see the [Documentation](#documentation) chapter).  
To start it automatically **at boot and then once every hour**, enable the associated systemd timer (you can modify the auto-check cycle to your liking, see the [Tips and tricks - Modify the auto-check cycle](#modify-the-auto-check-cycle) chapter):

```bash
systemctl --user enable --now arch-update.timer
```

### Screenshots

Once started, the systray applet appears in the systray area of your panel.  
It is the icon at the right of the 'wifi' one in the screenshot below:

![systray-icon](https://github.com/Antiz96/arch-update/assets/53110319/fe032e68-3582-470a-9e6d-b51a9ea8c1ba)

With [the system timer](#the-systemd-timer) enabled, `Arch-Update` automatically checks for updates at boot and then once every hour. The check can be manually triggered by running the `arch-update --check` command.

If there are new available updates, the systray icon will show a red circle and a desktop notification indicating the number of available updates will be sent (requires [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/ "libnotify package") and a running notification server):

![notification](https://github.com/Antiz96/arch-update/assets/53110319/db94c308-526a-4b8f-8f2a-0624d0a83553)

When the systray applet is clicked, it prints the list of packages available for updates inside a terminal window and asks for the user's confirmation to proceed with the installation (it can also be launched by running the `arch-update` command, requires [yay](https://aur.archlinux.org/packages/yay "yay") or [paru](https://aur.archlinux.org/packages/paru "paru") for AUR packages support and [flatpak](https://archlinux.org/packages/extra/x86_64/flatpak/) for Flatpak packages support).

![listing_packages](https://github.com/Antiz96/arch-update/assets/53110319/ed552414-0dff-4cff-84d2-6ff13340259d)

By default, if at least one Arch Linux news has been published since the last run, `Arch-Update` will offer you to read the latest Arch Linux news directly from your terminal window.  
The news published since the last run are as `[NEW]`:  

![listing_news](https://github.com/Antiz96/arch-update/assets/53110319/4f6f1c84-e5d6-4072-aa57-0c3e80783c01)

When recent news gets listed, either type the number associated to a news to read it (you'll be re-prompted to read other news afterwards so you can read multiple news in one run), or simply press "enter" to proceed with the update.  
If no news has been published since the last run, `Arch-Update` will directly proceed to the update after you gave your confirmation.

In both cases, from there, you just have to let `Arch-Update` guide you to the various steps required for a complete and proper update of your system! :smile:

Certain options can be enabled/disabled or modified via the `arch-update.conf` configuration file. See the [arch-update.conf documentation chapter](#arch-update-configuration-file) for more details.

## Documentation

### arch-update

```text
An update notifier/applier for Arch Linux that assists you with
important pre/post update tasks.

Run arch-update to perform the main "update" function:
Display the list of packages available for update, then ask for the user's confirmation
to proceed with the installation.
Before performing the update, offer to display the latest Arch Linux news.
Post update, check for orphan/unused packages, old cached packages, pacnew/pacsave files
and pending kernel update and, if there are, offers to process them.

Options:
-c, --check       Check for available updates, send a desktop notification containing the number of available updates (if libnotify is installed)
-l, --list        Display the list of pending updates
-d, --devel       Include AUR development packages updates
-n, --news [Num]  Display latest Arch News, you can optionally specify the number of Arch news to display with `--news [Num]` (e.g. `--news 10`)
-D, --debug       Display debug traces
--gen-config      Generate a default/example configuration file (see the arch-update.conf(5) man page for more details)
--tray            Launch the Arch-Update systray applet
-h, --help        Display this help message and exit
-V, --version     Display version information and exit

Exit Codes:
0  OK
1  Invalid option
2  No privilege elevation method (sudo or doas) is installed
3  Error when launching the Arch-Update systray applet
4  User didn't gave the confirmation to proceed
5  Error when updating the packages
6  Error when calling the reboot command to apply a pending kernel update
7  No pending update when using the `-l/--list` option
8  Error when generating a configuration file with the `--gen-config` option
```

For more information, see the arch-update(1) man page.  
Certain options can be enabled/disabled or modified via the arch-update.conf configuration file, see the arch-update.conf(5) man page.

### arch-update configuration file

```text
The arch-update.conf file is an optional configuration file for arch-update to enable/disable
or modify certain options within the script.

This configuration file has to be located in "${XDG_CONFIG_HOME}/arch-update/arch-update.conf"
or "${HOME}/.config/arch-update/arch-update.conf".
A default/example configuration file can be generated by running: `arch-update --gen-config`

The supported options are:

- NoColor # Do not colorize output.
- NoVersion # Do not show versions changes for packages when listing pending updates (including when using the `-l/--list` option).
- AlwaysShowNews # Always display Arch news before updating, regardless of whether there's a new one since the last run or not.
- NewsNum=[Num] # Number of Arch news to display before updating and with the `-n/--news` option (see the arch-update(1) man page for more details). Defaults to 5.
- KeepOldPackages=[Num] # Number of old packages' versions to keep in pacman's cache. Defaults to 3.
- KeepUninstalledPackages=[Num] # Number of uninstalled packages' versions to keep in pacman's cache. Defaults to 0.

Options are case sensitive, so capital letters have to be respected.
```

For more information, see the arch-update.conf(5) man page.

## Tips and tricks

### AUR support

Arch-Update supports AUR packages if **yay** or **paru** is installed:  
See <https://github.com/Jguer/yay> and <https://aur.archlinux.org/packages/yay>  
See <https://github.com/morganamilo/paru> and <https://aur.archlinux.org/packages/paru>

### Flatpak support

Arch-Update supports Flatpak packages if **flatpak** is installed:  
See <https://www.flatpak.org/> and <https://archlinux.org/packages/extra/x86_64/flatpak/>

### Desktop notifications support  

Arch-Update supports desktop notifications when performing the `--check` function if **libnotify** is installed (and a notification server is running):  
See <https://wiki.archlinux.org/title/Desktop_notifications>

### Modify the auto-check cycle

If you enabled the [systemd.timer](#the-systemd-timer), the `--check` option is automatically launched at boot and then once per hour.

If you want to change the check cycle, run `systemctl --user edit arch-update.timer` to create an override configuration for the timer and input the following in it:

```text
[Timer]
OnUnitActiveSec=
OnUnitActiveSec=10m
```

Time units are `s` for seconds, `m` for minutes, `h` for hours, `d` for days...  
See <https://www.freedesktop.org/software/systemd/man/latest/systemd.time.html#Parsing%20Time%20Spans> for more details.

## Contributing

You can raise your issues, feedbacks and suggestions in the [issues tab](https://github.com/Antiz96/arch-update/issues).  
[Pull requests](https://github.com/Antiz96/arch-update/pulls) are welcomed as well!
