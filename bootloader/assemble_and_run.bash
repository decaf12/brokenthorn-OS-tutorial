declare stage1SourceName="stage1"
declare stage2SourceName="stage2"
declare stage2FATName="DECAFOS"
nasm -f bin "$stage1SourceName".asm -o "$stage1SourceName".bin
nasm -f bin "$stage2SourceName".asm -o "$stage2FATName".sys
dd if=/dev/zero of=./"$stage1SourceName".img bs=512 count=2880
mkfs.vfat -F12 "$stage1SourceName".img
dd if=./"$stage1SourceName".bin of=./"$stage1SourceName".img bs=512 count=1 conv=notrunc
sudo mount -o loop -t msdos "$stage1SourceName".img /mnt
sudo cp "$stage2FATName".sys /mnt
sudo umount /mnt