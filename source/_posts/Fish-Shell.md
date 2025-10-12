---
title: Fish Shell
top: false
cover: false
toc: true
description: everyday fish shell
categories:
  - Programming
  - Tools
  - Shell
tags:
  - Fish
abbrlink: 5fb5d34d
date: 2022-05-04 09:43:16
password:
summary:
---

# Add or Remove `PATH` in fish

To permanently add the path /opt/cuda/bin to your PATH variable, use the command
`fish_add_path /opt/cuda/bin`. This will ensure the path remains in your
environment even after restarting the terminal, without needing to include the
command in config.fish.

`set --erase --universal fish_user_paths[4]` can erase the 4th path universally
so it persists in new sessions.

I prefer to use a global fish_user_paths. This is not save automatically, I need
to add this to `config.fish`, if I want it to stay:

`fish_add_path -g /opt/cuda/bin`

# Lazy-Loading Conda for Faster Shell Startup

In machine learning, we often use conda to manage our python environments, and
have several conda installations (on network drives, in $HOME, etc…). It can be
a pain to manage them. Worse still, since conda loads on shell startup, it can
noticeably slow you down when opening terminals – especially when loading it off
a slow network.

Here’s a simple trick for your shell config to alleviate the pain:

```fish
set -x CONDA_PATH /opt/miniconda3/bin/conda $HOME/miniconda3/bin/conda

function conda
    echo "Lazy loading conda upon first invocation..."
    functions --erase conda
    for conda_path in $CONDA_PATH
        if test -f $conda_path
            echo "Using Conda installation found in $conda_path"
            eval $conda_path "shell.fish" "hook" | source
            conda $argv
            return
        end
    end
    echo "No conda installation found in $CONDA_PATH"
end
```

This snippet is for the fish shell and goes in your `config.fish`. It replaces
the block that conda auto-generates when you run `conda init fish` (the one that
begins with `# !! Contents within this block are managed by 'conda init' !!`).

# Configuration of shortcuts for fish

Use bind to configure the shortcuts, e.g.,
`bind -M insert \ck 'accept-autosuggestion'`. `-M` is used to define the mode of
the shortcut. `accept-autosuggestion` is the input function, which means accept
the current autosuggestion. For more special function see
[this](https://fishshell.com/docs/current/cmds/bind.html).

In fish `bind -M normal` can not work for normal mode of vi input method.
However, `bind -M default` works fine for the normal mode of the vi input
method.

## Shortcut to copy contents selected in visual model to the clipboard.

`bind --mode visual --sets-mode default Y 'fish_clipboard_copy; commandline -f repaint-mode; commandline -f end-selection'`

`--sets-mode default` go back to the normal mode after `fish_clipboard_copy`.

`commandline -f repaint-mode` can refresh the mode then show `N` (normal mode),
otherwise it will show `V`, even though it has already gone back to normal mode
by `--set-mode default`.

`commandline -f end-selection` can stop selection, otherwise it will still
highlight the contents which are selected before.

`commandline -f function` is useful. The detail of the functions can be used see
'man bind'.

# Set the default editor in fish

[fzf](https://github.com/jethrokuan/fzf) allows fish to use fuzzy search. `\co`
is a shortcut of fzf-fish to open a file by fuzzy search with default editor.
The default editor can be set by `set -gx EDITOR nvim`.
