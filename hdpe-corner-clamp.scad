$fn=150;

px_per_in=90;

thickness=1/2 * px_per_in;
width=2 * px_per_in;
length=4 * px_per_in;

module hex(r,h)
{
   angle=180/3;
	edge = r * cot(angle);

	union()
	{
		rotate([0,0,0])
			cube([r,edge,h],center=true);
		rotate([0,0,angle])
			cube([r,edge,h],center=true);
		rotate([0,0,2*angle])
			cube([r,edge,h],center=true);
	}
}

function cot(x)=1/tan(x);

module slot(xoff,zoff){
  s_width=9/32 * px_per_in;
  s_len=3/4 * length;

  r=s_width/2;
  yoff=10;

  t_buf=10;
  s_thick=thickness + (2*t_buf);

  union(){
    translate([r+xoff,0-t_buf,zoff]) rotate([270,0,0]) cylinder(r=r,h=s_thick);
    translate([r+xoff,0-t_buf,zoff-r]) cube(size=[s_len-s_width, s_thick, s_width]);
    translate([s_len-r+xoff,0-t_buf,zoff]) rotate([270,0,0]) cylinder(r=r, h=s_thick);
  }
}

module plate(){
  minkowski(){
    cube(size=[length,thickness/2,width-20],center=false);
    translate([1/4*px_per_in,0,1/4*px_per_in]) rotate([270,0,0]) cylinder(r=1/4*px_per_in,h=thickness/2);
  }
}

module thumbscrew(){
  t_width=width/2;
  tbuf=20;
  burl_r=1/16*px_per_in;
  burls=12;

  difference(){
    rotate([270,0,0]) cylinder(d=t_width, h=thickness);
    translate([0,thickness,0]) rotate([270,0,0]) hex(7/16*px_per_in,thickness/2+tbuf);
    rotate([270,0,0]) cylinder(d=1/4*px_per_in, h=thickness+tbuf);


    for( i = [0:burls])
    {
      rotate([270,i*(360/burls),0])
        translate([t_width/2,0,-tbuf/2])
          cylinder(r=burl_r, h=thickness+tbuf*2 );
    }
  }
}

module main(){
  ts_xoff=-5/8*px_per_in;

  union(){
    difference(){
      plate();
      slot(1/4*px_per_in, 1/4*width);
      slot((1/4*length+1/2*thickness), 3/4*width+1/2*thickness);
    }
  
    translate([ts_xoff,0,(1+3/4)*px_per_in]) thumbscrew();
    mirror([0, 0, 1]) translate([ts_xoff,0,-1/2*px_per_in]) thumbscrew();
  }
}

main();
