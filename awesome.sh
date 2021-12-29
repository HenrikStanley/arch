sudo pacman -S xorg-server xorg-xinit xterm awesome
echo “exec awesome” > ~/.xinitrc

startx
