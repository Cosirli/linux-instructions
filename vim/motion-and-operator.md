> Operator + Motion = Action



# Text object

Format: `i`/`a` + Object   i for inner and a for around

Objects include:

- `w`/`W`, `s`, `p`
- Matching punctuations, {} [] () ‘’ “” …

### Extensions

```bash
vim-easymotion: extends motion
vim-surround: defined operatos for matching punctuations
vim-commentary: defined operator for comments
targets.vim: extends textobjects, such as function parameters
```

# Motion 

### Word level

`b`		   the beginning of the word (reversely)   
`e`	   	the end of the word  
`w`		   the beginning of the next word  
`ge`         the end of the word (reversely) 
`B E W`   big jump (redefined word: include punctuations)

### Line level

`^` (Shift + 6)		the beginning of the line 0			the beginning (including some blank chars) $ (Shift + 4)		the end of the line

### Block (paragraph)

`{`		jump to the last paragraph  
`}`			the next paragraph

### File

`G`		end of file  
`gg`		top of file  
`Ctrl + G`	display current location  
`{number} + G`	move to that line number  
`Ctrl + O`	back to older positions  
```Ctrl + I`	to newer positions

## Search-based motion

### search in the line

`f{char}`/`t{char}` find/till (forwards)    

`F{char}`/`T{char}` find/till (backwards)   

`;`/`,`                         repeat search forwards/backwards   

### search in the file

`/{pattern}`/`?{pattern}`            search for `pattern` forwards/backwards (pattern can be regex)

`*` is equivalent to `/{pattern}`   where `pattern` represents the word nearest to the cursor

`n`/`N`                                                  repeat search forwards/backwards

### others

L	Lowest line on the screen M	Middle line on the screen H	Highest line on the screen



## Mark-based motion

`m{mark}` : Set mark named `{mark}` at cursor position (not a motion), where`{mark}` : {a-zA-Z}  

``{mark}` : Jump back to the marked position

### Built-in marks:

` `` ` the position before the latest jump, or where the last `m` command was given

``.` the position where the last *change* was made

``^` the position where the last time *Insert mode* was stopped.

## Text object motions

(                       [count] sentences backward. exclusive motion. )                       [count] sentences forward.  exclusive motion. {                       [count] paragraphs backward.  exclusive motion. }                       [count] paragraphs forward.  exclusive motion.

## Text object selection



## Various motions

`%`    jump to the matching bracket/preprocessor directive/comment bracket … on this line



# Operator

### c for change

`cw`	change the rest of the word  
`cc`	change the line to blank  
`c$`	change the rest of the line from current cursor on

### d for delete

`d%`   delete to the next match  
`dd `   delete the line  
`dgg` delete to the beginning of the file

### y for yank

`ye`	copy the current word with out following space  
`y$`	copy from the current word to the end-of-line

### gu/gU/g~

turn text to lowercase/uppercase/flipped case

### J for join

Join `[count]` lines

### `<`/`>`

indent left/right

### Ctrl-a, Ctrl-x

increment/decrement

`{Visual}CTRL-A`          Add [count] to the number or alphabetic character in the highlighted text.  
`{Visual}g CTRL-A`        Add [count] to the number or alphabetic character in the highlighted text. If several lines are highlighted, each one will be incremented by an additional [count] (so effectively creating a [count] incrementing sequence). 

For Example, if you have this list of numbers: 

```
1. 
1.6
3. 44e 
1.e324
```

Move to the second "1." and Visually select three lines, pressing g CTRL-A results in:

```
1.
2.6  
6. 44e
4.e324
```



### . and [count]

`.` repeat the last action

`{count}{action}` repeat action for [count] times