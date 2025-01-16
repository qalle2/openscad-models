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

// fuselage
color(FUC) {
    // front
    translate([0, FUL2+(FUL1+FUL3)/2, 0]) {
        scale([FUA*FUH2, FUL1, FUH2]) oct_frustum(FUH1/FUH2);
    }
    // mid-front
    translate([0, (FUL2+FUL3)/2, 0]) {
        scale([FUA*FUH3, FUL2, FUH3]) oct_frustum(FUH2/FUH3);
    }
    // mid
    scale([FUA*FUH3, FUL3, FUH3]) oct_frustum();
    // mid-rear
    translate([0, -(FUL3+FUL4)/2, 0]) {
        rotate(180) scale([FUA*FUH3, FUL4, FUH3]) oct_frustum(FUH4/FUH3);
    }
    // rear
    translate([0, -FUL4-(FUL3+FUL5)/2, 0]) {
        rotate(180) scale([FUA*FUH4, FUL5, FUH4]) oct_frustum(FUH5/FUH4);
    }
}

// wings
color(PLC) translate([0, 0, (WIW1/WIA-FUH3)/2]) for(x = [-1, 1]) {
    // inner (straight)
    translate([x*(FBW3+WIL1)/2, 0, 0]) {
        rotate(-x*90) scale([WIW1, WIL1, WIW1/WIA]) oct_frustum();
    }
    // middle (horizontal & vertical slope)
    translate([x*((FBW3+WIL2)/2+WIL1), 0, 0]) {
        rotate(-x*90) scale([WIW1, WIL2, WIW1/WIA]) {
            oct_frustum(WIW2/WIW1, x*WIXO*WIW2/WIW1, WIYO*WIL2*WIA/WIW1);
        }
    }
    // outer (vertical slope)
    translate([x*((FBW3+WIL3)/2+WIL1+WIL2), -WIXO*WIW2, WIYO*WIL2]) {
        rotate(-x*90) scale([WIW2, WIL3, WIW2/WIA]) {
            oct_frustum(WIW3/WIW2, 0, WIYO*WIL3*WIA/WIW2);
        }
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

module stabiliser(il, ol, iw, mw, ow, sl) {
    /*
    il/ol    = inner/outer length
    iw/mw/ow = inner/middle/outer width
    sl       = slant backwards
    */
    translate([0, -ol/2, 0]) {
        scale([iw, il, STAR*iw]) oct_frustum(mw/iw, sl*il/(il+ol), 0);  // inner
    }
    translate([sl*il/(il+ol)*iw, il/2, 0]) {
        scale([mw, ol, STAR*mw]) oct_frustum(ow/mw, sl*ol/(il+ol), 0);  // outer
    }
}

module engine() {
    // front half
    translate([0, ENL/4, 0]) {
        scale([ENR*2, ENL/2, ENR*2]) oct_frustum();
    }
    // rear half
    translate([0, -ENL/4, 0]) rotate(180) {
        scale([ENR*2, ENL/2, ENR*2]) oct_frustum(WIW1/(WIA*ENR*2));
    }
    // propeller hub
    translate([0, ENL/2+PHL/2, 0]) scale([ENR, PHL, ENR]) oct_frustum(1/2);
    // propeller blades
    for(i = [0, 1, 2]) rotate([0, 30+i*120, 0]) {
        translate([PRR/2, ENL/2+THIN, 0]) rotate([0, 45, -90]) {
            scale([THIN, PRR, THIN*2]) oct_frustum(1/2);
        }
    }
}
