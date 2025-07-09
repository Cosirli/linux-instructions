# grep

```bash
grep [options] <patterns> path/to/file
```

## Options

- `-o`: Print only the matched (non-empty) parts of a matching line, each on a separate line.
- `-E`: Interpret PATTERNS as extended regexs (EREs).
- `-P`: Interpret PATTERNS as Perl-compatible regexs (PCREs).
- `-i`: Ignore case
- `-r`: Recursive
- `-n`: Show line number
- `-v`: Invert match. Search for lines that do not match a pattern.
- `-l`: Print file names with matches.
- `-L`: Print names of files with no matches.
- `-H`: Prefix file names on output.
- `-h`: Suppress the prefixing of file names on output.
- `-q`: Suppress all output, only use *exit status* (`--silent`, `--quiet`)




## Examples: 
Search for images and links in all markdown files in the working directory.
```bash
grep -oP "!\[.*\]\(.*\)" *.md
```

Use `stdin` as input
```bash
cat path/to/file | grep -i "pattern"
```

Extract os info
```bash
grep '^NAME=".*"' /etc/os-release | grep -o '"[^"]*"' | tr -d '"' # output eg: Debian
```

# find

find [-H] [-L] [-P] [-D debugopts] [-Olevel] [starting-point...] [expression]

[expression] may contain tests, operators, options and actions


## Tests
- `-empty`: empty files and directories 
- `-name`: use glob to match
- `-iname`: Like `-name` but case-insensitive
- `-regex`: use regex
- `-type`: could be b, c, d, f, l
- `-user`: belonging to a specified user
- `-group`: belonging to a specified group
- `-inum`: files with specifed inode (usage: finding hard links to an inode)
- `-samefile`: files sharing the same inode as the specified file


Tests like `-size`, `-mtime` expects numeric arguments, which can be specified as:
- +n     for greater than n,
- -n     for less than n,
- n      for exactly n.

### size
`-size` Units:

- `c`: Bytes
- `b`: 512-byte blocks. ***default***
- `k`: kilobytes (1024 bytes)
- `M`: Megabytes (1024 KiB)
- `G`: Gigabytes (1024 MiB)

### time
Unit being days:
- `-mtime`
- `-ctime`
- `-atime`

Unit being minutes:
- `-mmin`
- `-cmin`
- `-amin`



### mode

- `-perm mode`: exact match
- `-perm -mode`: (AND) all specified bits must be set
- `-perm /mode`: (OR) any specified bit is set


## Options

### Search Depth
Depth 0 represents the starting points themselves.

- `-mindepth N`: process only files that are at depth >= N
- `-maxdepth M`: process only files that are at depth <= M.

If you want the files that are at depth D, exactly, you need to use both.

Example: copy files in working dir (1 <= depth <= 2), that are either non-hidden or match the glob `.conf*` to another directory:
```bash
$ find . -mindepth 1 -maxdepth 1 \( -type f ! -name ".*" -or -name ".conf*" \) -exec cp -v -t ../dest/ {} +
'./bar' -> '../dest/bar'
'./-dash-prefixed' -> '../dest/-dash-prefixed'
'./.hid-sub/foo' -> '../dest/foo'
'./.config' -> '../dest/.config'
```

## Operators

- `!`: Negation.
- `-o`, `-or`: OR
- `-a`, `-and`: AND
- `()`: paren (may need to be escaped)

Example:
```bash
$ find . \( -name "foo*" -o -name "bar*" \) -name "*.conf" -print
./foo.conf
./bar.conf
./foobar.conf
./barfoo.conf
$ find . \( ! -name "foo*" -o -name "bar*" \) -name "*.conf" -print
./example.conf
./bar.conf
./barfoo.conf
```
Please note that -a when specified implicitly (for example by two tests appearing without an explicit operator between them) or explicitly has higher precedence than -o.  This means that `find . -name afile -o -name bfile -print` will never print afile.

## Actions

- `-print`: the default option: print the full pathname of matching files to stdout
- `-print0`: print pathnames with null termination
- `-fprint0`: print pathnames with null termination to a file
- `-delete`: delete matching files.
- `-ls`: print the equivalent of `ls -dils` on matching files
- `-quit`: quit once a match has been made


### `-exec` and `-ok`: user-defined action

To interactively execute user-defined actions, use `-ok` in place of `-exec`

- `{}`: placeholder, would be replaced by filenames
- `\;`: execute command for each file
- `+` : execute command for all files


```bash
find . -name "*.py" -exec chmod 644 {} \;
```

Compress all the `.c` and `.h` files using Gzip:
```bash
find . -type f -name "*.[ch]" -exec tar -czvf code.tar.gz {} +
```

Find all the `#include <>` operations in a C project: 
```bash
find . -type f -name "*.[ch]" -exec cat {} \; | grep -oP "#\s*include\s*<\K\w+(\.h)?" | sort | uniq
```

Find all the `#include <>` operations in a C++ project: 
```bash
find . -type f -regextype posix-extended -regex '.*\.(cpp|cc|h)' -exec cat {} \; | grep -oP '^#\s*include\s*<\K\w+(\.h)?' | sort | uniq
```



Find the most recent modified file:
```bash
find . -type f -exec ls -lt {} + | head -n 1
```



## Miscellaneous


#### Do not use `--` (from manual page)
A double dash `--`, as a shell feature, could theoretically be used to signal that any remaining arguments are not options, but this does not work for `find` due to the way find determines the end of path arguments (starting points): by reading until an expression argument (which starts with a `-`) comes. Now, if a path argument would start with a `-`, then find would treat it as expression argument instead. 

Thus, to ensure that all start points are taken as such, and especially to prevent that wildcard patterns expanded by the calling shell are not mistakenly treated as expression arguments, it is generally safer to prefix wildcards or dubious path names with either './' or to use absolute path names starting with '/'. Alternatively, it is generally safe though non-portable to use the GNU option -files0-from to pass arbitrary starting points to find.

#### `-files0-from` 
- `-files0-from`: a GNU extension, it expects a file containing a list of *null-character separated* pathnames.
- `-print0`: print pathnames with null termination
- `-fprint0`: print pathnames with null termination to a file

Using **null-terminated strings** instead of newlines to separate the pathname is much safer. If you have a filenames that might contain special characters like spaces, newlines, or leading dashes (e.g., `-file.txt`), passing the list of files via `--files0-from` helps avoid issues with interpreting those files as options or arguments. This is especially helpful when dealing with file lists generated by other tools, like `find`, `ls`, or `xargs`.

Example:
```bash
find . -type f -fprint0 filelist.txt
find -files0-from filelist.txt -name "*.png"
```



# ag

The silver searcher.

```bash
ag [options] pattern [path ...]
```

## Options

- `-o`: Print only the matching parts, not the entire line.
- `-E`: Interpret PATTERNS as extended regexs (EREs).
- `-P`: Interpret PATTERNS as Perl-compatible regexs (PCREs).
- `-i`: Ignore case
- `-r`: Recursive (default)
- `-v`: Invert match.
- `-c`: Print the number of matches only.
- `-l`: Only print the file names of files containing matches.

