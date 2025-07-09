
```bash
tmux attach -t NUM    # attach to session NUM
```

# Session
- `C-b d`: Detach the current client.

# Window

- `C-b c`: Create a new window.
- `C-b l`: Switch to the most recently window.
- `C-b p`: Switch to the \[p\]revious window.
- `C-b w`: Display all windows and choose a window interactively.

# Pane

- `C-b x`: Kill the pane
- `C-b %`: Split pane into left and right, focus on the right.
- `C-b "`: Split pane into top and bottom, focus on the bottom.
- `C-b <Arrow>`: Switch pane
- `C-b q NUM`: Switch to pane NUM.
- `C-b z`: Toggle zoom state (full-screen) of the current pane.


             C-b         Send the prefix key (C-b) through to the application.
             C-o         Rotate the panes in the current window forwards.
             C-z         Suspend the tmux client.
             !           Break the current pane out of the window.
             "           Split the current pane into two, top and bottom.
             #           List all paste buffers.
             $           Rename the current session.
             %           Split the current pane into two, left and right.
             &           Kill the current window.
             '           Prompt for a window index to select.
             (           Switch the attached client to the previous session.
             )           Switch the attached client to the next session.
             ,           Rename the current window.
             -           Delete the most recently copied buffer of text.
             .           Prompt for an index to move the current window.
             0 to 9      Select windows 0 to 9.
             :           Enter the tmux command prompt.
             ;           Move to the previously active pane.
             =           Choose which buffer to paste interactively from a list.
             ?           List all key bindings.
             D           Choose a client to detach.
             L           Switch the attached client back to the last session.
             [           Enter copy mode to copy text or view the history.
             ]           Paste the most recently copied buffer of text.
             c           Create a new window.
             d           Detach the current client.
             f           Prompt to search for text in open windows.
             i           Display some information about the current window.
             l           Move to the previously selected window.
             m           Mark the current pane (see select-pane -m).
             M           Clear the marked pane.
             n           Change to the next window.
             o           Select the next pane in the current window.
             p           Change to the previous window.
             q           Briefly display pane indexes.
             r           Force redraw of the attached client.
             s           Select a new session for the attached client interactively.
             t           Show the time.
             w           Choose the current window interactively.
             x           Kill the current pane.
             z           Toggle zoom state of the current pane.
             {           Swap the current pane with the previous pane.
             }           Swap the current pane with the next pane.
             ~           Show previous messages from tmux, if any.
             Page Up     Enter copy mode and scroll one page up.
             Up, Down
             Left, Right
                         Change to the pane above, below, to the left, or to the right of the current pane.
             M-1 to M-5  Arrange panes in one of the seven preset layouts: even-horizontal, even-vertical, main-horizontal, main-horizontal-mirrored, main-vertical, main-vertical, or tiled.
             Space       Arrange the current window in the next preset layout.
             M-n         Move to the next window with a bell or activity marker.
             M-o         Rotate the panes in the current window backwards.
             M-p         Move to the previous window with a bell or activity marker.
             C-Up, C-Down
             C-Left, C-Right
                         Resize the current pane in steps of one cell.
             M-Up, M-Down
             M-Left, M-Right
                         Resize the current pane in steps of five cells.


