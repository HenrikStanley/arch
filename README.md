# Command line help to install base system  

### Check system has an IP  
ip -a  

### Update mirrors for speed  
pacman -S reflector  

reflector -c Denmark -a 6 --sort rate --save /etc/pacman.d/mirrorlist  

pacman -Syyy  

### Set system time  
timedatectl set-ntp true  

### Check disk labels  
lsblk  

### Mount a disk  
fdisk /dev/{DiskLabel}  

### Fdisk commands:  
#### Create a disk label  
g  

#### Create new partition for boot at 500 MB size and set the type to EFI  
n  
+500M  
t  
1  

### Create new partition for root  
n  
Enter for partition number  
Enter for first sector  
Enter for end sector  

### Write changes to disk
w

### Show new disk labels  
lsblk  

### Format EFI partition with fat32  
mkfs.fat -F32 -n EFI /dev/{EFI-Partition-Label}  

### Format Main partition with btrfs  
mkfs.btrfs -L ROOT dev/{Main-Partition-Label}  

### Mount root directory into the /mnt installation directory  
mount dev/{Main-Partition-Label} /mnt  

btrfs su cr /mnt/@  
btrfs su cr /mnt/@home  
btrfs su cr /mnt/@var  
btrfs su cr /mnt/@snapshots  

umount /mnt  

### mount root  
mount -o noatime,compress=lzo,space_cache,subvol=@ /dev/{Main-Partition-Label} /mnt  
mkdir -p /mnt/{boot,home,var,.snapshots}  

### mount home, var and snapshots
mount -o noatime,compress=lzo,space_cache,ssd,discard=async,subvol=@home /dev/{Main-Partition-Label} /mnt/home  
mount -o noatime,compress=lzo,space_cache,ssd,discard=async,subvol=@var /dev/{Main-Partition-Label} /mnt/var  
mount -o noatime,compress=lzo,space_cache,ssd,discard=async,subvol=@snapshots /dev/{Main-Partition-Label} /mnt/.snapshots  

### mount EFI  
mount /dev/{EFI-Partition-Label} /mount/boot  


### install base system
pacstrap /mnt base btrfs-progs linux linux-firmware git nvim snapper amd-ucode

### generate filesystem table 
genfstab -U /mnt >> /mnt/etc/fstab  

### enter installation
arch-chroot /mnt
