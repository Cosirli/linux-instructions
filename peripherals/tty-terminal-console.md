# Terminal, console and shell

## **T**ele**ty**pewriter (**TTY**)

```
Teletypewriter
      |
      |
      |
UART (Universal Asynchronous Receiver and Transmitter)
      |
      |
      |
UART driver
      |
      |
      |
TTY driver (with line displine)
      |
      |
      |
User processes
```

## Terminal and Host computer


## Terminal Emulator

```

Monitor   ----  driver --- 
                           '
                           '
                           ' --- Terminal Emulator --- TTY driver --- User proc
                           '
                           '
Keyboard  ----  driver --- '
```


### Virtual console
Provided by kernal space 

Console: originally means a control panel


### Pseudo terminal
Provided by user space


## Manipulation and commands

```bash
tty
ls /dev/pts
echo "hello tty1 from tty2" > /dev/pts/1
```


## How pseudo terminal interacts with tty driver
