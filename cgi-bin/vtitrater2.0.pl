#!/usr/bin/perl -wT

# A Virtual Lab: Virtual Titrater 2.0
# Patrick E. Fleming
# California State University, East Bay
# June 9, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');						# Determines part
my $i = 0;											# looping variable
my $mmKHP = 204.22; 								# g/mol

# Begin html output
print header;
print start_html("Titration");
print "<h1>Titration of KHP with NaOH</h1>\n";

if ($flow eq "") {
	# need to generate data for titration
	my $mass_KHP = sprintf("%.4f", random_value (1.2, 0.7) );
	my $base_conc = sprintf("%.4f", random_value (0.22, 0.18) );
	my $mol_KHP = $mass_KHP / $mmKHP * 1000;		# mmol
	my $vbase = 0;									# mL
	my $approx_vol_base = sprintf("%.1f", $mol_KHP / 0.2);
	
	# Now build user interface to add base
	print <<EOF;
	<div name="decorate">
	<img src="/~pfleming/chem/titrate/sn1setup.gif" align="right">
	</div>
	<div name="form">
	<form action="/~pfleming/cgi-bin/vtitrater2.0.pl" method="post">
	<p>You are using $mass_KHP g of KHP. If [NaOH] = 0.2 M, you will need $approx_vol_base mL.</p>
	<p>How many mL of NaOH solution would you like to add?</p>
	<input name="vbase_added"> mL
	<input type="hidden" name="vbase" value="$vbase">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="mass_KHP" value="$mass_KHP">
	<input type="hidden" name="control_1" value="AddBase">
	<input type="submit" value="Add the base!">
	</form>
	</div>
EOF

} elsif ($flow eq 'AddBase') {
	# Read some parameters
	my $mass_KHP = param('mass_KHP');
	my $mol_KHP = $mass_KHP / $mmKHP * 1000;
	my $base_conc = param('base_conc');
	my $vbase = param('vbase');
	my $vbase_added = param('vbase_added');
	my $pic = 'not_close.png';
	my $approx_vol_base = sprintf("%.1f", $mol_KHP / 0.2);
	$vbase = $vbase + $vbase_added;
	
	if ($vbase * $base_conc < $mol_KHP) {
		# not yet at end point - but how far?
		if ($vbase < 0.75 * $mol_KHP / $base_conc) {
			# Not yet within 25% of volume needed
			$pic = 'not_close.png';
		} else {
			# Within 25%, but still short
			$pic = 'close.gif';
		}
	} else {
		# we have passed the endpoint - but by how much?
		if ($vbase < 1.05 * $mol_KHP / $base_conc) {
			# not terribly passed
			$pic = 'endpoint.jpg'
		} else {
			# terribly passed
			$pic = 'over.jpg'
		}
	}
	print <<EOF;
	<div name="decorate">
	<img src="/~pfleming/chem/titrate/sn1setup.gif" align="right">
	</div>
	<div name="form">
	<form action="/~pfleming/cgi-bin/vtitrater2.0.pl" method="post">
	<img src="/~pfleming/chem/titrate/$pic" height="240"><br>
	<p>You are using $mass_KHP g of KHP. If [NaOH] = 0.2 M, you will need $approx_vol_base mL.</p>
	<p>After adding $vbase_added mL of NaOH, you have added a total of $vbase mL.</p>
	<p>How many mL of NaOH solution would you like to add?</p>
	<input name="vbase_added"> mL
	<input type="hidden" name="vbase" value="$vbase">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="mass_KHP" value="$mass_KHP">
	<input type="hidden" name="control_1" value="AddBase">
	<input type="submit" value="Add the base!">
	</form><br>
	<form action="/~pfleming/cgi-bin/vtitrater2.0.pl" method="post">
	<input type="hidden" name="vbase" value="$vbase">
	<input type="hidden" name="vbase_added" value="$vbase_added">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="mass_KHP" value="$mass_KHP">
	<input type="hidden" name="control_1" value="Finish">
	<input type="submit" value="Finish the Titration">
	</form>
	</div>
EOF

} elsif ($flow eq "Finish")  {
	#Finish the titration
	# Read some parameters
	my $mass_KHP = param('mass_KHP');
	my $mol_KHP = $mass_KHP / $mmKHP * 1000;
	my $base_conc = param('base_conc');
	my $vbase = param('vbase');
	my $vbase_added = param('vbase_added');
	my $vbase_prime = $vbase - $vbase_added;
	my $pic = 'not_close.png';
	if ($vbase * $base_conc < $mol_KHP) {
		# not yet at end point - but how far?
		if ($vbase < 0.75 * $mol_KHP / $base_conc) {
			# Not yet within 25% of volume needed
			$pic = 'not_close.png';
		} else {
			# Within 25%, but still short
			$pic = 'close.gif';
		}
	} else {
		# we have passed the endpoint - but by how much?
		if ($vbase < 1.05 * $mol_KHP / $base_conc) {
			# not terribly passed
			$pic = 'endpoint.jpg'
		} else {
			# terribly passed
			$pic = 'over.jpg'
		}
	}
	my $base_conc_calc = sprintf("%.4f", $mol_KHP / $vbase);
	my $base_conc_calc_prime = sprintf("%.4f", $mol_KHP / $vbase_prime);
	print <<EOF;
	<div name="decorate">
	<img src="/~pfleming/chem/titrate/sn1setup.gif" align="right">
	</div>
	<h2>Data Summary</h2>
	<pre>
	------------------------------------------------------------------
	Mass KHP                                      = $mass_KHP g
	Volume NaOH                                   = $vbase mL
	Last volume NaOH added                        = $vbase_added mL
	
	Concentration of base (using last volume)     = $base_conc_calc M
	Concentration of base (using previous volume) = $base_conc_calc_prime M

	Actual Concentration of base                  = $base_conc M
	------------------------------------------------------------------
	</pre>
	<form action="/~pfleming/cgi-bin/vtitrater2.0.pl" method="post">
	<input type="hidden" name="control_1" value="">
	<input type="submit" value="Try another Titration?">
	</form>
	</div>
EOF

} else {
	print "No Part Specified!<br>\n";

}

# Finish html output
print "	<footer>\n";
print "		<hr>\n";
print "		<p><b>This work is made available under the <a href=\"https://creativecommons.org/licenses/by-nc/4.0/\">Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)</a> license.</b></p>\n";
print "		Patrick E. Fleming<br>\n";
print "		Department of Chemistry and Biochemistry<br>\n";
print "		California State University, East Bay<br>\n";
print "		<a href=\"mailto:patrick.fleming\@csueastbay.edu\">patrick.fleming\@csueastbay.edu</a>\n";
print "	</footer>\n";

print end_html;

sub random_value {
	my $max = $_[0];
	my $min = $_[1];
	my $value = rand(1) *($max - $min) + $min;
	return $value;
}
