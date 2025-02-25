Assuming your tmux command shortcut is the default: Ctrl+b, then:

1. `Ctrl`+`b`, `[` Enter copy(?) mode.
2. Move to start/end of text to highlight.
3. `Ctrl`+`Space`

Start highlighting text (on Arch Linux). When I've compiled tmux from source on OSX and other Linux's, just Space on its own usually works. Selected text changes the colors, so you'll know if the command worked.

1. Move to opposite end of text to copy.
2. `Alt`+`w` Copies selected text into `tmux` clipboard.
    On Mac, use `Esc`+`w`. Try `Enter` if none of the above work.
3. Move cursor to opposite tmux pane, or completely different tmux  window. Put the cursor where you want to paste the text you just copied.
4. `Ctrl`+`b`, `]` Paste copied text from tmux clipboard.

`tmux` is quite good at mapping commands to custom keyboard shortcuts.

See `Ctrl`+`b`,`?` for the full list of set keyboard shortcuts.