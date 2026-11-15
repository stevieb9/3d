# LED-frame controller enclosure

Two-part printed case for the `led_frame` PCB (91.44 × 59.69 mm, positions
extracted from `led_frame.kicad_pcb`). Outer size **112.2 × 66.5 × 24.9 mm**
assembled.

- **Top** — the box. Stepped roof, four tiers:
  1. **Tall** (L-shape: left column + top band) — clears the 470 µF cap
     (tallest part), D1 mini, JST, MCP3008, 10 µF.
  2. **Pots** — underside *rests on* the two square pot bodies; knurled
     shafts pass through 8 mm holes.
  3. **Screen** — low deck floating 0.4 mm above the OLED glass, with a
     26.5 × 14.4 mm window (the measured visible area plus 0.5 mm a side).
  4. **Buttons** — deck top flush with the tact switches' **square bodies**
     (3.6 mm); square cutouts (body + 0.8) wrap each body and the round
     plungers stand ~2 mm proud for easy pressing. Body + 0.4 was too
     tight on the first test print; + 0.8 has not been printed yet.
     Cutouts are centred on the true plunger positions (the KiCad
     footprint origin is pin 1 — centres are origin + (3.25, −2.25)).
  - The screen and button decks run **flat to the right edge** — the tall
    frame exists only on the left and across the top band. The
    bottom-right corner post is short (it stops under the button deck, so
    its pilot is 8.6 mm deep instead of 9; an M2×10 still fits).
  - The tall-zone drops **left of and above the OLED are angled** (sloped
    panels, 55° on the left and 52° on top as measured on `top.stl`,
    meeting in a hip at the window's NW corner) instead of vertical
    cliffs; the slope undersides print support-free. The angle is
    as shallow as the layout allows: the 10 µF cap (C3) stands under the
    top ramp's path and the left ramp's foot already lands at the window
    rim. `ramp_in` and the hull strips in `top()` are the tuning knobs.
    Preview PNGs (`preview_*.png`) show the current shape; the command
    that renders them is under *Regenerate*.
  - Left wall: micro-USB slot (13 × 8.5 mm) with a guide tunnel running
    in to the D1 mini's socket, and a 12 × 7.5 mm slot that the LED
    strip's JST XH plug passes through.
- **Bottom** — flat plate, four Ø7 standoffs (4 mm tall, **1.90 mm pilots**)
  under the board's 2.2 mm M2 corner holes. The plate screws **up** into
  corner posts inside the top (1.90 mm pilots, 9 mm deep; 8.6 in the
  short bottom-right post).

## Screws

8 × M2 self-tappers: 4 short (M2×5/6) board → standoffs, 4 long (M2×8/10)
plate → corner posts from underneath.

## Full-board audit (all footprints, courtyard-derived — no origins trusted)

Every component's true extent was extracted from the KiCad courtyards/pads
and checked against every case feature. Fixes that came out of it: USB slot
recentred to the module's real courtyard centre (was 11.5 mm off) plus a
guide tunnel across the 8 mm post margin (a micro-B nose is ~6 mm and could
never have reached); pot-tier boundary moved east of the 470 µF's body;
bottom-left standoff chord-cut clear of J1's pin-1 solder tail.

**The OLED module and glass are not in the board file** (the footprint
holds only the 4-pin header; the module hangs south of it), so they were
**measured** on the part: visible area x 58.40–83.92, y 27.21–40.63
(board-local), centre (71.16, 33.92); module PCB south edge at y 18.36,
which sets the button/screen step.

## VERIFY WITH CALIPERS before printing

Rows marked **measured** came from the real parts; the rest are
typical-part defaults to check:

| Param | Default | What to measure |
|---|---|---|
| `cap_h` | 13.0 | 470 µF body top above board |
| `pot_body_h` | 7.0 | pot square-body top above board (tier 2 rests here) |
| `oled_glass_h` | 5.68 | **measured** — OLED glass top above board |
| `oled_win` / `oled_win_dy` | 26.5×14.4, 0 | **measured** — visible area + 0.5 a side |
| `usb_above_board` | 1.25 | **measured** — this module's USB is underside-mounted, shell top 2.6 above the board; slot is 13×8.5 with the guide tunnel running floor-to-top |
| `standoff_h` | 4.0 | ≥ solder-tail protrusion under the board |
| `btn_body_h` | 3.6 | switch square-body top above board (deck is flush here) |
| `btn_body_w` | 6.12 | switch body width — **measured** |

Plunger tops are the measured 5.65 mm, so they stand `5.65 − btn_body_h`
proud of the deck.

**Measurement list (blocking a final print).** The OLED window and module
edge are already measured (above). Still open — each limit is the lowest
roof over that part, probed on `top.stl` against the board's footprints:

1. OLED header **pin tops** above the main board: must be < **6.08**. The
   pins (y = 44.45) sit under the screen deck's underside.
2. **C3** (10 µF) height above board: must be < **13.45** (the top ramp
   passes over its south edge).
3. **C1** (0.1 µF disc) height above board: must be < **7.0** (it lives
   under the resting pot tier).

## Printing (0.4 mm nozzle)

- **Bottom**: as-is, flat, no supports.
- **Top**: as modeled (open side down). The tier undersides span the
  cavity — enable **interior supports** (scars hide inside) or trust your
  bridging. Printing it inverted puts support scars on the visible tiers;
  not recommended.

## Regenerate

```
openscad -D 'part="top"'    -o top.stl    led_frame_case.scad
openscad -D 'part="bottom"' -o bottom.stl led_frame_case.scad
```

Previews (OpenSCAD preview mode, 1400 × 1000, run from this folder):

```
for v in "iso 55,0,25 p" "top 0,0,0 o" "east 65,0,70 p" "west 65,0,290 p"; do
  set -- $v
  openscad -D 'part="top"' --imgsize=1400,1000 --viewall --autocenter \
    --projection=$3 --camera=0,0,0,$2,0 -o preview_$1.png led_frame_case.scad
done
```

Debug switches for geometry work: `with_skirts`, `with_posts`, `nsk`
(include only the first *n* step-wall boxes).
