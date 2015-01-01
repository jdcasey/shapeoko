$fn=100;

cm=10;

length=8*cm;
width=4*cm;
height=1*cm;

module hex(r,h){
  echo("r is ", r);
  echo("h is ",h);

  passes = [0:2];
  chord=r*1/tan(60);

  union(){
     for(pass=passes){
       rotate([0,0,pass*60]) cube(size=[r,chord,h],center=true);
     }
  }
}

module block(){
  cube(size=[length, width, height],center=true);
}

module scoop(){
  union(){
    rotate([90,0,0]) translate([-length/4,height/2,-width/1.75]) cylinder(d=height,h=width*1.5);
    rotate([90,0,0]) translate([length/4,height/2,-width/1.75]) cylinder(d=height,h=width*1.5);
    translate([0,0,height/4]) cube(size=[length/2,width*1.5,height/2],center=true);
  }
}

module fastenerCuts(){
  union(){
    translate([-length/2+1/2*cm+2,0,height/2]) hex(r=1*cm,h=1/2*cm);
    translate([-length/2+1/2*cm+2,0,-height/2]) cylinder(r=3.25,h=height*1.5);
    translate([0,0,-height/2]) cylinder(r=3.25,h=height*1.5);
  }
}

module assembly(){
  difference(){
    block();
    scoop();
    fastenerCuts();
  }
}

assembly();



