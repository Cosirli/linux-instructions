# ed

Line-oriented text editor. Minimal, no visual interface, best for quick-edits.

## Basic Commands

Syntax: `[range]command`.

- `.`: current line
- `$`: the last line in the file
- `%`: the entire file

1. **Print**

Without line number:
```ed
1,10p
1,$p
```

With line number, print the entire file:
```ed
,n
```


2. **Navigate through lines**: For example, go to line 5
 ```ed
 5
 ```

3. **Insert/append lines**:
To *insert* text before a line, use the `i` command.  
To *append* after a line, use the `a` command. 
```ed
2i
This is a new line
.
```
The `.` (dot) indicates the end of the insertion.


4. **Change or delete lines**:
Change the content of a line using `c`.
To delele a range of lines, use `d`. example: 
```ed
2,4d
```

5. **Substitution**: The `s` command. Examples:

```ed
2s/old/new/
1,$s/old/new/g
```

6. **Undo a change**: `u`

7. **Buffers for multi-file editing**: `e filename`


To list open buffers, type `files`


8. **Save the file and quit**: `w` for Write. You can to write to a different file:
```ed
w newfile.txt
```

`q` for quit.


## Advanced


### `g` and `v`
`g` for global. Execute commands on all lines matching a pattern. You can chain multiple commands to operate on matching lines:
`v` is the inverse of `g`, acting on lines that do not match a pattern.

To delete all lines containing the word foo:
```ed
g/foo/d
```

Replace old with new on all lines containing old_pattern:
```ed
g/old_pattern/s/old/new/g
```

### & and capture (*just some regex*)
use the & symbol to refer to the last substitution's pattern.

Append at the end of a line:
```ed
3s/.*/& appended_text
```

Insert text before foo:
```ed
s/\(foo\)/some_text \1/
```
Here, `\(foo\)` *captures* foo, and `\1` refers to the matched foo.



# sed

`sed`: Stream EDitor (a modification of `ed`)


## Options

- `-i`: Edit files in place

## Examples

```bash
cat foo | sed 's/000$//'   # remove the 000 at the end of a line
uptime -p | sed 's/up //; s/ days/d/; s/ hours/h/; s/ minutes/m/'
cat foo | sed 's/[^[:alpha:] ]//g' | tr ' ' '\n' | sed '/^$/d' | sort | uniq -c | sort -n   # count words in a file
```

