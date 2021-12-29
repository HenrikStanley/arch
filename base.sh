#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime
hwclock --systohc

# edit file instead
# sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=dk-latin1" >> /etc/vconsole.conf
echo "vetinari" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 vetinari.localdomain vetinari" >> /etc/hosts
# passwd
echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

# Grub boot
pacman -S grub grub-btrfs efibootmgr n

# Base tools
pacman -S reflector base-devel linux-headers xdg-user-dirs mtools dosfstools os-prober dialog

# Network
pacman -S networkmanager network-manager-applet wpa_supplicant iptables-nft ipset

# Audio 
pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack alsa-utils

# Utilities 
pacman -S avahi dnsutils xdg-user-dirs xdg-utils dnsutils bluez bluez-utils cups 

# pacman -S --noconfirm xf86-video-amdgpu
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# Install systemd-boot
# bootctl --path=/boot install

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
#systemctl enable tlp # You can comment this command out if you didn't install tlp, see above (used for battery savings)
systemctl enable reflector.timer
systemctl enable fstrim.timer
#systemctl enable libvirtd
#systemctl enable firewalld
#systemctl enable acpid

useradd -m stanley
echo stanley:password | chpasswd
usermod -aG libvirt stanley

echo "stanley ALL=(ALL) ALL" >> /etc/sudoers.d/ermanno


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
