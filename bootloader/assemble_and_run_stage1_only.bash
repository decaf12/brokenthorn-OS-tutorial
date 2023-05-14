declare stage1SourceName="stage1"
nasm -f bin "$stage1SourceName".asm -o "$stage1SourceName".bin
dd if=/dev/zero of=./"$stage1SourceName".img bs=512 count=2880
mkfs.vfat -F12 "$stage1SourceName".img
dd if=./"$stage1SourceName".bin of=./"$stage1SourceName".img bs=512 count=1 conv=notrunc
sudo mount -o loop -t msdos "$stage1SourceName".img /mnt
sudo umount /mnt