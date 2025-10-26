// general 
piece_strength = 7;
bonding_margin = 1;
total_width= 40;


// piece 2 params
extra_depth = 9;
actual_p2_z = 75;
p2_x = piece_strength;
p2_y = 40;
p2_z = actual_p2_z + extra_depth;
p2_offset_x = 0;
p2_offset_y = 0;
p2_offset_z = -extra_depth;

// piece 1 params
p1_x = 60;
p1_y = total_width;
p1_z = piece_strength;
p1_offset_x = -p1_x+bonding_margin;
p1_offset_y = 0;
p1_offset_z = actual_p2_z-p1_z;

// piece 3 params
p3_x = 60;
p3_y = total_width;
p3_z = piece_strength;

p3_offset_x = piece_strength -bonding_margin;
p3_offset_y = 0;
p3_offset_z = 0;

// piece 4 params
p4_x = p3_x;
p4_y = piece_strength*1.3;
p4_z = extra_depth;
p4a_offset_x = piece_strength;
p4a_offset_y = 0;
p4a_offset_z = -p4_z;
p4b_offset_x = p4a_offset_x;
p4b_offset_y = p2_y - p4_y;
p4b_offset_z = p4a_offset_z;
p4_sub_x = 30;
p4_sub_y = p4_y+2;
p4_sub_z = 100;

// piece 5 params
p5_x = p1_x-5;
p5_y = total_width;
p5_z = p2_z-1;
p5_offset_x = 0;
p5_offset_y = 0;
p5_offset_z = -extra_depth;
p5_sub_x = 300;
p5_sub_y = p5_y+2;
p5_sub_z = 100;


// piece 6 params
p6_length = total_width + 10;
p6_offset_x = -15;
p6_offset_y = -5;
p6_offset_z = 44;
p6_radius = 10;


// piece 7 params
p7_radius = 7;
p7_offset_x = p3_x + p2_x - p7_radius - 5;
p7_offset_y = p3_y/2;
p7_offset_z = p3_z-3;

// piece 8 params
p8_x = 4;
p8_y = 4;
p8_z = 1000;
p8_offset_x = p7_offset_x - p8_x/2;
p8_offset_y = p7_offset_y - p8_y/2;
p8_offset_z = -p8_z/2;


// piece 11 params
p11_length = piece_strength;
p11_radius = total_width/2;
p11_offset_x = p3_x;
p11_offset_y = p11_radius;
p11_offset_z = 0;

// piece 12 params
p12_length = p11_length;
p12_radius = p11_radius;
p12_offset_x = - p1_x + piece_strength;
p12_offset_y = p11_radius;
p12_offset_z = p1_offset_z;

// piece 9-10 params
phole_inner_radius= 3;
phole_outer_radius= 9;
pcyla_length = 4 + 2;
pcylb_length = 3;
pcylc_length = 100;
p9_offset_x = -p1_x/2 - 15;
p9_offset_y = total_width/2;
p9_offset_z = p2_z - piece_strength- pcylb_length - pcyla_length ;
p10_offset_x = p9_offset_x +36;
p10_offset_y = p9_offset_y;
p10_offset_z = p9_offset_z;


// piece 2
color("green")
translate([ p2_offset_x,  p2_offset_y, p2_offset_z])
cube([p2_x, p2_y, p2_z]);


// piece 1
module p1(){
color("red")
translate([ p1_offset_x,  p1_offset_y, p1_offset_z])
cube([p1_x,p1_y,p1_z]);
}

// piece 12
module p12() {   
  translate([ p12_offset_x,  p12_offset_y, p12_offset_z])
  cylinder( p12_length, p12_radius, p12_radius);
}


module hole_9_10(){
 // cyl a
 translate([0, 0,pcylb_length])
 cylinder(pcyla_length,phole_inner_radius, phole_inner_radius);
 // cyl b
 translate([0, 0,0])
 cylinder(pcylb_length,phole_outer_radius, phole_inner_radius);
 // cyl c
 translate([0, 0,-pcylc_length])
 cylinder(pcylc_length,phole_outer_radius, phole_outer_radius);
}


// piece 5
module p5(){
 color("black")
 rotate([0,0,180])
 translate([ 0, -p5_y, 0])
 difference(){
  cube([p5_x, p5_y, p5_z]);
  translate([0,-1,0])
  rotate([0, 35, 0])
  cube([p5_sub_x, p5_sub_y, p5_sub_z]);
 }  
}

// piece 6
module p6(){
  translate([ p6_offset_x,  p6_offset_y, p6_offset_z])
  rotate( [-90, 0, 0])
  cylinder( p6_length, p6_radius, p6_radius);
}


module p1_56_12(){
 p1();
 p12();   
 difference() {
  translate([ p5_offset_x,  p5_offset_y, p5_offset_z])
  p5();
  p6();
 };

}
module p1_56_910_12(){
  difference() {
   p1_56_12();
   difference() {
    // hole 10
    translate([ p10_offset_x,
       p10_offset_y,
       p10_offset_z])
    hole_9_10();
   }
   // hole 9
   translate([ p9_offset_x,  p9_offset_y, p9_offset_z])
   hole_9_10();
  }
  
}




// piece 4
module p4(){
 color("black")
 difference(){
  cube([p4_x, p4_y, p4_z]);
  translate([0,-1,0])
  rotate([0, 80, 0])
  cube([p4_sub_x, p4_sub_y, p4_sub_z]);
 }  
}

module p11() {   
  translate([ p11_offset_x,  p11_offset_y, p11_offset_z])
  cylinder( p11_length, p11_radius, p11_radius);
}

module p3_11_7(){
p11();
// piece 3
color("blue")
translate([ p3_offset_x,  p3_offset_y, p3_offset_z])
cube([p3_x, p3_y, p3_z]);
// piece 7
translate([ p7_offset_x,  p7_offset_y, p7_offset_z])
sphere(r=p7_radius);
}
module hole_8(){
 translate([ p8_offset_x,    p8_offset_y, p8_offset_z])
 cube([p8_x, p8_y, p8_z]);
}

module p34_78_11(){

// piece 4.a
translate([ p4a_offset_x,  p4a_offset_y, p4a_offset_z])
p4();
// piece 4.b
translate([ p4b_offset_x,  p4b_offset_y, p4b_offset_z])
p4();
    
difference() {
 difference() {    
  p3_11_7();
  hole_8();
 };
 // piece 7
 translate([ p7_offset_x,  p7_offset_y, p7_offset_z-3])
 sphere(r=p7_radius);
}
    
}






p1_56_910_12();
p34_78_11();