
## Wipe the provided LUN
wipe_lun(){

wipefs -a $1

}

## Partition the provided LUN with fdisk
create_part(){
LUN=$1
wipe_lun $LUN
fdisk $LUN <<EOS

n




w

EOS
return $?
}

## Run the mkfs command on provided LUN
makefs() {
LUN=$1
mkfs.ext4 $LUN
}

## To mount the provided LUN on provided dir
mount_fs(){
LUN=$1
MOUNT=$2
mount $LUN $MOUNT
}


## Organizer function, calling all the other functions 
create_fs(){
LUN=$1
MOUNT=$2

wipe_lun $LUN
create_part $LUN
# Since the LUN is partitioned, as per defaults, there'd 1 partition present after create_part
# and hence ${LUN}1 as LUN below
makefs "${LUN}1"
mkdir $MOUNT
mount_fs "${LUN}" $MOUNT
}

main(){
DISK1=/dev/sdc	# 64G, for /u01
DISK2=/dev/sdd  #16G, for /data01
DISK3=/dev/sde  #16G, for /data02
DISK4=/dev/sdf  #16G, for /data03
DISK5=/dev/sdg  #8G, for /swap01
DISK6=/dev/sdh  #16G, for /archive01
DISK7=/dev/sdi  #16G, for /ocr01

create_fs $DISK1 '/u01'
create_fs $DISK2 '/data01'
create_fs $DISK3 '/data02'
create_fs $DISK4 '/data03'
create_fs $DISK5 '/swap01'
create_fs $DISK6 '/archive01'
create_fs $DISK7 '/ocr01'

}





#sdc                 8:32   0   64G  0 disk
#sdd                 8:48   0   16G  0 disk
#sde                 8:64   0   16G  0 disk
#sdf                 8:80   0   16G  0 disk
#sdg                 8:96   0    8G  0 disk
#sdh                 8:112  0   16G  0 disk
#sdi                 8:128  0    4G  0 disk

main

