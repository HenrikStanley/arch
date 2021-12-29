sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector -c Denmark -a 12 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -S xorg-server xorg-xinit xterm awesome
echo “exec awesome” > ~/.xinitrc

# Options
aur_helper=true

if [[ $aur_helper = true ]]; then
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru/;makepkg -si --noconfirm;cd
fi

startx
