#!/usr/bin/perl -wT

# A Virtual Lab: Acid Neutralizing Capacity of an Antacid
# Patrick E. Fleming
# California State University, East Bay
# June 10, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');						# Determines part

# Set some global parameters
# These are the indices for the antacid object data.
my $label = 0;
my $brand = 1;
my $formula = 2;
my $tab_mass = 3;
my $active_mass = 4;
my $FW = 5;
my $n_acid = 6;

my @antacid = (["A", "Calcarb", "CaCO<sub>3</sub>",   "1.3", 0.5, "100.09", 2],
               ["B", "Aluox",   "Al(OH)<sub>3</sub>", "1.5", 0.6,  "78.00", 3],
               ["C", "Magox",   "Mg(OH)<sub>2</sub>", "1.4", 0.3,  "58.32", 2],
               ["D", "Magcarb", "MgCO<sub>3</sub>",   "1.8", 0.4,  "84.31", 2],
               ["E", "Nacarb",  "NaHCO<sub>3</sub>",  "2.0", 0.8,  "84.01", 1]);

# Begin html output
print header;
print start_html("Acid Neutralizing Capacity of an Antacid");
print "<h1>Acid Neutralizing Capacity of an Antacid</h1>\n";

if ($flow eq 'generate') {
	# Must generate values for the experiment
	my $unknown = int(random_value(scalar(@antacid), 0));
	my $acid_conc = sprintf("%.4f", random_value(0.11, 0.09));
	my $base_conc = sprintf("%.4f", random_value(0.11, 0.09));
	my $sample_mass = sprintf("%.4f", random_value(0.2, 0.1));

# Report these values and get user unput
	print <<EOF;
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="6"><font size="+1"><b>Label Information</b></font></td>
		</tr>
		<tr>
			<td bgcolor="ccffcc">Label</td>
			<td bgcolor="ccffcc">Brand</td>
			<td bgcolor="ccffcc">Active Ingredient</td>
			<td bgcolor="ccffcc">Tablet mass (g)</td>
			<td bgcolor="ccffcc">Active Ing. mass (g)</td>
			<td bgcolor="ccffcc">Act. Ing. FW (g/mol)</td>
		</tr>
EOF
	for (my $i = 0; $i < scalar(@antacid); $i += 1) {
		print "		<tr>\n";
		for (my $j = 0; $j < 6; $j += 1) {
			print "			<td>$antacid[$i][$j]</td>\n";
		}
		print "		</tr>\n";
	}
	print <<EOF;
	</table</p><br>
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Your Data</b></font></td>
		</tr>
		<tr>
			<td>Your antacid</td> <td>$antacid[$unknown][$label]</td>
		</tr>
		<tr>
			<td>Mass used</td> <td>$sample_mass g</td>
		</tr>
		<tr>
			<td>[HCl]</td> <td>$acid_conc M</td>
		</tr>
		<tr>
			<td>[NaOH]</td> <td>$base_conc M</td>
		</tr>
	</table></p>
	<form action="/~pfleming/cgi-bin/Antacid.pl" method="post">
	<p>How much acid would you like to use to dissolve your sample?<p>
	<input type="radio" name="acid_vol" value="5.00"> 5 mL<br>
	<input type="radio" name="acid_vol" value="10.00"> 10 mL<br>
	<input type="radio" name="acid_vol" value="20.00"> 20 mL<br>
	<input type="radio" name="acid_vol" value="25.00"> 25 mL<br>
	<input type="radio" name="acid_vol" value="30.00"> 30 mL<br>
	<input type="radio" name="acid_vol" value="35.00"> 35 mL<br>
	<input type="radio" name="acid_vol" value="40.00"> 40 mL<br>
	<input type="radio" name="acid_vol" value="45.00"> 45 mL<br>
	<input type="radio" name="acid_vol" value="50.00"> 50 mL<br>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="acid_conc" value="$acid_conc">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="control_1" value="dissolve">
	<input type="submit" value="Dissolve my antacid!">
EOF

} elsif ($flow eq 'dissolve') {
	# Read the inputs
	my $unknown = param('unknown');
	my $acid_conc = param('acid_conc');
	my $base_conc = param('base_conc');
	my $sample_mass = param('sample_mass');
	my $acid_vol = param('acid_vol');
	
	print <<EOF;
	<div name="decorate">
	<img src="/~pfleming/chem/titrate/sn1setup.gif" align="right">
	</div>
	<p><table border="2" cellpadding="2">
		<tr>
			<td>Your antacid</td> <td>$antacid[$unknown][$label]</td>
		</tr>
		<tr>
			<td>Mass used</td> <td>$sample_mass g</td>
		</tr>
		<tr>
			<td>[HCl]</td> <td>$acid_conc M</td>
		</tr>
		<tr>
			<td>[NaOH]</td> <td>$base_conc M</td>
		</tr>
		<tr>
			<td>Acid used</td> <td>$acid_vol mL</td>
		</tr>
	</table></p>
EOF

	# Did the student add enough acid?
	my $acid_mmol = $acid_conc * $acid_vol;
	my $antacid_mmol = $sample_mass * ($antacid[$unknown][$active_mass] / $antacid[$unknown][$tab_mass]) / $antacid[$unknown][$FW] * 1000 * $antacid[$unknown][$n_acid];
	my $pic = '';
	if ($acid_mmol > $antacid_mmol) {
		$pic = "<img src=\"/~pfleming/chem/titrate/not_close.png\" height=\"240\">";
	} elsif ($acid_mmol > $antacid_mmol) {
		$pic = "<img src=\"/~pfleming/chem/titrate/endpoint.jpg\" height=\"240\">";
	} else {
		$pic = "<img src=\"/~pfleming/chem/titrate/over.jpg\" height=\"240\">";
	}
	print <<EOF;
	$pic<br>
	<form action="/~pfleming/cgi-bin/Antacid.pl" method="post">
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="acid_conc" value="$acid_conc">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="acid_vol" value="$acid_vol">
	<input type="hidden" name="base_vol" value="0">
	<input type="hidden" name="base_added" value="0">
	<input type="hidden" name="control_1" value="titrate">
	<input type="submit" value="Begin back-titration!">
	</form>
EOF
	
	
} elsif ($flow eq 'titrate') {
	# Read the inputs
	my $unknown = param('unknown');
	my $acid_conc = param('acid_conc');
	my $base_conc = param('base_conc');
	my $sample_mass = param('sample_mass');
	my $acid_vol = param('acid_vol');
	my $base_vol = param('base_vol');
	my $base_added = param('base_added');
	$base_vol = $base_vol + $base_added;
	
	# where are we in the back-titration?
	my $acid_mmol = $acid_conc * $acid_vol;
	my $base_mmol = $base_conc * $base_vol;
	my $antacid_mmol = $sample_mass * ($antacid[$unknown][$active_mass] / $antacid[$unknown][$tab_mass]) / $antacid[$unknown][$FW] * 1000 * $antacid[$unknown][$n_acid];
	$acid_mmol = $acid_mmol - $antacid_mmol;
	my $vol_tot = $acid_vol + $base_vol + 25;
	my $pic = '';
	my $pH = 7;
	if ($acid_mmol > $base_mmol) {
		$pH = -log10(($acid_mmol - $base_mmol)/$vol_tot);
	} elsif ($acid_mmol == $base_mmol) {
		$pH = 7;
	} else {
		my $OH_conc = ($base_mmol - $acid_mmol) / $vol_tot;
		$pH = 14 + log10($OH_conc);
	}
	$pH = sprintf("%.2f", $pH);
	if ($pH < 3) {
		$pic = "<img src=\"/~pfleming/chem/titrate/not_close.png\" height=\"240\">";
	} elsif ($pH < 7) {
		$pic = "<img src=\"/~pfleming/chem/titrate/close.gif\" height=\"240\">";
	} elsif ($pH < 10) {
		$pic = "<img src=\"/~pfleming/chem/titrate/endpoint.jpg\" height=\"240\">";
	} else {
		$pic = "<img src=\"/~pfleming/chem/titrate/over.jpg\" height=\"240\">";
	}

	print <<EOF;
	<div name="decorate">
	<img src="/~pfleming/chem/titrate/sn1setup.gif" align="right">
	</div>
	$pic
	<p><table border="2" cellpadding="2">
		<tr>
			<td>Your antacid</td> <td>$antacid[$unknown][$label]</td>
		</tr>
		<tr>
			<td>Mass used</td> <td>$sample_mass g</td>
		</tr>
		<tr>
			<td>[HCl]</td> <td>$acid_conc M</td>
		</tr>
		<tr>
			<td>[NaOH]</td> <td>$base_conc M</td>
		</tr>
		<tr>
			<td>Acid used</td> <td>$acid_vol mL</td>
		</tr>
		<tr>
			<td>Total base used</td> <td>$base_vol mL</td>
		</tr>
		<tr>
			<td>Solution pH</td> <td>$pH</td>
		</tr>
	</table></p>
	<p><form action="/~pfleming/cgi-bin/Antacid.pl" method="post">
	<p>How much base would you like to add?<p>
	<input name="base_added"><br>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="acid_conc" value="$acid_conc">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="acid_vol" value="$acid_vol">
	<input type="hidden" name="base_vol" value="$base_vol">
	<input type="hidden" name="control_1" value="titrate">
	<input type="submit" value="Add the base!">
	</form></p>
	
	<p><form action="/~pfleming/cgi-bin/Antacid.pl" method="post">
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="acid_conc" value="$acid_conc">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="acid_vol" value="$acid_vol">
	<input type="hidden" name="base_vol" value="$base_vol">
	<input type="hidden" name="control_1" value="finish">
	<input type="submit" value="Finish the titration!">
	</form></p>
EOF

} elsif ($flow eq 'finish') {
	#read the parameters
	my $unknown = param('unknown');
	my $acid_conc = param('acid_conc');
	my $base_conc = param('base_conc');
	my $sample_mass = param('sample_mass');
	my $acid_vol = param('acid_vol');
	my $base_vol = param('base_vol');
	print <<EOF;
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="6"><font size="+1"><b>Label Information</b></font></td>
		</tr>
		<tr>
			<td bgcolor="ccffcc">Label</td>
			<td bgcolor="ccffcc">Brand</td>
			<td bgcolor="ccffcc">Active Ingredient</td>
			<td bgcolor="ccffcc">Tablet mass (g)</td>
			<td bgcolor="ccffcc">Active Ing. mass (g)</td>
			<td bgcolor="ccffcc">Act. Ing. FW (g/mol)</td>
		</tr>
		<tr>
			<td>$antacid[$unknown][0]</td>
			<td>$antacid[$unknown][1]</td>
			<td>$antacid[$unknown][2]</td>
			<td>$antacid[$unknown][3]</td>
			<td>$antacid[$unknown][4]</td>
			<td>$antacid[$unknown][5]</td>
		</tr>
	</table</p><br>
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffff" colspan="2"><font size="+1"><b>Final Data</b></font></td>
		</tr>
		<tr>
			<td>Your antacid</td> <td>$antacid[$unknown][$label]</td>
		</tr>
		<tr>
			<td>Mass used</td> <td>$sample_mass g</td>
		</tr>
		<tr>
			<td>[HCl]</td> <td>$acid_conc M</td>
		</tr>
		<tr>
			<td>[NaOH]</td> <td>$base_conc M</td>
		</tr>
		<tr>
			<td>Acid used</td> <td>$acid_vol mL</td>
		</tr>
		<tr>
			<td>Total base used</td> <td>$base_vol mL</td>
		</tr>
	</table></p>
	<form action="/~pfleming/cgi-bin/Antacid.pl" method="post">
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ffcccc" colspan="2"><font size="+1"><b>Calculations</b></font></td>
		</tr>
		<tr>
			<td>mmol of HCl (total)</td>
			<td><input name="acid_mmol_calc"> mmol</td>
		</tr>
		<tr>
			<td>mmol of NaOH added</td>
			<td><input name="base_mmol_calc"> mmol</td>
		</tr>
		<tr>
			<td>mmol of HCl neutralized</td>
			<td><input name="acid_mmol_neut_calc"> mmol</td>
		</tr>
		<tr>
			<td>mmol of antacid ingredient in sample</td>
			<td><input name="antacid_mmol_calc"> mmol</td>
		</tr>
		<tr>
			<td>mass of antacid ingredient in sample</td>
			<td><input name="antacid_mass_calc"> mg</td>
		</tr>
		<tr>
			<td>mass of antacid ingredient in tablet</td>
			<td><input name="antacid_mass_tablet_calc"> mg</td>
		</tr>
	</table></p>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="acid_conc" value="$acid_conc">
	<input type="hidden" name="base_conc" value="$base_conc">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="acid_vol" value="$acid_vol">
	<input type="hidden" name="base_vol" value="$base_vol">
	<input type="hidden" name="control_1" value="grade">
	<input type="submit" value="Am I right?">
	</form>
EOF

} elsif ($flow eq 'grade') {
	# Read parameters
	my $unknown = param('unknown');
	my $acid_conc = param('acid_conc');
	my $base_conc = param('base_conc');
	my $sample_mass = param('sample_mass');
	my $acid_vol = param('acid_vol');
	my $base_vol = param('base_vol');
	my $acid_mmol_calc = param('acid_mmol_calc');
	my $base_mmol_calc = param('base_mmol_calc');
	my $acid_mmol_neut_calc = param('acid_mmol_neut_calc');
	my $antacid_mmol_calc = param('antacid_mmol_calc');
	my $antacid_mass_calc = param('antacid_mass_calc');
	my $antacid_mass_tablet_calc = param('antacid_mass_tablet_calc');

	# Calculate correct answers
	my $acid_mmol = $acid_conc * $acid_vol;
	my $base_mmol = $base_conc * $base_vol;
	my $acid_mmol_neut = $acid_mmol - $base_mmol;
	my $antacid_mmol = $acid_mmol_neut / $antacid[$unknown][$n_acid];
	my $antacid_mass = $antacid_mmol * $antacid[$unknown][$FW];
	my $antacid_mass_tablet = $antacid_mass * $antacid[$unknown][$tab_mass] / $sample_mass;
	my @response = ("", "", "", "", "", "");
	
	# Check if the respnses match the calculated values
	if (abs($acid_mmol - $acid_mmol_calc)/$acid_mmol < 0.01) {
		$response[0] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[0] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($base_mmol - $base_mmol_calc)/$base_mmol < 0.01) {
		$response[1] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[1] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($acid_mmol_neut - $acid_mmol_neut_calc)/$acid_mmol_neut < 0.01) {
		$response[2] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[2] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($antacid_mmol - $antacid_mmol_calc)/$antacid_mmol < 0.01) {
		$response[3] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[3] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($antacid_mass - $antacid_mass_calc)/$antacid_mass < 0.01) {
		$response[4] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[4] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($antacid_mass_tablet - $antacid_mass_tablet_calc)/$antacid_mass_tablet < 0.01) {
		$response[5] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[5] = "<font color=\"red\">You are incorrect.</font>";
	}
	print <<EOF;
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ffcccc" colspan="3"><font size="+1"><b>Results</b></font></td>
		</tr>
		<tr>
			<td>mmol of HCl (total)</td>
			<td>$acid_mmol_calc mmol</td>
			<td>$response[0]</td>
		</tr>
		<tr>
			<td>mmol of NaOH added</td>
			<td>$base_mmol_calc mmol</td>
			<td>$response[1]</td>
		</tr>
		<tr>
			<td>mmol of HCl neutralized</td>
			<td>$acid_mmol_neut_calc mmol</td>
			<td>$response[2]</td>
		</tr>
		<tr>
			<td>mmol of antacid ingredient in sample</td>
			<td>$antacid_mmol_calc mmol</td>
			<td>$response[3]</td>
		</tr>
		<tr>
			<td>mass of antacid ingredient in sample</td>
			<td>$antacid_mass_calc mg</td>
			<td>$response[4]</td>
		</tr>
		<tr>
			<td>mass of antacid ingredient in tablet</td>
			<td>$antacid_mass_tablet_calc mg</td>
			<td>$response[5]</td>
		</tr>
	</table></p>
EOF

} else {
	print "No valid part specified.\n";
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
	return $value
}

sub log10 {
	my $value = log($_[0])/log(10);
	return $value;
}
