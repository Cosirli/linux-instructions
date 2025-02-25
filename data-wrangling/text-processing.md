# comm

```bash
comm -12 <(sort gnu) <(sort linux) #strip column 1 and 2, not we have the common contents
#col 1: unique to the first file
#col 2: unique to the second file
#col 3: common contents
```

# uniq

```bash
uniq -c <(cat gnu linux | sort) 
```

# diff and patch

`-u` output NUM (default 3) lines of unified output (generate a patch)  
`-y` side by side, output in two columns

```bash
touch unix-like
diff -u unix-like gnu > gnu.patch
patch unix-like < gnu.patch
```

`patch`: apply a `diff` file to an original  



# sort

sort: sort lines of txt files.

| Options |                                                              |
| ------- | ------------------------------------------------------------ |
| `-b`    | `--ignore-leading-blanks`                                    |
|         |                                                              |
| `-k`    | `--key=KEYDEF`   sort via the specified `KEYDEF`, which gives key location and type |
| `-t`    | `--field-separator=SEP`: use `SEP` instead of non-blank to blank transition |
| `-o`    | `--output=FILE`: redirect result to FILE instead of `stdout` |
| `-c`    | check for sorted input; do not sort                          |
| `-u`    | `--unique`. With `-c`, check for strict ordering; without `-c`, remove duplicates. |
| `-r`    | reverse the comparison results                               |
| `-R`    | `--random-sort`: shuffle, but group identical keys           |
| `-M`    | `--month-sort`   *compare (unknown) < 'JAN' < ... <'DEC'*  sort according to months |
| `-n`    | `--numeric-sort`   compare according to string *numerical value*. Without `-n`, numbers are sorted by their leading characters only. |
| `-h`    | `--human-numeric-sort`  compare human readable numbers( e.g., 2K 1G) |

`--files0-from=F`: Reads input from the files specified by NUL-terminated names in the specified F file. If F is `-`, sort reads names from standard input.  

```bash
-k FStart [ .CStart ] [ Modifier ] [ , [ FEnd [ .Cend ] ][ Modifier ] ]
```

The sort key includes all characters beginning with the field specified by the `FStart` variable and the column specified by the `CStart` variable. The key ends with the field specified by `FEnd` and the column specified by `CEnd`.

Not specifying `Fend` assumes the line's last character as the end. Without specifying `CEnd`, the last character in the `FEnd` field is assumed.

Examples:

```bash
du -sh * | sort -nr
find -name "default?.txt" -print0 | sort --files0-from=-  # '-print0' option: End filename with NUL
sort -k 2,2 example.txt
```

# wc
Count lines, bytes, words for each file.
## options
```bash
wc [OPTION]... [FILE]...
```

|Option|  |
|------|-------------|
|`-c`| print the byte counts      |
|`-m`| print the character counts |
|`-l`| print the newline counts   | 
|`-L`| print the max line length  | 
|`-w`| print the word counts| 


```bash
wc [OPTION]... -files0-from=F
```

`-file0-from=F`: read input from the files specified by NUL-terminated names in file *F*; If F is `-` then read names from stdin.  

## use cases
You might have noticed that `wc` command output consists of the file names. If just want to get the number without the filename, you may use it with the cut command and get rid of the filename from the output.

```bash
wc -l agatha.txt | cut -d ' ' -f 1
```

You can also get rid of the filename by using the wc command in this way:

```bash
wc -l < agatha.txt
```



#  cut

Remove sections from each line of files.

```
cut OPTION... [FILES]...
```

`cut` will *never reorder or duplicate data*.

Print each line

# join

Join lines of two files on a common *field*, where *field* is specified by a number or 1 by default.

```bash
join [OPTION]... FILE1 FILE2
```

When FILE1 or FILE2 (not both) is `-`, read *standard input*.

| OPTIONS         |                                                              |
| --------------- | ------------------------------------------------------------ |
| `   -a FILENUM` | also print unpairable lines from file FILENUM, where FILENUM is 1 or 2, corresponding to FILE1 or FILE2 |
| `-v FILENUM`    | like `-a FILENUM`, but suppress joined output lines          |
| `-i`            | `--ignore-case`                                              |
| `-1 FIELD`      | join on this `FIELD` of `FILE1` (similarly, `-2 FIELD`  specifies the *join field* of `FILE2` to be `FIELD`) |
| `-j FIELD`      | equivalent to `-1 FIELD -2 FIELD`                            |
| `-t CHAR`       | use `CHAR` as input and output field separator               |
| `-e EMPTY`      | replace missing input fields with `EMPTY`                    |
| `--header`      | treat the first line in each file as field headers, print them without trying to pair them |

Additional:

- `--nocheck-order`: not check that the input is correctly sorted
- `--check-order`: check that the input is correctly sorted, even if all input lines are pairable

For each pair of input lines with identical join fields, write a line to *stdout*.  The default join *field* is the first, delimited by blanks.

```bash
# Example
join -j2 -t; file1.txt file2.txt 
```

