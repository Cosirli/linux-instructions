## Scroll up and down
Ctrl + F	Page Down Ctrl + B	Page Up Ctrl + D	Scroll Down by half a screen Ctrl + U	Scroll Up by half a screen

## Scroll relative to cursor

Ctrl-y  Scroll up `{count}` lines without moving the cursor.

Ctrl-e  Scroll down `{count}` lines without moving the cursor.

zb  bottom

zz

z<CR>

Redraw, line [count] at **top** of window (default cursor line).  Put cursor at first non-blank in the line.

zt

Like "z<CR>", but leave the cursor in the same column.

z{height}<CR>

Redraw, make window {height} lines tall.  This is useful to make the number of lines small when screen updating is very slow.  Cannot make the height more than the physical screen height.

z.

Redraw, line [count] at **center** of window (default cursor line).  Put cursor at first non-blank in the line.

zz

Like "z.", but leave the cursor in the same column. Careful: If caps-lock is on, this command becomes "ZZ": write buffer and exit!

z-

Redraw, line [count] at **bottom** of window (default cursor line).  Put cursor at first non-blank in the

line.

zb

Like "z-", but leave the cursor in the same column.

## Scroll horizontally

## Scroll synchronously

