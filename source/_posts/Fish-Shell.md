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
