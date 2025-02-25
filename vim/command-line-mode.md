Command-line mode is used to enter Ex commands (":"), search patterns ("/" and "?"), and filter commands ("!").

# Ex command-line

Format: `:[range] {excommand} [args]`

ex commands example (`[x]` stands for register, which is optional):

- `:[range] delete [x]`: delete lines in `[range]` and store them to `[x]`.
- `:[range] print`: print lines in `[range]`
- `:[range] yank [x]`: yank lines in `[range]` to `[x]`.

## range

`range` is composed of 1 or 2 `address`es, i.e., `{address}` or `{address},{address}`

`address` could be:

- `{number}`: Line number, where `0` stands for the virtual line above the 1st line
- `$`: The last line in the file. (e.g., `$-1` represents the second to last line)
- `.`: The current line. (e.g., `.+3` represents the third line below the cursor)
- `/{pattern}[/]`: The next line where `{pattern}` matches.
- `?{pattern}[?]`: The previous line where `{pattern}` matches.    

Each `address` may be followed (several times) by `+` or `-` and an optional number. This number is added or subtracted from the preceding line number.  If the number is omitted, 1 is used.

Feel free to combine `address` into a `range`:

Special range:

- `%`: The entire file (`1,$`)
- `'<`/`>'`: The selected range in Visual mode.



## Text edit Ex commands

Delete, yank and print (`x`: *register*, optional): 

````
:[range] delete [x]
:[range] print
:[range] yank[x]
````

Copy, move and put: 

```
:[range] copy {address}
:[range] move {address}
:[address] put [x]
```

## Normal command

```
:[range] normal {commands}
```

Execute Normal mode commands {commands}.  This makes it possible to execute Normal mode commands typed on the command-line.  {commands} are executed like they are typed.   

**Tips**: Combine Normal commands with `.` and macros!

## Substitute command

```
:[range]s[ubstitute]/{pattern}/{string}/[flags] [count]
```

Replace a match of {pattern} with {string} for each lines in [range]. When [count] is given, replace in [count] lines, starting with the last line in [range]. When [range] is omitted, start in the current line.

Flags: 
`g`: Replace all the matches in each line.
`i`: Ignore case.
`c`: Confirm before substitute.
`n`: Count instead of substitute.

`:%s/Vim/whatever/n`: Count the number of times `Vim` appears.

`:s/old/new`	substitute new for the 1st old in a line  
`:s/old/new/g`	substitute new for all 'old's on a line (globally in a line)    
`:s/old/new/gc`	ask for confirmation each time  
`:%s/old/new/g`	substitute all occurrences in the file   
`:#,#s/old/new/g`	between 2 lines, where #,# are the line numbers of the range  
`:s/old/new/gc`	all, with confirmation