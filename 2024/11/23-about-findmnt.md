---
date: '2024-11-23'
tags:
  - linux
  - networks
---

# About findmnt

When you look up how to list mounted filesystems on Linux, just about *every* source will tell you to use the `mount` command. The output of `mount` used to be simple enough, but these days, with all the pseudo filesystems under `/sys`, `/run` and the like, you have to pipe it through `grep` to find useful information through all the noise.

As it turns out, though, using `mount` to *list* mounted filesystems is *deprecated*. From the man page `mount(8)`:

```text
   Listing the mounts
       The listing mode is maintained for backward compatibility only.

       For more robust and customizable output use findmnt(8), especially in your scripts.
```

## using `findmnt`

And indeed, `findmnt` is actually *way* better. Even the default output looks better structured than `mount` and there are a lot of options and arguments to customize the output. Try the default output yourself, as it's quite verbose.

A few examples of useful options:

- `--real`: Only show "real" filesystems (i.e. not pseudo filesystems):

    ```console
    [vagrant@el ~]$ findmnt --real
    TARGET       SOURCE    FSTYPE  OPTIONS
    /            /dev/sda2 xfs     rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota
    ├─/mnt/part3 /dev/sdc5 xfs     rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota
    ├─/mnt/part4 /dev/sdc6 fuseblk rw,relatime,user_id=0,group_id=0,allow_other,blksize=4096
    ├─/mnt/part2 /dev/sdc2 ext4    rw,relatime,seclabel
    └─/mnt/part1 /dev/sdc1 ext3    rw,relatime,seclabel
    ```

    Note the tree structure and aligned columns!

- `--fstab`, `-s`: Show only filesystems listed in `/etc/fstab`:

    ```console
    [vagrant@el ~]$ findmnt --fstab
    TARGET     SOURCE                                      FSTYPE OPTIONS
    /          UUID=303db791-9236-4ac4-a176-e2a033576d89   xfs    defaults
    none       UUID=a4814ebe-c0b2-4819-8129-30f32b3e8772   swap   defaults
    /mnt/part1 UUID="f89d27bf-94d3-40a4-9fca-2af9cbe94856" ext3   defaults
    /mnt/part2 UUID="cb44e6c4-a49e-43e1-b9a8-ed5d272b8efb" ext4   defaults
    /mnt/part3 UUID="6b306b44-23fe-4cef-8c3e-423188e5c088" xfs    defaults
    /mnt/part4 UUID="2856B0906FE06278"                     ntfs   defaults
    /vagrant   vagrant                                     vboxsf uid=1000,gid=1000,_netdev
    ```

- `--json`, `-J`: Output in JSON format

- `--pairs`, `-P`: Output in key-value pairs

    ```console
    [vagrant@el ~]$ findmnt --pairs
    TARGET="/proc" SOURCE="proc" FSTYPE="proc" OPTIONS="rw,nosuid,nodev,noexec,relatime"
    TARGET="/sys" SOURCE="sysfs" FSTYPE="sysfs" OPTIONS="rw,nosuid,nodev,noexec,relatime,seclabel"
    [...]
    ```

- `--df`, `-D`: imitate the output of `df(1)`

    ```console
    [vagrant@el ~]$ findmnt  --df
    SOURCE    FSTYPE     SIZE  USED  AVAIL USE% TARGET
    devtmpfs  devtmpfs     4M     0     4M   0% /dev
    tmpfs     tmpfs    384.5M     0 384.5M   0% /dev/shm
    tmpfs     tmpfs    153.8M  4.4M 149.4M   3% /run
    /dev/sda2 xfs       61.9G  1.8G    60G   3% /
    /dev/sdc5 xfs        4.9G 67.5M   4.9G   1% /mnt/part3
    /dev/sdc6 fuseblk      5G 26.2M     5G   1% /mnt/part4
    /dev/sdc2 ext4       5.8G   24K   5.5G   0% /mnt/part2
    /dev/sdc1 ext3       3.9G   96K   3.7G   0% /mnt/part1
    tmpfs     tmpfs     76.9M     0  76.9M   0% /run/user/1000
    ```

## References

- Man page `mount(8)`, `findmnt(8)`
