### Modes

| commands | Which mode to enter |
| -- | -- |
| i o a s …	| insert mode |
| \:		| command mode |
| Esc		| normal mode |
| R		| replace mode |
| v		| visual mode |
| V		| visual line mode |
| CTRL-V| visual block mode |

### How to exit Vim

Make sure you are in normal mode (if not, press Enter)
|command|action|
| - | - |
| `:wq` | write buffer to file and exit vim | 
| `:q!` | quit, discarding any changes you've made |
| `ZZ` | write current file, if modified, and quit | 
| `ZQ` | Quit without checking for changes (same as ":q!").|
| `:x` | same as “ZZ” |

#### Dive deeper: modification time might matter

`:x` and `ZZ` are equivalent and *only* save a file if the associated buffer has been changed. Whereas `:wq` always rewrites the buffer to the corresponding file even if the buffer is unchanged.

In both cases, the contents of the buffer will be saved to disk. However, if you exit Vim via `:x` and there has been no change to the buffer, there will be no change to the modification time (`mtime`) of that file. On the other hand, if you quit via `:wq`, the modification time will change, as the file is technically rewritten (saved again).

This can have some impact in certain situations. For example a backup process that is dependent on modification time, could store this file (and potentially send it over the network) even if no additional information has been included. Or some monitoring process could ring an alarm if it detects that (for it) the file has been changed...

In order to leave an modified buffer/file without changing the modification time, a `:q` (without the `w`) will work, too.
### Getting HELP 

|examples|
|-|
`:help`
`:help w`
`:h CTRL-D`
`:h c_CTRL-D` (c for completion)
`:h insert-index`
`:h user-manual`
`:h vimrc-intro`
