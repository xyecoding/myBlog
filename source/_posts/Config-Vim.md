---
title: Config Vim
top: false
cover: false
toc: true
mathjax: true
description: Vim Configuration
categories:
  - Programming
  - Tools
  - Vim
tags:
  - Vim
abbrlink: 730c940e
date: 2022-01-20 10:24:34
password:
summary:
---

# 安装 anaconda

本来安装 anaconda 应该问题不大，但是却发现了一个问题。
`./Anaconda3-2021.11-Linux-x86_64.sh: 489: [[: Exec format error` 这个错，是因为
直用./Anaconda.sh 启动安装默认用的是 sh 改成了 bash Anaconda.sh 就不会报错了.

# 一些碎的 Linux 知识

## 查找包的安装位置

一些软件用 apt install 了，但是不知道安装位置在哪里 `dpkg -L xxx`显示包的安装位
置．

## 编译错误定位

编译的时候,打印一些 log 但是并不详细一般会有更加详细的编译 log 文件，在里面可以
更精确的定位错误发生的原因．

## linux 的环境变量可能是两个

`LIBRARY_PATH`编译的时候用到的库的搜索路径 `LD_LIBRARY_PATH`程序加载时库的搜索路
径

## 遇到一个问题明明再搜索路径下有动态库，却报错所无法找到

okular: error while loading shared libraries: libQt5Core.so.5: cannot open
shared object file: No such file or directory 用 strip 处理完之后解决 sudo strip
--remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

# 编译 vim

apt 安装的 vim 不能随意的控制 vim 的特性，比如在 latex 反向搜索的时候需要的
+clietservice。 apt-cache search libc-dev ln -s libXtst.so.6 libXtst.so 综合两篇
博客。 https://www.jianshu.com/p/aa5ea81bbc72
https://toutiao.io/posts/runvgs/preview 尽量多的保留特性，最终得到的 config 命令
是

```python
./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-python3interp=yes \
    --enable-perlinterp=yes \
    --enable-cscope \
    --enable-fontset \
    --enable-largefile \
    --enable-fail-if-missing \
    --prefix=/path-to-install
```

`--enable-fail-if-missing` 用于显示错误信息。

## 很久没有成功，最后 apt 安装解决了

编译的时候 feature 用了 hug，但是还是没有增加+clientserver。我估计是缺少库。查
src/auto/cofig.log 也没有发现很相关的信息。最后`sudo apt-get install vim-gtk`成
功安装了+clientserver 的 vim。

# tmux

To enable vi key mode in tmux. I mapped `hjkl` for select the pane.

```
bind -r 'h' select-pane -L  # move left
bind -r 'j' select-pane -D  # move down
bind -r 'k' select-pane -U  # move up
bind -r 'l' select-pane -R  # move right
```

`r` means I can change the pane continually by click `<prefix>` and twice `k`.

# A practice of vim

## Search and Replace

`:.,$s/old/new/gc`, where `g` means match all for each line and `c` means ask me
before replace at each position. Without `g` only the first match of each line
will be considered.

# Why lua instead of vimL(vim script)

## Introduction

Neovim has an embedded lua 5.1 runtime which is used to create faster and more
powerful extentions of you favorite efitor.

1. VimL is a slow interpreted language with almost no optimizations. Much of the
   time spent in vim startup and in actions from plugins that can block the main
   loop in the editor is in parsing and executing vim script.

## How to use lua in command line or vimL file

see `:h lua`.

- From the vim command line, you can run `lua <you code>`. This is useful for
  keybindings, commands, and other one-off execution cases.
- Inside of a vimL file, you can demarcate lua code with the follow code
  fencing:

```vim
lua << EOF
-- your lua code
EOF
```

- Inside of a vimL file you can use the `lua` keyword to execute commands
  similar to the first example,i.e., `lua <your code>`.

One important note here is that Neovim will look for lua code in the
`runtimepath` you've set in your settings. Additionally, it will append your
runtimepath with `/lua/?.lua` and `lua/?/init.lua` so it is common practice to
see a `/lua` sub-directory inside `nvim`. For more detailed information about
where Neovim looks for lua code, check out `:h lua-require`.

[More Information](https://github.com/nanotee/nvim-lua-guide)

# Debug vim

1. `:message/:mes` will display the messages that your configuration files
   print.
2. `:nmap` or `:imap` can check all the shortcuts of normal or insert mode.
   `:map` lists the shortcuts of all modes. However, I find that some shortcuts
   defined can not be find by `:map`.

# A Practice for `Neovim-from-scratch`

## Install

1. Plugins are defined in `~/.config/nvim/lua/user/plugins.lua`. The plugins
   will fail to be installed due to the internet of China Mainland. Thus, git is
   asked to be configured with ssh. Then the path of plugins can be changed by
   add `git@github.com:` before the original path.
2. `treesitter` is a plugin for syntax-hight. It will install a series of
   language parsers. They are defined in
   `~/.config/nvim/lua/user/treesitter.lua`. By setting
   `ensure_installed = {'astro', 'xxx'}`, we can define the parsers to be
   download. Also, download errors may be occurred due to the internet. The path
   of these language parsers are defined in
   `~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/lua/nvim-treesitter/parsers.lua`,
   which may be changed by download with ssh.

## Analysis

1. There are 21 files required in `init.lua`. They are exactly the 21 files in
   `lua/user` folder. About 34 plugins are defined in `plugins.lua`. The lua
   files are all the configuration file of the plugins defined in `plugins.lua`,
   except for `keymaps.lua`, `option.lua`, `autocommand.lua`. `plugins.lua`
   itself is the configuration file of `packer.nvim`, a plugin manager.
2. Here gives a brief look at the plugins.

   1. `packer.nvim` is a plugin manager.
   2. `Alpha-vim` is a plugin used by Neovim-from-scratch. It allow one to
      custom the greeter for neovim
   3. `popup.nvim`, An implementation of the Popup API from vim in neovim.
   4. `plenary.nvim`, implement some useful window management items for neovim.
   5. `nvim-autopais` A super powerful auto pair plugin for neovim that supports
      multiple characters.
   6. `Comment.nvim` Smart and Powerful commenting plugin for neovim.
   7. `nvim-web-devicons` A lua fork of `vim-devicons`. This plugin provides the
      same icons as well as colors for each icon
   8. `nvim-tree-lua` A file explorer for neovim written in lua.
   9. `bufferline.nvim` A snazzy buffer line (with tabpage integration) for
      neovim built using lua.
   10. `vim-bbye` Bbye allows you to do delete buffers (close files) without
       colosing you windows or messing up your layout.
   11. `lualine.nvim` A blazing fast and easy to configure neovim status line
       written in lua.
   12. `toggleterm.nvim` A neovim plugin to persist and toggle multiple
       terminals during an editing session.
   13. `project.nvim` an all in one neovim plugin written in lua that provides
       superior project management.
   14. `impatient.nvim` speed up loading lua modules in neovim to improve start
       up time.
   15. `indent-blankline.nvim` adds indentation guides to all lines (including
       empty lines.)
   16. `FixCursorHold.nvim` This is needed to fix lsp doc highlight.
   17. `which-key.nvim` a lua plugin that displays a popup with possible key
       bindings of the command you started typing.
   18. `darkplus.nvim` color themes
   19. `nvim-cmp` The completion plugin
   20. `cmp-buffer` buffer completions
   21. `cmp-path` path completions
   22. `cmp-cmdline` cmdline completions
   23. `cmp_luasnip` snippet completions.
   24. `cmp-nvim-lsp` nvim-cmp source for neovim's built-in language server
       client.
   25. `LuaSnip` snippet engin
   26. `friendly-snippets` a bunch of snippets to use
   27. `nvim-lspconfig` A collection of common configurations for neovim's
       built-in language server clinet. Features: go-to-definition,
       find-references, hover, completion, rename, format, refactor.
   28. `nvim-lsp-installer` allows you to seamlessly install LSP server
       locally(inside `:echo stdpaht("data")`)
   29. `nlsp-settings.nvim` A plugin to configure LSP using json/yaml files like
       `coc-setting.json`
   30. `null-ls.nvim` for formatters and linters, use neovim as a language
       server to inject LSP diagnostic, code actions, and more via lua
   31. `telescope.nvim` a highly extendable fuzzy finder over lists.
   32. `nvim-treesitter` both provide a simple and easy way to use the interface
       for `tree-sitter` in neovim and to provide some basic functionality such
       as highlighting based on it.
   33. `nvim-ts-context-commentstring"` setting `comment string` option based on
       the cursor location in the file. The location is checked via treesitter
       queries.
   34. `gitsigns.nvim` Git

3. The plugins are installed in `~/.local/share/nvim/site/pack/packer/start`,
   which is defined in the `install_path` in `plugins.lua`.

# Analyze `LunarVim`

## The Install Script `install.sh`

25 functions are defined in `install.sh`.

```tex
    __attempt_to_install_with_cargo
    __install_nodejs_deps_npm
    __install_nodejs_deps_pnpm
    __install_nodejs_deps_yarn
    __validate_node_installation
    backup_old_config
    check_neovim_min_version
    check_system_deps
    clone_lvim
    detect_platform
    install_nodejs_deps
    install_python_deps
    install_rust_deps
    link_local_lvim
    main
    msg
    parse_arguments
    print_logo
    print_missing_dep_msg
    remove_old_cache_files
    setup_lvim
    setup_shim
    usage
    validate_lunarvim_files
    verify_lvim_dirs
```

The last line `main "$@"` shows that it well execute the `main` function first.
`$@` means that all the args will be passed to the function.

### Function `main`

```bash
function main() {
# function parse_arguments is defined to parse the arguments passed by
# "$@$"
  parse_arguments "$@"

  # print the logo of lunarvim
  print_logo

  msg "Detecting platform for managing any additional neovim dependencies"
  detect_platform
  # check if the git and neovim is installed
  check_system_deps

  if [ "$ARGS_INSTALL_DEPENDENCIES" -eq 1 ]; then
    if [ "$INTERACTIVE_MODE" -eq 1 ]; then
      msg "Would you like to install LunarVim's NodeJS dependencies?"
      read -p "[y]es or [n]o (default: no) : " -r answer
      [ "$answer" != "${answer#[Yy]}" ] && install_nodejs_deps

      msg "Would you like to install LunarVim's Python dependencies?"
      read -p "[y]es or [n]o (default: no) : " -r answer
      [ "$answer" != "${answer#[Yy]}" ] && install_python_deps

      msg "Would you like to install LunarVim's Rust dependencies?"
      read -p "[y]es or [n]o (default: no) : " -r answer
      [ "$answer" != "${answer#[Yy]}" ] && install_rust_deps
    else
      install_nodejs_deps
      install_python_deps
      install_rust_deps
    fi
  fi

  # backup old config of lunarvim if it is installed before
  backup_old_config
  # if the paths are not already, mkdir them
  verify_lvim_dirs

  if [ "$ARGS_LOCAL" -eq 1 ]; then
    link_local_lvim
  elif [ -d "$LUNARVIM_BASE_DIR" ]; then
    validate_lunarvim_files
  else
    clone_lvim
  fi

  setup_lvim

  msg "Thank you for installing LunarVim!!"
  echo "You can start it by running: $INSTALL_PREFIX/bin/lvim"
  echo "Do not forget to use a font with glyphs (icons) support [https://github.com/ryanoasis/nerd-fonts]"
}
```

### Function `clone_lvim`

```bash
function clone_lvim() {
  msg "Cloning LunarVim configuration"
  if ! git clone --branch "$LV_BRANCH" \
    # to download by ssh, change this line to
    # `--depth 1 "git@github.com:LunarVim/LunarVim.git" "$LUNARVIM_BASE_DIR"; then`
    --depth 1 "https://github.com/${LV_REMOTE}" "$LUNARVIM_BASE_DIR"; then
    echo "Failed to clone repository. Installation failed."
    exit 1
  fi
}
```

### Function `setup_lvim`

```bash
function setup_lvim() {

  remove_old_cache_files

  msg "Installing LunarVim shim"

  # output the executable file of `lvim` which lies in `~/.local/bin/lvim`
  setup_shim

  cp "$LUNARVIM_BASE_DIR/utils/installer/config.example.lua" "$LUNARVIM_CONFIG_DIR/config.lua"

  echo "Preparing Packer setup"

  # Prepare Packer, this is done by `nvim -u init.lua --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'`
  # `--headless` means Don't start a user interface.
  # `-c <cmd>` means Execute <cmd> after config and first file

  # packer is often failed to be setup due to the network of the China Mainland

  # Packer's operation are asynchronous. Previously, to install plugins in a non
  # -interactive way, `nvim + PackerSync + 30sleep + quitall`.
  # It is not ideal since we do not really know that after 30 seconds, the plugin
  # install process should finish.
  # A more ideal way is to use autocmd PackerComplete
  # https://github.com/wbthomason/packer.nvim/blob/master/doc/packer.txt#L479
  # provided by Packer
  # `nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'`
  # PackerComplete xxx: Fires xxx after install, update, clean, and sync
  # asynchronous operations finish
  # PackerSync: Perform 'PackerUpdate' and then 'PackerCompile'
  # PackerUpdate: Clean, then update and install plugins
  # PackerCompile: You must run this or 'PackerSync' whenever you make
  # changes to your plugin configuration. Regenerate compiled loader file.

  "$INSTALL_PREFIX/bin/lvim" --headless \
    -c 'autocmd User PackerComplete quitall' \
    -c 'PackerSync'

  echo "Packer setup complete"
}
```

### Function `setup_shim`

```bash
function setup_shim() {
 #  make -C ~/.local/share/lunarvim/lvim install-bin
 # `-C` specifies the directory of `Makefile`
 # `install-bin` is a target defined in `Makefile`
 # install-bin:
 #	@echo starting LunarVim bin-installer
 #	bash ./utils/installer/install_bin.sh
 # This command outputs `~/.local/bin/lvim`, the executable file of `lvim`,

  make -C "$LUNARVIM_BASE_DIR" install-bin
}
```

The `~/.local/bin/lvim` is

```bash
#!/bin/sh

export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"~/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"~/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"~/.cache/nvim"}"

 # `exec` is a builtin command of the Bash shell. It allows you to execute a
 # command that completely replaces the current process. The current shell process
 # is destroyed, and entirely replaced by the command you specify.
 # `-u` means use this config file, which is `~/.config/share/lunarvim/lvim/init.lua`
exec nvim -u "$LUNARVIM_RUNTIME_DIR/lvim/init.lua" "$@"

```

### Function `msg`

Message or log is an effective tool to debug and make the users know the detail
of the programming. Instead of simply using `print/echo` function, most
programmers define their message functions to enable effective message giving.
Have a look at this message function.

```bash
function msg() {
# local variable receives the message needed to be print.
  local text="$1"
  local div_width="80"
  # before print the message a line comprised of `-` will be printed.
  # it will makes the message easily been noticed.
  # div_width gives the width of the line.
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}
```

## ABout the init process

### The `init.lua`

```lua
-- init_path = '~/.local/share/lunarvim/lvim/init.lua'
-- base_dir = '~/.local/share/lunarvim/lvim/'
local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

-- vim.opt return a option object
-- rtp mean runtimepath
if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end
-- bootstrap file is in lua/lvim/, which is the guide file of lvim
-- NOTICE THAT, the end of the bootstrap file, return a local module M,
-- which is defined at the beginning of the file.
-- Thus, the term :init(base_dir) runs the init function of module M.
require("lvim.bootstrap"):init(base_dir)

require("lvim.config"):load()

-- the plugins are defined in lua/lvim/plugins.lua
local plugins = require "lvim.plugins"

-- the same as init funtion in bootstrap, `load` is a function of the module in
-- plugins-loader

require("lvim.plugin-loader").load { plugins, lvim.plugins }

local Log = require "lvim.core.log"
Log:debug "Starting LunarVim"

local commands = require "lvim.core.commands"
commands.load(commands.defaults)

require("lvim.lsp").setup()
```

### The `Bootstrap:init`

```lua
---Initialize the `&runtimepath` variables and prepare for startup
---@return table
function M:init(base_dir)
  self.runtime_dir = get_runtime_dir()
  self.config_dir = get_config_dir()
  self.cache_dir = get_cache_dir()
  self.pack_dir = join_paths(self.runtime_dir, "site", "pack")
  self.packer_install_dir = join_paths(self.runtime_dir, "site", "pack", "packer", "start", "packer.nvim")
  self.packer_cache_path = join_paths(self.config_dir, "plugin", "packer_compiled.lua")

  ---Get the full path to LunarVim's base directory
  ---@return string
  function _G.get_lvim_base_dir()
    return base_dir
  end

  if os.getenv "LUNARVIM_RUNTIME_DIR" then
    -- vim.opt.rtp:append(os.getenv "LUNARVIM_RUNTIME_DIR" .. path_sep .. "lvim")
    vim.opt.rtp:remove(join_paths(vim.fn.stdpath "data", "site"))
    vim.opt.rtp:remove(join_paths(vim.fn.stdpath "data", "site", "after"))
    vim.opt.rtp:prepend(join_paths(self.runtime_dir, "site"))
    vim.opt.rtp:append(join_paths(self.runtime_dir, "site", "after"))

    vim.opt.rtp:remove(vim.fn.stdpath "config")
    vim.opt.rtp:remove(join_paths(vim.fn.stdpath "config", "after"))
    vim.opt.rtp:prepend(self.config_dir)
    vim.opt.rtp:append(join_paths(self.config_dir, "after"))
    -- TODO: we need something like this: vim.opt.packpath = vim.opt.rtp

    vim.cmd [[let &packpath = &runtimepath]]
  end

  -- FIXME: currently unreliable in unit-tests
  if not in_headless then
    _G.PLENARY_DEBUG = false
    require("lvim.impatient").setup {
      path = join_paths(self.cache_dir, "lvim_cache"),
      enable_profiling = true,
    }
  end

  require("lvim.config"):init()

  require("lvim.plugin-loader").init {
    package_root = self.pack_dir,
    install_path = self.packer_install_dir,
  }

  return self
end
```

### The `config` function in `builtin` folder

For some plugins, such as `whichkey` and `telescope`, there are `M.config`
functions in their configuration files. However, the `setup` function only uses
some variable defined in them and do not execute them first. The are executed by
the `init.lua` in the `builtin` folder.

```lua
function M.config(config)
  for _, builtin_path in ipairs(builtins) do
    local builtin = require(builtin_path)
    builtin.config(config)
  end
end
```

During the lunch process, the `config` functions will be called in front of the
functions defined in the configuration file `config.lua`.

## The nerd-fonts

The font is only related to your local devices. It is not related to the remote
device.

To install the nerd fonts, you need to download the nerd version of your fonts,
for example I use `hack`, though
[this](https://www.nerdfonts.com/font-downloads) or
[this](https://github.com/ryanoasis/nerd-fonts). Then put it in your font
directory. For windows, it is `C:\Windows\Fonts`. Finally, restart your terminal
and set your terminal such as mobaxterm to use that font.

## Debug system

### lvim.log

1. The file is in `~/.cache/` which is defined by
   `~/.local/share/lunarvim/lvim/lua/lvim/core/log.lua`. Using `Log:warn/debug`
   will write logs in the file.
2. `lvim.log.level` controls the level that will be print into the `lvim.log`
   (see `local log_level = Log.levels[(lvim.log.level):upper() or "WARN"]` in
   the `log.lua`. `function Log:get_path()` sets the path and name of the log
   file.
3. `log.lua` used `structlog` which is a plugin of nvim defined in the
   `plugins.lua`. In the readme of `structlog`:
   > `structlog` makes logging in lua less painful and more powerful by adding
   > structure to your log entries.

## Plugins

### yank

In the visual mode of `lunarvim`, `y` will yank the select chars into the system
clipboard automatically. Do not use `"+Y`, which will yank the whole line.
`"[~+]y` is also available.

### `project.nvim`

If open vim in a subdirectory of a git package, and then open a new tmux pane or
window, its initial path will be the main directory of that git package. The
`manual mode` in `~/.local/share/lunarvim/lvim/lua/lvim/core/project.lua`
determines vim change the directory or not.

#### With lsp

In the readme of `project`.

> Automagically cd to project directory using nvim lsp. If not then uses pattern
> matching to cd to root directory

This means that lsp has the function to find the project directories.

### Telescope

The `telescope` is depended on `fd`. To install `fd` do not use
`apt install fdclone` which causes a collapse of nvim when run `telescope`.

#### Telescope in which key

`~/.local/share/lunarvim/lvim/lua/lvim/core/which-key.lua` defines many which
key mapping related to telescope. <leader>f can find the files in git repos
which is the feature provided by `telescope.builtin` (see the document of
telescope). `<leader>sf` can find the files in current directory.

### `Comment`

An error occur with `Comment` when open `lvim`, which is solved by adding
`tag = 'v0.6',` to the `plugins.lua` file the Comment part.

### Treesitter

#### Parsers install

11 parsers are defined to be installed in `~/.config/lvim/config.lua`

Parsers often failed to be downloaded. See
`https://github.com/nvim-treesitter/nvim-treesitter#adding-parsers`. One can
download it manually. And change the url of the parsers.

[parsers](https://github.com/nvim-treesitter/nvim-treesitter#language-parsers)

> parser for every language need to be generated via `tree-sitter-cli` from
> `grammer.js` file, then complied to a `.so` library that needd to be placed in
> neovim's `runtimepath` (typically under `parser/{language}.so`). To simplify
> this, `nvim-treesitter` provides commands to automate this process. If the
> language is already supported by `nvim-treesitter` you can install it with
> `TSInstall <language>`

The `{language}.so` files are in
`~/.local/share/lunarvim/site/pack/packer/start/nvim-treesitter.git/parser`.

#### An Error May Occur When using `aerial`

When using aerial, and open a markdown file a error may be occur
`Error executing vim.schedule lua callback: ...c/.local/share/nvim/runtime/lua/vim/treesitter/query.lua:172 : query: invalid field at position 122`.

This is solved by remove the parser of markdown in the parser folder.

<!-- #### Notice -->

<!-- treestter may not always perform a good highlight, e.g., for markdown or tex -->
<!-- files. -->

### About `packer`

1. the some plugins are installed in `opt` directory. Some are installed in
   `start` directory. This is controlled by the settings in `plugins.lua`. 7
   plugins are installed in `opt` directory, 6 of which are setted `event` and
   only the 6 plugins are setted it. `lua-dev` is setted `module`.

   > module = string or list -- Specifies lua module name for require. When
   > requiring a string which starts with one of these module names, the plugin
   > will be loaded.

   > event = string or list, -- Specifies auto command events which load this
   > plugin

   In the Readme of `Packer`

   > `use` takes either a string or a table. If a string is provided, it is
   > treated as a plugin location (link) for a non-optional plugin with no
   > additional configuration.

   [Opt](https://github.com/wbthomason/packer.nvim/issues/237#issuecomment-787457600)

   > `start` packages are always available and loaded every time you start nvim,
   > while `opt` packages are loaded on-demand with the `packadd` command. This
   > is what `packer` uses to conditionally load plugins. `packer` itself
   > doesn't run any code until you call `require('packer')`, so it should be
   > fine to keep it as a start package.

   [Opt](https://github.com/wbthomason/packer.nvim/discussions/823#discussioncomment-2184455)

### LSP

#### The setup process

1. the setup function of a lsp server is defined by the files in
   ` ~/.local/share/lunarvim/site/after/ftplugin`. `ftplugin` directory means
   file type plugin. Vim will auto load this directory when it is in the runtime
   path. However, only the `filetype.lua/vim` will be loaded when open a file of
   particular filetype. ` ~/.local/share/lunarvim/site/after/ftplugin` is
   created by `~/.local/share/lunarvim/lvim/lua/lvim/lsp/templates.lua` (see
   line 67). The server list is given in line 58. The content in the files in
   ftplugins is given in line 40. The `ft.lua` will call `lvim.lsp.manager`
   which is a function defined in
   `~/.local/share/lunarvim/lvim/lua/lvim/lsp/manager.lua`. It setup the lsp
   servers since when `ft.lua` is removed, the lsp server will not start.
2. The configuration files of `nvim-lspconfig` are listed in
   `~/.local/share/lunarvim/site/pack/packer/start/nvim-lspconfig.git/lua/lspconfig/server_configurations`.
   Which can be modified.
3. The servers installed by `lsp-installer` are installed in
   `~/.local/share/nvim/lsp_servers`
4. see `setup` function in `manager.lua`

```lua
function M.setup(server_name, user_config)
  vim.validate { name = { server_name, "string" } }


  if lvim_lsp_utils.is_client_active(server_name) or client_is_configured(server_name) then
    return
  end


  local config = resolve_config(server_name, user_config)

  local servers = require "nvim-lsp-installer.servers"
  local server_available, requested_server = servers.get_server(server_name)

  -- if not server available in nvim-lsp-installer, call lspconfig[server_name].setup(config)
  -- if the server is  available it will be set up by nvim-lsp-installer.
  -- that is to say all the servers will preferentially be set upped by nvim-lsp-installer.

  -- NOTE THAT

  -- Most servers will be set uppped by nvim-lsp-installer by this way.
  if not server_available then
    -- The pcall function calls its first argument in protected mode, so that it
    -- catches any errors while the function is running. If there are no errors, pcall
    -- returns true, plus any values returned by the call. Otherwise, it returns false,
    -- plus the error message.
    pcall(function()
      require("lspconfig")[server_name].setup(config)
      buf_try_add(server_name)
    end)
    return
  end

  local install_notification = false

  if not requested_server:is_installed() then
    if lvim.lsp.automatic_servers_installation then
      Log:debug "Automatic server installation detected"
      requested_server:install()
      install_notification = true
    else
      Log:debug(requested_server.name .. " is not managed by the automatic installer")
    end
  end

  requested_server:on_ready(function()
    if install_notification then
      -- `vim.notify` is defined in `log.lua` in lvim folder.
      -- > `vim.notify` A fancy, configurable, notification manager for NeoVim.
      -- `vim.log.levels.INFO` is defined in the `lua-dev` plunin defined in `plugins.lua`.
      -- > `lua-dev` setup for init.lua and plugin development with full signature help,
      -- > docs and completion for the nvim lua API.
      -- i do not find where the vim.log.levels is required by `manager.lua`.
      -- I think vim.log.levels must be in the search path of nvim thus it can find it
      -- though the search path.
      vim.notify(string.format("Installation complete for [%s] server", requested_server.name), vim.log.levels.INFO)
    end
    install_notification = false
    requested_server:setup(config)
    -- Log:warn(config)
  end)
end
```

From the code we know that most of the servers will be setup by
`nvim-lsp-installer` (see `requested_server:setup(config)`). However, thought
this the configuration for manually setup server is not works. From the document
of `nvim-lsp-installer`,
[server.setup](https://github.com/williamboman/nvim-lsp-installer/blob/40442b67a151fc2a58a790fd7e74a7487f1f9157/doc/nvim-lsp-installer.txt#L349)
is deprecated. Thus I change the `setup` function in `manager.lua`.

```lua
function M.setup(server_name, user_config)
  vim.validate { name = { server_name, "string" } }


  if lvim_lsp_utils.is_client_active(server_name) or client_is_configured(server_name) then
    return
  end


  local config = resolve_config(server_name, user_config)

  local servers = require "nvim-lsp-installer.servers"
  local server_available, requested_server = servers.get_server(server_name)

  -- if the server is installed then setup by lspconfig
  if requested_server:is_installed() then
    pcall(function()
      require("lspconfig")[server_name].setup(config)
      buf_try_add(server_name)
    end)
    return
  end

  local install_notification = false

  -- if the server is not installed, install it
  if not requested_server:is_installed() then
    if lvim.lsp.automatic_servers_installation then
      Log:debug "Automatic server installation detected"
      requested_server:install()
      install_notification = true
    else
      Log:debug(requested_server.name .. " is not managed by the automatic installer")
    end
  end

  requested_server:on_ready(function()
    if install_notification then
      vim.notify(string.format("Installation complete for [%s] server", requested_server.name), vim.log.levels.INFO)
    end
    install_notification = false
    -- requested_server:setup(config)
  end)
end
```

#### the relationship between `lspconfig` and `null-ls`

1. Both of them can use `latexindent` to format the tex file
2. `lspconfig` can not use `prettier`.

Thus `null-ls` provide an extension tools for `lspconfig`. When `lspconfig` can
match our requirement, we do not need to use `null-ls`, e.g., tools for tex
file.

#### the relationship between `lspconfig` and `lsp-installer`

1. `lsp-installer` depends on `lspconfig` as in the readme of `lsp-installer`.
2. lvim strives to have support for all major languages. This is made possible
   by plugins such as `nvim-lspconfig`, for LSP support, and `null-ls` to
   provide support for handing external formatters, such as `prettier` and
   `eslint`.

`lua print(vim.inspect(vim.lsp.buf_get_clients()[2].resolved_capabilities))` see
the detail of server clients.

#### Code Action

Code action = quick fixes and refactoring

### The lualine

The status line is defined in
`~/.local/share/lunarvim/lvim/lua/lvim/core/lualine/init.lua` line 5 which can
be chose as `default`, `lvim`, or `none`. The are defined in the
`~/.local/share/lunarvim/lvim/lua/lvim/core/lualine/styles.lua` file. The
component are defined in
`~/.local/share/lunarvim/lvim/lua/lvim/core/lualine/components.lua`.

### The whichkey

Which key can define key mappings for vim. They are defined in
`~/.local/share/lunarvim/lvim/lua/lvim/core/which-key.lua`. The use of
`telescope` can be learned by reading `which-key.lua`, since the key mapping of
`telescope` is defined in it.

The lsp also used which key, which is defined in
`~/.local/share/lunarvim/lvim/lua/lvim/lsp/config.lua` and used/registered in
`~/.local/share/lunarvim/lvim/lua/lvim/lsp/init.lua`. Which key makes the key
mappings more organized.

#### Modify which key map

To modify which key maps, for example, `<leader>sp` is defined in
`whichkey.lua`. I want to change it in `config.lua`.
`lvim.builtin.which_key.mappings["sp"] = { "<CMD>Telescope projects<CR>", "Project" }`
does not work.

`lvim.builtin.which_key.mappings.s["p"] = { "<CMD>Telescope projects<CR>", "Project" }`
works. `lvim.builtin.which_key.mappings.s` is a table, and the `config` function
in `which-key.lua` is executed in front of the `config.lua`. So that the value
of key `p` can be modified.

### The alpha

The start cover is defined in
`~/.local/share/lunarvim/lvim/lua/lvim/core/alpha/startify.lua`.

### nvim-notify

The notation manager and message manager for nvim.
