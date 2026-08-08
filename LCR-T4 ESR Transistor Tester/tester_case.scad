// =====================================================================
//  Component-tester enclosure  (transistor / LCR tester + 9V battery)
//  Layout: BATTERY on the LEFT, BOARD on the RIGHT, divider between.
//  The ZIF socket sits at the board's left edge; its overhang + lever
//  cross a top-open notch in the divider into the airspace ABOVE the
//  battery (option 2). Wires exit the board's left edge and pass through
//  a mid-Y slot in the divider to the battery.
//  Tuned for a 0.4 mm nozzle. Units: millimetres.
//
//     openscad -D 'part="base"' -o base.stl tester_case.scad
//     openscad -D 'part="lid"'  -o lid.stl  tester_case.scad
// =====================================================================

part = "both";        // "base" | "lid" | "both"
$fn  = 48;

// ---- shell (0.4 mm nozzle: 2.4 = 6 clean perimeters) ----------------
wall = 2.4; floor_th = 2.4; lid_th = 2.4; divider_th = 2.4;

// ---- PCB (device) ---------------------------------------------------
// Board-local: x=0 LEFT edge (ZIF side), x=board_x RIGHT edge (button);
// y=0 bottom edge, y=board_y top edge (screen is up top).
board_x = 70.91; board_y = 64.0; board_th = 1.60;
board_clear = 1.0;

// Mounting-hole CENTRES (3 mm holes). Interpreted as symmetric rectangle.
board_holes = [ [ 2.59, 20.20], [ 2.59, 60.25],
                [68.32, 20.20], [68.32, 60.25] ];
standoff_d = 7.0;      // was 6.0 - thicker for stronger standoffs (nears divider/corner posts)
screw_pilot_d = 1.90;   // self-tap pilot, dialed in on M2 fit-tester (1.7 split; 1.90 grips w/o splitting)

// ---- 9V battery (PP3) ----------------------------------------------
batt_x = 26.5; batt_y = 48.5; batt_h = 17.5;
batt_clear   = 2.0;    // clearance left/top/bottom of battery
batt_gap_div = 6.0;    // gap between battery right edge and divider
                       //   (ZIF overhang + lever descend into here)

// ---- heights --------------------------------------------------------
screen_top_above_board = 5.67;   // LCD glass top above PCB top face
screen_gap = 2;                  // screen top this far above battery top
top_gap    = 1;                  // screen top -> lid underside
leg_h = batt_h + screen_gap - board_th - screen_top_above_board;

// ---- lid openings (board-local x,y) --------------------------------
screen_win_x = [8.86, 63.37];    // active area: left 8.86, width 54.51
screen_win_y = [26.78, 56.46];   // active area: bottom 26.78, height 29.68
zif_open_x   = [-6, 32];         // ZIF body + lever swing (left)
zif_open_y   = [-1, 20];         // + trench up for lever-down
button_center = [64.70, 8.0]; button_d = 14.0;   // 12.93 cap + clearance

// ---- lid corner posts ----------------------------------------------
post_size = 7; post_pilot_d = 1.90; post_pilot_dep = 9; lid_clear_d = 2.6;

// ---- board offset from divider & right wall ------------------------
board_gap_div     = 1.0;            // board left edge sits just right of divider
board_right_margin = post_size + 1; // clear the right corner posts

// ---- divider notch (ZIF overhang crossing) & wire slot -------------
slot_w = 12;                        // wire slot width (Y)
slot_depth = 10;                    // wire slot depth down from top

// =====================================================================
//  DERIVED LAYOUT
// =====================================================================
battery_zone_x = batt_clear + batt_x + batt_gap_div;
board_zone_x   = board_gap_div + board_x + board_right_margin;
inner_x = battery_zone_x + divider_th + board_zone_x;
inner_y = max(board_y + 2*board_clear, batt_y + 2*batt_clear);
ox = inner_x + 2*wall;  oy = inner_y + 2*wall;
cavity_depth = batt_h + screen_gap + top_gap;
H = floor_th + cavity_depth;

div_x0 = wall + battery_zone_x;                 // divider left face
bx0 = wall + battery_zone_x + divider_th + board_gap_div;  // board left edge
by0 = wall + (inner_y - board_y)/2;             // board bottom edge
function babs(p) = [bx0 + p[0], by0 + p[1]];

// battery placement (pushed left, gap on the right)
batt_x0 = wall + batt_clear;
batt_y0 = wall + (inner_y - batt_y)/2;

post_pos = [ [wall,                  wall],
             [ox - wall - post_size, wall],
             [wall,                  oy - wall - post_size],
             [ox - wall - post_size, oy - wall - post_size] ];

// ZIF overhang notch through divider: bottom just below ZIF underside
notch_z0 = floor_th + leg_h + board_th - 1;
zif_ny0 = by0 - 2;  zif_ny1 = by0 + 20;   // Y span of ZIF + lever

echo(str("OUTER (X,Y,Z) = ", ox, " x ", oy, " x ", H, " mm"));
echo(str("leg_h = ", leg_h, "  cavity = ", cavity_depth));
echo(str("battery gap to divider = ", batt_gap_div, " mm"));

// =====================================================================
module base() {
    difference() {
        union() {
            // shell
            difference() {
                cube([ox, oy, H]);
                translate([wall, wall, floor_th])
                    cube([inner_x, inner_y, cavity_depth + 5]);
            }
            // divider
            translate([div_x0, wall, floor_th])
                cube([divider_th, inner_y, cavity_depth]);
            // corner posts
            for (p = post_pos)
                translate([p[0], p[1], floor_th]) cube([post_size, post_size, cavity_depth]);
            // board standoffs
            for (h = board_holes)
                translate([babs(h)[0], babs(h)[1], floor_th]) cylinder(d = standoff_d, h = leg_h);
        }
        // ZIF overhang notch (top-open, through divider)
        translate([div_x0 - 1, zif_ny0, notch_z0])
            cube([divider_th + 2, zif_ny1 - zif_ny0, cavity_depth]);
        // wire slot (top-open notch at mid-Y, through divider)
        translate([div_x0 - 1, wall + (inner_y - slot_w)/2, H - slot_depth])
            cube([divider_th + 2, slot_w, slot_depth + 2]);
        // corner-post pilots
        for (p = post_pos)
            translate([p[0] + post_size/2, p[1] + post_size/2, H - post_pilot_dep])
                cylinder(d = post_pilot_d, h = post_pilot_dep + 1);
        // standoff pilots
        for (h = board_holes)
            translate([babs(h)[0], babs(h)[1], floor_th - 1])
                cylinder(d = screw_pilot_d, h = leg_h + 2);
    }
}

module lid() {
    difference() {
        cube([ox, oy, lid_th]);
        // screen window
        translate([babs([screen_win_x[0], screen_win_y[0]])[0],
                   babs([screen_win_x[0], screen_win_y[0]])[1], -1])
            cube([screen_win_x[1]-screen_win_x[0], screen_win_y[1]-screen_win_y[0], lid_th+2]);
        // ZIF opening
        translate([babs([zif_open_x[0], zif_open_y[0]])[0],
                   babs([zif_open_x[0], zif_open_y[0]])[1], -1])
            cube([zif_open_x[1]-zif_open_x[0], zif_open_y[1]-zif_open_y[0], lid_th+2]);
        // button hole
        translate([babs(button_center)[0], babs(button_center)[1], -1])
            cylinder(d = button_d, h = lid_th+2);
        // corner screw clearance
        for (p = post_pos)
            translate([p[0]+post_size/2, p[1]+post_size/2, -1])
                cylinder(d = lid_clear_d, h = lid_th+2);
    }
}

if (part == "base") base();
else if (part == "lid") lid();
else { base(); translate([0, oy + 10, 0]) lid(); }
