---
date: '2017-03-16'
tags:
  - linux
  - bash
---

# About the time command

When you execute the `time` command in Bash, it may not be what you expect (i.e. the `/usr/bin/time` binary), but a shell builtin with more limited features. [This blog post](https://hackernoon.com/usr-bin-time-not-the-command-you-think-you-know-34ac03e55cc3#.xmf4fezev) from Alistair Roche goes into the subject.

`/usr/bin/time` has options and can show more information than just "real/user/sys".

Alastair Roche apparently works on a Mac (his console prompt reads `bash-3.2$`, the GNU version of `/usr/bin/time` has different options. The option `-l`, shown in Roche's blogpost doesn't exist in GNU `time`.

The examples below are based on GNU `time`.

## Examples

Default output:

```console
$ /usr/bin/time bash -c "dnf list installed | wc -l"
5466
1.33user 0.13system 0:01.48elapsed 98%CPU (0avgtext+0avgdata 102088maxresident)k
0inputs+136outputs (0major+37940minor)pagefaults 0swaps
```

Portable (POSIX compliant) output:

```console
$ /usr/bin/time -p bash -c "dnf list installed | wc -l"
5466
real 2.38
user 1.80
sys 0.23
```

## Sources

- Roche, Alistair (2017-03-06). /usr/bin/time: not the command you think you know. Retrieved from <https://hackernoon.com/usr-bin-time-not-the-command-you-think-you-know-34ac03e55cc3#.29cvyd7wg> on 2017-03-17
