# Arch-Update

## Table of contents
* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Documentation](#documentation)
* [Tips and tricks](#tips-and-tricks)
* [Contributing](#contributing)

## Description

An update notifier/applier for Arch Linux that assists you with important pre/post update tasks.  
  
Features:
- Includes a (.desktop) clickeable icon that automatically changes to act as an update notifier/applier. Easy to integrate with any DE/WM, dock, status/launch bar, app menu, etc...
- Automatic check and listing of every packages available for update (through [checkupdates](https://archlinux.org/packages/community/x86_64/pacman-contrib/ "pacman-contrib package")), optionally shows the version changes as well.
- Offers to print the latest Arch Linux news before applying updates (through [curl](https://archlinux.org/packages/core/x86_64/curl/ "curl package") and [hq](https://archlinux.org/packages/community/x86_64/hq/ "hq package")).
- Helps you processing pacnew/pacsave files after an update (through [pacdiff](https://archlinux.org/packages/community/x86_64/pacman-contrib/ "pacman-contrib package")).
- Support for both [sudo](https://archlinux.org/packages/core/x86_64/sudo/ "sudo package") and [doas](https://archlinux.org/packages/community/x86_64/opendoas/ "opendoas package").
- Optional support for AUR package updates (through [yay](https://aur.archlinux.org/packages/yay "yay AUR package") or [paru](https://aur.archlinux.org/packages/paru "paru AUR package")).
- Optional support for desktop notifications (through [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/ "libnotify package"), see: https://wiki.archlinux.org/title/Desktop_notifications).

## Installation

### AUR

Install the [arch-update](https://aur.archlinux.org/packages/arch-update "arch-update AUR package") AUR package.

### From Source

Install dependencies:  
```
sudo pacman -S --needed pacman-contrib curl hq diffutils vim
```
  
Download the archive of the [latest stable release](https://github.com/Antiz96/arch-update/releases/latest) and extract it *(alternatively, you can clone this repository via `git`)*.  
  
To install `arch-update`, go into the extracted/cloned directory and run the following command:
```
sudo make install
```
   
To uninstall `arch-update`, go into the extracted/cloned directory and run the following command:  
```
sudo make uninstall
```

## Usage

The usage consist of integrating [the .desktop file](#the-desktop-file) anywhere (could be your desktop, your dock, your status/launch bar and/or your app menu) and enabling the [systemd timer](#the-systemd-timer).

### The .desktop file

The .desktop file is located in `/usr/share/applications/arch-update.desktop` (or `/usr/local/share/applications/arch-update.desktop` if you installed `arch-update` [from source](#from-source)).  
Its icon will automatically change depending on the different states (checking for updates, updates available, installing updates, up to date).  
It will launch the main `update` function when clicked (see the [Documentation](#documentation) chapter). It is easy to integrate with any DE/WM, dock, status/launch bar or app menu.  

### The systemd timer

There is a systemd service in `/usr/lib/systemd/user/arch-update.service` (or in `/etc/systemd/user/arch-update.service` if you installed `arch-update` [from source](#from-source)) that executes the `check` function when launched (see the [Documentation](#documentation) chapter).  
To launch it automatically **at boot and then once every hour**, enable the associated systemd timer:  
```
systemctl --user enable --now arch-update.timer
```

### Screenshot

Personally, I integrated the .desktop file in my top bar.  
  
It is the first icon from the left.  
![Up_to_date](https://user-images.githubusercontent.com/53110319/204068077-40775c1c-06dd-4665-b837-08f0cefb3941.png)  
     
When `arch-update` is checking for updates, the icon changes accordingly *(the check function is automatically triggered at boot and then once every hour if you enabled the [systemd timer](#the-systemd-timer) and can be manually triggered by running the `arch-update -c` command)*:  
![Searching_for_updates](https://user-images.githubusercontent.com/53110319/204068136-25adb912-54f7-4d95-afd6-f08c5b73677d.png)  
   
If there are available updates, the icon will show a bell sign and a desktop notification indicating the number of available updates will be sent *(requires [libnotify/notify-send](https://archlinux.org/packages/extra/x86_64/libnotify/ "libnotify package"))*:  
![Updates_availables](https://user-images.githubusercontent.com/53110319/204068175-5ef1cb05-b72b-44b1-9f4b-0a801d363663.png)  
![Updates_availables+notif](https://user-images.githubusercontent.com/53110319/204068184-e2fddf44-ffd6-4b2a-80fe-75e8d20ecf7e.png)  
   
When the icon is clicked, it refreshes the list of packages available for updates and print it inside a terminal window. Then it asks for the user's confirmation to proceed with the installation *(requires [yay](https://aur.archlinux.org/packages/yay "yay") or [paru](https://aur.archlinux.org/packages/paru "paru") for AUR package updates support)*:  
![List_of_packages](https://user-images.githubusercontent.com/53110319/204068223-a31e7a21-8df7-4e51-ac4b-7df6c52c5d20.png)  
  
You can optionally configure `arch-update` to show the version changes during the package listing *(see: [Tips and tricks - Show package version changes](#show-packages-version-changes))*:  
![List_of_packages_with_version](https://user-images.githubusercontent.com/53110319/204068369-2da6480f-7faa-4fa1-937c-6b168ca11795.png)  

Once you gave the confirmation to proceed, `arch-update` offers to print latest Arch Linux news so you can acknowledge them easily. Select which news to read by typing its associated number. After your read a news, `arch-update` will once again offers to print latest Arch Linux news, so you can multiple news at each update. Simply press "enter" without typing any number beforehand to proceed with update:  
![Arch_news](https://user-images.githubusercontent.com/53110319/204068653-de484935-344a-4956-b134-5b4b1771360e.png)  
   
While `arch-update` is performing updates, the icon changes accordingly:  
![Installing_updates](https://user-images.githubusercontent.com/53110319/204068693-1f71b07a-e273-46aa-a8c1-7d729617e466.png)  

After each successful update, `arch-update` will scan your system for pacnew/pacsave files and offers to process them via `pacdiff` (if there are):  
![Pacdiff](https://user-images.githubusercontent.com/53110319/204068789-a45e1576-9336-469b-8b6e-a482fbf6b160.png)  
  
Finally, when the update is over, the icon changes accordingly:  
![Up_to_date](https://user-images.githubusercontent.com/53110319/204068822-85f19af5-f817-49b9-9a25-96c5364e61fa.png)  

## Documentation

See the documentation below:  

*The documentation is also available as a man page and with the "--help" function*  
*Type `man arch-update` or `arch-update --help` after you've installed the **arch-update** package.*  
  
### SYNOPSIS

arch-update [OPTION]

### DESCRIPTION

An update notifier/applier for Arch Linux that assists you with important pre/post update tasks and that includes a (.desktop) clickeable icon that can easily be integrated with any DE/WM, dock, status/launch bar or app menu. 
Optionnal support for AUR package updates (through [yay](https://aur.archlinux.org/packages/yay) or [paru](https://aur.archlinux.org/packages/paru)) and desktop notifications (through [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/)).  

### OPTIONS

If no option is passed, perform the main update function: Check for updates and print the list of packages available for update, then ask for the user's confirmation to proceed with the installation (`pacman -Syu`).  
It also supports AUR package updates if [yay](https://aur.archlinux.org/packages/yay) or [paru](https://aur.archlinux.org/packages/paru) is installed. 
Before performing the updates, it offers to print the latest Arch Linux news to the user.  
Once the update has been successfully performed, it checks for pacnew/pacsave files and, if there are, it offers to launch `pacdiff` to process them.  
The update function is launched when you click on the (.desktop) icon.  

#### -c, --check

Check for available updates and change the (.desktop) icon accordingly if there are.  
It sends a desktop notification containing the number of available update if [libnotify](https://archlinux.org/packages/extra/x86_64/libnotify/) is installed.  
It supports AUR package updates if [yay](https://aur.archlinux.org/packages/yay) or [paru](https://aur.archlinux.org/packages/paru) is installed.  
The `--check` option is automatically launched at boot and then once every hour if you enabled the `systemd.timer` with the following command:  
```
systemctl --user enable --now arch-update.timer
```

#### -v, --version

Print the current version.

#### -h, --help

Print the help.

### EXIT STATUS

#### 0
      
if OK

#### 1
      
if problems (user didn't gave confirmation to proceed with the installation, a problem happened during the update process, the user passed an invalid option, ...)

## Tips and tricks

### AUR Support

Arch-Update supports AUR package updates when checking and installing updates if **yay** or **paru** is installed:  
See https://github.com/Jguer/yay and https://aur.archlinux.org/packages/yay  
See https://github.com/morganamilo/paru and https://aur.archlinux.org/packages/paru  

### Desktop notifications Support  

Arch-Update supports desktop notifications when performing the `--check` function if **libnotify (notify-send)** is installed:  
See https://wiki.archlinux.org/title/Desktop_notifications

### Modify the auto-check cycle

If you enabled the systemd.timer, the `--check` option is automatically launched at boot and then once every hour.  
  
If you want to change that cycle, you can edit the `/usr/lib/systemd/user/arch-update.timer` file (or `/etc/systemd/user/arch-update.timer` if you installed `arch-update` [from source](#from-source)) and modify the `OnUnitActiveSec` value.  
The timer needs to be re-enabled to apply changes, you can do so by typing the following command:  
```
systemctl --user enable --now arch-update.timer
```
  
See https://www.freedesktop.org/software/systemd/man/systemd.time.html

### Show package version changes

If you want `arch-update` to show the packages version changes in the main `update` function, run the following command:  
```
sudo sed -i "s/ | awk '{print \$1}'//g" /usr/bin/arch-update /usr/local/bin/arch-update 2>/dev/null || true
```
  
**Be aware that you'll have to relaunch that command at each `arch-update`'s new release.**  

## Contributing

You can raise your issues, feedbacks and suggestions in the [issues tab](https://github.com/Antiz96/arch-update/issues).  
[Pull requests](https://github.com/Antiz96/arch-update/pulls) are welcomed as well!
