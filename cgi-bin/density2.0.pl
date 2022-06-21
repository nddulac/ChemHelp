#!/usr/bin/perl -wT

# A Virtual Lab: Density
# Patrick E. Fleming
# California State University, East Bay
# April 16, 2020 
# Version 2.0
# July 14, 2020

# this virtual Density experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use Math::Trig;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');
my $score = 0;                                    # score for a given part
my $i = 0;                                        # looping variable

# Begin html output
print header;
print start_html("Virtual Density Lab");
print "<h1>Virtual Density Lab</h1>\n";

# Set some universal parameters
my @liquid = (["methyl-ethyl ketone", 0.805 ], 
              ["ethanol",             0.0860], 
              ["ether",               0.713 ]);
my @solid = (["copper",  8.96], 
             ["gold",   19.32],
             ["silver", 10.49]);
my @pyc = (["zinc",      7.140],
           ["aluminum",  2.700],
           ["lead",     11.342]);
my $nliqs = scalar(@liquid);
my $nsols = scalar(@solid);
my $npycs = scalar(@pyc);
	
if ($flow eq '') {
	# Choose uknowns
	my $unk_liq = int(random_value($nliqs, 0));
	my $unk_sol = int(random_value($nsols, 0));
	my $unk_pyc = int(random_value($npycs, 0));
	
	# Now generate the Part A data
	my $vol_liq = sprintf("%.2F", random_value(6, 3) + random_value(0.05, -0.05));					# mL
	my $mass_liq = $vol_liq * $liquid[$unk_liq][1];													# g
	my $mass_liq_top = sprintf("%.2f", $mass_liq);													# g
	my $mass_liq_ana = sprintf("%.4f", $mass_liq);													# g
	my $mass_pip = 20 * $liquid[$unk_liq][1] + random_value(0.05, -0.05);							# g
	my $mass_pip_top = sprintf("%.2f", $mass_pip);													# g
	my $mass_pip_ana = sprintf("%.4f", $mass_pip);													# g
	
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="4" bgcolor="ccffcc"><font size="+1"><b>Part A - Density of a liquid</b></font></td>
		</tr>
	  <tr>
	    <td rowspan="3">Graduated Cylinder Method</td> <td bgcolor="cccccc">Volume</td> <td bgcolor="cccccc">Mass</td> <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td>$vol_liq mL</td> <td>$mass_liq_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>$vol_liq mL</td> <td>$mass_liq_ana g</td> <td>Analytical Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="3">Volumetric Pipet Method</td> <td bgcolor="cccccc">Volume</td> <td bgcolor="cccccc">Mass</td> <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td>20.00 mL</td> <td>$mass_pip_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>20.00 mL</td> <td>$mass_pip_ana g</td> <td>Analytical Balance</td>
	  </tr>	
	  </table><p>
EOF

	# Now, generate the Part B data
	my $diameter = sprintf("%.2f", random_value(1.0, 0.8));											# cm
	my $length = sprintf("%.2f", random_value(4.0, 2.0));											# cm
	my $vol_cyl = pi * ($diameter / 2)**2 * $length;												# cm^3
	my $vol_water = sprintf("%.2f", random_value(5.0, 3.0));										# mL
	my $vol_final = sprintf("%.2f", $vol_water + $vol_cyl);											# mL
	my $mass_cyl = $vol_cyl * $solid[$unk_sol][1] + random_value(0.05, -0.05);						# g
	my $mass_cyl_top = sprintf("%.2f", $mass_cyl);													# g
	my $mass_cyl_ana = sprintf("%.4f", $mass_cyl);													# g

	print <<EOF;
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="5" bgcolor="ccffcc"><font size="+1"><b>Part B - Desnity of a Solid</b></font></td>
	  </tr>
	  <tr>
	    <td rowspan="3">Direct Method</td> 
	    <td bgcolor="cccccc">Diameter</td> 
	    <td bgcolor="cccccc">Length</td> 
	    <td bgcolor="cccccc">Mass</td> 
	    <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="2">$diameter cm</td> <td rowspan="2">$length cm</td> <td>$mass_cyl_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>$mass_cyl_ana g</td> <td>Analytical Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="3">Displacment Method - Grad. Cyl.</td> 
	    <td bgcolor="cccccc">Vol<sub>i</sub></td> 
	    <td bgcolor="cccccc">Vol<sub>f</sub></td> 
	    <td bgcolor="cccccc">Mass</td> 
	    <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="2">$vol_water mL</td> <td rowspan="2">$vol_final mL</td> <td>$mass_cyl_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>$mass_cyl_ana g</td> <td>Analytical Balance</td>
	  </tr>
	</table><p>
EOF

	# Now, generate Part C data
	my $vol_pycnometer = random_value(35,20);														# mL
	my $mass_pycnometer = sprintf("%.4f", random_value(85, 65));									# g
	my $vol_sample = random_value(10, 6);															# cm^3
	my $mass_sample = sprintf("%.4f", $pyc[$unk_pyc][1] * $vol_sample);								# g
	my $vol_surr = $vol_pycnometer - $vol_sample;													# g
	
	my $mass_pyc_sample = sprintf("%.4f", $mass_pycnometer + $mass_sample);							# g
	my $mass_pyc_water = sprintf("%.4f", $mass_pycnometer + $vol_pycnometer);						# g
	my $mass_pyc_sample_water = sprintf("%.4f", $mass_pyc_sample + $vol_surr);						# g
	
	print <<EOF;
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Part C - Desnity of a Solid</b> - Pycnometer Method</font></td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer</td> <td>$mass_pycnometer g</td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer + water</td> <td>$mass_pyc_water g</td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer + sample</td> <td>$mass_pyc_sample g</td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer + sample + water</td> <td>$mass_pyc_sample_water g</td>
	  </tr>
	</table><p>
	
	
	<form action="/~pfleming/cgi-bin/density2.0.pl" method="post">
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="2" bgcolor="ffcccc"><font size="+1"><b>Calculations - Desnity of a Solid</b> - Pycnometer Method</font></td>
	  </tr>
	  <tr>
	    <td>Mass of sample</td> <td><input name="mass_samp"> g</td>
	  </tr>
	  <tr>
	    <td>Volume of pycnometer</td> <td><input name="vol_pyc"> mL</td>
	  </tr>
	  <tr>
	    <td>Volume of water surrounding sample</td> <td><input name="vol_surr"> mL</td>
	  </tr>
	  <tr>
	    <td>Volume of sample</td> <td><input name="vol_samp"> cm<sup>3</sup></td>
	  </tr>
	  <tr>
	    <td>Density of sample</td> <td><input name="density_samp"> g/cm<sup>3</sup></td>
	  </tr>
	</table><br>
	<input type="hidden" name="mass_samp_ans" value="$mass_sample">
	<input type="hidden" name="vol_pyc_ans" value="$vol_pycnometer">
	<input type="hidden" name="vol_surr_ans" value="$vol_surr">
	<input type="hidden" name="vol_samp_ans" value="$vol_sample">
	<input type="hidden" name="unk_pyc" value="$unk_pyc">
	<input type="hidden" name="control_1" value="grade_pyc">
	<input type="submit" value="Grade Part C"> <input type="reset" value="Start over!">
	</form><p>
EOF

} elsif ($flow eq 'grade_pyc') {
	# Read the parameters
	my @calc;
	my @answ;
	my @response;
	my $unk_pyc = param('unk_pyc');
	$calc[0] = param('mass_samp');
	$calc[1] = param('vol_pyc');
	$calc[2] = param('vol_surr');
	$calc[3] = param('vol_samp');
	$calc[4] = param('density_samp');
	$answ[0] = param('mass_samp_ans');
	$answ[1] = param('vol_pyc_ans');
	$answ[2] = param('vol_surr_ans');
	$answ[3] = param('vol_samp_ans');
	$answ[4] = $pyc[$unk_pyc][1];
	for ($i=0; $i<5; $i+=1) {
		if (abs($calc[$i] - $answ[$i])/$answ[$i] < 0.0002) {
			$response[$i] = "<font color=\"green\">You are correct!</font>";
		} else {
			$response[$i] = "<font color=\"red\">You are incorrect.</font>";
		}
		$answ[$i] = sprintf("%.4f", $answ[$i]);
	}
	print <<EOF;
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="4" bgcolor="ffcccc"><font size="+1"><b>Results - Desnity of a Solid</b> - Pycnometer Method</font></td>
	  </tr>
	  <tr>
	    <td>Property</td>
	    <td>Your answer</td>
	    <td>Correct Answer</td>
	    <td>Evaluation</td>
	  </tr>
	  <tr>
	    <td>Mass of sample</td> 
	    <td>$calc[0] g</td>
	    <td>$answ[0] g</td>
	    <td>$response[0]</td>
	  </tr>
	  <tr>
	    <td>Volume of pycnometer</td> 
	    <td>$calc[1] mL</td>
	    <td>$answ[1] mL</td>
	    <td>$response[1]</td>
	  </tr>
	  <tr>
	    <td>Volume of water surrounding sample</td> 
	    <td>$calc[2] mL</td>
	    <td>$answ[2] mL</td>
	    <td>$response[2]</td>
	  </tr>
	  <tr>
	    <td>Volume of sample</td> 
	    <td>$calc[3] cm<sup>3</sup></td>
	    <td>$answ[3] cm<sup>3</sup></td>
	    <td>$response[3]</td>
	  </tr>
	  <tr>
	    <td>Density of sample</td> 
	    <td>$calc[4] g/cm<sup>3</sup></td>
	    <td>$answ[4] g/cm<sup>3</sup></td>
	    <td>$response[4]</td>
	  </tr>
	</table><br>
EOF

} else {
	print "No Part Specified.<br>\n";
}

# Finish html output
print "<footer>\n";
print "		<hr>\n";
print "		<p><b>This work is made available under the <a href=\"https://creativecommons.org/licenses/by-nc/4.0/\">Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)</a> license.</b></p>\n";
print "		Patrick E. Fleming<br>\n";
print "		Department of Chemistry and Biochemistry<br>\n";
print "		California State University, East Bay<br>\n";
print "		<a href=\"mailto:patrick.fleming\@csueastbay.edu\">patrick.fleming\@csueastbay.edu</a>\n";
print "</footer>\n";

print end_html;

sub random_value {
	my ($max, $min) = @_;
	return rand() * ($max - $min) + $min;
}
