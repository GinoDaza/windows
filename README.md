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
│   └── vscode/               # VS Code settings and keybindings
├── wsl/                      # WSL Ubuntu setup
│   ├── bashrc                # shell prompt, aliases, PATH
│   ├── packages.txt          # apt and rustup installs
│   └── nvim/init.lua         # Neovim config
├── games/
│   └── warcraft3/            # Warcraft 3 custom hotkeys
└── notes/
    └── yt-dlp-ffmpeg.md      # download and trim YouTube videos
```
