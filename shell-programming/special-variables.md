`bash` uses many special variables to represent parameters, error codes, and related variables.  

```bash
$0    # Name of the script

$1 to $9    # The first argument and so on

$@    # all args

$#    # (hash): Number of arguments

!!    # the previous command

$?    # Return (err) code of the previous command

$$    # PID of the current script

$_    # The last argument from the previous command.
			# If you are in an interactive shell, 
			# you can also quickly get this value 
			# by typing Esc followed by . or Alt+.
```
