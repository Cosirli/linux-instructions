# Globbing intro
Bash itself cannot recognize Regular Expressions. Bash does carry out *filename expansion* a process known as ***globbing***.

Globbing recognizes and expands *wildcards*. Globbing interprets the standard wildcard characters -- `*`, `?`, square brackets, curly braces, and certain other special characters (such as ^ for negating the sense of a match). 


## dotfile
Wildcards and metacharacters will not expand to a dot in globbing. For example, `*` will not match dotfiles.

```bash
~/[.]bashrc    #  Will not expand to ~/.bashrc
~/?bashrc      #  Neither will this.

~/.[b]ashrc    #  Will expand to ~/.bashrc
~/.ba?hrc      #  Likewise.
```

set the dotglob option to turn off matching hidden files

```bash
$ ls -l test1.???
-rw-rw-r--    1 bozo  bozo       758 Jul 30 09:02 test1.txt

$ ls -l [a-c]*
-rw-rw-r--    1 bozo  bozo         0 Aug  6 18:42 a.1
-rw-rw-r--    1 bozo  bozo         0 Aug  6 18:42 b.log
-rw-rw-r--    1 bozo  bozo         0 Aug  6 18:42 c.md

$ ls -l [^ab]*
-rw-rw-r--    1 bozo  bozo         0 Aug  6 18:42 c.md
-rw-rw-r--    1 bozo  bozo       466 Aug  6 17:48 t2.sh
-rw-rw-r--    1 bozo  bozo       758 Jul 30 09:02 test1.txt

$ ls -l {b*,c*,*est*}
-rw-rw-r--    1 bozo  bozo         0 Aug  6 18:42 b.log
-rw-rw-r--    1 bozo  bozo         0 Aug  6 18:42 c.md
-rw-rw-r--    1 bozo  bozo       758 Jul 30 09:02 test1.txt
```


# Modify globbing behavior
It is possible to modify the way Bash interprets special characters in globbing. A set -f command disables globbing, and the nocaseglob and nullglob options to shopt change globbing behavior.


