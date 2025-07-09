# Group command

To treat the a sequence of commands as a whole with a single output stream, create a *group command* by surrounding your commands with braces (`{}`):
```bash
{ ls bar; ls nonexist; ls foo; } &> out.txt 
```

Note that: 
- whitespaces are required around the braces 
- the final command in the sequence must be terminated with either a semicolon or a newline.

