# Substitute command

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



