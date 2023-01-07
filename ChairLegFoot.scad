VEC_X = [1, 0, 0];
VEC_Y = [0, 1, 0];
VEC_Z = [0, 0, 1];
function mm(x) = x;

foot_diameter = mm(20.0);
pipe_diameter = mm( 9.0);
knob_diameter = mm( 9.0);
knob_height   = mm( 3.0);
bottom_thickness = mm(2.0);
bend_radius   = mm(15);
bend_pos      = mm(6);
bevel_radius  = mm(1.0);
wall          = mm(2.0);

//$fs= mm(2); //$preview?16:64;
$fn = 32;

render(convexity = 2) difference() {
    minkowski() {
        sphere(r = bevel_radius, $fn = $fn / 2);
        difference() {
            render() hull() {
                cylinder(d=foot_diameter - 2*bevel_radius, h = bottom_thickness);
                translate([0,0, bottom_thickness + knob_height + pipe_diameter / 2]) {
                    cube([
                        sqrt(pow(foot_diameter,2) - pow(pipe_diameter, 2)) - 2*bevel_radius,
                        pipe_diameter + 2*wall - 2*bevel_radius, 
                        pipe_diameter * .5
                    ], center=true);
                }
            }
            ChairLeg(r_extra = bevel_radius);
        }
    }
    BIAS = 0.1;
    mirror(VEC_Z) linear_extrude(bevel_radius + BIAS) square(foot_diameter + 2*BIAS, true);
}

module ChairLeg(r_extra = 0, knob = true, pipe = true) {
    translate([0,0, bottom_thickness + knob_height + pipe_diameter / 2]) {
        if(knob) mirror(VEC_Z) cylinder(
            d = knob_diameter + 2*r_extra,
            h = knob_height + pipe_diameter / 2 + r_extra
        );
        if(pipe) translate([bend_pos, 0]) {
            BIAS = 0.1;
            rotate(-90, VEC_Y) {
                cylinder(d = pipe_diameter + 2*r_extra, bend_pos + foot_diameter/2 + BIAS);
            }
            translate([0,0, bend_radius]) rotate(90, VEC_X) {
                rotate_extrude(angle = -90) {
                    translate([bend_radius, 0]) circle(d = pipe_diameter + 2*r_extra);
                }
            }
        }
    }
}