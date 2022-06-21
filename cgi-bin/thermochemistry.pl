#!/usr/bin/perl -wT

# A Virtual Lab: Density
# Patrick E. Fleming
# California State University, East Bay
# July 16, 2020

# this virtual Thermochemistry experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');
my $i = 0;                                        # looping variable

# Begin html output
print header;
print start_html("Virtual Thermochemistry Lab");
print "<h1>Virtual Thermochemistry Lab</h1>\n";

# Set some universal parameters
my @metal = (["aluminum", 0.903],
             ["copper",   0.385],
             ["iron",     0.449],
             ["lead",     0.128],
             ["nickel",   0.444],
             ["gold",     0.129],
             ["antimony", 0.207],
             ["tin",      0.228],
             ["silver",   0.235]);
my $nmetals = scalar(@metal);
	
if ($flow eq 'PartA') {
	# Choose an unknown, mass, initial temperatures
	my $unk = random_value($nmetals, 0);
	my $mass_met = sprintf("%.4f", random_value(40, 10));
	my $mass_wat = sprintf("%.4f", random_value(26, 24));
	my $T_met = sprintf("%.2f", random_value(99, 96));
	my $T_wat = sprintf("%.2f", random_value(22, 18));
	my $T_fin = sprintf("%.2f", ($mass_met*$metal[$unk][1]*$T_met+$mass_wat*4.184*$T_wat)/($mass_met*$metal[$unk][1]+$mass_wat*4.184));
	
	print <<EOF;
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<table border="2" cellpadding="2">
	  <tr>
		<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Part A Data</b></font></td>
	  </tr>
	  <tr>
	    <td>Specific Heat of water</td> <td> 4.184 J g<sup>-1</sup> <sup>o</sup>C</td>
	  </tr>
	  <tr>
	    <td>Mass of water</td> <td>$mass_wat g</td>
	  </tr>
	  <tr>
	    <td>Mass of metal</td> <td>$mass_met g</td>
	  </tr>
	  <tr>
		<td>Initial Temperataure of water</td> <td>$T_wat <sup>o</sup>C</td>
	  </tr>
	  <tr>
		<td>Initial Temperataure of metal</td> <td>$T_met <sup>o</sup>C</td>
	  </tr>
	  <tr>
		<td>Final Temperataure of water</td> <td>$T_fin <sup>o</sup>C</td>
	  </tr>
	  <tr>
	    <td>Specific Heat of Metal</td> <td><input name="C_met"> J g<sup>-1</sup> <sup>o</sup>C</td>
	  </tr>
	</table><p>
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="T_wat" value="$T_wat">
	<input type="hidden" name="T_met" value="$T_met">
	<input type="hidden" name="T_fin" value="$T_fin">
	<input type="hidden" name="mass_wat" value="$mass_wat">
	<input type="hidden" name="mass_met" value="$mass_met">
	<input type="hidden" name="control_1" value="PartA2">
	<input type="submit" value="Am I right?">
	<input type="reset" value="Clear form">
	</form>
EOF

} elsif ($flow eq 'PartA2') {
	# Read the parameters
	my $unk = param('unk');
	my $T_wat = param('T_wat');
	my $T_met = param('T_met');
	my $T_fin = param('T_fin');
	my $mass_wat = param('mass_wat');
	my $mass_met = param('mass_met');
	my $C_met = param('C_met');
	
	# Grade answer
	my $response = "<font color=\"red\">You are incorrect.</font>";
	if (abs($metal[$unk][1] - $C_met)/$metal[$unk][1] < 0.005) {
		$response = "<font color=\"green\">You are correct!</font>";
	}
	
	print <<EOF;
	<table border="2" cellpadding="2">
	  <tr>
		<td colspan="3" bgcolor="ffcccc"><font size="+1"><b>Part A Results</b></font></td>
	  </tr>
	  <tr>
	    <td>Specific Heat of water</td> <td> 4.184 J g<sup>-1</sup> <sup>o</sup>C</td> <td bgcolor="cccccc"></td>
	  </tr>
	  <tr>
	    <td>Mass of water</td> <td>$mass_wat g</td>  <td bgcolor="cccccc"></td>
	  </tr>
	  <tr>
	    <td>Mass of metal</td> <td>$mass_met g</td>  <td bgcolor="cccccc"></td>
	  </tr>
	  <tr>
		<td>Initial Temperataure of water</td> <td>$T_wat <sup>o</sup>C</td>  <td bgcolor="cccccc"></td>
	  </tr>
	  <tr>
		<td>Initial Temperataure of metal</td> <td>$T_met <sup>o</sup>C</td>  <td bgcolor="cccccc"></td>
	  </tr>
	  <tr>
		<td>Final Temperataure of water</td> <td>$T_fin <sup>o</sup>C</td>  <td bgcolor="cccccc"></td>
	  </tr>
	  <tr>
	    <td>Specific Heat of Metal</td> <td>$C_met J g<sup>-1</sup> <sup>o</sup>C</td> <td>$response</td>
	  </tr>
	</table><p>
EOF

} elsif ($flow eq 'PartB_fresh') {
	# Set the initial temperature
	my $temp = param('temp');
	if ($temp eq '') {
		$temp = sprintf("%.2f", random_value(22, 18));
	}
	my $temp_measured = 0;				# flag for if the temperature has been measured
	
	# We are starting with a fresh calorimeter
	my $mass_mg = 0;					# g
	my $mass_mgo = 0;					# g
	my $vol_hcl = 0;					# mL
	my $mol_mg = 0;						# mol
	my $mol_mgo = 0;					# mol
	my $mol_hcl = 0;					# mol
	
	my $mass_tot = sprintf("%.3f", $mass_mg + $mass_mgo + 1.03645 * $vol_hcl);
	 
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Contents of Calorimeter</b></font><br>(before reaction)</td>
		</tr>
		<tr>
			<td>Mass of Mg(s)</td>
			<td>$mass_mg g</td>
		</tr>
		<tr>
			<td>Mass of MgO(s)</td>
			<td>$mass_mgo g</td>
		</tr>
		<tr>
			<td>Volume of 1.0 M HCl(aq)</td>
			<td>$vol_hcl mL</td>
		</tr>
	</table>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<b>Select a reagent to add to your calorimeter</b>:<br>
	<input type="radio" name="reagent" value="mg">Add ~0.15 g Mg<br>
	<input type="radio" name="reagent" value="mgo">Add ~0.25 g MgO<br>
	<input type="radio" name="reagent" value="hcl">Pipet 25.00 mL of 1.0 M HCl<br>
	<input type="hidden" name="mass_mg" value="$mass_mg">	
	<input type="hidden" name="mass_mgo" value="$mass_mgo">	
	<input type="hidden" name="vol_hcl" value="$vol_hcl">
	<input type="hidden" name="mass_tot" value="$mass_tot">
	<input type="hidden" name="mol_mg" value="$mol_mg">	
	<input type="hidden" name="mol_mgo" value="$mol_mgo">	
	<input type="hidden" name="mol_hcl" value="$mol_hcl">	
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="temp_measured" value="$temp_measured">
	<input type="hidden" name="control_1" value="PartB_add">
	<input type="submit" value="Add the Reagent!">
	</form>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<input type="hidden" name="mass_mg" value="$mass_mg">	
	<input type="hidden" name="mass_mgo" value="$mass_mgo">	
	<input type="hidden" name="vol_hcl" value="$vol_hcl">
	<input type="hidden" name="mass_tot" value="$mass_tot">
	<input type="hidden" name="mol_mg" value="$mol_mg">	
	<input type="hidden" name="mol_mgo" value="$mol_mgo">	
	<input type="hidden" name="mol_hcl" value="$mol_hcl">	
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="temp_measured" value="$temp_measured">
	<input type="hidden" name="control_1" value="PartB_temp">
	<input type="submit" value="Measure the Temperature">
	</form>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<input type="hidden" name="control_1" value="PartB_fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>
EOF

} elsif ($flow eq 'PartB_add') {
	# Read the parameters
	my $reagent = param('reagent');
	my $mass_mg = param('mass_mg');
	my $mass_mgo = param('mass_mgo');
	my $vol_hcl = param('vol_hcl');
	my $mass_tot = param('mass_tot');
	my $mol_mg = param('mol_mg');
	my $mol_mgo = param('mol_mgo');
	my $mol_hcl = param('mol_hcl');
	my $temp = param('temp');
	my $temp_measured = param('temp_measured');
	
	# Add the reagent
	my $mmass_mg = 24.305;				# g/mol
	my $mmass_mgo = 40.3044;			# g/mol
	if ($reagent eq 'mg') {
		$mass_mg = sprintf("%.3f", $mass_mg + random_value(0.16, 0.14));
		$mol_mg = $mass_mg / $mmass_mg;
	} elsif ($reagent eq 'mgo') {
		$mass_mgo = sprintf("%.3f", $mass_mgo + random_value(0.26, 0.24));
		$mol_mgo = $mass_mgo / $mmass_mgo;
	} elsif ($reagent eq 'hcl') {
		$vol_hcl = sprintf("%.2f", $vol_hcl + 25);
		$mol_hcl = $mol_hcl + 0.025;
	}
	$mass_tot = $mass_mg + $mass_mgo + 1.036 * $vol_hcl;
	
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Contents of Calorimeter</b></font><br>(before reaction)</td>
		</tr>
		<tr>
			<td>Mass of Mg(s)</td>
			<td>$mass_mg g</td>
		</tr>
		<tr>
			<td>Mass of MgO(s)</td>
			<td>$mass_mgo g</td>
		</tr>
		<tr>
			<td>Volume of 1.0 M HCl(aq)</td>
			<td>$vol_hcl mL</td>
		</tr>
EOF
	if ($temp_measured == 1) {
		print "		<tr>\n";
		print "			<td>Calorimeter Temperature</td>\n";
		print "			<td>$temp <sup>o</sup>C</td>\n";
		print "		</tr>\n";
	}
	print <<EOF;
	</table>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<b>Select a reagent to add to your calorimeter</b>:<br>
	<input type="radio" name="reagent" value="mg">Add ~0.15 g Mg<br>
	<input type="radio" name="reagent" value="mgo">Add ~0.25 g MgO<br>
	<input type="radio" name="reagent" value="hcl">Pipet 25.00 mL of 1.0 M HCl<br>
	<input type="hidden" name="mass_mg" value="$mass_mg">	
	<input type="hidden" name="mass_mgo" value="$mass_mgo">	
	<input type="hidden" name="vol_hcl" value="$vol_hcl">
	<input type="hidden" name="mass_tot" value="$mass_tot">
	<input type="hidden" name="mol_mg" value="$mol_mg">	
	<input type="hidden" name="mol_mgo" value="$mol_mgo">	
	<input type="hidden" name="mol_hcl" value="$mol_hcl">	
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="temp_measured" value="$temp_measured">
	<input type="hidden" name="control_1" value="PartB_add">
	<input type="submit" value="Add the Reagent!">
	</form>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<input type="hidden" name="mass_mg" value="$mass_mg">	
	<input type="hidden" name="mass_mgo" value="$mass_mgo">	
	<input type="hidden" name="vol_hcl" value="$vol_hcl">
	<input type="hidden" name="mass_tot" value="$mass_tot">
	<input type="hidden" name="mol_mg" value="$mol_mg">	
	<input type="hidden" name="mol_mgo" value="$mol_mgo">	
	<input type="hidden" name="mol_hcl" value="$mol_hcl">	
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="temp_measured" value="$temp_measured">
	<input type="hidden" name="control_1" value="PartB_temp">
	<input type="submit" value="Measure the Temperature">
	</form>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<input type="hidden" name="control_1" value="PartB_fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>
EOF

} elsif ($flow eq 'PartB_temp') {
	# Read the parameters
	my $mass_mg = param('mass_mg');
	my $mass_mgo = param('mass_mgo');
	my $vol_hcl = param('vol_hcl');
	my $mass_tot = param('mass_tot');
	my $mol_mg = param('mol_mg');
	my $mol_mgo = param('mol_mgo');
	my $mol_hcl = param('mol_hcl');
	my $temp = param('temp');
	my $temp_measured = 1;
	
	# figure out the new temperature
	if ($vol_hcl == 0) {
		$temp_measured = 0;
		print "You must put HCl solution into the calorimeter to measure the temperature!<br>\n";
	}
	
	# Reaction enthalpies and molar masses are set here
	my $DH1 = -466.85;					# kJ (reaction 1)
	my $DH2 = -151.1;					# kJ (reaction 2)
	my $mmass_mg = 24.305;				# g/mol
	my $mmass_mgo = 40.3044;			# g/mol
	my $DT = 0;
	
	# We must base the temperature increase on the limitting reagent
	if ($mol_mg < $mol_hcl) {
		$DT = $DT - ($mol_mg * $DH1 * 1000) / ($mass_tot * 4.184);
		$mol_hcl = $mol_hcl - 2*$mol_mg;
		$mass_mg = 0;
		$mol_mg = 0;
	} 
	if ($mol_mgo < $mol_hcl) {
		$DT = $DT - ($mol_mgo * $DH2 * 1000) / ($mass_tot * 4.184);
		$mol_hcl = $mol_hcl - 2*$mol_mgo;
		$mass_mgo = 0;
		$mol_mgo = 0;
	}
	if ($mol_hcl < $mol_mg) {
		$DT = $DT - ($mol_hcl / 2 * $DH1 * 1000) / ($mass_tot * 4.184);
		$mol_mg = $mol_mg - $mol_hcl / 2;
		$mass_mg = sprintf("%.3f", $mol_mg * $mmass_mg);
		$mol_hcl = 0;
	}
	if ($mol_hcl < $mol_mgo) {
		$DT = $DT - ($mol_hcl / 2 * $DH2 * 1000) / ($mass_tot * 4.184);
		$mol_mgo = $mol_mgo - $mol_hcl / 2;
		$mass_mgo = sprintf("%.3f", $mol_mgo * $mmass_mgo);
		$mol_hcl = 0;
	}
	
	$temp = (sprintf("%.2f", $temp + $DT));
	
	if ($temp > 100) {
		print "Your calorimeter has boiled over and you have made a mess!<br>\n";
		$temp_measured = 0;
	}

	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Contents of Calorimeter</b></font><br>(after reaction)</td>
		</tr>
		<tr>
			<td>Mass of Mg(s)</td>
			<td>$mass_mg g</td>
		</tr>
		<tr>
			<td>Mass of MgO(s)</td>
			<td>$mass_mgo g</td>
		</tr>
		<tr>
			<td>Volume of 1.0 M HCl(aq)</td>
			<td>$vol_hcl mL</td>
		</tr>
EOF
	if ($temp_measured == 1) {
		print "		<tr>\n";
		print "			<td>Calorimeter Temperature</td>\n";
		print "			<td>$temp <sup>o</sup>C</td>\n";
		print "		</tr>\n";
	}
	print <<EOF;
	</table>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<b>Select a reagent to add to your calorimeter</b>:<br>
	<input type="radio" name="reagent" value="mg">Add ~0.15 g Mg<br>
	<input type="radio" name="reagent" value="mgo">Add ~0.25 g MgO<br>
	<input type="radio" name="reagent" value="hcl">Pipet 25.00 mL of 1.0 M HCl<br>
	<input type="hidden" name="mass_mg" value="$mass_mg">	
	<input type="hidden" name="mass_mgo" value="$mass_mgo">	
	<input type="hidden" name="vol_hcl" value="$vol_hcl">
	<input type="hidden" name="mass_tot" value="$mass_tot">
	<input type="hidden" name="mol_mg" value="$mol_mg">	
	<input type="hidden" name="mol_mgo" value="$mol_mgo">	
	<input type="hidden" name="mol_hcl" value="$mol_hcl">	
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="temp_measured" value="$temp_measured">
	<input type="hidden" name="control_1" value="PartB_add">
	<input type="submit" value="Add the Reagent!">
	</form>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<input type="hidden" name="mass_mg" value="$mass_mg">	
	<input type="hidden" name="mass_mgo" value="$mass_mgo">	
	<input type="hidden" name="vol_hcl" value="$vol_hcl">
	<input type="hidden" name="mass_tot" value="$mass_tot">
	<input type="hidden" name="mol_mg" value="$mol_mg">	
	<input type="hidden" name="mol_mgo" value="$mol_mgo">	
	<input type="hidden" name="mol_hcl" value="$mol_hcl">	
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="temp_measured" value="$temp_measured">
	<input type="hidden" name="control_1" value="PartB_temp">
	<input type="submit" value="Measure the Temperature">
	</form>
	<form action="/~pfleming/cgi-bin/thermochemistry.pl" method="post">
	<input type="hidden" name="control_1" value="PartB_fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>
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
