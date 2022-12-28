declare filename=boot1
nasm -f bin "$filename".asm -o "$filename".bin
dd if=/dev/zero of=./"$filename".img bs=512 count=2880
mkfs.vfat -F12 "$filename".img
dd if=./"$filename".bin of=./"$filename".img bs=512 count=1 conv=notrunc
sudo mount -o loop -t msdos "$filename".img /mnt
sudo cp Stage2.sys /mnt
sudo umount /mnt