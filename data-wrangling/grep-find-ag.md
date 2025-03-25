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
- `-H`: Prefix file names on output.
- `-h`: Suppress the prefixing of file names on output.




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

## Options


### `-exec`

`\;`: execute command for each file
`+` : execute command for all files


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

