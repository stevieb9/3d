// =====================================================================
//  LED-frame controller enclosure  (led_frame PCB, 91.44 x 59.69 mm)
//  TOP = the box: stepped roof descending over four height zones —
//    T1 tall  : L-shape, left column + top band (D1 mini, JST, 470uF,
//               diode, MCP3008, 10uF) — clears the tallest cap
//    T2 pots  : mid-bottom; underside RESTS on the two 9.7 mm square
//               pot bodies, shafts pass through holes
//    T3 screen: right-middle; low deck over the OLED with a window
//    T4 btns  : bottom-right; deck TOP is level with the tact-switch
//               plunger tops, plungers poke through flush
//  BOTTOM = flat plate with four PCB standoffs (1.90 mm pilots, board's
//  2.2 mm M2 holes pass the screws); the plate screws up into corner
//  posts inside the top shell from underneath.
//  Step transition walls span only BETWEEN tier levels, never down to
//  the board — RV2 and SW1 bodies are 0.7 mm apart, nothing can descend
//  between them.
//  All PCB coordinates extracted from led_frame.kicad_pcb (board-local,
//  origin bottom-left, y-up).  Tuned for a 0.4 mm nozzle.  Millimetres.
//
//     openscad -D 'part="top"'    -o top.stl    led_frame_case.scad
//     openscad -D 'part="bottom"' -o bottom.stl led_frame_case.scad
// =====================================================================

part = "both";        // "top" | "bottom" | "both"
$fn  = 48;
with_skirts = true;   // debug switches for manifold bisection
with_posts  = true;
with_holes  = true;
nsk = -1;             // debug: include only the first nsk skirt boxes (-1 = all)

// ---- shell (0.4 mm nozzle: 2.4 = 6 clean perimeters) ----------------
wall = 2.4; plate_th = 2.4; roof_th = 2.4;
t4_th = 2.0;           // button deck thinner: underside must clear the
                       // 3.6 mm switch bodies while the top sits at 5.65

// ---- PCB ------------------------------------------------------------
board_x = 91.44; board_y = 59.69; board_th = 1.60;
board_clear = 1.0;     // air around board edges (left edge gets margin)

// Mounting-hole CENTRES, board-local (2.2 mm holes for M2 screws)
board_holes = [ [ 2.54,  2.54], [88.90,  2.54],
                [ 2.54, 57.15], [88.90, 57.15] ];
standoff_d = 7.0; standoff_h = 4.0;   // >= 3: THT solder clearance under board
screw_pilot_d = 1.90;   // self-tap pilot, dialed in on the M2 fit-tester

// ---- component heights above BOARD TOP (calipers before printing!) --
cap_h        = 13.0;   // VERIFY: 470uF radial C4, the tallest part
cap_gap      = 1.5;    // air above it
pot_body_h   = 7.0;    // VERIFY: RV09 square body top — T2 rests HERE
pot_shaft_d  = 6.0;    // knurled shaft; hole gets +2 clearance
oled_glass_h = 5.68;   // measured: glass top 7.28 above board underside − 1.6
oled_gap     = 0.4;    // T3 underside floats this far above the glass
btn_body_h   = 3.6;    // VERIFY: 6x6 tact SQUARE BODY top — T4 top = this;
                       // deck wraps the bodies, plungers stand ~2 mm proud
                       // (plunger tops measured 5.65 above board)
btn_body_w   = 6.12;   // measured: square body width
btn_cut_clear = 0.8;   // square cutout = body + this. FDM prints interior
                       // square holes ~0.15/side undersize (corner
                       // rounding + swell) — 0.4 proved too tight on the
                       // first test print

// ---- component positions, board-local (from KiCad) ------------------
// KiCad footprint origins are PIN 1 for both the pots and the switches —
// true feature centres extracted from the footprints themselves: the pot
// shaft is the F.Fab circle at footprint-local (7.5, 2.5); the button
// plunger is the courtyard centre at origin + (3.25, -2.25). Result
// matches the physical board: plungers sit ~2 mm above the dials.
pot_pos  = [ [30.50,  9.08], [48.11,  9.08] ];   // RV1 HUE, RV2 BRIGHT shafts
btn_pos  = [ [62.79, 11.14], [74.22, 11.14], [85.65, 11.14] ]; // SEL UP DN
// OLED: fully measured. Visible area x 58.40..83.92 (width 25.52),
// y 27.21..40.63 (height 13.42) -> centre (71.16, 33.92). Window opens
// 0.5 mm past the visible area on each side. Module PCB south edge at
// y=18.36 (sets the button/screen boundary below).
oled_ctr = [71.16, 33.92];
oled_win = [26.5, 14.4];
oled_win_dy = 0;
m1_usb_y = 41.92;                                // D1 mini courtyard ctr — the
                                                 // USB sits here (west edge)

// ---- zone boundaries, board-local (chosen to clear component bodies) -
zx1 = 19.8;   // T1 left column | T2   (C4's Ø8 body reaches x=19.24 and is
              // 13 tall — the pot slab must start east of it)
zy1 = 29.0;   // T2 | T1 top band      (U2 SOIC ends 27.9)
zx2 = 56.0;   // T2 | T4 and T2 | T3   (RV2 ends 55.46, SW1 starts 56.2)
zy2 = 18.1;   // T4 | T3 — the OLED module PCB reaches down to y=18.36
              // (measured), so the step wall must finish south of it;
              // button courtyards end at 14.89
zy3 = 46.0;   // T3 | T1 top band      (C3 body starts 47.07)

// ---- wall openings --------------------------------------------------
usb_w = 13.0; usb_h = 8.5;
usb_above_board = 1.25; // MEASURED (fit test): this module mounts its USB
                        // on the UNDERSIDE — shell hangs in the header gap
                        // nearly touching the main PCB, shell top ~2.6
                        // above the board -> centre 2.6 - 1.35. The plug's
                        // nose passes ~0.25 above the main board's edge;
                        // the 8.5 slot height gives ±2 mm of forgiveness.
// Strip-wire exit, left wall: the strip's 3-pin JST XH plug (XHP-3
// housing, 9.9 x 5.75 plus its latch rib) must PASS THROUGH, so it's a
// generous slot — ~2 mm spare on width, ~1.5 on height. Positioned just
// above the corner post's footprint so the passage behind the wall is
// completely unobstructed (the old round hole ran into the post).
jst_w = 12.0; jst_h = 7.5; jst_z_ctr = 13.0;

// ---- corner posts (screws enter from under the bottom plate) --------
post_size = 7; post_pilot_d = 1.90; post_pilot_dep = 9; plate_clear_d = 2.6;

// =====================================================================
//  DERIVED LAYOUT
// =====================================================================
side_margin = post_size + 1;                 // posts live beside the board (x)
inner_x = side_margin + board_x + side_margin;
inner_y = board_y + 2*board_clear;
ox = inner_x + 2*wall;  oy = inner_y + 2*wall;

bx0 = wall + side_margin;                    // board-local -> case coords
by0 = wall + board_clear;
function babs(p) = [bx0 + p[0], by0 + p[1]];

z_board = standoff_h + board_th;             // board TOP above plate top
usb_z_ctr = z_board + usb_above_board;       // slot centre in case coords
zu1 = z_board + cap_h + cap_gap;             // tier undersides
zu2 = z_board + pot_body_h;
zu3 = z_board + oled_glass_h + oled_gap;
zt4 = z_board + btn_body_h;                  // T4 top flush with switch bodies
zu4 = zt4 - t4_th;
zt1 = zu1 + roof_th;  zt2 = zu2 + roof_th;  zt3 = zu3 + roof_th;
H = zt1;                                     // shell height = tallest tier top

// zone rectangles in CASE coords [x0, y0, x1, y1] — tile the full outline
// (each zone owns its adjacent wall band, so wall height follows the roof)
Z1a = [0,             0,             wall + side_margin + zx1, oy];  // left col + margin
// ramp geometry: flat tall zones pull back to the ramp ridges; sloped
// panels (below) roof the transition strips
ramp_in = 3.0;         // ridge sits this far inside the old tall boundary
Z1b = [wall + side_margin + zx1, by0 + zy1, bx0 + zx2 - ramp_in, oy]; // top band (over T2)
Z1c = [bx0 + zx2 - ramp_in, by0 + zy3 + ramp_in, ox - wall - side_margin, oy];
Z1d = [ox - wall - side_margin, by0 + zy3 + ramp_in, ox, oy];        // right margin, top band
Z2  = [wall + side_margin + zx1, 0, bx0 + zx2,     by0 + zy1];       // pots
Z3  = [bx0 + zx2,     by0 + zy2,    ox,            by0 + zy3];       // screen, to the right edge
Z4  = [bx0 + zx2,     0,            ox,            by0 + zy2];       // buttons, to the right edge

// [rect, underside, top] per zone
zones = [ [Z1a, zu1, zt1], [Z1b, zu1, zt1], [Z1c, zu1, zt1], [Z1d, zu1, zt1],
          [Z2,  zu2, zt2], [Z3,  zu3, zt3], [Z4,  zu4, zt4] ];

// Step transition walls + bond tabs, [x0,y0,x1,y1,z0,z1].  Walls span only
// BETWEEN tier levels (never down to the board).  Each wall gets a "bond"
// box that volumetrically overlaps both the wall and the higher tier's
// slab — coplanar edge-contact alone is non-manifold.  These are unioned
// AFTER hollowing so the cavities can't shave them.
xm = ox - wall - side_margin;    // right-margin boundary (T1 frame)
skirts = [
  // T1 | T2 at x=zx1: wall, then bond tab kept entirely on the tall side
  // so it stays buried under the Z1a roof instead of poking proud
  [bx0+zx1-1.2, 0,           bx0+zx1+1.2, by0+zy1,     zt2,     zu1],
  [bx0+zx1-1.2, 0,           bx0+zx1,     by0+zy1,     zu1-0.3, zu1+0.5],
  // T1 | T2 at y=zy1 (east ends stop where the left ramp's slope dives
  // below them — the ramp panel takes over the seal from there)
  [bx0+zx1-1.2, by0+zy1-2.4, bx0+zx2-1.4, by0+zy1,     zt2,     zu1],
  [bx0+zx1-1.2, by0+zy1-0.2, bx0+zx2-1.7, by0+zy1+1.2, zu1-0.3, zu1+0.5],
  // (T1|T3 vertical steps at x=zx2 and y=zy3 replaced by the ramp panels)
  // corner seal: where the left ramp's foot region meets the y=zy1 step,
  // a small slit would open between the T2 roof and the panel underside
  [bx0+zx2-1.6, by0+zy1-2.4, bx0+zx2+0.2, by0+zy1,     zt2-0.3, 17.2],
  // (right-margin skirt deleted: the terraces now run to the right edge)
  // T2 | T4 at x=zx2: 1.2 mm wall dropped straight at RV2's body edge
  // (courtyard ends 54.76 -> 0.24 clear) instead of set back — buys the
  // SEL button ~1.9 mm of finger room. Thin column bonds into the T2 slab.
  [bx0+55.0,    0,           bx0+56.2,    by0+zy2,     zt4,     zu2],
  [bx0+55.0,    0,           bx0+55.9,    by0+zy2,     zt4,     zu2+0.5],
  // T3 | T4 at y=zy2: 1.1 mm wall dropped straight at the OLED module's
  // measured south edge (18.36 -> 0.36 clear) — ~1.2 mm more room above
  // the button row. Tab bridges the 0.1 gap to the T3 slab and bonds it.
  [bx0+zx2,     by0+zy2-1.2, ox,          by0+zy2-0.1, zt4,     zu3],
  [bx0+zx2,     by0+zy2-0.3, ox,          by0+zy2+1.2, zu3-0.2, zu3+0.5],
];

// [x, y, height]: the bottom-right post lives under the lowered button
// deck, so it stops at that deck's underside (9.25 — the 9 mm pilot fits)
post_pos = [ [wall,                  wall,                  zu1],
             [ox - wall - post_size, wall,                  zu4],
             [wall,                  oy - wall - post_size, zu1],
             [ox - wall - post_size, oy - wall - post_size, zu1] ];

echo(str("OUTER (X,Y,Z) = ", ox, " x ", oy, " x ", H + plate_th, " mm (assembled)"));
echo(str("tier tops above plate: T1=", zt1, " T2=", zt2, " T3=", zt3, " T4=", zt4));
echo(str("board top z=", z_board, "  USB slot ctr z=", usb_z_ctr,
         " (module+USB: verify!)"));

module zbox(r, z0, z1) {
    translate([r[0], r[1], z0]) cube([r[2]-r[0], r[3]-r[1], z1-z0]);
}

// =====================================================================
module top() {
    difference() {
        union() {
            // stepped shell: zone solids hollowed to their tier undersides
            difference() {
                for (z = zones) zbox(z[0], 0, z[2]);
                for (z = zones) {
                    ix0 = max(z[0][0], wall);  iy0 = max(z[0][1], wall);
                    ix1 = min(z[0][2], ox - wall);  iy1 = min(z[0][3], oy - wall);
                    zbox([ix0, iy0, ix1, iy1], -1, z[1]);
                }
            }
            // step transition walls + bond tabs (post-hollow, uncarved).
            // eps-inflated: every face-rest becomes a volume overlap, else
            // coplanar contacts leave the union non-manifold.
            eps = 0.02;
            if (with_skirts)
                for (i = [0 : (nsk < 0 ? len(skirts) : nsk) - 1])
                    if (i < len(skirts))
                        translate([skirts[i][0]-eps, skirts[i][1]-eps, skirts[i][4]-eps])
                            cube([skirts[i][2]-skirts[i][0]+2*eps,
                                  skirts[i][3]-skirts[i][1]+2*eps,
                                  skirts[i][5]-skirts[i][4]+2*eps]);
            // corner posts (plate face up into the tall roof; z0 stays exact
            // so the mating face is flat)
            if (with_posts)
                for (p = post_pos)
                    translate([p[0]-eps, p[1]-eps, 0])
                        cube([post_size+2*eps, post_size+2*eps, p[2]+eps]);
            // ---- ramp panels: sloped roof slabs replacing the vertical
            // cliffs left of and above the OLED (~55 deg — the undersides
            // print support-free). Each hull runs from a ridge strip buried
            // in the tall roof slab down to a foot strip buried in the T3
            // deck, so both ends bond volumetrically.
            xr = bx0 + zx2;   yr = by0 + zy3;   // old tall-zone boundaries
            hull() {          // left ramp (foot lands at the window's rim;
                              // north end stops at the top ramp's ridge)
                translate([xr-3.6, by0+26.6, zu1-0.3]) cube([0.6, 22.4, roof_th+0.3]);
                translate([xr+2.3, by0+26.6, zu3-0.3]) cube([0.6, 22.4, roof_th+0.3]);
            }
            hull() {          // top ramp, full width to the right wall
                translate([xr-3.6, yr+2.4,  zu1-0.3]) cube([ox-(xr-3.6), 0.6, roof_th+0.3]);
                translate([xr-3.6, yr-4.1,  zu3-0.3]) cube([ox-(xr-3.6), 0.6, roof_th+0.3]);
            }
            hull() {          // right wall rises along the top ramp's slope
                translate([ox-wall, yr-0.4, 0]) cube([wall, 0.6, zt3+2.2]);
                translate([ox-wall, yr+2.2, 0]) cube([wall, 0.6, zu1+0.7]);
            }
            // USB guide tunnel: the board sits 8 mm off the left wall
            // (post margin) and a micro-B plug's nose is only ~6 mm — this
            // duct carries the plug from the wall slot to the module edge
            // so it can actually reach the socket. With the socket now
            // near board level, the duct runs floor-to-top: it prints on
            // the bed and bears on the bottom plate when assembled.
            translate([wall-0.2, babs([0, m1_usb_y])[1] - usb_w/2 - 2.4, 0])
                cube([bx0 - 0.6 - (wall-0.2), usb_w + 4.8,
                      usb_z_ctr + usb_h/2 + 2.4]);
        }
        // pot shaft holes
        for (p = pot_pos)
            translate([babs(p)[0], babs(p)[1], zu2 - 1])
                cylinder(d = pot_shaft_d + 2.0, h = roof_th + 2);
        // square cutouts wrapping each switch body (plunger stands proud)
        for (p = btn_pos)
            translate([babs(p)[0] - (btn_body_w + btn_cut_clear)/2,
                       babs(p)[1] - (btn_body_w + btn_cut_clear)/2, zu4 - 1])
                cube([btn_body_w + btn_cut_clear, btn_body_w + btn_cut_clear,
                      t4_th + 2]);
        // OLED window
        translate([babs(oled_ctr)[0] - oled_win[0]/2,
                   babs(oled_ctr)[1] + oled_win_dy - oled_win[1]/2, zu3 - 1])
            cube([oled_win[0], oled_win[1], roof_th + 2]);
        // micro-USB slot, left wall — cut continues through the guide
        // tunnel so the plug has a clear channel to the module edge
        translate([-1, babs([0, m1_usb_y])[1] - usb_w/2, usb_z_ctr - usb_h/2])
            cube([bx0 + 0.6, usb_w, usb_h]);
        // LED strip wire slot, left wall (passes the JST XH plug)
        translate([-1, wall + post_size + 0.2, jst_z_ctr - jst_h/2])
            cube([wall + 2, jst_w, jst_h]);
        // corner-post pilots (screws come up from under the plate); the
        // short post's pilot stops 0.6 below the button deck's top face
        for (p = post_pos)
            translate([p[0] + post_size/2, p[1] + post_size/2, -1])
                cylinder(d = post_pilot_d,
                         h = min(post_pilot_dep, p[2] + t4_th - 0.6) + 1);
    }
}

module bottom() {
    difference() {
        union() {
            cube([ox, oy, plate_th]);
            // PCB standoffs
            for (h = board_holes)
                translate([babs(h)[0], babs(h)[1], plate_th])
                    cylinder(d = standoff_d, h = standoff_h);
        }
        // 1.90 pilots for the board's M2 screws
        for (h = board_holes)
            translate([babs(h)[0], babs(h)[1], plate_th - 1])
                cylinder(d = screw_pilot_d, h = standoff_h + 2);
        // J1's pin-1 solder tail sits only 3.3 mm from the bottom-left
        // mounting hole — chord-cut that standoff so the ring can't land
        // on the fillet
        translate([babs(board_holes[0])[0], babs(board_holes[0])[1], plate_th - 0.1])
            rotate([0, 0, 45])
                translate([2.2, -6, 0]) cube([10, 12, standoff_h + 0.2]);
        // clearance for the case screws, up into the corner posts
        for (p = post_pos)
            translate([p[0] + post_size/2, p[1] + post_size/2, -1])
                cylinder(d = plate_clear_d, h = plate_th + 2);
    }
}

if (part == "top") top();
else if (part == "bottom") bottom();
else { top(); translate([0, oy + 10, 0]) bottom(); }
