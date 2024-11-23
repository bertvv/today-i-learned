---
date: '2017-04-21'
tags:
  - git
---

# About .gitattributes

I have created several Vagrant environments for setting up Linux VMs provided either with shell scripts and published them on Github. A common problem Windows users encounter with these projects has to do with line endings.

## The problem

When cloning a project, Git will apply the line endings for the local system, i.e. CRLF on Windows, LF on Linux/MacOS. Scripts that are executed using the "shebang" that have Windows line endings won't run and produce an error message similar to:

```console
$ ./script.sh
bash: ./script.sh: /bin/bash^M: bad interpreter: No such file or directory
$ ./script.py
bash: ./script.py: /usr/bin/python^M: bad interpreter: No such file or directory
```

I usually instruct Windows users to set the `autocrlf` option when cloning, e.g.:

```console
$ git clone --config core.autocrlf=input git@github.com:bertvv/ansible-skeleton.git
```

However, it happens regularly that this is forgotten and mayhem ensues.

Turns out, I could have prevented this. Enter `.gitattributes`.

## The `.gitattributes` file

The `.gitattributes` file should be added to the root directory of the repository and contains rules for line endings regardless of `autocrlf` settings.

```console
# Default behaviour
* text=auto

# Shell scripts should have Unix endings
*.sh text eol=lf
*.bats text eol=lf
*.py text eol=lf

# Windows Batch or PowerShell scripts should have CRLF endings
*.bat text eol=crlf
*.ps1 text eol=crlf
```

I have quite a few repositories to fix, but this should definitely improve the experience of Windows users.

## References

- Dorogin, S. (2016) *The case of Windows line-ending in bash-script*. Retrieved 2017-04-21 from <https://techblog.dorogin.com/case-of-windows-line-ending-in-bash-script-7236f056abe>
- Github (2017) *Dealing with line endings.* Retrieved 2017-04-21 from <https://help.github.com/articles/dealing-with-line-endings/>
