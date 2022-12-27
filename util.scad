module mirror_dupe(axis=[1,0,0], center=undef)
{
	children();
	if (!center)
	{
		mirror(axis) children();
	} else {
		// should only translate on the mirrored axis?
		translate(center)
		mirror(axis)
		translate(-center)
		children();
	}
}

module quad_dupe()
{
	mirror_dupe([0,1,0])
	mirror_dupe([1,0,0])
	children();
}

module hollow_cylinder(d1,d2,h,$fn=60)
{
	render() difference()
	{
		cylinder(h=h, d=d1);
		translate([0,0,-1]) cylinder(h=h+2, d=d2);
	}
}

module countersink(d,h,h2=1, $fn=30, reverse=0)
{
	if (reverse)
	{
		translate([0,0,h-h2]) cylinder(d1=d, d2=d+h2*sqrt(2), h=h2+.1);
		translate([0,0,-0.1]) cylinder(d=d, h=h+0.1);
	} else {
		translate([0,0,-0.1]) cylinder(d2=d, d1=d+h2*sqrt(2), h=h2+.1);
		cylinder(d=d, h=h);
	}
}

module round_box(w,l,h,r=5,$fn=16,center=false)
{
	translate(center ? [-w/2,-l/2,-h/2] : [0,0,])
	hull() {
		translate([r,r,0]) cylinder(r=r, h=h);
		translate([w-r,r,0]) cylinder(r=r, h=h);
		translate([w-r,l-r,0]) cylinder(r=r, h=h);
		translate([r,l-r,0]) cylinder(r=r, h=h);
	}
}

module translate_ref(ref,w,l,h)
{
	pos = [
		ref[0] == "-" ? -w/2 : ref[0] == "+" ? +w/2 : 0,
		ref[1] == "-" ? -l/2 : ref[1] == "+" ? +l/2 : 0,
		ref[2] == "-" ? -h/2 : ref[2] == "+" ? +h/2 : 0,
	];
	translate(pos) children();
}

module box(w,l,h,r=0,pos=[0,0,0],rot=[0,0,0],ref="+++")
{
	translate(pos)
	rotate(rot)
	translate_ref(ref,w,l,h)
	{
		if (r == 0)
			cube([w,l,h], center=true);
		else
			round_box(w,l,h,r, center=true);
	}
}

module spin(n,pos=[0,0,0],r=0,offset=0,phase=0)
{
	for(i=[0:n-1])
		rotate([0,0,phase + (i+offset)*360/n])
		translate(r == 0 ? pos : [r,0,0])
		children();
}


module dupe(coords=[],z=0)
{
	for(pos=coords)
	{
		translate([pos[0], pos[1], pos[2] ? pos[2] : z])
		children();
	}
}

module drill(d,h,pos=[0,0,0],coords=undef,$fn=24,tap=false,countersink=false,dir=1)
{
	if (coords)
	{
		for(pos=coords)
			drill(d,h,pos,tap=tap);
	} else {
		translate([pos[0], pos[1], pos[2] ? pos[2] : 0])
		{
			if (countersink)
			{
				if (dir == -1)
					mirror([0,0,1])
					countersink(d,h, $fn=$fn);
				else
					countersink(d,h, $fn=$fn);
			} else {
				if (dir == -1)
					translate([0,0,+0.1])
					mirror([0,0,1])
					cylinder(d=d,h=h+0.2, $fn=$fn);
				else
					translate([0,0,-0.1])
					cylinder(d=d,h=h+0.2, $fn=$fn);
			}
		}
	}
}

