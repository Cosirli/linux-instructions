# Types of streams

There are 3 main data stream when u run a Linux command (stream ID, aka *file descriptor*): 

- stdin: the source of input data, stream ID: 0
- stdout: the outcome of command, stream ID: 1
- stderr: the error message produced, stream ID: 2


## Redirect out data stream
`>&` redirects one out data stream (stdout/stderr) to another. Put it at the end of a command.
```bash
# display both stdout and stderr
ls -l new.txt ff
ls -l new.txt ff 2>&1
ls -l new.txt ff 1>&2

# redirect stdout and stderr to out.txt
ls -l new.txt fff > out.txt 2>&1
ls -l new.txt fff 2> out.txt >&2   # short for '1>&2'
```

`&>`: A shortcut to redirect both stdout and stderr to a file. Example:
```bash
ls -l new.txt fff &> out.txt
```

The redirected-to-target file is created before the intended command is run since it needs to have the output destination ready to which the output will be sent.


## pipe redirection
Pipe redirection: send the stdout of a command to the stdin of another command

Stream is just a chuck of data, which cannot be parsed as arguments. This is where commands like `xargs` that can convert text into arguments come into play. Example: 

```bash
find . -type f -name "*.txt" | xargs -t -I{} mv {} ../new_dir/
```

## tee

Display the standard output and save it to a file simultaneously.

`tee` reads from stdin and writes to both stdout and files. Since it reads from stdin, it is always used in conjugation of another command. Syntax: 

```bash
tee [option]... [FILE]...
```

### Options
- `-a` Append instead of overwrite.

### Common use
```bash
ls | sudo tee /root/temp_output.txt
```

## Named pipe
```bash
mkfifo myfifo
gpg --cipher-algo aes256 -c <myfifo> mysecret
# in another terminal:
cat <<< "GNU's Not Unix" >myfifo
```

# Process substitution

`<()`

for fish: `| psub`


# Here Document

Here Document (HereDoc) allows you to provides multiple lines of input to a command.
  [Reference blog](https://linuxize.com/post/bash-heredoc/)

```bash
[COMMAND] <<[-] 'DELIMITER'
	HERE-DOCUMENT
DELIMITER
```
Notes: 
- If the 'DELIMITER' is **unquoted**, the shell will substitute all variables, commands and special characters before passing the HereDoc lines to the command.
- When the delimiter is **quoted** no expansion is done.
- Appending a minus sign to the redirection operator `<<-` will cause all leading tab characters to be ignored. This allows you to *indent* your code when writing here-documents in shell scripts. Leading whitespaces are not allowed, tab only.  
- The last line ends with the delimiting identifier. Leading whitespace is not allowed.

Test script: 

```bash
#!/usr/bin/bash
msg="Hello" day=$(date +%A)
<<- block_comment
if true; then
	echo "$msg $USER!"    # leading tab is okay
fi
block_comment
echo "It's $day today."

# Unquoted Delimiting identifier:
cat <<- EOF
working dir: $PWD
	user:$(whoami)
	EOF

# Quoted:
cat <<- "EOF" # or 'EOF'
working dir: $PWD
	user:$(whoami)
EOF

echo 'Comparing leading tabs under `<<-` and `<<`'
cat << EOF
	leading tab with `<<`
EOF     # here you cannot prefix a tab, since `<<-` is not used

cat <<- EOF
	leading tab with `<<-` (ignored)
	EOF
```
If you are debugging your code and want to comment out blocks of code, you may use heredoc. Otherwise, avoid using it since it’s not a shell built-in feature.

## Using Heredoc with SSH
If you want to execute commands remotely by HereDoc with *unquoted delimiter*, make sure you ***escape*** all variables, commands and special characters (using backslash), otherwise they will be interpolated (expanded) locally:

```bash
ssh -T user@host.com << _EOF_
echo "local working directory: $PWD"
echo "remote working directory: \$PWD"
_EOF_
```

output: 
```text
local working directory: /home/linuxize
remote working directory: /home/serveruser
```

# Here String

Syntax: `command <<< str`   

You can also feed a string to a command's `stdin` like this:
`echo "$string" | command`. However in Bash, introducing a pipe means the individual commands are run in subshells. Consider this:  

```bash
echo "hello world" | read first second
echo $second $first
```

In bash, the output of the 2nd `echo` command prints just a single space. Because the `read` command is in a pipeline, it is run in a subshell. When the subshell exits, variables are lost.

To remedy this confusing situation, use a *here string:*  

```bash
read first second <<< "hello world"
```

Other use cases:
```bash
tr a-z A-Z <<< "text"
fdisk /dev/nvme0n1p1 <<< m | less
```
