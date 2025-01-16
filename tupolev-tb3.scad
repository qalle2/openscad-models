/*
Tupolev TB-3 from behind;
1 unit = 16 mm (actual wingspan = 41.8 metres);
Y=0 at middle of wings; Z=0 at centerline of thickest fuselage
*/

use <common.scad>

/*
Sections of fuselage from front to rear:
    1: "front":     front of frustum
    2: "front-mid": frustum
    3: "mid-front": from frustum to leading  edge of wings
    4: "mid":       from leading to trailing edge of wings
    5: "mid-rear":  from trailing edge of wings to frustum
    6: "rear-mid":  frustum
    7: "rear":      rectangular cuboid
*/
FUL1 =  80;  // length - front
FUL2 = 140;  // length - front-mid
FUW2 = 100;  // width  - front-mid
FUH2 = 120;  // height - front-mid
FUL3 = 100;  // length - mid-front
FUL4 = 520;
FUW4 = 140;  // width  - mid
FUH4 = 160;  // height - mid
FUL5 = 100;  // length - mid-rear
FUL6 = 480;  // length - rear-mid
FUL7 = 200;  // length - rear
FUW7 =  80;  // width  - rear
FUH7 = 120;  // height - rear

/*
For wings and stabilisers:
    "length" = from fuselage to tip
    "width"  = from leading to trailing edge
Sections of wing: inner, outer. Separated by centerline of inner engine.
*/
WIA  =    5;  // width/thickness (must be uniform)
WIL1 =  150;  // length - inner
WIW1 = FUL4;  // width - inner
WIL2 = 1060;  // length - outer
WIW2 =  150;  // width - outer
WTSL = 7/10;  // tip vertical slant (of max height)

// stabilisers
HSTL  = 400;  // horizontal - length
VSTL  = 230;  // vertical   - length
HSTW2 = 120;  // horizontal - width outer
VSTW2 =  90;  // vertical   - width outer

// engines
ENW  =  60;  // width
ENL  = 180;  // length
ENH  = 130;  // height
ENOX = 280;  // outer engine X/Y/Z relative to inner
ENOY = -30;
ENOZ =  20;
PHR  =  20;  // propeller hub radius/length
PHL  =  30;
PBL  = 115;  // propeller blade length/width/thickness
PBW  =  20;
PBT  =  10;

// landing gear
GEH = 110;  // height (vertical beam)
GEL = 130;  // length (horizontal beam)
WHR =  45;  // wheel radius

GUL = 100;  // gun length

THIN = 20;  // minimum thickness of anything

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

// fuselage
// front
translate([0, FUL2+FUL3+(FUL1+FUL4)/2, (FUH2-FUH4)/2]) {
    color(FUC) front_fuselage();
    // gun
    color(OTC) translate([0, GUL/2, (FUH2+THIN)/2]) {
        scale([THIN, GUL, THIN]) oct_frustum();
    }
}
// front-mid
color(FUC) translate([0, FUL3+(FUL2+FUL4)/2, 0]) scale([FUW4, FUL2, FUH4]) {
    rect_frustum(FUW2/FUW4, FUH2/FUH4, 0, (FUH2/FUH4-1)/2);
}
// mid-front
translate([0, (FUL4+FUL3)/2, 0]) {
    color(FUC) mid_front_fuselage();
    // windshield
    color(OTC) translate([0, THIN/2, (FUH4+THIN)/2]) {
        scale([FUW4*2/3, THIN, THIN]) wedge(1, 0, -.5);
    }
}
// mid
color(FUC) cube([FUW4, FUL4, FUH4], center=true);
// mid-rear
translate([0, -(FUL4+FUL5)/2, 0]) {
    color(FUC) mid_rear_fuselage();
    // guns
    color(OTC) for(x = [-1, 1]) {
        translate([x*(FUW4/3+GUL/2), x*FUL5*3/10, (FUH4+THIN)/2]) {
            rotate(90) scale([THIN, GUL, THIN]) oct_frustum();
        }
    }
}
// rear-mid
translate([0, -FUL5-(FUL4+FUL6)/2, 0]) color(FUC) {
    rotate(180) scale([FUW4, FUL6, FUH4]) {
        rect_frustum(FUW7/FUW4, FUH7/FUH4, 0, (1-FUH7/FUH4)/2);
    }
}
// rear
translate([0, -FUL5-FUL6-(FUL4+FUL7)/2, (FUH4-FUH7)/2]) {
    color(FUC) cube([FUW7, FUL7, FUH7], center=true);
}

// wings
color(PLC) translate([0, 0, (WIW1/WIA-FUH4)/2]) for(x = [-1, 1]) {
    // inner
    translate([x*(FUW4+WIL1)/2, 0, 0]) {
        scale([WIL1, WIW1, WIW1/WIA]) rotate(90) oct_frustum();
    }
    // outer
    translate([x*((FUW4+WIL2)/2+WIL1), 0, 0]) {
        rotate(-x*90) scale([WIW1, WIL2, WIW1/WIA]) {
            oct_frustum(WIW2/WIW1, 0, WTSL);
        }
    }
}
// stabilisers
color(PLC) translate([0, -FUL5-FUL6-(FUL4+FUL7)/2, (FUH4-FUH7)/2]) {
    // horizontal
    for(x = [-1, 1])  {
        translate([x*(FUW7+HSTL)/2, 0, (FUH7-THIN)/2]) {
            rotate([0, -90+x*90, -x*90]) scale([FUL7, HSTL, THIN]) {
                oct_frustum(HSTW2/FUL7, 1/2-(HSTW2/2+20)/FUL7, 0);
            }
        }
    }
    // vertical
    translate([0, 0, (FUH7+VSTL)/2]) rotate([90, 0, -90]) {
        scale([FUL7, VSTL, THIN]) {
            oct_frustum(VSTW2/FUL7, 1/2-(VSTW2/2+20)/FUL7, 0);
        }
    }
}

// engines (x = left/right, o = inner/outer)
color(OTC) for(x = [-1, 1], o = [0, 1]) {
    translate(
        [x*(FUW4/2+WIL1+o*ENOX), WIW1/2+o*ENOY, (WIW1/WIA-FUH4)/2+o*ENOZ]
    ) engine();
}
// landing gear
color(OTC) for(zr = [0, 180]) rotate(zr) translate([FUW4/2+WIL1, 0, -FUH4/2]) landing_gear();

module front_fuselage() {
    // 6 polyhedra
    scale([FUW2/3, FUL1/2, FUH2]) {
        // center
        translate([0, -1/2, -1/8]) cube([1, 1, 3/4], center=true);  // rear
        translate([0,  1/2,    0]) rotate([0, 180, 0]) wedge(1, 0, -.5);  // front
        // left/right
        for(x = [-1, 1]) translate([x, 0, 0]) {
            // rear
            translate([0, -1/2, 0]) rotate([0, 135-x*45, 0]) five_sixths_cube();
            // front
            translate([0,  1/2, 0]) rotate([0, 135-x*45, 0]) sixth_cube();
        }
    }
}

module mid_front_fuselage() {
    // rear half is seat; seat width is 2/3 of total width
    scale([FUW4, FUL3, FUH4]) {
        // front
        translate([0,  1/4,    0]) cube([  1, 1/2,   1], center=true);
        // rear center
        translate([0, -1/4, -1/8]) cube([2/3, 1/2, 3/4], center=true);
        // rear left/right
        for(x = [-1, 1]) {
            translate([x*5/12, -1/4, 0]) cube([1/6, 1/2, 1], center=true);
        }
    }
}

module mid_rear_fuselage() {
    // gunners' seats; 6 cuboids; all have the same Z_min;
    // from above ("S" = seat, "." = full-height):
    //   . . . S S .
    //   . . . S S .
    //   . . . . . .
    //   . S S . . .
    //   . S S . . .
    for(x = [-1, 1]) {
        scale([FUW4, FUL5, FUH4]) {
            // seats (front right / rear left)
            translate([x/6, x*3/10, -1/8]) cube([1/3, 2/5, 3/4], center=true);
            // large full-height cuboids (front left / rear right)
            translate([x/4, -x/5, 0]) cube([1/2, 3/5, 1], center=true);
            // small full-height cuboids (front right / rear left)
            translate([x*5/12, x*3/10, 0]) cube([1/6, 2/5, 1], center=true);
        }
    }
}

module engine() {
    // rear
    translate([0, -ENL/4, 0]) cube([ENW, ENL/2, ENH], center=true);
    // front
    translate([0, ENL/4, 0]) {
        scale([ENW, ENL/2, ENH]) rect_frustum(1, 1/2, 0, 1/4);
    }
    // propeller hub
    translate([0, ENL/2+PHL/2, PHR]) {
        scale([PHR*2, PHL, PHR*2]) oct_frustum(1/2);
    }
    // propeller blades
    translate([0, (ENL+PHL)/2, PHR]) for(x = [0, 1]) {
        rotate([0, 30+x*180, 0])
            translate([PBL/2, 0, 0])
            rotate([0,45,-90]) scale([PBT, PBL, PBW]) oct_frustum(1/2);
    }
}

module landing_gear() {
    // centered on vertical beam
    // vertical beam
    translate([0, 0, -GEH/2]) cube([THIN, THIN, GEH], center=true);
    translate([0, 0, -GEH-THIN/2]) {
        // horizontal beam
        cube([THIN, GEL, THIN], center=true);
        // wheels
        translate([THIN, 0, 0]) for(x = [-1, 1]) translate([0, x*GEL/2, 0]) {
            rotate(x*90) scale([WHR*2, THIN, WHR*2]) oct_frustum();
        }
    }
}
