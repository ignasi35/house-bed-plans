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


// PART LIST

// 1. head/foot fence
//https://www.bricomart.es/liston-abeto-cepillado-2400-x-68-x-34-mm.html
//https://www.bricomart.es/liston-abeto-cepillado-2400-x-34-x-34-mm.html
fence_rail_width=34;
fence_rail_height=34;
fence_bar_width=34;
fence_bar_height=34;
fence_main_width=34;
fence_main_height=68;

fence_bar_length=280; // 28cm

bed_board_width=940;   // 0.94m
bed_board_length=1840; // 1.84m


// this arithmetic is wrong
//fence_bar_separation=(bed_board_width)/5 ; // 188
// 
fence_bar_separation=(bed_board_width+fence_bar_width)/6 ; // 188


// fence main
translate([0,0, -1*((fence_bar_length + fence_main_height)/2 - 0.001)])
    cube([
        bed_board_width,   // x
        fence_main_width,  // y 
        fence_main_height  // z
        ],
       center=true);

// fence rail
translate([0,0, ((fence_bar_length + fence_rail_height)/2 - 0.001)])
    cube(
       [
        bed_board_width,   // x
        fence_rail_width,  // y 
        fence_rail_height  // z
        ],
       center=true);

// fence bars
// (starting from the left...)
translate([-fence_bar_separation*2, 0, 0])
    cube(
       [
        fence_bar_width,  // x
        fence_bar_height, // y
        fence_bar_length  // z
        ],
       center=true);
translate([-fence_bar_separation, 0, 0])
    cube(
       [
        fence_bar_width,  // x
        fence_bar_height, // y
        fence_bar_length  // z
        ],
       center=true);
    cube(
       [
        fence_bar_width,  // x
        fence_bar_height, // y
        fence_bar_length  // z
        ],
       center=true);
translate([fence_bar_separation, 0, 0])
    cube(
       [
        fence_bar_width,  // x
        fence_bar_height, // y
        fence_bar_length  // z
        ],
       center=true);
translate([fence_bar_separation*2, 0, 0])
    cube(
       [
        fence_bar_width,  // x
        fence_bar_height, // y
        fence_bar_length  // z
        ],
       center=true);







