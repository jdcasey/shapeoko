$fn=50;

len=60;
wid=30;
thick=10;

module block(){
  cube(size=[len,wid,thick], center=false);
}

module scoopEnd(){
  width=2*wid;
  r=5;
    rotate([0,90,0])
      cylinder(r=r, h=width);
}

module scoopMiddle(){
  cube(size=[30,wid*2,thick],center=false);
}

module scoop(){
  xoff=-10;
  y2off=45;
  yoff=15;
  zoff=thick;

  union(){
    translate([xoff,yoff,zoff])
      scoopEnd();
    translate([xoff,y2off,zoff])
      scoopEnd();

    translate([xoff,yoff,zoff/2])
      scoopMiddle();
  }
}

module assemble(){
  difference(){
    block();
    scoop();
  }
}

scoop();