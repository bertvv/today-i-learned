---
date: '2017-09-15'
tags:
  - bash
  - linux
---

# about ~/.inputrc

Actually, I found out about this some time ago, but didn't get to writing something about it. The `~/.inputrc` file contains settings for GNU readline, i.e. it controls how the command line behaves. Not only the Bash shell either, but also e.g. the Python REPL.

Hong (2017) gives an example of a useful `.inputrc` file, which I won't repeat here. Highlights for me are:

- Tab completion with colors
- Replace common prefixes in completions with an ellipsis
- List completions immediately instead of after second TAB
- Case insensitive completion
- Highlight matching parentheses
- etc.

See the manual (Ramey, 2016) for a complete overview.

## References

- Hong (2017). *A ~/.inputrc for Humans*. Retreived 2017-09-15 from <https://www.topbug.net/blog/2017/07/31/inputrc-for-humans/>
- Ramey, C. (2016). *GNU Readline Library*. Retreived 2017-09-15 from <https://cnswww.cns.cwru.edu/php/chet/readline/readline.html>
