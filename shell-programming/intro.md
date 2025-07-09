# Variables
The syntax for assigning a value to a variable is `foo=bar`, and to access the value stored in a variable, the syntax is `$foo`. Note that `foo = bar` will not work, the interpreter will try to run a program `foo` with 2 arguments.
```bash
var=hello\ shell  # fish: set var hello\ shell
echo $var
```
## Special variables
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

Exit codes can be used to conditionally execute commands using `&&` and `||`, both of which are [short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) operators.

Commands can be separated within the same line using a semicolon `;`. The `true` program will always have a 0 return code and the `false` command will always have a 1 return code.



# Strings

Strings delimited with `'` are *literal* strings that won't substitute variable with their values whereas `"` delimited strings will.

```bash
str="hello strings"
echo "str = $str"    # output: str = hello strings
echo 'str = $str'    # output: str = $str
```


# Conditionals

## Control Structures

### Test expressions

```bash
[ -e file ]       # file exists => true
[ string ]        # string not empty => true
[ str1 != str2 ]  # str1 and str2 are diffenent => true
[ int1 -eq int2 ] # int1 equals to int2 => true
```

```bash
if [[ $? -ne 0 ]]; then
        echo "File $file does not have any foobar, adding one"
        echo "# foobar" >> "$file"
    fi
```

Bash implements many comparisons of this sort - you can find a detailed list in the manpage for [`test`](https://www.man7.org/linux/man-pages/man1/test.1.html)


### Conditionals
```bash
touch hello
if [ -f hello ]; then
    echo "yes"
elif [ -f tryhello ]; then
    echo "try"
else
    echo "no"
fi

[ -f hello ] && echo yes || echo no
```

#### `[[]]`: a bash extension

Supports regex.
```bash
a=01
if [[ "$a" =~ ^-?[0-9]+$ ]] then
    echo "integer"
else
    echo "no"
fi
```

#### `(())`: conditional for arithmetic operations
```bash
a=-1; if (( a>= 0)); then echo positive; else echo negative; fi
```

### Loops

For loop: 
```bash
for i in 1 2 3 4 5; do
    echo $i
done
```

While loop: 
```bash
while [ expr ]; do
    # do something
done
```

#### Example: batch process files

Rename:
```bash
n=0; for i in $(command ls -tr); do mv "$i" "$n-$i"; n=$((n+1)); done
```

Edit:
```bash
for i in 0[0-9]?*; do sed -i '/@since/s/$/,\ 2026/' $i; done
```

Execute repeatedly:
```bash
cnt=0; for i in {1..100}
    do stdout=$(./ctarget -i raw3.txt | grep PASS)
    if [[ ${stdout} == "PASS" ]]; then 
	((cnt++)); fi
done; echo $cnt
```


# Functions

```bash
cdls () {
    cd $1
    ls
}
```


# Shebang
```bash
#!/usr/bin/python3
import sys
for arg in reversed(sys.argv[1:]):
    print(arg)
```
[**shebang**](https://en.wikipedia.org/wiki/Shebang_(Unix)) is a special comment that tells the kernal which interpreter to use to execute the script, usually located at the top of a script.

It is good practice to write shebang lines using the [`env`](https://www.man7.org/linux/man-pages/man1/env.1.html) command that will resolve to wherever the command lives in the system, increasing the *portability* of your scripts. To resolve the location, `env` will make use of the `PATH` environment variable. For this example the shebang would look like `#!/usr/bin/env python3`.

# Array

```bash
a=(1 2 3)
echo $a
echo ${a[1]}
packages=(htop mpv yay)
for pkg in ${packages[@]}; do
    sudo pacman -S --needed ${pkg}
done
```
