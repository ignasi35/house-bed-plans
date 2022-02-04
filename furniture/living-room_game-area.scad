// factory parts

main_back_x=2000;
main_back_z=600;
main_top_z=400;
main_top_y=18;

side_back_x=1200;
side_back_z=500;
side_top_y=18;

margin_on_side=100;


module p2000_600_18(){
    cube([ 
        main_back_x,         // x
        18,           // y
        main_back_z   // z
        ], center=false);
}

module p800_400_18(){
    cube([
        800,  // x
        18, // y
        main_top_z  // z
        ], center=false);
}

module p2000_400_18(){
    cube([
        main_back_x,  // x
        main_top_y, // y
        main_top_z  // z
        ], center=false);
}

module p1200_500_18(){
    cube([
        side_back_x,  // x
        side_top_y, // y
        side_back_z  // z
        ], center=false);
}

module p1200_300_18(){
    cube([
        side_back_x,  // x
        18, // y
        300  // z
        ], center=false);
}

module p500_300_18(){
    cube([
        side_back_z,  // x
        18, // y
        300  // z
        ], center=false);
}

// REMINDERS
// - subtract 0.001 units to guarantee items form a single object
// - rotate first, translate later
// - buld pieces centered so rotation is more intuitive
// - increase resolution using
//     $fa = 1;
//     $fs = 0.4;

module main_back(){
  color("red")    
    p2000_600_18();
}

module main_top(){
  color("white")    
    p2000_400_18();
}

module main_left(){
  color("green")    
    p800_400_18();
}

module side_back(){
  color("green")    
    p1200_500_18();
}

module side_top(){
  color("cyan")    
    p1200_300_18();
}

module side_right(){
  color("red")    
    p500_300_18();
}

module main() {
  translate([0, 20, 0])
    main_back();
  translate([0, 0, main_back_z + main_top_y - 0.001])
    rotate([-90, 0, 0])  
      main_top();
  translate([main_back_x-0.001, 0, 0])
    rotate([0, -90, -90])  
      main_left();  
}
module side() {   
  translate([0, side_back_x  - 0.001, 0])
    rotate([0, 0, -90])  
      side_back();
  translate([side_top_y, 0, side_back_z - margin_on_side  - 0.001])
    rotate([90, 0, 90])  
      side_top();
  translate([0, side_back_x + side_top_y - 0.001, 0])
    rotate([0, -90, 180])  
      side_right();  
}
module full() {   
  main();
  side();
}

full();
