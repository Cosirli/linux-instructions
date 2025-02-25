## Editing

### Insert

  Note: i and a do not obliterate existing contents

  i	insert (to the left of the cursor)  
 I       insert at the beginning of the line  
a	append (to the right of the cursor)  
 A	append at the end of the line  
 o	open a line below the cursor  
O	open a line above the cursor

### Replace

  r	  replace the character at the cursor   
  R	enter Replace mode

### Change/Delete

  x	delete the character at cursor position  
  d	the delete operator  
  c	the change operator

### Copy/Paste

y	  yank (copy) selected text   
p	  paste (put) previously deleted/copied text after the cursor   
P      paste text before the cursor

### Undo/Redo

u	 undo a change  
U	   undo all the changes on a line  
CTRL-R	redo a change

### Repeat

  `.`       repeat the last change   
`[count]`  repeat for [count] times. e.g., 7dd

## Search and substitute

`/`	search forward for phrase  
`?`	search backward  
`%`	while the cursor is on a `(`,`)`,`[`,`]`,`{`, or `}`, find its match  
`n`	search the same phrase N	search in the opposite direction

`CTRL-O`	back to older positions  
`CTRL-I`	 to newer position  
`CTRL-D`	see possible completions when typing a  :  command

`:s/old/new`	substitute new for the 1st old in a line  
`:s/old/new/g`	substitute new for all 'old's on a line (globally in a line)    
`:s/old/new/gc`	ask for confirmation each time  
`:%s/old/new/g`	substitute all occurrences in the file   
`:#,#s/old/new/g`	between 2 lines, where #,# are the line numbers of the range  
`:s/old/new/gc`	all, with confirmation

## External command

`:!`		followed by an external command to execute that command :!rm TEST	remove the file TEST

## File writing and retrieving

`:w FILENAME`		save the file under the name TEST :r FILENAME		retrieve file FILENAME and put it below the cursor `position :r !ls`			read the output of ls  and put it below the cursor position

## Text object modifiers

`i`	inside  
`a`	around

e.g., `da(`  `di[`
