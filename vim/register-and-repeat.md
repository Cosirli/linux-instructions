# Register

Used to store contents

`:reg {register}`: Check the content in the corresponding register

## Special registers

`"` unnamed register: the last deleted/yanked text, regardless of whether a specific register was used

`%` contains the name of the current file

`:` the most-recent executed command-line

`.` the last inserted text

`0` the yank register

`=` the expression register

There are ten types of registers:		*registers* *{register}* *E354*
1. The unnamed register ""
2. 10 numbered registers "0 to "9
3. The small delete register "-
4. 26 named registers "a to "z or "A to "Z
5. Three read-only registers ":, "., "%
6. Alternate buffer register "#
7. The expression register "=
8. The selection and drop registers "*, "+ and "~ 
9. The black hole register "_
10. Last search pattern register "/

## Specify register

### Normal mode / Visual mode
Prefix action with `"{register}`.

lowercase letter: obliterate existing contents and write to the specified register

uppercase letter: append contents to the end of the existing contents in the specified register

### Insert mode
Press <C-r> followed by {register}

# Macros

Record a series of key strokes (typed characters) and then you can replay these operations. Macros are stored in the specified register.

`q{register}`    start recording a macro, to be stored in the specified register. press `q` to stop.

`@{register}`    replay the macro (`{register}` can be one of: `{0-9a-z".=*+}`)

`@@` replay the previous macro

Note: the `.` command doesn’t work for macros, since `.` only repeats the last modification, while a macro may contain multiple modifications.

## Automatic incrementing / decrementing

<img src="https://www.joshmorony.com/images/totw/28-desired.png" alt="https://www.joshmorony.com/images/totw/28-desired.png" style="zoom: 60%;" />

To do this, I could `yank` the text I want to paste at the beginning of each line and then repeat: `j` (go down a line) `0` (go to start of line) `P` (paste before cursor). This is a very repetitive task that is well suited to a macro.

All I needed to do instead was press: `qw` (this starts recording a macro in the `w` register), repeat the same actions above, `q` (stop recording the macro).

With the macro recorded I can now repeat it by pressing `@w` this will repeat it once, or I can do `10@w` to repeat it `10` times or however many times I need.

This sped things up a great deal, but you might be able to tell that I actually wanted these numbers to increment on each line, not just be a bunch of zeroes.

After failing to do this with a macro, I found that you can simply select the numbers as a block with `Ctrl-V`:

<img src="https://www.joshmorony.com/images/totw/28-select.png" style="zoom: 40%;" >

Then hit `g Ctrl-A` - this will increment all of the numbers:

<img src="https://www.joshmorony.com/images/totw/28-increment.png" style="zoom:40%;" width=1680>

`Ctrl-A` will increment, `Ctrl-X` will decrement, and prefixing with `g` is what increments each line by an increasing number (rather than just incrementing them all by the same amount).

