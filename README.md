# Zero Reboot Installer

A tool for creating a new kind of LiveUSB, where from the moment you first boot, you're working from your installed system, which transparently migrates from existing only on the USB drive to existing only on the local drive, with no reboot required.

With a normal LiveUSB installer, these are some overarching steps to install to your local disk:

## Traditional LiveUSB installer (i.e. not this project):

#### 1. Boot from the LiveUSB
You're now booted into a full graphical environment and can do almost anything you can do from an installed system. You were automatically logged into an account, likely named $distro, without entering any credentials. You can browse the web, install software, change your desktop background, etc. Any changes that you make are either stored in RAM, and will disappear when you shut down, or are stored on a "casper-rw" partition / filesystem on the USB drive and most changes (except things like kernel updates) will persist after a reboot. This is already super cool! Your initial OS state is stored in a read only squashfs filesystem, which may or may not itself be inside a read only iso9660 filesystem. Any files that are changed get copied into the casper-rw filesystem, usually ext4, and aufs (or any number of other implementations of the same concept) takes this read only lower dir and read-write upper dir and combines them into one writable filesystem.

#### 2. You run the installer.
The installer asks you to choose a username and password for the user account that will be created on your local-disk backed installation. This user will not exist within your live session, of course.

Installer has you make decisions about partitioning, and then copies files from the read-only squashfs (not the RW aufs) into the root filesystem you've created, does some necessary bits to make your internal installation bootable, and might even install package updates so that you'll have a completely up-to-date system when you reboot. This also is already very cool!

#### 3. You reboot into your internally installed system.
This system doesn't have any packages you installed when you were booted into the live environment. Your changes to the desktop background or bashrc within the live environment similarly do not exist within the new user account which you log into for the first time after rebooting. Those changes are either lost, or only affect the system you get when booting the LiveUSB.

## Zero reboot installer steps:

#### 1. Boot from the live(?) USB
You boot into a full, graphical environment and are prompted to create a user account (as if you were booting from an OEM install). After choosing your username and password, you log into that account. This bit is entirely implemented by gnome-initial-setup, KDE Initial System Setup (KISS), or whatever other system implemented by whatever desktop environment / distro / whatever you're using. You can do anything you can do from an installed system. Install software, modify your bashrc, change your desktop background. *All* of this will persist into your installed system. This environment is backed by two btrfs devices, which together make up one (multi-device) btrfs filesystem. The first device is a partition on the USB drive containing a read-only btrfs system. This is the "seed device". Any changes are written to the second device, another partition on the USB drive, which is writable. This gives you a *full* writable btrfs root filesystem, without any of the caveats you get from aufs. IF you decided to reboot (still booting into the USB drive), you would not be prompted to create a new user. You would be brought to a login screen where you'd log in as the user you created. All of your changes have persisted. This is already pretty cool, but isn't much cooler than a persistent LiveUSB.

#### 2. You run the installer
The installer has you make decisions about partitions. Your root FS must be btrfs, because that's fundamentally how this whole thing is implemented. Once you've confirmed your partition layout, the installer will "btrfs device add" your local partition(s), and when that completes, will "btrfs device remove" both the rw partition and the read-only "seed" partition devices. As with a normal LiveUSB install, you can browse the web / do whatever you want while this process happens. Unlike a normal LiveUSB installation, when the installer completes, you're in your locally installed system. You *could* reboot at this point, but there's no *need* to. Keep doing your work / play / whatever. You can safely remove the USB drive. The rw partition that was removed is now "empty" again (No delta from the seed partition's contents), if you boot another machine from that USB drive you will get a first-boot experience: You'll be prompted to create a user account by gnome-initial-setup, none of the changes that you made when booted from the USB drive persist now, because they exist only on the internal drive now.

* Questions
#### 1. What practical problems does this solve?
#### No.

#### 2. Should I use this project?
No.

Please do *NOT* use this on any systems you care about. Frankly, there's no reason you should use it on systems you don't care about either. I am using a system installed this way as a daily driver, and am writing this from said system, but there are a lot of things that I do which most people *should not do*.

#### 3. Why did you make this then?

Because I can. And I think it's cool.
