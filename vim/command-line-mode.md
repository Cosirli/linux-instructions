Command-line mode is used to enter Ex commands (":"), search patterns ("/" and "?"), and filter commands ("!").

# Ex command-line

Press or `:` in normal mode to enter command-line mode.  

Press `Q` or `gQ` in Neovim to enter Ex mode.

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

- `%`: The entire file (equivalent: `1,$`)
- `'<,'>`: The selected range in Visual mode.



## Text edit Ex commands

Delete, yank and print (`x`: *register*, optional): 

````
:[range] d [x] 
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

### Normal command

```
:[range] normal {commands}
```

Execute Normal mode commands {commands}.  This makes it possible to execute Normal mode commands typed on the command-line.  {commands} are executed like they are typed.   

**Tips**: Combine Normal commands with `.` and macros!


## More
You are close to `ed`, the ancient line-oriented text editor. Give it a shot!

# Enter Ex mode 

Press `Q` or `gQ` in *Normal mode* to enter Ex-mode, press `:visual` or `:vi` to exit. 

## Tricks

Use `|` to concatenate two commands.  

Sort the text in [range] reversely: `[range]!sort -r`.  

Command-line mode is used to enter Ex commands (":"), search patterns ("/" and "?"), and filter commands ("!").



## Ex command history

Open Ex-command history by pressing `q:` in *normal mode*, or by `<C-j>` in Ex mode.

Cycle through history with `j` and `k`, or use `<C-p>` and `<C-n>` alternatively. Use `:[number]` to move focus to the [number]'s command in the list. 

You can edit the commands in the history, and press `<CR>` to run the command at cursor.



Command-line mode is used to enter Ex commands (":"), search patterns ("/" and "?"), and filter commands ("!").

# Filter commands (Shell commands)
1. Sort the text in [range] reversely: `:[range]!sort -r`.
2. Insert file contents below after line [num]:   `:r ../example.txt`
3. Save with sudo: `:w !sudo tee %`  
4. Insert date below the cursorline:   `:r !date`
5. Insert Unix timestamp:  `r!date "+\%s`, where backslash escapes `%` so the shell receives `+%s`.


