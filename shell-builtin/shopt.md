In **Bash**, `shopt` is a built-in command that allows you to set and unset various shell options.

## Common Uses

### Enable/Disable Shell Features:


- `dotglob`: Includes hidden files (those starting with a `.`) in expansions like `*`. By default, `*` does not match hidden files.
- `nullglob`: If a glob pattern matches no files, it expands to nothing, rather than the pattern itself.
- `globstar`: Enable glob `**` to match directories recursively.
- `checkwinsize`: Automatically checks and updates the window size after each command.
- `histappend`: Appends new history lines to the history file rather than overwriting it.
- `expand_aliases`: Allows alias expansion in non-interactive shells.
- `cdspell`: Allows the shell to correct minor typos in directory names when using `cd`.


### Examples of `shopt` Usage in Bash

  
- Check the status of a specific option:
```bash
shopt -p dotglob
```

- Set `globstar` (recursive globbing):
```bash
shopt -s globstar
# Now you can use ** to match files recursively
echo **/*.txt  # Finds all .txt files in subdirectories
```

- Unset `nullglob`:
```bash
shopt -s nullglob
echo *.nonexistent  # Returns nothing instead of "*.nonexistent"
```

