#!/usr/bin/perl -wT

# A Virtual Lab: Freezing Point Depression
# Patrick E. Fleming
# California State University, East Bay
# July 19, 2020 

# this virtual kinetics is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part
my $i = 0;							# looping variable

# Some global parameters

# Begin html output
print header;
print start_html("Freezing Point Depression");
print "<h1>Freezing Point Depression</h1>\n";

my @solvent = (["benzene",             5.12,   5.5,   78.11],
               ["nitrobenzene",        8.1,    5.67, 123.11],
               ["ethylene dibromide", 11.80,  10.0,  187.862],
               ["cyclohxene",          6.5,   20.2,   82.143],
               ["phenol",              7.27,  40.5,   94.11],
               ["benzophenone",        9.80,  48.5,  182.217],
               ["diphenylamine",       8.60,  53.0,  169.23],
               ["biphenyl",            8.00,  69.2,  154.21],
               ["naphthalene",         6.85,  80.26, 128.17]);
my $nsolvents = scalar(@solvent);
for ($i=0; $i < $nsolvents; $i+=1) {
	$solvent[$i][1] = sprintf("%.2f", $solvent[$i][1]);
}

if ($flow eq 'fresh') {
	# Choose an unknown solvent and molar mass of solute
	my $solv = param('solv');
	my $unk_mmass = param('unk_mmass');

	if ($solv eq '') {
		$solv = int(random_value($nsolvents, 0) + 0.5);
	}
	if ($unk_mmass eq '') {
		$unk_mmass = sprintf("%.2f", random_value(188,122));
	}
		
	# Now, let's build a cell and measure the Freezing temperature(s)
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="5" bgcolor="ccffcc"><font size="+1"><b>Centents of cell</b></font></td>
		</tr>
		<tr>
			<td bgcolor="cccccc"><b>Solvent</b></td>
			<td bgcolor="cccccc"><b>K<sub>f</sub> (<sup>o</sup>C mol kg<sup>-1</sup></b></td>
			<td bgcolor="cccccc"><b>Molar mass (g/mol)</b></td>
			<td bgcolor="cccccc"><b>Mass used (g)</b></td>
			<td bgcolor="cccccc"><b>Freezing Temperature (<sup>o</sup>C)</b></td>
		</tr>
		<tr>
			<td>$solvent[$solv][0]</td>
			<td>$solvent[$solv][1]</td>
			<td>$solvent[$solv][3]</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="2"><b>Unknown compound</b></td>
			<td></td>
			<td></td>
			<td bgcolor="black"></td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="4"><b>Mixture</b></td>
			<td></td>
		</tr>
	</table><br>

	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<b>Choose a reagent to add</b>:<br>
	<input type="radio" name="reagent" value="solvent">$solvent[$solv][0]<br>
	<input type="radio" name="reagent" value="unknown">Unknown compound<br>
	<b>Choose a nominal mass to add</b>:<br>
	<input type="radio" name="mass" value="1">~1 g<br>
	<input type="radio" name="mass" value="2">~2 g<br>
	<input type="radio" name="mass" value="5">~5 g<br>
	<input type="radio" name="mass" value="10">~10 g<br>
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="control_1" value="add_reagent">
	<input type="submit" value="Add the reagent">
	</form>
EOF

} elsif ($flow eq 'add_reagent') {
	# Read parameters
	my $solv = param('solv');
	my $unk_mmass = param('unk_mmass');
	my $reagent = param('reagent');
	my $mass = param('mass');
	my $mass_solv = param('mass_solv');
	my $melt_solv = param('melt_solv');
	my $mass_unk = param('mass_unk');
	my $melt_mix = param('melt_mix');
	
	if ($mass eq '') {
		print "<font color=\"red\">You must select a mass to add!</font><br>\n";
	} else {
		if ($reagent eq 'solvent') {
			$mass_solv = sprintf("%.3f", $mass_solv + $mass + random_value(0.1, -0.1));
		} elsif ($reagent eq 'unknown') {
			$mass_unk = sprintf("%.3f", $mass_unk + $mass + random_value(0.1, -0.1));
		} else {
			print "<font color=\"red\">You must select a reagent to add!</font><br>\n";
		}
	}
	
	# Now, let's continue building a cell and measure the Freezing temperature(s)
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="5" bgcolor="ccffcc"><font size="+1"><b>Centents of cell</b></font></td>
		</tr>
		<tr>
			<td bgcolor="cccccc"><b>Solvent</b></td>
			<td bgcolor="cccccc"><b>K<sub>f</sub> (<sup>o</sup>C mol kg<sup>-1</sup></b></td>
			<td bgcolor="cccccc"><b>Molar mass (g/mol)</b></td>
			<td bgcolor="cccccc"><b>Mass used (g)</b></td>
			<td bgcolor="cccccc"><b>Freezing Temperature (<sup>o</sup>C)</b></td>
		</tr>
		<tr>
			<td>$solvent[$solv][0]</td>
			<td>$solvent[$solv][1]</td>
			<td>$solvent[$solv][3]</td>
			<td>$mass_solv</td>
			<td>$melt_solv</td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="2"><b>Unknown compound</b></td>
			<td></td>
			<td>$mass_unk</td>
			<td bgcolor="black"></td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="4"><b>Mixture</b></td>
			<td>$melt_mix</td>
		</tr>
	</table><br>

	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<b>Choose a reagent to add</b>:<br>
	<input type="radio" name="reagent" value="solvent">$solvent[$solv][0]<br>
	<input type="radio" name="reagent" value="unknown">Unknown compound<br>
	<b>Choose a nominal mass to add</b>:<br>
	<input type="radio" name="mass" value="1">~1 g<br>
	<input type="radio" name="mass" value="2">~2 g<br>
	<input type="radio" name="mass" value="5">~5 g<br>
	<input type="radio" name="mass" value="10">~10 g<br>
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="mass_solv" value="$mass_solv">
	<input type="hidden" name="melt_solv" value="$melt_solv">
	<input type="hidden" name="mass_unk" value="$mass_unk">
	<input type="hidden" name="melt_mix" value="$melt_mix">
	<input type="hidden" name="control_1" value="add_reagent">
	<input type="submit" value="Add the reagent">
	</form>
	
	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="mass_solv" value="$mass_solv">
	<input type="hidden" name="melt_solv" value="$melt_solv">
	<input type="hidden" name="mass_unk" value="$mass_unk">
	<input type="hidden" name="melt_mix" value="$melt_mix">
	<input type="hidden" name="control_1" value="temperature">
	<input type="submit" value="Measure the Freezing Temperature">
	</form>
	
	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="control_1" value="fresh">
	<input type="submit" value="Start Fresh">
	</form>
EOF

} elsif ($flow eq 'temperature') {
	# Read the parameters
	my $solv = param('solv');
	my $unk_mmass = param('unk_mmass');
	my $mass_solv = param('mass_solv');
	my $melt_solv = param('melt_solv');
	my $mass_unk = param('mass_unk');
	my $melt_mix = param('melt_mix');
	
	# Calculate the freezing point if the sample is pure solvent
	if ($mass_unk eq '') {
		if ($mass_solv ne '') {
			# pure solvent
			$melt_solv = sprintf("%.2f", $solvent[$solv][2] + random_value(0.05, -0.05));
		} else {
			# no contents at all!
			print "<font color=\"red\">You must have some solvent present in order to measure the freezing point!</font><br>\n";
		}
	} else {
		if ($mass_solv eq '') {
			# some unknown but no solvent
			print "<font color=\"red\">You must have some solvent present in order to measure the freezing point!</font><br>\n";
		} else {
			# mixture of solvent and solute
			my $molality = ($mass_unk / $unk_mmass) / $mass_solv * 1000;
			$melt_mix = sprintf("%.2f", $solvent[$solv][2] - $solvent[$solv][1] * $molality + random_value(0.05, -0.05));
		}
	}
	
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="5" bgcolor="ccffcc"><font size="+1"><b>Centents of cell</b></font></td>
		</tr>
		<tr>
			<td bgcolor="cccccc"><b>Solvent</b></td>
			<td bgcolor="cccccc"><b>K<sub>f</sub> (<sup>o</sup>C mol kg<sup>-1</sup></b></td>
			<td bgcolor="cccccc"><b>Molar mass (g/mol)</b></td>
			<td bgcolor="cccccc"><b>Mass used (g)</b></td>
			<td bgcolor="cccccc"><b>Freezing Temperature (<sup>o</sup>C)</b></td>
		</tr>
		<tr>
			<td>$solvent[$solv][0]</td>
			<td>$solvent[$solv][1]</td>
			<td>$solvent[$solv][3]</td>
			<td>$mass_solv</td>
			<td>$melt_solv</td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="2"><b>Unknown compound</b></td>
			<td></td>
			<td>$mass_unk</td>
			<td bgcolor="black"></td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="4"><b>Mixture</b></td>
			<td>$melt_mix</td>
		</tr>
	</table><br>

	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<b>Choose a reagent to add</b>:<br>
	<input type="radio" name="reagent" value="solvent">$solvent[$solv][0]<br>
	<input type="radio" name="reagent" value="unknown">Unknown compound<br>
	<b>Choose a nominal mass to add</b>:<br>
	<input type="radio" name="mass" value="1">~1 g<br>
	<input type="radio" name="mass" value="2">~2 g<br>
	<input type="radio" name="mass" value="5">~5 g<br>
	<input type="radio" name="mass" value="10">~10 g<br>
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="mass_solv" value="$mass_solv">
	<input type="hidden" name="melt_solv" value="$melt_solv">
	<input type="hidden" name="mass_unk" value="$mass_unk">
	<input type="hidden" name="melt_mix" value="$melt_mix">
	<input type="hidden" name="control_1" value="add_reagent">
	<input type="submit" value="Add the reagent">
	</form>
	
	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="control_1" value="fresh">
	<input type="submit" value="Start Fresh">
	</form>
EOF

	if (($melt_mix ne '') and ($melt_solv ne '')) {
		print <<EOF;
	<hr>
	<form action="/~pfleming/cgi-bin/fpd.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Calculations</b></font></td>
		</tr>
		<tr>
			<td>&Delta;T</td> 
			<td><input name="dt"> <sup>o</sup>C</td>
		</tr>
		<tr>
			<td>Molality of Unknown</td>
			<td><input name="molality"> mol/kg</td>
		</tr>
		<tr>
			<td>Moles of Unknown</td>
			<td><input name="moles"> mol</td>
		</tr>
		<tr>
			<td>Molar Mass of Unknown</td>
			<td><input name="molar_mass"> g/mol</td>
		</tr>
	</table>
	<input type="hidden" name="solv" value="$solv">
	<input type="hidden" name="unk_mmass" value="$unk_mmass">
	<input type="hidden" name="mass_solv" value="$mass_solv">
	<input type="hidden" name="melt_solv" value="$melt_solv">
	<input type="hidden" name="mass_unk" value="$mass_unk">
	<input type="hidden" name="melt_mix" value="$melt_mix">
	<input type="hidden" name="control_1" value="grade">
	<input type="submit" value="Am I right?">
	<input type="reset" value="Clear Form">
	</form>
EOF
	}

} elsif ($flow eq 'grade') {
	# Read parameters
	my $solv = param('solv');
	my $unk_mmass = param('unk_mmass');
	my $mass_solv = param('mass_solv');
	my $melt_solv = param('melt_solv');
	my $mass_unk = param('mass_unk');
	my $melt_mix = param('melt_mix');
	my $DT = param('dt');
	my $molality = param('molality');
	my $moles = param('moles');
	my $molar_mass = param('molar_mass');
	
	# Grade the results
	my $response1 = "<font color=\"red\">You are incorrect.</font>";
	my $response2 = "<font color=\"red\">You are incorrect.</font>";
	my $response3 = "<font color=\"red\">You are incorrect.</font>";
	my $response4 = "<font color=\"red\">You are incorrect.</font>";
	
	my $ans1 = abs($melt_solv - $melt_mix);			# DT
	my $ans2 = $ans1 / $solvent[$solv][1];			# molality
	my $ans3 = $ans2 * $mass_solv / 1000;			# moles
	my $ans4 = $mass_unk / $ans3;					# molar mass
	
	if (abs($ans1 - $DT)/$ans1 <= 0.005) {
		$response1 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($ans2 - $molality)/$ans2 <= 0.005) {
		$response2 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($ans3 - $moles)/$ans3 <= 0.005) {
		$response3 = "<font color=\"green\">You are correct!</font>";
	}
	if (abs($ans4 - $molar_mass)/$ans4 <= 0.005) {
		$response4 = "<font color=\"green\">You are correct!</font>";
	}
	
	
	# Print Data Table
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="5" bgcolor="ccffcc"><font size="+1"><b>Centents of cell</b></font></td>
		</tr>
		<tr>
			<td bgcolor="cccccc"><b>Solvent</b></td>
			<td bgcolor="cccccc"><b>K<sub>f</sub> (<sup>o</sup>C mol kg<sup>-1</sup></b></td>
			<td bgcolor="cccccc"><b>Molar mass (g/mol)</b></td>
			<td bgcolor="cccccc"><b>Mass used (g)</b></td>
			<td bgcolor="cccccc"><b>Freezing Temperature (<sup>o</sup>C)</b></td>
		</tr>
		<tr>
			<td>$solvent[$solv][0]</td>
			<td>$solvent[$solv][1]</td>
			<td>$solvent[$solv][3]</td>
			<td>$mass_solv</td>
			<td>$melt_solv</td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="2"><b>Unknown compound</b></td>
			<td></td>
			<td>$mass_unk</td>
			<td bgcolor="black"></td>
		</tr>
		<tr>
			<td bgcolor="cccccc" colspan="4"><b>Mixture</b></td>
			<td>$melt_mix</td>
		</tr>
	</table><br>

	<hr>
	<table border="2" cellpadding="3">
		<tr>
			<td colspan="3" bgcolor="ffcccc"><font size="+1"><b>Results</b></font></td>
		</tr>
		<tr>
			<td>&Delta;T</td> 
			<td>$DT <sup>o</sup>C</td>
			<td>$response1</td>
		</tr>
		<tr>
			<td>Molality of Unknown</td>
			<td>$molality mol/kg</td>
			<td>$response2</td>
		</tr>
		<tr>
			<td>Moles of Unknown</td>
			<td>$moles mol</td>
			<td>$response3</td>
		</tr>
		<tr>
			<td>Molar Mass of Unknown</td>
			<td>$molar_mass g/mol</td>
			<td>$response4</td>
		</tr>
	</table>

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
	my ($max, $min) = @_;
	my $value = rand(1) * ($max - $min) + $min;
	return $value;
}
