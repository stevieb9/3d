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
| Foot | `foot.stl` | flat, as exported | 125 × 87 × 16; three rubber bumpers underneath; pocket for a 2×AA holder |
| Tilt stage | `tilt.stl` | **on its side**, as exported | so the flexure bends along the layers |
| Knob | `knob.stl` | flat | for the jack screw; a spare is cheap |
| Phone bracket (optional) | `phone_mount.stl` | as exported | holds a 1/4"-20 bolt for a phone tripod clamp |

Previews: `preview_iso.png`, `preview_side.png`, `preview_top.png`, and
`preview_phone.png` (with the bracket and a phone).

## Hardware

- Adafruit 1054 laser
- 2×AA battery holder with an on/off switch, about 58 × 32 × 16 mm. The
  pocket is sized by `batt`, so **measure yours**. Use **lithium AAs**: they
  hold their voltage in the cold, and alkalines can fall below the laser's
  2.8 V minimum well before they're flat.
- 3 stick-on rubber bumpers, Ø12.7 × 3.5 mm (3M Bumpon size)
- M3 screws:
  - 1 × **M3×25** for the jack screw. A hex head press-fits the knob; a cap
    head needs a drop of glue.
  - 1 × **M3×16** for the laser clamp.
  - 2 × **M3×20** to bolt the tilt stage to the foot, from underneath.
- 4 × M3 nuts
- 1 hair elastic or small rubber band
- Phone option: 2 × M3×20, 2 × M3 nuts, a 1/4"-20 × 1/2" hex bolt, and any
  phone tripod clamp

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
   in its pocket and join the laser leads to it (red +, black −; solder and
   heat-shrink).
7. **Phone option.** Bolt the bracket to the front-left corner with
   2 × M3×20 into nuts under the foot. Push the 1/4"-20 bolt up through the
   top plate and screw on the phone clamp.

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
6. **Film it** from beside the laser on the phone bracket, or from behind
   it.

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
| `batt` | 58 × 32 × 16 | your battery holder |
| `tri_len` | 12.7 | 1/4"-20 bolt length (phone option) |

**Not yet tried at a rink.** The dot's size and brightness at 37.5 m are
estimates; Adafruit lists no beam divergence. Before printing, it's worth
shining the laser down a sheet, or any 35 m+ hallway, to see the dot.

## Checks done (2026-11-15)

- All four parts render as single closed solids.
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
openscad -D 'part="phone"' -o phone_mount.stl curling_laser_mount.scad
```

Previews (OpenSCAD preview mode, 1400 × 1000, run from this folder):

```
for v in "iso 60,0,35 p false" "phone 62,0,215 p true" "side 90,0,0 o false" "top 0,0,0 o false"; do
  set -- $v
  openscad -D "with_phone=$4" --imgsize=1400,1000 --viewall --autocenter \
    --projection=$3 --camera=0,0,0,$2,0 -o preview_$1.png curling_laser_mount.scad
done
```
