// instead of proper tapping, we make the holes slightly undersized
tap_offset = -0.23; // this is a negative offset, so it goes slightly larger
drill_offset = 0.50;

// these are 2x since we are 50 percent scale
M4 = 8;
M3 = 6;
M25 = 5;
M2 = 4;
M14 = 2.8;

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

module linear_dupe(n,offset)
{
	for(i=[0:n-1])
		translate(i*offset)
		children();
}

module hollow_cylinder(d1,d2,h,$fn=60,tap=false)
{
	// we don't have proper tapping
	d2 = tap ? d2 - tap_offset : d2;

	render() difference()
	{
		cylinder(h=h, d=d1);
		translate([0,0,-1]) cylinder(h=h+2, d=d2);
	}
}

module countersink(d,h,h2=2.5, $fn=30, reverse=0)
{
	angle = 1.6;

	if (reverse)
	{
		translate([0,0,h-h2]) cylinder(d1=d, d2=d+angle*h2*sqrt(2), h=h2+.1);
		translate([0,0,-0.1]) cylinder(d=d, h=h+0.1);
	} else {
		translate([0,0,-0.1]) cylinder(d2=d, d1=d+angle*h2*sqrt(2), h=h2+.1);
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
	// we don't have proper tapping, so we just shrink the hole slightly
	d = tap ? d - tap_offset: d + drill_offset;

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


// shape with circular edges and a flat top
module round_keyway(w,h,t)
{
	render() intersection()
	{
		cylinder(d=w, h=t, $fn=180);
		box(w, h, t, ref="cc+");
	}
}

