sudo mount -o loop ./floppy.img /mnt/floppy
cp stage2.sys /mnt/floppy
umount /mnt/floppy

# dd if=./boot1.bin of=floppy.img bs=512 count=1