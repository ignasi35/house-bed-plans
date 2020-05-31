// factory parts

// mattress board
// main structure holding mattress board
// all-round fence
// house structure

// REMINDERS
// - subtract 0.001 units to guarantee items form a single object
// - rotate first, translate later
// - buld pieces centered so rotation is more intuitive
// - increase resolution using
//     $fa = 1;
//     $fs = 0.4;


bed_board_width=940;   // 0.94m
bed_board_length=1840; // 1.84m
bed_board_height=28;

// PART MODULES

// fence common
//https://www.bricomart.es/liston-abeto-cepillado-2400-x-68-x-34-mm.html
//https://www.bricomart.es/liston-abeto-cepillado-2400-x-34-x-34-mm.html
fence_rail_width=44;
fence_rail_height=44;  // !! 
fence_main_width=44;
fence_main_height=44;
fence_bar_width=44;
fence_bar_height=fence_bar_width;
fence_bar_length=280; // 28cm

// both W and H are equivalent
board_support = 10 ; 

fence_rail_entrance_length=1100;


main_leg_width=44;
main_leg_height=44;
main_leg_length=1400;

height_from_floor= 100;

header_length=bed_board_width + fence_bar_width;

// the separation between fence bars is determined by 
// the aesthetics of the head/foot fence. If the head/foot 
// fence looks nicer with 6 voids (5 bars), then that separation
// will govern all the bed fences
fence_bar_separation=(header_length+fence_bar_width)/4 ; // 188


module fence_bar() {
  cube([
        fence_bar_width,  // x
        fence_bar_height, // y
        fence_bar_length  // z
        ], center=true);
}

// 1. head/foot fence
module head_foot_fence() {
  // fence main
  translate([0,0, -1*((fence_bar_length + fence_main_height)/2)])
    cube([
        header_length,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);

  // fence rail
  translate([0,0, ((fence_bar_length + fence_rail_height)/2)])
    cube(
       [
        header_length,   // x
        fence_rail_width,  // y 
        fence_rail_height  // z
        ],
       center=true);

  // fence bars
  x=header_length+fence_bar_width - 0.001;
  for (dx=[ -x/2 + fence_bar_separation :fence_bar_separation: x/2]) {
    color("green")
      translate([dx, 0, 0])
        fence_bar();
  }

}


// 2. wall fence
module wall_fence() {
  // fence main
  translate([0,0, -1*((fence_bar_length + fence_main_height)/2)])
   rotate([0,0,90])
    cube([
        bed_board_length,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);

  // fence rail
  translate([0,0, ((fence_bar_length + fence_rail_height)/2)])
   rotate([0,0,90])
    cube(
       [
        bed_board_length,   // x
        fence_rail_width,  // y 
        fence_rail_height  // z
        ],
       center=true);

  // fence bars
  x=bed_board_length+fence_bar_width;
  for (dy=[ -x/2 + fence_bar_separation :fence_bar_separation: x/2]) {
    color("green")
     translate([0, dy, 0])
      fence_bar();
  }
  
  wall_support_up = -( fence_bar_length/2+fence_main_height)+board_up;
  color("cyan")
   translate([fence_main_width/2+board_support/2, 0, wall_support_up])
      cube([
        board_support,   // x
        bed_board_length-100,  // y 
        board_support  // z
        ],
       center=true);
}


// 3. entrance fence
module entrance_fence_rail() {
  // fence rail
  translate([0, 0, ((fence_bar_length + fence_rail_height)/2)])
   rotate([0,0,90])
    cube(
       [
        fence_rail_entrance_length,   // x
        fence_rail_width,  // y 
        fence_rail_height  // z
        ],
       center=true);

  // fence bars
  start = (fence_rail_entrance_length-fence_rail_width)/2;
  end = start;
  for (dy=[ -start :fence_bar_separation: end]) {
    color("green")
     translate([0, dy, 0])
      fence_bar();
  }
}

module entrance_fence() {
  // fence main
  translate([0,0, -1*((fence_bar_length + fence_main_height)/2)])
   rotate([0,0,90])
    cube([
        bed_board_length,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);
  translate([0,(bed_board_length-fence_rail_entrance_length)/2,0])
    entrance_fence_rail();

  wall_support_up = -( fence_bar_length/2+fence_main_height)+board_up;
  color("cyan")
   translate([-(fence_main_width+board_support)/2, 0, wall_support_up])
      cube([
        board_support,   // x
        bed_board_length-100,  // y 
        board_support  // z
        ],
       center=true);
}
module bed_board () {
    
  color("red")
    cube([
        bed_board_width,   // x
        bed_board_length,  // y 
        bed_board_height  // z
        ],
       center=true);
    
}


fence_up=fence_bar_length/2+fence_main_height;
board_up=board_support+main_leg_height/5;

module header() {
  translate([ 0, 0 , fence_up])
    head_foot_fence();
    
  // side legs
  up = main_leg_length/2 - height_from_floor  ;
  translate([ header_length/2 , 0 ,  up])
    cube([
        main_leg_height,   // x
        main_leg_width,  // y 
        main_leg_length  // z
        ],
       center=true);
  translate([ -header_length/2, 0 ,  up])
    cube([
        main_leg_height,   // x
        main_leg_width,  // y 
        main_leg_length  // z
        ],
       center=true);

  color("cyan")
   translate([0, -(fence_main_width/2 + board_support), fence_main_width/2])
      cube([
        bed_board_width -100,   // x
        board_support,  // y 
        board_support  // z
        ],
       center=true);

}

module footer() {
  rotate([0,0,180])
    header();
}


module full_bed(){
  translate([0, -(bed_board_length+fence_bar_width)/2, 0])
    footer();
  translate([0, (bed_board_length+fence_bar_width)/2, 0])
    header();
  
  translate([-header_length/2, 0, fence_up])
    wall_fence();
  translate([header_length/2 , 0, fence_up])
    entrance_fence();
    
  translate([0, 0, board_up + bed_board_height/2 + board_support/2 +1 ])
    bed_board();
    
}


full_bed();

