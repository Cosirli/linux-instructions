## Toggle case
- ~		convert between uppercase and lowercase letters
- u		convert to lowercase letter
- U		convert to capitals


## Toggle comments
```
gc
```

## Fold and Unfold
```
zf
zo
```


## Netrw Directory Listing
```
:h rtp
```

Create a file or a directory: 
```
% filename
d directory_name
```

Back to explorer
```
:Ex
```


# Visual mode tricks

Vim's visual mode has three versions: character, line, and block. The keystrokes to enter each mode are:

- Character mode: v (lower-case)
- Line mode: V (upper-case)
- Block mode: Ctrl + v


## Cursor movement
- `o`: move the cursor to the diagonally opposite corner of the visual selection
- `O`: move the cursor to the other corner of the current line in visual block selection


## Text-object
- vaw	select word
- vab	select in (), including ()
- vaB	{}, including {}

## write partial buffer
- v  motion  :w TEST	save selected part of file to TEST


# Editing multiple files

- `:bn`: switch to next file
- `:bp`: switch to previous file 
- `:buffers`: display a list of files being edited
- `:b NUM`: switch to buffer NUM
- `:r FILE`: insert the specified file below cursor
