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


bed_board_width=910;   // 0.91m
bed_board_length=1810; // 1.81m
bed_board_height=28;

mattress_board_width=900;   // 
mattress_board_length=1800; // 
mattress_board_height=190;  // 


main_leg_width=44;
main_leg_height=44;
main_leg_length=1400;


// PART MODULES

// fence common
//https://www.bricomart.es/liston-abeto-cepillado-2400-x-68-x-34-mm.html
//https://www.bricomart.es/liston-abeto-cepillado-2400-x-34-x-34-mm.html
fence_rail_width=45;
fence_rail_height=45;  // !! 
fence_main_width=45;
fence_main_height=45;
fence_bar_width=45;
fence_bar_height=fence_bar_width;
fence_bar_length=320; // magic number


// both W and H are equivalent
board_support = 10 ; 

fence_rail_entrance_length=1200;

height_from_floor= 140;

header_length=bed_board_width;
full_side_width=bed_board_width + 2*main_leg_width ;

// the separation between fence bars is determined by 
// the aesthetics of the head/foot fence. If the head/foot 
// fence looks nicer with 6 voids (5 bars), then that separation
// will govern all the bed fences
fence_bar_separation=(header_length+fence_bar_width)/4 ; // 188

fence_up=fence_bar_length/2+fence_main_height;
board_up=board_support+main_leg_height/5;

margin = fence_main_width/sqrt(2);
roof_length = (full_side_width)/sqrt(2) ;
roof_height = roof_length/sqrt(2) ;

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
  // side top
  top_up = main_leg_length - height_from_floor - fence_up - fence_main_width/2;
  translate([0,0, top_up])
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
  
  wall_support_up = -( -fence_main_width*1/7 + fence_bar_length/2 + fence_main_height  );  color("cyan")
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
//  adjust_up = 
  // fence main
  translate([0,0, -1*((fence_bar_length + fence_main_height)/2)])
   rotate([0,0,90])
    cube([
        bed_board_length,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);

  // side top
  top_up = main_leg_length - height_from_floor - fence_up - fence_main_width/2;
  translate([0,0, top_up])
   rotate([0,0,90])
    cube([
        bed_board_length,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);

  translate([0,(bed_board_length-fence_rail_entrance_length)/2,0])
    entrance_fence_rail();

  wall_support_up = -( -fence_main_width*1/7 + fence_bar_length/2 + fence_main_height  );
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

module mattress () {
    
  color("white")
    cube([
        mattress_board_width,   // x
        mattress_board_length,  // y 
        mattress_board_height  // z
        ],
       center=true);
    
}



module header() {
  translate([ 0, 0 , fence_up])
    head_foot_fence();
   
  // side legs
  side_leg_up = main_leg_length/2 - height_from_floor  ;
  side_leg_x= header_length + main_leg_width;
  translate([ side_leg_x/2 , 0 ,  side_leg_up])
    cube([
        main_leg_height,   // x
        main_leg_width,  // y 
        main_leg_length  // z
        ],
       center=true);
  translate([ -side_leg_x/2, 0 ,  side_leg_up])
    cube([
        main_leg_height,   // x
        main_leg_width,  // y 
        main_leg_length  // z
        ],
       center=true);

  top_up = main_leg_length - height_from_floor - main_leg_height/2 ;
  translate([0,0, top_up])
    cube([
        header_length,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);

  color("cyan")
   translate([0, -(fence_main_width/2 + board_support), fence_main_width*1/7])
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



module roof_side() {
        translate([ 0,0, roof_length/2-fence_main_width/2])
          cube([
              fence_bar_width,   // x
              fence_bar_width,  // y 
              roof_length  // z
              ],
             center=true);
        translate([ 0,roof_length/2-fence_main_width/2, 0])
          rotate([90,0,0])
             cube([
                fence_bar_width,   // x
                fence_bar_width,  // y 
                roof_length  // z
                ],
               center=true);
}

module roof() {
        cube([
            bed_board_length,   // x
            fence_bar_width,  // y 
            fence_bar_height  // z
            ],
           center=true);
        translate([ (bed_board_length+fence_main_width) /2,0, 0])
          roof_side();
        translate([ -(bed_board_length+fence_main_width) /2,0, 0])
          roof_side();
}




module full_bed(){
    
  translate([0, -(bed_board_length+fence_bar_width)/2, 0])
    footer();
  translate([0, (bed_board_length+fence_bar_width)/2, 0])
    header();
  translate([0, 0, main_leg_length-height_from_floor + roof_height-margin])
    rotate([0,225,0])
      rotate([0,0,90])
        roof();
    
  translate([-(header_length+main_leg_width)/2, 0, fence_up])
    wall_fence();
  translate([(header_length+main_leg_width)/2 , 0, fence_up])
    entrance_fence();
    
  b_up = board_up + bed_board_height*1/7 + board_support/2 +1 ;
  translate([0, 0, b_up ])
    bed_board();
    
  translate([0, 0, mattress_board_height/2 + b_up])
    mattress();
    
}


full_bed();

