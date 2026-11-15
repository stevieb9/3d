# Curling "hit the broom" laser mount

A laser that stands in for the skip's broom. Set it on the ice at the broom
spot on the T-line and aim it at the centre of the thrower's rock in front of
the far hack, about **37.5 m** away. Filmed from the laser end, the dot stays
centred on the rock's leading face while the slide is on the broom, and walks
across it when it isn't.

Laser: **Adafruit 1054**: red 650 nm, 5 mW, Class IIIa, Ø10 × 31 mm,
adjustable focus, 2.8–5.2 V at 25 mA.

## How it aims

- **Side to side:** turn the whole foot by hand. Sight along the groove on
  the clamp top, then nudge the foot until the dot is on the rock.
- **Up and down:** the laser arm pivots on a printed **cartwheel flexure**,
  two crossed 1.2 mm blades that bend instead of a hinge, so it has no play.
  An M3 jack screw 80 mm behind the pivot lifts the arm, and a hair elastic
  holds the arm down onto it. One knob turn moves the dot **~23 cm** at
  37.5 m, so 1/16 of a turn is about 1.5 cm. The range is about ±4°.
- The beam runs **57 mm above the ice**, at the height of the rock's
  striking band.

## Parts

| Part | STL | Print | Notes |
|---|---|---|---|
| Foot | `foot.stl` | flat, as exported | 125 × 87 × 16; three rubber bumpers underneath; pocket for a 3×AAA holder |
| Tilt stage | `tilt.stl` | **on its side**, as exported | so the flexure bends along the layers |
| Knob | `knob.stl` | flat | for the jack screw; a spare is cheap |

Previews: `preview_iso.png`, `preview_side.png` and `preview_top.png`.

## Hardware

- Adafruit 1054 laser
- **3×AAA battery holder with an on/off switch**: the Amazon.ca six-pack
  (B0C7VV29QR), with a 15 cm lead and a PH2.0 JST plug. The pocket is sized
  from Adafruit's near-identical #727 (63.5 × 36.8 × 15.7 mm) by `batt`, so
  **measure yours**. Cut off the plug and solder the leads to the laser's,
  red to red.
- **3 × AAA cells, alkaline or NiMH.** Three cells give 4.5–4.8 V fresh and
  about 3 V near flat, inside the laser's 2.8–5.2 V. That's about 40 hours
  on alkalines by estimate. **Not lithium:** fresh lithium cells can top
  5.2 V.
- 3 stick-on rubber bumpers, Ø12.7 × 3.5 mm (3M Bumpon size)
- M3 screws:
  - 1 × **M3×25** for the jack screw. A hex head press-fits the knob; a cap
    head needs a drop of glue.
  - 1 × **M3×16** for the laser clamp.
  - 2 × **M3×20** to bolt the tilt stage to the foot, from underneath.
- 4 × M3 nuts
- 1 hair elastic or small rubber band

## Assembly

1. **Tilt stage nuts.** Drop M3 nuts into the four slots that open on the
   side that faced up while printing: two in the floor, one in the arm's
   tail for the jack screw, and one in the clamp for the pinch screw.
2. **Mount the tilt stage.** Bolt it to the foot with 2 × M3×20 from
   underneath; the heads sit in recesses.
3. **Jack screw.** Press the M3×25 head into the knob, then thread it down
   through the arm's nut until the tip rests on the pedestal.
4. **Elastic.** Loop the hair elastic through the slot in the pedestal and
   over the groove at the arm's tail.
5. **Laser.** Slide it into the clamp from the back with about 11 mm
   sticking out the front, so the lens can still turn, and the leads out the
   back. Snug the M3×16 pinch screw gently.
6. **Power.** Stick the bumpers into their recesses. Put the battery holder
   in its pocket with its switch facing up, and join the laser leads to it
   (red +, black −; solder and heat-shrink).

## At the rink

1. **Place it.** Set the foot on the ice where the skip would hold the
   broom. The V-notch on the front edge marks the beam's line, and the side
   notches go over the T-line.
2. **Focus.** Switch on and turn the brass lens at the front for the
   smallest dot on the far backboard, which is close to the rock's distance.
3. **Aim side to side.** With the thrower set in the hack and the rock in
   front, sight along the clamp's groove and turn the whole foot until the
   dot is on the rock. Nudge the foot's tail to centre it.
4. **Aim the height.** Use the knob to put the dot on the rock's striking
   band, at mid-height.
5. **Off-axis beam.** If the beam leaves the barrel off-axis (cheap modules
   can be a few degrees off), loosen the pinch screw and roll the laser
   until the error lies sideways, where turning the foot takes it out.
   Then retighten.
6. **Film it** from a separate tripod beside or behind the laser. Keep the
   camera off the foot: tapping record on a phone that rode on the foot
   would knock the aim.

## Safety

The laser is Class IIIa (≤5 mW). The beam runs at ice level, below everyone's
eyes, but don't look into it or point it at people. Watch for reflections off
polished granite and wet ice.

## Printing (0.4 mm nozzle)

- **PETG**: tougher in the cold, and better for a flexing part.
- **At least 3 walls**: each 1.2 mm blade needs 3 lines to print solid.
- **Foot at 40–100 % infill**: weight helps it stay put on the ice.
- **No supports.** Horizontal holes are teardrop-shaped, and the nut slots
  are open shafts.

## VERIFY WITH CALIPERS before printing

| Param | Default | Measure |
|---|---|---|
| `las_d` | 10.0 | laser barrel OD (spec) |
| `las_len` | 31.0 | laser overall length (spec) |
| `las_free` | 11 | how much of the front must stay out of the clamp so the focus lens can turn |
| `feet_d`, `feet_h` | 12.7, 3.5 | your rubber bumpers |
| `batt` | 64 × 37 × 16 | your 3×AAA holder; the switch must face up |

**Not yet tried at a rink.** The dot's size and brightness at 37.5 m are
estimates; Adafruit lists no beam divergence. Before printing, it's worth
shining the laser down a sheet, or any 35 m+ hallway, to see the dot.

## Checks done (2026-11-15)

- All three parts render as single closed solids.
- **Collisions:** the arm clears the base and the foot across ±4.5° of tilt.
  First contact comes past −4.5° (by calculation near −5°), when the arm
  meets the pedestal under the jack screw, which acts as a stop.
- The Ø10 laser clears its bore.
- **Blade strain** at full tilt is about 0.9 % by estimate, well within what
  PETG takes.

## Tuning knobs (`curling_laser_mount.scad`)

| Param | Default | Meaning |
|---|---|---|
| `beam_h` | 57 | beam height above the ice |
| `R_tilt` | 80 | pivot → jack screw; longer is finer |
| `tilt_deg` | 4 | tilt range ± |
| `cwt_t`, `cwt_a` | 1.2, 10 | flexure blade thickness, half-length |
| `gap_t` | 8 | arm ↔ pedestal gap at level |
| `las_clear` | 0.3 | bore clearance on the barrel |

## Regenerate

```
openscad -D 'part="foot"'  -o foot.stl        curling_laser_mount.scad
openscad -D 'part="tilt"'  -o tilt.stl        curling_laser_mount.scad
openscad -D 'part="knob"'  -o knob.stl        curling_laser_mount.scad
```

Previews (OpenSCAD preview mode, 1400 × 1000, run from this folder):

```
for v in "iso 60,0,35 p" "side 90,0,0 o" "top 0,0,0 o"; do
  set -- $v
  openscad --imgsize=1400,1000 --viewall --autocenter \
    --projection=$3 --camera=0,0,0,$2,0 -o preview_$1.png curling_laser_mount.scad
done
```
