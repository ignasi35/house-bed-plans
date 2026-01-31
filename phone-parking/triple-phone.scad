number_of_phones = 3;

$fn = 20;

base_height = 6;
wall_width =9;
phone_width = 16;

wall_height_low = 42;
wall_height_high = 56;
wall_offset = 1;

length = 150;
extra_width_per_phone = wall_width - wall_offset + phone_width ;
base_width = wall_width + extra_width_per_phone * number_of_phones;

// base
cube([length, 
  base_width ,
  base_height,
  ]);

// letter P
color("white")
translate( [length *1/17,  1, wall_height_low * 1/9])
  rotate([90, 0, 0])
    linear_extrude(2) 
      text("Phone Garage", font = "Liberation Sans:style=Bold");

// low wall (exists always) 
rotate([90, 0, 90])
    linear_extrude(length)
     translate([wall_offset, wall_offset])
      offset( [wall_offset, true])
        square([
           wall_width - wall_offset, 
           wall_height_low - wall_offset
        ]);


// 
module high_walls_module(number_of_phones) {
 for( index = [1:number_of_phones]) {
   offset = index * (wall_width - wall_offset + phone_width) ;
   wall_height = wall_height_low + 
     (wall_height_high - wall_height_low) * index/number_of_phones;
   translate( [0, offset, 0 ])
     rotate([90, 0, 90])
       linear_extrude(length)
         translate([wall_offset, wall_offset])
          offset( [wall_offset, true])
            square([
              wall_width - wall_offset, 
              wall_height - wall_offset
           ]);
  }
}


// high-walls (one per phone)
high_walls_module(number_of_phones);
