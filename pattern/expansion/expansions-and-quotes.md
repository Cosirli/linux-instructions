# All kinds of expansion in Bash

Expansion is performed on the command line after it has been split into tokens. There are seven kinds of expansion performed:

## Brace Expansion

Integers may be *zero-padded* like so:
```bash
mkdir -p photos/202{4,5}-{01..12}/{Mon,Tue,Wed,Thu,Fri,Sat,Sun}
```

You can specify stride like so:
```bash
echo odd{1..19..2}
```

Numbers or Letters may be in reverse order:
```bash
echo {D..A}-{001..3}
```

Brace expansions may be nested:
```bash
echo a{A{1,2},B{3,4}}b
```

## Word Splitting

Word splitting looks for spaces, tabs and newlines and treats them as *delimiters* between words.
```bash
$ echo Hello     World
Hello World
```

## Filename Expansion
To see the result of filename/pathname expansion, use the `echo` command.

For hidden files:
```bash
echo .*
```

## Tilde Expansion
If a word begins with an unquoted tilde (`~`), all of the characters up to the first unquoted slash (or all characters, if there is no unquoted slash) are considered a *tilde-prefix*.

If the tilde-prefix is `~+`, value of the shell variable PWD replaces the tilde-prefix.
If the tilde-prefix is `~-`, the value of the shell variable OLDPWD, if it is set, is substituted.

Expands into the home directory of the named user or, if no user is named, the home directory of the current user.

```bash
echo ~root
```


## Arithmetic Expansion

Syntax:
```bash
$((expression))
```

where `expression` is an arithmetic expression of *integer values* and arithmetic operators.


### Arithmetic operators
`+`, `-`, `*`, `/`, `%`, `**`

Example:
```bash
echo $(((5**2)*3+51/2))
```

## Parameter Expansion

```bash
echo $PWD
```

## Command Substitution

Use the output of a command as an expansion. Syntax: `$()` or backquotes(\`\`)
```bash
vim $(fzf)
ls -l `which cp`
```

# Quoting

## Single Quotes
Supress all expansions.

## Double Quotes
All the special characters lose their meaning in double quotes *except* for doller sign, backslash and backquotes, which means that:
- word splitting, pathname expansion (glob), tilde expansion and brace expansion are compressed.
- parameter expansion, arithmetic expansion and command substitution are still carried out.

### Escape Characters
- eliminate special meaning of a character 
- suppress an alias.
- represent special characters called *control codes* (such as `\n`)


# Other Expansion

## History Expansion
```bash
!!        # the last command
!number   # history item number
!string   # last history list item starting with string
```


Trailing `:p` tells the shell to print the matching history command
```bash
!ls:p    # print the command, rather than repeat it
```
