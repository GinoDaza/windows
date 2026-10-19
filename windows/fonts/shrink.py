# Usage: python shrink.py SymbolsNerdFontMono-Regular.ttf SymbolsNerdFontMonoSmaller.ttf 0.9
import sys
from fontTools.ttLib import TTFont
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen

src, dst, s = sys.argv[1], sys.argv[2], float(sys.argv[3])
f = TTFont(src)
gs = f.getGlyphSet()
glyf, hmtx = f["glyf"], f["hmtx"]
cy = (f["hhea"].ascent + f["hhea"].descent) / 2
new = {}
for name in f.getGlyphOrder():
    g = glyf[name]
    if g.numberOfContours == 0:
        continue
    cx = hmtx[name][0] / 2
    pen = TTGlyphPen(gs)
    # scale around (cx, cy)
    gs[name].draw(TransformPen(pen, (s, 0, 0, s, cx * (1 - s), cy * (1 - s))))
    new[name] = pen.glyph()
for n, g in new.items():
    glyf[n] = g
    glyf[n].recalcBounds(glyf)
    hmtx[n] = (hmtx[n][0], glyf[n].xMin if hasattr(glyf[n], "xMin") else 0)
for rec in f["name"].names:
    if rec.nameID in (1, 16): rec.string = "Symbols Nerd Font Mono Smaller"
    elif rec.nameID in (4,): rec.string = "Symbols Nerd Font Mono Smaller"
    elif rec.nameID == 6: rec.string = "SymbolsNerdFontMonoSmaller"
    elif rec.nameID in (3,): rec.string = "SymbolsNerdFontMonoSmaller-1"
f.save(dst)
print("ok", len(new))
