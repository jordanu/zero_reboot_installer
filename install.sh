#!/bin/bash

set -ex

#sudo parted /dev/nvme0n1 mklabel gpt
#sudo parted /dev/nvme0n1 mkpart ESP fat32 0% 10G
#sudo parted /dev/nvme0n1 mkpart root btrfs 10G 100%

sudo parted /dev/nvme1n1 mklabel gpt
sudo parted /dev/nvme1n1 mkpart ESP fat32 0% 10G
sudo parted /dev/nvme1n1 mkpart root btrfs 10G 100%


sudo btrfs device add /dev/nvme0n1p2 /dev/nvme1n1p2 /

sudo btrfs device remove /dev/sda3
sudo btrfs device remove /dev/sda2

sudo umount /dev/sda1
