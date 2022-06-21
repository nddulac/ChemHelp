#!/usr/bin/perl -wT

# A Virtual Lab: Density
# Patrick E. Fleming
# California State University, East Bay
# April 16, 2020 

# this virtual Denisty experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');
my $score = 0;                                    # score for a given part
my $i = 0;                                        # looping variable

# Begin html output
print header;
print start_html("Virtual Density Lab");
print "<h1>Virtual Density Lab</h1>\n";

if ($flow eq '') {
	# We are generating the starting page for practice and final calculation
	# Set some parameters
	my @liquid = ( "methyl-ethyl ketone", "ethanol", "ether");
	my @liquid_density = ( "0.805", "0.860", "0.713" );
	my $nliquids = scalar(@liquid);
	my @solid = ( "copper", "gold", "silver" );
	my @solid_density = ( "8.96", "19.32", "10.49" );
	my $nsolids = scalar(@solid);
	my @pyc_unk = ( "zinc", "aluminum", "lead" );
	my @pyc_unk_density = ( "7.140", "2.700", "11.342" );
	my $npycs = scalar(@pyc_unk);
	
	# Choose uknowns
	my $unk_liquid = int(rand() * $nliquids);
	my $unk_solid = int(rand() * $nsolids);
	my $unk_pyc = int(rand() * $npycs);
	
	# Generate so random data to be analyzed
	# Part A (Density of a liquid) data
	my $liq_vol = sprintf("%.2f", rand() * 3 + 3);                                            # mL
	my $mass_liq = $liq_vol * $liquid_density[$unk_liquid];                                  # g
	my $mass_liq_top = sprintf("%.2f", $mass_liq + 2 * (rand() - 0.5) / 100);
	my $mass_liq_ana = sprintf("%.4f", $mass_liq + 2 * (rand() - 0.5) / 10000);
	my $mass_pip = sprintf("%.2f", 20.00 * $liquid_density[$unk_liquid]);                     # g
	my $mass_pip_top = sprintf("%.2f", $mass_pip + 2 * (rand() - 0.5) / 100);
	my $mass_pip_ana = sprintf("%.4f", $mass_pip + 2 * (rand() - 0.5) / 10000);

    # Part B (Density of a solid) data
	my $diameter = sprintf("%.2f", 1.00 + 2 * (rand() -0.5) / 100);                           # cm
	my $length = sprintf("%.2f", int(rand() * 300 + 300) / 100);                              # cm
	my $vol_solid = ($diameter / 2)**2 * 3.14159 * $length;                                  # cm^3
	my $mass_cyl = $solid_density[$unk_solid] * $vol_solid;                                  # g
	my $mass_dir_top = sprintf("%.2f", $mass_cyl + 2 * (rand() - 0.5) / 100);
	my $mass_dir_ana = sprintf("%.4f", $mass_cyl + 2 * (rand() - 0.5) / 10000);
	my $vol_init = sprintf("%.2f", rand() * 3 + 1);                                           # mL
	my $vol_fin = sprintf("%.2f", ($vol_init) + ($vol_solid));
	my $mass_cyl_top = sprintf("%.2f", $mass_cyl);
	my $mass_cyl_ana = sprintf("%.4f", $mass_cyl);
	
	# Part C (Density of a solid - pycnometer method) data 
	my $pyc_vol = sprintf("%.4f", rand() * 5 + 23.324);                                       # mL
	my $pyc_samp_vol = sprintf("%.4f", rand() * 2 + 4.592);                                   # cc
	my $pyc_mass = sprintf("%.4f", rand() * 7 + 124.432);                                     # g pycnometer
	my $pyc_samp_mass = sprintf("%.4f", $pyc_samp_vol * $pyc_unk_density[$unk_pyc]);          # g sample 
	my $pyc_pyc_samp_mass = sprintf("%.4f", $pyc_mass + $pyc_samp_mass);                      # pycnometer + sample
	my $pyc_samp_water_mass = sprintf("%.4f", $pyc_pyc_samp_mass + ($pyc_vol - $pyc_samp_vol));   # g pycnmeter + sample + water 
	my $pyc_water_nosamp_mass = sprintf("%.4f", $pyc_mass + $pyc_vol);                        # g pycnometer + water
	my $pyc_water_sur_vol = sprintf("%.4f", $pyc_samp_water_mass - $pyc_pyc_samp_mass);       # mL
	
	# Print page with data to be analyzed
	print <<EOF;
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="4" bgcolor="ccffcc"><font size="+1"><b>Data for Part A - Desnity of a Liquid</b></font></td>
	  </tr>
	  <tr>
	    <td rowspan="3">Graduated Cylinder Method</td> <td bgcolor="cccccc">Volume</td> <td bgcolor="cccccc">Mass</td> <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td>$liq_vol mL</td> <td>$mass_liq_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>$liq_vol mL</td> <td>$mass_liq_ana g</td> <td>Analytical Balance</td>
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
	
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="5" bgcolor="ccffcc"><font size="+1"><b>Data for Part B - Desnity of a Solid</b></font></td>
	  </tr>
	  <tr>
	    <td rowspan="3">Direct Method</td> 
	    <td bgcolor="cccccc">Diameter</td> 
	    <td bgcolor="cccccc">Length</td> 
	    <td bgcolor="cccccc">Mass</td> 
	    <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="2">$diameter cm</td> <td rowspan="2">$length cm</td> <td>$mass_dir_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>$mass_dir_ana g</td> <td>Analytical Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="3">Displacment Method - Grad. Cyl.</td> 
	    <td bgcolor="cccccc">Vol<sub>i</sub></td> 
	    <td bgcolor="cccccc">Vol<sub>f</sub></td> 
	    <td bgcolor="cccccc">Mass</td> 
	    <td bgcolor="cccccc">Balance</td>
	  </tr>
	  <tr>
	    <td rowspan="2">$vol_init mL</td> <td rowspan="2">$vol_fin mL</td> <td>$mass_cyl_top g</td> <td>Top Loading Balance</td>
	  </tr>
	  <tr>
	    <td>$mass_cyl_ana g</td> <td>Analytical Balance</td>
	  </tr>
	</table><p>
	
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Data for Part C - Desnity of a Solid</b> - Pycnometer Method</font></td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer</td> <td>$pyc_mass g</td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer + water</td> <td>$pyc_water_nosamp_mass g</td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer + sample</td> <td>$pyc_pyc_samp_mass g</td>
	  </tr>
	  <tr>
	    <td>Mass of pycnometer + sample + water</td> <td>$pyc_samp_water_mass g</td>
	  </tr>
	</table><p>
	
	<form action="/~pfleming/cgi-bin/density.pl" method="post">
	<table border="2" cellpadding="2">
	  <tr>
	    <td colspan="2" bgcolor="ffcccc"><font size="+1"><b>Results for Part C - Desnity of a Solid</b> - Pycnometer Method</font></td>
	  </tr>
	  <tr>
	    <td>Mass of sample</td> <td><input name="samp_mass"> g</td>
	  </tr>
	  <tr>
	    <td>Volume of pycnometer</td> <td><input name="pyc_vol"> mL</td>
	  </tr>
	  <tr>
	    <td>Volume of water surrounding sample</td> <td><input name="vol_sur_samp"> mL</td>
	  </tr>
	  <tr>
	    <td>Volume of sample</td> <td><input name="vol_samp"> cm<sup>3</sup></td>
	  </tr>
	  <tr>
	    <td>Density of sample</td> <td><input name="density_samp"> g/cm<sup>3</sup></td>
	  </tr>
	</table><br>
	<table>
	  <tr>
	    <td>For Practice</td> <td><input type="radio" name="practice" value="yes" checked></td>
	  </tr>
	  <tr>
	    <td>For a Grade</td> <td><input type="radio" name="practice" value="no"></td>
	  </tr>
    </table>
	<input type="hidden" name="pyc_samp_mass_ans" value="$pyc_samp_mass">
	<input type="hidden" name="pyc_vol_ans" value="$pyc_vol">
	<input type="hidden" name="pyc_vol_sur_samp_ans" value="$pyc_water_sur_vol">
	<input type="hidden" name="pyc_samp_vol_ans" value="$pyc_samp_vol">
	<input type="hidden" name="unknown_pyc" value="$pyc_unk[$unk_pyc]">
	<input type="hidden" name="unknown_pyc_density" value="$pyc_unk_density[$unk_pyc]">
	<input type="hidden" name="control_1" value="grade_pyc">
	<input type="submit" value="Grade Part C"> <input type="reset" value="Start over!">
	</form>
EOF
	
} elsif ($flow eq 'grade_pyc') {
    my $practice = param('practice');                                 # Is this to be graded for practice?
	if ($practice eq 'yes') {
		Print_Pycnometer_Results($score);
	} else {
		Print_Pycnometer_Results($score);
		print "You got ";
		print sprintf("%.2f", $score / 5 * 100);
		print "% on this part.</br>\n"; 
	}
} else {
	print "Go to hell!";
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

sub Print_Pycnometer_Results {
		# Get inputs from form
		my $samp_mass = param('samp_mass');                           # user answer for sample mass
		my $samp_mass_ans = param('pyc_samp_mass_ans');               # correct sample mass
		my $vol = param('pyc_vol');                                   # user answer for pycnometer volume
		my $vol_ans = param('pyc_vol_ans');                           # correct pycnometer volume
		my $vol_sur_samp = param('vol_sur_samp');                     # user answer for volume surrounding sample
		my $vol_sur_samp_ans = param('pyc_vol_sur_samp_ans');         # correct volume of water surrounding sample
		my $vol_samp = param('vol_samp');                             # user answer for volume of sample
		my $vol_samp_ans = param('pyc_samp_vol_ans');                 # correct volume of sample
		my $samp_density = param('density_samp');                     # user anser for sample density
		my $samp_density_ans = param('unknown_pyc_density');          # correct sample density
		
		# send response to browser
		print <<EOF;
		<table border="2" cellpadding="2">
		  <tr>
		    <td bgcolor=ffcccc" colspan="3"><font size="+1"><b>Part C - Density of a Solid</b> - Pycnometer Method</font></td>
		  </tr>
		  <tr>
		    <td bgcolor="cccccc">Value</td> <td bgcolor="cccccc">Your answer</td> <td bgcolor="cccccc">Correct value</td>
		  </tr>
		  <tr>
		    <td>Sample Mass</td> <td>$samp_mass g</td> <td>$samp_mass_ans g</td>
		  </tr>
		  <tr>
		    <td>Pycnometer volume</td> <td>$vol mL</td> <td>$vol_ans mL</td>
		  </tr>
		  <tr>
		    <td>Volume surrounding sample</td> <td>$vol_sur_samp mL</td> <td>$vol_sur_samp_ans mL</td>
		  </tr>
		  <tr>
		    <td>Volume of sample</td> <td>$vol_samp cm<sup>3</sup></td> <td>$vol_samp_ans cm<sup>3</sup></td>
		  </tr>
		  <tr>
		    <td>Density of sample</td> <td>$samp_density</td> <td>$samp_density_ans</td>
		  </tr>
		</table><p>
EOF
        # determine score
        $score = 0;
        if (abs($samp_mass - $samp_mass_ans) < 0.0002) {
          $score +=1;
        }
        if (abs($vol - $vol_ans) < 0.0002) {
          $score +=1;
        }
        if (abs($vol_sur_samp - $vol_sur_samp_ans) < 0.0002) {
          $score +=1;
        }
        if (abs($vol_samp - $vol_samp_ans) < 0.0002) {
          $score +=1;
        }
        if (abs($samp_density - $samp_density_ans) < 0.005) {
          $score +=1;
        }
        print "\n\nYou got $score/5 correct.<br>\n";
}