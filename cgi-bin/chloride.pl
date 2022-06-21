#!/usr/bin/perl -wT

# A Virtual Lab: Determination of % NaCl by mass
# Patrick E. Fleming
# California State University, East Bay
# June 23, 2020 
# Revised February 18, 2021 (to add experimental part)
# Revised again March 3, 2021 (to add NaCl or MgCl2 unknowns)

# this virtual chloride experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part
my $i = 0;							# looping variable

my $mmass_cl = 35.45;				# g/mol
my $mmass_nacl = 58.44;				# g/mol
my $mmass_nano3 = 84.99;			# g/mol
my $mmass_mgcl2 = 95.21;			# g/mol
my $mmass_agcl = 143.32;			# g/mol

# Begin html output
print header;
print start_html("An Unknown Chloride");
print "<h1>An Unknown Chloride</h1>\n";

if ($flow eq 'NaCl') {
	# This part will have the user determien the percent by mass due to NaCl for an unknown
	# consisting of NaCl and NaNO3
	my $unk_pct = sprintf("%.2f", random_value(80,20));
	my $unk_mass = sprintf("%.4f", random_value(1.2, 0.8));

	my $mol_cl = ($unk_pct / 100) * $unk_mass / $mmass_nacl;
	my $mass_agcl = sprintf("%.4f", $mol_cl * $mmass_agcl);
	my $mass_cl = $mol_cl * $mmass_cl;
	my $pct_cl = $mass_cl / $unk_mass * 100;
	my $mol_nacl = $mol_cl;
	my $mass_nacl = $unk_mass * $unk_pct / 100;
	my $pct_nacl = $mass_nacl / $unk_mass * 100;

	print <<EOF;
	<h2>Practice</h2>
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<table border="2" cellpadd="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Data</b></font></td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">Chlorine</td> 
			<td bgcolor="ffffcc">35.45 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">NaCl</td> 
			<td bgcolor="ffffcc">58.44 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">MgCl<sub>2</sub></td> 
			<td bgcolor="ffffcc">95.21 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">AgCl</td> 
			<td bgcolor="ffffcc">143.32 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffcccc">Unknown:</td> <td bgcolor="ffcccc">NaCl/NaNO<sub>3</sub></td>
		</tr>
		<tr>
			<td>Mass of sample of unknown</td> <td>$unk_mass g</td>
		</tr>
		<tr>
			<td>Mass of AgCl recovered</td> <td>$mass_agcl g</td>
		</tr>
		<tr>
			<td>Moles of Cl<sup>-</sup></td>
			<td><input name="mol_cl_ans"> mol</td>
		</tr>
		<tr>
			<td>Mass of Cl<sup>-</sup></td>
			<td><input name="mass_cl_ans"> g</td>
		</tr>
		<tr>
			<td>% by mass Cl<sup>-</sup> in unknown</td>
			<td><input name="pct_cl_ans"> %</td>
		</tr>
		<tr>
			<td>Moles of NaCl in sample</td>
			<td><input name="mol_nacl_ans"> mol</td>
		</tr>
		<tr>
			<td>Mass NaCl in sample</td>
			<td><input name="mass_nacl_ans"> g</td>
		</tr>
		<tr>
			<td>% by mass NaCl in unknown</td>
			<td><input name="pct_nacl_ans"> %</td>
		</tr>
		<tr>
			<td><input type="submit" value="Am I right?"></td>
			<td><input type="reset" value="Start over"></td>
		</tr>
	</table>
	<input type="hidden" name="mol_cl"    value="$mol_cl">
	<input type="hidden" name="mass_cl"   value="$mass_cl">
	<input type="hidden" name="pct_cl"    value="$pct_cl">
	<input type="hidden" name="unk_mass"  value="$unk_mass">
	<input type="hidden" name="mass_agcl" value="$mass_agcl">
	<input type="hidden" name="mol_nacl"  value="$mol_nacl">
	<input type="hidden" name="mass_nacl" value="$mass_nacl">
	<input type="hidden" name="pct_nacl"  value="$pct_nacl">
	<input type="hidden" name="magnesium" value="no">
	<input type="hidden" name="control_1" value="grade_practice">
	</form>

	<!--- Start a fresh experimental run --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="full">
	<input type="submit" value="Begin a fresh experimental run">
	</form>

EOF

} elsif ($flow eq 'practice') {
	my $unk_pct = sprintf("%.2f", random_value(80, 20));
	my $unk_mass = sprintf("%.4f", random_value(1.2, 0.8));
	
	my $mol_cl = ($unk_pct / 100) * $unk_mass / $mmass_nacl + (1 - $unk_pct / 100) * $unk_mass / $mmass_mgcl2 * 2;
	my $mass_agcl = sprintf("%.4f", $mol_cl * $mmass_agcl);
	my $mass_cl = $mol_cl * $mmass_cl;
	my $pct_cl = $mass_cl / $unk_mass * 100;
	my $mol_nacl = ($unk_mass * $unk_pct / 100) / $mmass_nacl;
	my $mass_nacl = $unk_mass * $unk_pct / 100;
	my $pct_nacl = $mass_nacl / $unk_mass * 100;

	print <<EOF;
	<h2>Practice</h2>
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<table border="2" cellpadd="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Data</b></font></td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">Chlorine</td> 
			<td bgcolor="ffffcc">35.45 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">NaCl</td> 
			<td bgcolor="ffffcc">58.44 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">MgCl<sub>2</sub></td> 
			<td bgcolor="ffffcc">95.21 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">AgCl</td> 
			<td bgcolor="ffffcc">143.32 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffcccc">Unknown:</td> <td bgcolor="ffcccc">NaCl/MgCl<sub>2</sub></td>
		</tr>
		<tr>
			<td>Mass of sample of unknown</td> <td>$unk_mass g</td>
		</tr>
		<tr>
			<td>Mass of AgCl recovered</td> <td>$mass_agcl g</td>
		</tr>
		<tr>
			<td>Moles of Cl<sup>-</sup></td>
			<td><input name="mol_cl_ans"> mol</td>
		</tr>
		<tr>
			<td>Mass of Cl<sup>-</sup></td>
			<td><input name="mass_cl_ans"> g</td>
		</tr>
		<tr>
			<td>% by mass Cl<sup>-</sup> in unknown</td>
			<td><input name="pct_cl_ans"> %</td>
		</tr>
		<tr>
			<td>Moles of NaCl in sample</td>
			<td><input name="mol_nacl_ans"> mol</td>
		</tr>
		<tr>
			<td>Mass NaCl in sample</td>
			<td><input name="mass_nacl_ans"> g</td>
		</tr>
		<tr>
			<td>% by mass NaCl in unknown</td>
			<td><input name="pct_nacl_ans"> %</td>
		</tr>
		<tr>
			<td><input type="submit" value="Am I right?"></td>
			<td><input type="reset" value="Start over"></td>
		</tr>
	</table>
	<input type="hidden" name="mol_cl"    value="$mol_cl">
	<input type="hidden" name="mass_cl"   value="$mass_cl">
	<input type="hidden" name="pct_cl"    value="$pct_cl">
	<input type="hidden" name="unk_mass"  value="$unk_mass">
	<input type="hidden" name="mass_agcl" value="$mass_agcl">
	<input type="hidden" name="mol_nacl"  value="$mol_nacl">
	<input type="hidden" name="mass_nacl" value="$mass_nacl">
	<input type="hidden" name="pct_nacl"  value="$pct_nacl">
	<input type="hidden" name="magnesium" value="yes">
	<input type="hidden" name="control_1" value="grade_practice">
	</form>

	<!--- Start a fresh experimental run --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="full">
	<input type="submit" value="Begin a fresh experimental run">
	</form>

EOF

} elsif ($flow eq 'grade_practice') {
	# read parameters
	my $mol_cl = param('mol_cl');
	my $mass_cl = param('mass_cl');
	my $pct_cl = param('pct_cl');
	my $mol_cl_ans = param('mol_cl_ans');
	my $mass_cl_ans = param('mass_cl_ans');
	my $pct_cl_ans = param('pct_cl_ans');
	my $mol_nacl_ans = param('mol_nacl_ans');
	my $mass_nacl_ans = param('mass_nacl_ans');
	my $pct_nacl_ans = param('pct_nacl_ans');
	my $unk_mass = param('unk_mass');
	my $mass_agcl = param('mass_agcl');
	my $mol_nacl = param('mol_nacl');
	my $mass_nacl = param('mass_nacl');
	my $pct_nacl = param('pct_nacl');
	my $magnesium = param('magnesium');
	
	# Grade answers
	my $response_1 = "<font color=\"red\">You are incorrect.</font>";
	my $response_2 = "<font color=\"red\">You are incorrect.</font>";
	my $response_3 = "<font color=\"red\">You are incorrect.</font>";
	my $response_4 = "<font color=\"red\">You are incorrect.</font>";
	my $response_5 = "<font color=\"red\">You are incorrect.</font>";
	my $response_6 = "<font color=\"red\">You are incorrect.</font>";
	if (abs($mol_cl - $mol_cl_ans)/$mol_cl < 0.0002) {
		$response_1 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($mass_cl - $mass_cl_ans)/$mass_cl < 0.0002) {
		$response_2 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($pct_cl - $pct_cl_ans)/$pct_cl < 0.0002) {
		$response_3 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($mol_nacl - $mol_nacl_ans)/$mol_nacl < 0.002) {
		$response_4 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($mass_nacl - $mass_nacl_ans)/$mass_nacl < 0.002) {
		$response_5 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($pct_nacl - $pct_nacl_ans)/$pct_nacl < 0.002) {
		$response_6 = "<font color=\"green\">You are correct!</font>";
	}
	print <<EOF;
	<table border="3" cellpadd="2">
		<tr>
			<td bgcolor="ffcccc" colspan="3"><font size="+1"><b>Data</b></font></td>
		</tr>
EOF
	if ($magnesium eq 'yes') {
		print <<EOF;
		<tr>
			<td bgcolor="ffcccc">Unknown:</td> <td bgcolor="ffcccc" colspan="2">NaCl/MgCl<sub>2</sub></td>
		<tr>
EOF
	} else {
		print <<EOF;
		<tr>
			<td bgcolor="ffcccc">Unknown:</td> <td bgcolor="ffcccc" colspan="2">NaCl/NaNO<sub>3</sub></td>
		<tr>
EOF
	}
	print <<EOF;
		<tr>
			<td>Mass of sample of unknown</td> <td>$unk_mass g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Mass of AgCl recovered</td> <td>$mass_agcl g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Moles of Cl<sup>-</sup></td>
			<td>$mol_cl_ans mol</td>
			<td>$response_1</td>
		</tr>
		<tr>
			<td>Mass of Cl<sup>-</sup></td>
			<td>$mass_cl_ans g</td>
			<td>$response_2</td>
		</tr>
		<tr>
			<td>% by mass Cl<sup>-</sup> in unknown</td>
			<td>$pct_cl_ans %</td>
			<td>$response_3</td>
		</tr>
		<tr>
			<td>Moles of NaCl in sample</td>
			<td>$mol_nacl_ans mol</td>
			<td>$response_4</td>
		</tr>
		<tr>
			<td>Mass of NaCl in sample</td>
			<td>$mass_nacl_ans g</td>
			<td>$response_5</td>
		</tr>
		<tr>
			<td>% by mass NaCl in unknown</td>
			<td>$pct_nacl_ans %</td>
			<td>$response_6</td>
		</tr>
	</table>

	<!--- Generate Practice Data --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="NaCl">
	<input type="submit" value="Generate fresh simple chloride practice data">
	</form>

	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="practice">
	<input type="submit" value="Generate fresh mixed chloride practice data">
	</form>

	<!--- Start a fresh experimental run --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="full">
	<input type="submit" value="Begin a fresh experimental run">
	</form>

EOF

} elsif ($flow eq 'full') {
	my $unk_pct = param('unk_pct');
	my $unk_num = param('unk_num');
	my $unk_mass = param('unk_mass');
	my $vol_water = param('vol_water');
	my $vol_agno3 = param('vol_agno3');
	my $vol_agno3_added = param('vol_agno3_added');
	my $reagent = param('reagent');
	
	if ($unk_pct eq '') {
		$unk_pct = sprintf("%.2f", random_value(80, 20));
		$unk_num = sprintf("%.0f", random_value(9900, 1100));
	}

	# Add Reagent
	if ($reagent eq 'unknown') {
		$unk_mass = $unk_mass + sprintf("%.4f", random_value(0.12, 0.08));
	} elsif ($reagent eq 'water') {
		$vol_water = $vol_water + 50;
	} elsif ($reagent eq 'AgNO3') {
		$vol_agno3 = $vol_agno3 + $vol_agno3_added;
	}
	
	my $vol_tot = $vol_water + $vol_agno3;
	if ($vol_tot > 110) {
		$unk_mass = "";
		$vol_water = "";
		$vol_agno3 = "";
		$vol_agno3_added = "";
		print "<font color=\"red\">You have over filled your beaker and made a mess.</font><br>\n";
		print "You must begin with a fresh beaker.<br>\n";
	}

	print <<EOF;
	<h2>Add Reagents</h2>
	<table border="2">
	  <tr>
	    <td colspan="2" bgcolor="ccffcc">Beaker Contents</td>
	  </tr>
	  <tr>
	    <td colspan="2">Unknown Number: $unk_num</td>
	  <tr>
	    <td>Unknown Sample</td> <td>$unk_mass g</td>
	  </tr>
	  <tr>
	    <td>Water</td> <td>$vol_water mL</td>
	  </tr>
	  <tr>
	    <td>0.100 M AgNO<sub>3</sub></td> <td>$vol_agno3 mL</td>
	  </tr>
	</table><hr>
	
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<p>Select what you wish to add to your 100 mL beaker:</p>
	<input type="radio" name="reagent" value="unknown">~ 0.1 g of your unknown<br>
	<input type="radio" name="reagent" value="water">50 mL water<br>
	<input type="radio" name="reagent" value="AgNO3"><input name="vol_agno3_added"> mL 0.100 M AgNO<sub>3</sub><br>
	<input type="hidden" name="unk_pct" value="$unk_pct">
	<input type="hidden" name="unk_num" value="$unk_num">
	<input type="hidden" name="unk_mass" value="$unk_mass">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="vol_agno3" value="$vol_agno3">
	<input type="hidden" name="control_1" value="full">
	<input type="submit" value="Add the Reagent">
	<input type="reset">
	</form>
	
	<!--- Start with a fresh beaker --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="unk_pct" value="$unk_pct">
	<input type="hidden" name="unk_num" value="$unk_num">
	<input type="hidden" name="unk_mass" value="">
	<input type="hidden" name="vol_water" value="">
	<input type="hidden" name="vol_agno3" value="">
	<input type="hidden" name="control_1" value="full">
	<input type="submit" value="Begin with a fresh 100 mL beaker">
	</form>
	
	<!--- Filter the precipitate --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="unk_pct" value="$unk_pct">
	<input type="hidden" name="unk_num" value="$unk_num">
	<input type="hidden" name="unk_mass" value="$unk_mass">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="vol_agno3" value="$vol_agno3">
	<input type="hidden" name="control_1" value="filter">
	<input type="submit" value="Filter the precipitate">
	</form>
EOF

} elsif ($flow eq 'filter') {
	my $unk_pct = param('unk_pct');
	my $unk_num = param('unk_num');
	my $unk_mass = param('unk_mass');
	my $vol_water = param('vol_water');
	my $vol_agno3 = param('vol_agno3');
	
	print "<h2>Results</h2>\n";
	
	my $mol_cl = ($unk_pct / 100) * $unk_mass / $mmass_nacl + (1 - $unk_pct / 100) * $unk_mass / $mmass_mgcl2 * 2;
	my $mol_ag = $vol_agno3 * 0.1;
	my $mol_agcl = 0;
	if ($mol_cl < $mol_ag) {
		$mol_agcl = $mol_cl;
	} else {
		$mol_agcl = $mol_ag;
	}
	my $mass_agcl = sprintf("%.4f", $mol_agcl * $mmass_agcl);

	print <<EOF;
	<table border="2" cellpadd="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Data</b></font></td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">Chlorine</td> 
			<td bgcolor="ffffcc">35.45 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">NaCl</td> 
			<td bgcolor="ffffcc">58.44 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">MgCl<sub>2</sub></td> 
			<td bgcolor="ffffcc">95.21 g/mol</td>
		</tr>
		<tr>
			<td bgcolor="ffffcc">AgCl</td> 
			<td bgcolor="ffffcc">143.32 g/mol</td>
		</tr>
	  <tr>
			<td colspan="2">Unknown Number: $unk_num</td>
	  <tr>
		<tr>
			<td>Mass of sample of unknown</td> <td>$unk_mass g</td>
		</tr>
		<tr>
			<td>Mass of AgCl recovered</td> <td>$mass_agcl g</td>
		</tr>
	</table>
	
	<!--- Start a fresh experimental run --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="unk_pct" value="$unk_pct">
	<input type="hidden" name="unk_num" value="$unk_num">
	<input type="hidden" name="control_1" value="full">
	<input type="submit" value="Begin a fresh run">
	</form>

	<!--- Generate Practice Data --->
	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="NaCl">
	<input type="submit" value="Generate fresh simple chloride practice data">
	</form>

	<form action="/~pfleming/cgi-bin/chloride.pl" method="post">
	<input type="hidden" name="control_1" value="practice">
	<input type="submit" value="Generate fresh mixed chloride practice data">
	</form>
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
	my $value = rand(1) * ($max - $min) + $min;
	return $value;
}

