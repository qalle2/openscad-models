/*
Heinkel He 111 from behind;
scale: 1 unit = 9.2 mm (actual wingspan = 22.6 metres)
*/

use <common.scad>

/*
Sections of fuselage from front to rear:
    1, 2: nose cone
    3: from leading to trailing edge of wings
    4: frustum, from trailing edge of wings to leading edge of horiz. stabil.
    5: tail
*/
FUA  = 4/5;  // width/height ratio (must be uniform)
FUL1 = 120;
FUH1 =  80;
FUL2 = 120;
FUH2 = 200;
FUL3 = 520;
FUH3 = 240;
FBW3 = FUA*FUH3/(1+sqrt(2));  // flat bottom width
FUL4 = 660;
FUH4 = 120;
FUL5 = 300;
FUH5 =   0;

/*
wings
    "1" = inner, "2" = middle, "3" = outer
    "length" = from root to tip
    "width"  = from leading to trailing edge
*/
WIA  = 5;     // width/height ratio (must be uniform)
WIXO = 1/4;   // horizontal offset of middle wing (of WIW2)
WIYO = 1/8;   // vertical slope of middle & outer wings (of WIL2 & WIL3)
WIL1 = 240; WIW1 = FUL3;
WIL2 = 940; WIW2 = 250;
WIL3 = 100; WIW3 = 100;

/*
stabilisers
    "H" = horizontal, "V" = vertical
    "length" = from root to tip
    "width"  = from leading to trailing edge
*/
STAR  = 2/15;  // width/thickness ratio (must be uniform)
HSTL1 =  280;
HSTL2 =  140;
VSTL1 =  200;
VSTL2 =  100;
STW1  = FUL5;
HSTW2 =  250;
VSTW2 =  200;
HSTW3 =  120;
VSTW3 =  100;
HSTSL = 0.03;  // backwards slant (of STW1)
VSTSL = 0.10;  // backwards slant (of STW1)

// engines
ENR  =  70;  // radius
ENL  = 360;  // length
PRR  = 180;  // propeller radius
PHL  =  50;  // propeller hub length

THIN = 20;  // minimum thickness of anything

// colors
FUC = [.8, .5, .5];  // fuselage
PLC = [.8, .8, .5];  // wings and stabilisers
OTC = [.5, .8, .8];  // other parts

module he111() {
    /* Heinkel He 111 */
    color(FUC) fuselage(FUL1, FUL2, FUL3, FUL4, FUL5, FUH1, FUH2, FUH3, FUH4, FUH5, FUA);
    // wings
    color(PLC) for(x = [-1, 1]) {
        translate([x*(WIL1+WIL2+WIL3+FBW3)/2, 0, (WIW1/WIA-FUH3)/2]) {
            rotate(-x*90) wing(x);
        }
    }
    // stabilisers
    color(PLC) translate([0, -(FUL3+FUL5)/2-FUL4, 0]) {
        // horizontal
        for(x = [-1, 1]) translate([x*(HSTL1+HSTL2)/2, 0, 0]) rotate(-x*90) {
            stabiliser(HSTL1, HSTL2, STW1, HSTW2, HSTW3, x*HSTSL);
        }
        // vertical
        translate([0, 0, (VSTL1+VSTL2)/2]) rotate([90, 0, -90]) {
            stabiliser(VSTL1, VSTL2, STW1, VSTW2, VSTW3, VSTSL);
        }
    }
    // engines
    color(OTC) for(x = [-1, 1]) {
        translate([x*(FBW3/2+WIL1), FUL3/2, (WIW1/WIA-FUH3)/2]) engine();
    }
}

he111();

module fuselage(l1, l2, l3, l4, l5, h1, h2, h3, h4, h5, whr) {
    /*
    args:
        l1...l5: length (front to rear)
        h1...h5: height (front to rear)
        whr:     width/height ratio
    */
    // front
    translate([0, l2+(l1+l3)/2, 0]) {
        scale([whr*h2, l1, h2]) oct_frustum(h1/h2);
    }
    // mid-front
    translate([0, (l2+l3)/2, 0]) {
        scale([whr*h3, l2, h3]) oct_frustum(h2/h3);
    }
    // mid
    scale([whr*h3, l3, h3]) oct_frustum(1);
    // mid-rear
    translate([0, -(l3+l4)/2, 0]) {
        rotate(180) scale([whr*h3, l4, h3]) oct_frustum(h4/h3);
    }
    // rear
    translate([0, -l4-(l3+l5)/2, 0]) {
        rotate(180) scale([whr*h4, l5, h4]) oct_frustum(h5/h4);
    }
}

module wing(ss) {
    /* centered;
    root towards viewer;
    ss = slant sign */
    // inner (straight)
    translate([0, (-WIL2-WIL3)/2, 0]) {
        scale([WIW1, WIL1, WIW1/WIA]) hex_frustum(1);
    }
    // middle (horizontal & vertical slant)
    translate([0, (WIL1-WIL3)/2, 0]) {
        scale([WIW1, WIL2, WIW1/WIA]) {
            hex_frustum(WIW2/WIW1, ss*WIXO*WIW2/WIW1, WIYO*WIL2*WIA/WIW1);
        }
    }
    // outer (vertical slant)
    translate([ss*WIXO*WIW2, (WIL1+WIL2)/2, WIYO*WIL2]) {
        scale([WIW2, WIL3, WIW2/WIA]) {
            hex_frustum(WIW3/WIW2, 0, WIYO*WIL3*WIA/WIW2);
        }
    }
}

module stabiliser(il, ol, iw, mw, ow, sl) {
    /*
    il/ol    = inner/outer length
    iw/mw/ow = inner/middle/outer width
    sl       = slant backwards
    */
    // inner
    translate([0, -ol/2, 0]) {
        scale([iw, il, STAR*iw]) hex_frustum(mw/iw, sl*il/(il+ol), 0);
    }
    // outer
    translate([sl*il/(il+ol)*iw, il/2, 0]) {
        scale([mw, ol, STAR*mw]) hex_frustum(ow/mw, sl*ol/(il+ol), 0);
    }
}

module engine() {
    // front half
    translate([0, ENL/4, 0]) {
        scale([ENR*2, ENL/2, ENR*2]) oct_frustum(1);
    }
    // rear half
    translate([0, -ENL/4, 0]) rotate(180) {
        scale([ENR*2, ENL/2, ENR*2]) oct_frustum(WIW1/(WIA*ENR*2));
    }
    // propeller hub
    translate([0, ENL/2+PHL/2, 0]) scale([ENR, PHL, ENR]) hex_frustum();
    // propeller blades
    for(i = [0, 1, 2]) rotate([0, 30+i*120, 0]) {
        translate([PRR/2, ENL/2+THIN, 0]) rotate([0, 45, -90]) {
            scale([THIN, PRR, THIN*2]) hex_wedge(1/2);
        }
    }
}
