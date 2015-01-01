$fn=200;

cm=10;
mm=1;

thickness=8*mm;
sideW=8*cm;
sideH=4*cm;

topBottomW=8*cm;
topBottomL=8*cm;

tabMaxWidth=1*cm;
tabMinWidth=1*cm;
tabDepth=1*cm;

partSeparation=5*mm;

notchDepth=2*mm;
notchThickness=4*mm;

module topBottomBase(){
  cube(size=[topBottomW,topBottomL,thickness],center=true);
}

module topNotches(){
  union(){
    translate([0,-topBottomL/2+notchDepth/2,thickness-notchThickness*1.5])
      cube(size=[topBottomW,notchDepth,notchThickness], center=true);
    translate([0,topBottomL/2-notchDepth/2,thickness-notchThickness*1.5])
      cube(size=[topBottomW,notchDepth,notchThickness], center=true);
    translate([-topBottomW/2+notchDepth/2,0,thickness-notchThickness*1.5])
      cube(size=[notchDepth,topBottomW,notchThickness], center=true);
  }
}

module top(){
  difference(){
    topBottomBase();
    topNotches();
  }
}

module joint(length, offset=0){
  tabs = length/tabMaxWidth - offset;
  translate([-length/2+offset*tabMaxWidth,0,0])
    union(){
      for(i=[1:tabs]){
        translate([i*tabMaxWidth*2 + (tabMaxWidth),0,-thickness*0.25])
          cube(size=[tabMaxWidth,tabDepth,thickness*1.5],center=true);
      }
    }
}

module bottomJoints(){
  union(){
    translate([-topBottomW/2,-topBottomL/2,0]) joint(length=topBottomL/2);
    translate([-topBottomW/2,topBottomL/2,0]) joint(length=topBottomL/2);
    rotate([0,0,90]) translate([-topBottomL/2,-topBottomW/2,0]) joint(length=topBottomW/2);
    rotate([0,0,90]) translate([-topBottomL/2,topBottomW/2,0]) joint(length=topBottomW/2);
  }
}

module bottom(){
  difference(){
    topBottomBase();
    bottomJoints();
  }
}

module fbJoints(){
  union(){
    translate([-sideH/2-tabMaxWidth,-sideW/2,0]) joint(length=sideH/2, offset=0);
    translate([-sideH/2-tabMaxWidth,sideW/2,0]) joint(length=sideH/2, offset=0);
    rotate([0,0,90]) translate([-(sideW/2),sideH/2,0]) joint(length=sideW/2, offset=1);
  }
}

module frontBack(){
  difference(){
    cube(size=[sideH,sideW,thickness],center=true);
    fbJoints();
  }
}

module sideJoints(){
  union(){
  }
}

module side(){
  difference(){
    cube(size=[sideW,sideH,thickness],center=true);
    sideJoints();
  }
}

module assembly(){
  union(){
    translate([4*partSeparation + sideH + topBottomL,0,0]) top();
    translate([2*partSeparation + sideH/2 + topBottomL/2,0,0]) frontBack();
    bottom();
    translate([-(partSeparation*2 + sideH/2 + topBottomL/2),0,0])
      rotate([0,0,180])
        frontBack();

    translate([0,-(partSeparation*2 + topBottomW/2 + sideH/2),0]) side();
    translate([0,(partSeparation*2 + topBottomW/2 + sideH/2),0]) side();
  }
}

//bottomJoints();
assembly();
    