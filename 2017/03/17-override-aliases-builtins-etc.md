---
date: '2017-03-17'
tags:
  - linux
  - bash
---

# Override aliases, builtins, etc.

Prepending a command in Bash with `\` will disable lookup to builtins or aliases. E.g.

```
$ \time bash -c "dnf list installed | wc -l"
5466
1.32user 0.12system 0:01.45elapsed 99%CPU (0avgtext+0avgdata 97596maxresident)k
0inputs+136outputs (0major+37743minor)pagefaults 0swaps
```

Will use the `/usr/bin/time` command instead of the Bash builtin.

## Sources

- <https://medium.com/@kjetijor/with-bash-try-time-overrides-aliases-builtins-etc-482d74b78407#.trhea9idh>
