declare filename1="boot1_redo"
declare filename2="decafOS2"
# declare filename1="boot1"
# declare filename2="stage2"
nasm -f bin "$filename1".asm -o "$filename1".bin
nasm -f bin "$filename2".asm -o "$filename2".sys
dd if=/dev/zero of=./"$filename1".img bs=512 count=2880
mkfs.vfat -F12 "$filename1".img
dd if=./"$filename1".bin of=./"$filename1".img bs=512 count=1 conv=notrunc
sudo mount -o loop -t msdos "$filename1".img /mnt
sudo cp "$filename2".sys /mnt
sudo umount /mnt