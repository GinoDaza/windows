# Windows

Personal setup for my Windows machine and its WSL Ubuntu: config files, shell setup, package lists and a few notes.

## Structure

```
.
├── windows/                  # Windows-side setup
│   ├── hosts                 # hosts file that blocks distracting sites
│   ├── winget.txt            # winget installs
│   ├── msys2-ucrt64.txt      # MSYS2 UCRT64 toolchain install
│   ├── git-bash.bashrc       # Git Bash prompt and aliases
│   ├── vimrc                 # Vim settings
│   ├── newtab/ext/           # Edge extension that redirects new tabs to my page
│   └── vscode/               # VS Code settings and keybindings
├── wsl/                      # WSL Ubuntu setup
│   ├── bashrc                # shell prompt, aliases, PATH
│   ├── packages.txt          # apt and rustup installs
│   └── nvim/init.lua         # Neovim config
├── games/
│   ├── left4dead2/           # Left 4 Dead 2 autoexec and Steam launch options
│   └── warcraft3/            # Warcraft 3 custom hotkeys
└── notes/
    ├── newtab-setup.md       # custom new tab: extension, Vimium and Edge settings
    └── yt-dlp-ffmpeg.md      # download and trim YouTube videos
```
