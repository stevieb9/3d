// =====================================================================
//  Curling "hit the broom" laser mount
// ---------------------------------------------------------------------
//  Sits on the ice at the skip's broom spot on the T-line and aims a red
//  5 mW laser (Adafruit 1054, D10 x 31) at the centre of the thrower's
//  rock in front of the far hack, ~37.5 m away. Filmed from the laser
//  end, the dot stays centred on the rock's leading face while the slide
//  is on the broom, and walks across it when it isn't.
//
//  Side to side: turn the whole foot by hand (sight groove + the dot).
//  Up and down: the laser arm pivots on a printed CARTWHEEL flexure (two
//  crossed 1.2 mm blades: a hinge with no play), lifted by an M3 jack
//  screw 80 mm back and held down onto it by a hair elastic.
//    0.5 mm pitch / 80 mm = 6.25 mrad per knob turn = ~23 cm at the rock
//    (1/16 turn ~ 1.5 cm).
//
//  foot  - printed flat: base on three rubber bumpers, pocket for a 2xAA
//          holder with switch; the tilt stage bolts on from below.
//  tilt  - printed ON ITS SIDE (+Y up) so the flexure bends along the
//          layers: base, flexure, laser arm, jack screw, and a split
//          clamp for the laser (loosen it to roll the laser or slide it).
//  knob  - thumb knob for the jack screw.
//  phone - optional: bracket with a 1/4"-20 bolt for a phone tripod
//          clamp, so the phone films from beside the laser.
//
//  Origin = under the tilt pivot, on the foot's underside; beam along
//  +X; +Z up; the ice is feet_h below z = 0. Millimetres. PETG.
//
//    openscad -D 'part="foot"'  -o foot.stl        curling_laser_mount.scad
//    openscad -D 'part="tilt"'  -o tilt.stl        curling_laser_mount.scad
//    openscad -D 'part="knob"'  -o knob.stl        curling_laser_mount.scad
//    openscad -D 'part="phone"' -o phone_mount.stl curling_laser_mount.scad
// =====================================================================

part       = "assembly"; // "assembly" | "foot" | "tilt" | "knob" | "phone"
with_phone = false;      // assembly: add the optional phone bracket
show_band  = true;       // assembly: draw the elastic
$fn = 48;

// ---- laser: Adafruit 1054, 650 nm, 5 mW, Class IIIa -----------------
las_d     = 10.0;   // VERIFY: barrel OD (spec 10)
las_len   = 31.0;   // VERIFY: overall length (spec 31)
las_free  = 11;     // VERIFY: barrel left free IN FRONT of the clamp so
                    // the focus lens can be turned; the clamp holds 16
las_clear = 0.3;    // bore = las_d + this; the split clamp closes it

// ---- the setting ----------------------------------------------------
beam_h = 57;        // beam above the ice: the rock's striking band
                    // (114 mm tall rock -> centre ~57)
dist_m = 37.5;      // far tee line -> rock in front of the hack

// ---- bought parts ---------------------------------------------------
m3_hole = 3.4;
nut_af  = 5.5;  nut_t = 2.4;  nut_c = 0.3;   // M3 nut, pocket clearance
nut_ac  = nut_af / cos(30);                  // 6.35 across corners
head_af = 5.5;      // knob pocket: M3 hex head, or a cap head glued in
feet_d  = 12.7;     // VERIFY: stick-on rubber bumpers, diameter
feet_h  = 3.5;      // VERIFY: ...and height
batt    = [58, 32, 16];   // VERIFY: 2xAA holder with switch, L x W x H
tri_af  = 11.11;  tri_head = 4.0;  tri_hole = 6.6;  // 1/4"-20 hex bolt
tri_len = 12.7;     // VERIFY: 1/4"-20 bolt length (1/2")
tri_out = 5.5;      // thread left standing for the phone clamp

// ---- foot -----------------------------------------------------------
h_ft    = 16;       // foot thickness
foot_x  = [-102, 23];
foot_y  = [-30, 57];
foot_r  = 10;   chamf = 2;
batt_xy = [-88, 21];         // battery pocket corner
bumpers = [[14, 0], [-95, -20], [-95, 47]];   // three points never rock
phone_holes = [[-4, 46], [10, 46]];
mount_x = [-25, -60];        // tilt stage bolts (M3 x 20 from below)

// ---- tilt stage -----------------------------------------------------
tw       = 9;       // half-width of the side-printed profile
t_fl     = 5;       // floor
cwt_a    = 10;  cwt_t = 1.2;  cwt_s = cwt_a * cos(45);   // cartwheel
R_tilt   = 80;      // pivot -> jack screw
tilt_deg = 4;  tsweep = tilt_deg + 0.5;   // clearances cut for tsweep
arm_t    = 7;
gap_t    = 8;       // arm <-> pedestal at level
clamp_x  = [-6, 10];         // clamp block along X (holds 16 of barrel)
clamp_yp = 15;      // clamp block reaches +Y this far (pinch side)
pinch    = [2, 10.8];        // pinch screw (x, y)

// ---- phone bracket (optional) ---------------------------------------
ph_x    = [-12, 18];         // along X
ph_h    = 55;                // top above the foot top
ph_bolt = [3, 70];           // 1/4"-20 bolt (x, y)
ph_t    = tri_len - tri_out + tri_head + 0.3;   // top plate thickness

// =====================================================================
//  DERIVED
// =====================================================================
z_L   = beam_h - feet_h;         // laser axis
rb    = (las_d + las_clear) / 2;
z_at  = z_L - rb - 2.6;          // arm top
z_ab  = z_at - arm_t;            // arm bottom
z_H   = z_ab + 1.2 - cwt_s;      // tilt pivot
z_lb  = z_H - cwt_s + 1.2;       // fixed post top
z_f0  = h_ft;  z_f1 = h_ft + t_fl;   // floor
z_ped = z_ab - gap_t;            // pedestal top: the jack screw lands here
z_ct  = z_L + rb + 2.7;          // clamp block top
post_hx = cwt_s + 2.5;           // half-length of the post / bridges
arm_x0  = -R_tilt - 10;          // arm tail
fl_x0   = -94;                   // floor tail
ped_x   = [-92, -72];
tband_x = [-89, -86];            // elastic: arm groove, pedestal slot
las_x   = [clamp_x[1] + las_free - las_len, clamp_x[1] + las_free];

assert(z_lb > z_f1 + 1, "no room for the tilt post");
assert(z_ped > z_f1 + 3, "pedestal too low");
assert(gap_t > (R_tilt + 12) * sin(tsweep), "tilt gap too small for the sweep");
assert(las_x[0] < clamp_x[0], "laser shorter than clamp + free length");

echo(str("beam above the ice = ", z_L + feet_h, " mm; laser x ", las_x));
echo(str("tilt: ", 1000 * 0.5 / R_tilt, " mrad/turn = ",
         round(0.5 / R_tilt * dist_m * 1000), " mm/turn at ", dist_m, " m"));
echo(str("foot ", foot_x[1] - foot_x[0], " x ", foot_y[1] - foot_y[0],
         " x ", h_ft, "; clamp top ", z_ct + feet_h, " above the ice"));
// cross-spring pivot, bending strain ~ 2 t theta / L (L = blade length)
echo(str("blade strain at full tilt sweep ~ ",
         round(1000 * 2 * cwt_t * tsweep * PI / 180 / (2 * cwt_a)) / 10, " %"));

// these let a checking script `use` this file
function tilt_sweep()   = tsweep;
function tilt_pivot_z() = z_H;

// =====================================================================
//  HELPERS
// =====================================================================
module tear2d(d) {           // teardrop, apex toward +Y
    circle(d = d);
    polygon([[-d/2 * cos(45), d/2 * sin(45)], [0, d/2 / cos(45)],
             [ d/2 * cos(45), d/2 * sin(45)]]);
}
module tear_z(d, z0, h, ap = 90) {   // hole along Z, apex toward angle ap
    translate([0, 0, z0]) linear_extrude(h) rotate(ap - 90) tear2d(d);
}
module prof(w) {             // XZ profile -> solid spanning y +/- w/2
    rotate([90, 0, 0]) linear_extrude(height = w, center = true) children();
}
module rrect(x, y, r) {
    translate([x[0] + r, y[0] + r])
        offset(r = r) square([x[1] - x[0] - 2*r, y[1] - y[0] - 2*r]);
}
module nut_slot(x, y0, y1, zc) {     // M3 nut slid in along Y, axis along Z
    translate([x - (nut_af + nut_c)/2, y0, zc - (nut_t + nut_c)/2])
        cube([nut_af + nut_c, y1 - y0, nut_t + nut_c]);
}

// =====================================================================
//  FOOT
// =====================================================================
module foot2d() rrect(foot_x, foot_y, foot_r);

module foot() {
    difference() {
        hull() {
            linear_extrude(h_ft - chamf) foot2d();
            linear_extrude(h_ft) offset(delta = -chamf) foot2d();
        }
        // 2xAA holder pocket (2 mm floor)
        translate([batt_xy[0], batt_xy[1], 2]) cube([batt[0] + 0.6, batt[1] + 0.6, h_ft]);
        // locating recesses for the bumpers
        for (b = bumpers) translate([b[0], b[1], -1]) cylinder(d = feet_d + 0.6, h = 1.6);
        // tilt stage bolts, heads recessed underneath
        for (mx = mount_x) {
            translate([mx, 0, -1]) cylinder(d = m3_hole, h = h_ft + 2);
            translate([mx, 0, -0.01]) cylinder(d = 6.2, h = 3.4);
        }
        // phone bracket: nuts pulled up into pockets from below
        for (p = phone_holes) {
            translate([p[0], p[1], -0.01])
                cylinder(d = (nut_af + nut_c) / cos(30), h = nut_t + nut_c, $fn = 6);
            translate([p[0], p[1], -1]) cylinder(d = m3_hole, h = h_ft + 2);
        }
        // broom marks: V on the front edge = beam line; Vs on both sides
        // under the tilt pivot, to lay over the T-line
        translate([0, 0, -1]) linear_extrude(h_ft + 2) {
            polygon([[foot_x[1] + 0.1, -2], [foot_x[1] - 2.5, 0], [foot_x[1] + 0.1, 2]]);
            for (s = [0, 1]) let(y = foot_y[s], d = s ? -2.5 : 2.5)
                polygon([[-2, y - d/25], [0, y + d], [2, y - d/25]]);
        }
    }
}

// =====================================================================
//  TILT STAGE  (modelled in place; printed on its side, +Y up)
// =====================================================================
module tilt_fixed2d() {                     // XZ profile of the fixed base
    translate([fl_x0, z_f0]) square([post_hx - fl_x0, t_fl]);             // floor
    translate([-post_hx, z_f0]) square([2 * post_hx, z_lb - z_f0]);       // post
    translate([ped_x[0], z_f0]) square([ped_x[1] - ped_x[0], z_ped - z_f0]); // pedestal
}
module tilt_moving2d() {                    // the arm
    translate([arm_x0, z_ab]) square([clamp_x[1] - arm_x0, arm_t]);
}
module tilt_blades2d() {
    L = 2 * (cwt_a + 1.6);                  // ends embed in post / arm
    translate([0, z_H]) for (a = [45, -45])
        rotate(a) translate([-L/2, -cwt_t/2]) square([L, cwt_t]);
}
module clamp_block() {
    translate([clamp_x[0], -tw, z_at - 0.01])
        cube([clamp_x[1] - clamp_x[0], tw + clamp_yp, z_ct - z_at + 0.01]);
}

module tilt_cuts() {
    cl = clamp_x[1] - clamp_x[0];
    // laser bore along X, teardrop apex +Y (up when printed)
    translate([clamp_x[0] - 1, 0, z_L]) rotate([0, 90, 0])
        linear_extrude(cl + 2) tear2d(las_d + las_clear);
    // slit from the bore out to the +Y face: the pinch screw closes it
    translate([clamp_x[0] - 1, 0, z_L - 0.5]) cube([cl + 2, clamp_yp + 1, 1]);
    // pinch screw (M3 x 16 from the top) + its nut in the lower jaw
    translate([pinch[0], pinch[1], 0]) tear_z(m3_hole, z_at - 3, z_ct - z_at + 4);
    nut_slot(pinch[0], pinch[1] - nut_ac/2 - 0.1, clamp_yp + 1, z_at + 3.65);
    // jack screw (M3 x 25 from the top) + nut in the arm; its thrust
    // bears the nut on the slot's upper face
    translate([-R_tilt, 0, 0]) tear_z(m3_hole, z_ab - 1, arm_t + 2);
    nut_slot(-R_tilt, -nut_ac/2 - 0.1, tw + 1, z_ab + arm_t/2);
    // elastic: groove over the arm's tail, slot through the pedestal
    translate([tband_x[0], -tw - 1, z_at - 1.2]) cube([tband_x[1] - tband_x[0], 2*tw + 2, 2]);
    translate([tband_x[0], -tw - 1, z_f1 + 1])   cube([tband_x[1] - tband_x[0], 2*tw + 2, 4]);
    // bolts up from under the foot: nuts slid into the floor
    for (mx = mount_x) {
        translate([mx, 0, 0]) tear_z(m3_hole, z_f0 - 1, t_fl + 2);
        nut_slot(mx, -nut_ac/2 - 0.1, tw + 1, z_f0 + t_fl/2);
    }
    // sight groove along the clamp top, for turning the foot onto the rock
    translate([clamp_x[0] - 1, 0, z_ct]) rotate([45, 0, 0])
        translate([0, -0.8, -0.8]) cube([cl + 2, 1.6, 1.6]);
}

module tilt_fixed_body()  difference() { prof(2*tw) tilt_fixed2d(); tilt_cuts(); }
module tilt_moving_body() difference() { union() { prof(2*tw) tilt_moving2d(); clamp_block(); } tilt_cuts(); }
module tilt() {
    difference() {
        union() {
            prof(2*tw) { tilt_fixed2d(); tilt_moving2d(); tilt_blades2d(); }
            clamp_block();
        }
        tilt_cuts();
    }
}

// =====================================================================
//  KNOB  (M3 screw head pressed/glued into the hex pocket)
// =====================================================================
module knob() {
    d = 18;  h = 9;
    difference() {
        cylinder(d = d, h = h, $fn = 60);
        for (a = [0 : 30 : 359]) rotate(a) translate([d/2 + 0.9, 0, -1])
            cylinder(r = 1.6, h = h + 2, $fn = 16);
        translate([0, 0, -0.01]) cylinder(d = head_af / cos(30), h = 3.2, $fn = 6);
        translate([0, 0, -1]) cylinder(d = 3.2, h = h + 2);      // hex-key access
        translate([d/2 - 6, -0.6, h - 0.8]) cube([5, 1.2, 1]);    // pointer
    }
}

// =====================================================================
//  PHONE BRACKET  (optional; bolts to the foot's front-left corner)
// =====================================================================
module phone2d() {                          // (y, z) profile
    z0 = h_ft;  zt = h_ft + ph_h;
    polygon([[38, z0], [56, z0], [56, zt - ph_t], [80, zt - ph_t], [80, zt],
             [50, zt], [50, z0 + 28], [38, z0 + 5]]);
}
module phone_mount() {
    difference() {
        translate([ph_x[0], 0, 0]) rotate([90, 0, 90])
            linear_extrude(ph_x[1] - ph_x[0]) phone2d();
        for (p = phone_holes) translate([p[0], p[1], 0]) tear_z(m3_hole, h_ft - 1, 8, 0);
        translate([ph_bolt[0], ph_bolt[1], 0])
            tear_z(tri_hole, h_ft + ph_h - ph_t - 1, ph_t + 2, 0);
        translate([ph_bolt[0], ph_bolt[1], h_ft + ph_h - ph_t - 0.01])
            cylinder(d = (tri_af + 0.4) / cos(30), h = tri_head + 0.3, $fn = 6);
    }
}

// =====================================================================
//  ASSEMBLY HELPERS
// =====================================================================
module laser_dummy() {
    color("Goldenrod") translate([las_x[0], 0, z_L]) rotate([0, 90, 0])
        cylinder(d = las_d, h = las_len - 6);
    color("Khaki") translate([las_x[1] - 6, 0, z_L]) rotate([0, 90, 0])
        cylinder(d = las_d - 1, h = 6);
    color("Red") translate([las_x[1], 0, z_L]) rotate([0, 90, 0])
        cylinder(d = 0.8, h = 70);
}
module band() {
    color("Purple") translate([tband_x[0] + 0.5, 0, 0]) difference() {
        translate([0, -tw - 0.7, z_f1 + 1]) cube([2, 2*tw + 1.4, z_at - 1.2 - z_f1 - 0.3]);
        translate([-1, -tw, z_f1 + 1.7]) cube([4, 2*tw, z_at - 2.6 - z_f1]);
    }
}

// =====================================================================
if (part == "assembly") {
    color("SteelBlue") foot();
    color("Gold") tilt();
    laser_dummy();
    color("DimGray") translate([-R_tilt, 0, z_ped + 25]) knob();
    color("Silver") translate([-R_tilt, 0, z_ped]) cylinder(d = 3, h = 25);
    color("Black") {
        translate([batt_xy[0] + 0.3, batt_xy[1] + 0.3, 2]) cube(batt);
        for (b = bumpers) translate([b[0], b[1], -feet_h]) cylinder(d = feet_d, h = feet_h);
    }
    if (show_band) band();
    if (with_phone) {
        color("SlateGray") phone_mount();
        color("DarkSlateGray") translate([ph_bolt[0] - 6, ph_bolt[1] - 25, h_ft + ph_h])
            cube([12, 50, 22]);                                         // tripod clamp
        color("Black") translate([ph_bolt[0] - 4, ph_bolt[1] - 75, h_ft + ph_h + 22])
            cube([8, 150, 72]);                                         // phone
    }
    color("AliceBlue", 0.4) translate([foot_x[0] - 15, foot_y[0] - 15, -feet_h - 2])
        cube([foot_x[1] - foot_x[0] + 90, foot_y[1] - foot_y[0] + 30, 2]);
}
if (part == "foot")  foot();
if (part == "tilt")  translate([0, z_ct, tw]) rotate([90, 0, 0]) tilt();
if (part == "knob")  knob();
if (part == "phone") translate([0, 0, -ph_x[0]]) rotate([0, -90, 0]) phone_mount();
