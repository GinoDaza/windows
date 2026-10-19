# Smaller Nerd Font icons in Windows Terminal

Keep Ubuntu Mono for text and use a Nerd Font symbols-only font as fallback for the icons. Windows Terminal can't set a size per font, so the icons are scaled down to 90% with `windows/fonts/shrink.py`.

## Setup

1. Install `windows/fonts/SymbolsNerdFontMonoSmaller.ttf` on Windows (right click > Install for all users).
2. In the Ubuntu profile of Windows Terminal `settings.json`:

```json
"font": {
    "face": "Ubuntu Mono, Symbols Nerd Font Mono Smaller",
    "size": 13
}
```

3. Restart Windows Terminal.

## Regenerate with another size

`windows/fonts/SymbolsNerdFontMono-Regular.ttf` is the original font from Nerd Fonts. Install fonttools and run the script from `windows/fonts/` (last argument is the scale, 0.85 = smaller, 0.95 = barely smaller):

```
pip install fonttools
python shrink.py SymbolsNerdFontMono-Regular.ttf SymbolsNerdFontMonoSmaller.ttf 0.9
```

The font is derived from Nerd Fonts Symbols Only (https://github.com/ryanoasis/nerd-fonts).
