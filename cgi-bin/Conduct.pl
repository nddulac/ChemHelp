#!/usr/bin/perl -wT

# A Virtual Lab: Conductometric Titration
# Patrick E. Fleming
# California State University, East Bay
# May 30, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');					# Determines part
my $i = 0;										# looping variable

# Begin html output
print header;
print start_html("Virtual Conductometric Titration Lab");
print "<h1>Virtual Conductometric Lab</h1>\n";

if ($flow eq 'generate') {
	# Set random parameters
	my $conc_acid = sprintf("%.4f", rand(1) * 0.001 + 0.02);
	my $conc_base = sprintf("%.4f", rand(1) * 0.02 + 0.025);
	my $vol_base = sprintf("%.2f", 5.0);
	my $vol_acid = sprintf("%.2f", 0.0);
	my $cond = Conductivity($conc_acid, $vol_acid, $conc_base, $vol_base);
	print <<EOF;
	<form action="/~pfleming/cgi-bin/Conduct.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td>The conductivity is:</td> <td>$cond S/m</td>
		</tr>
		<tr>
			<td>Volume of base used:</td> <td>$vol_base mL</td>
		</tr>
		<tr>
			<td>Volume of acid added so far:</td> <td>$vol_acid mL</td>
		</tr>
		<tr>
			<td>Acid concentration:</td> <td>$conc_acid M</td>
		</tr>
		<tr>
			<td>How many mL of acid do you wish to add?</td> <td><input name="vol_acid_added"> mL</td>
		</tr>
		<tr>
			<td><input type="radio" name="control_1" value="continue" checked>Add the acid<br>
			    <input type="radio" name="control_1" value="finish">Finish and filter BaSO<sub>4</sub></td> 
			<td><align="center"><input type="submit" value="Continue"></td>
		</tr>
	</table>
	<input type="hidden" name="conc_acid" value="$conc_acid">
	<input type="hidden" name="conc_base" value="$conc_base">
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	</form>
EOF
} elsif ($flow eq 'continue') {
	#parse input
	my $conc_acid = param('conc_acid');
	my $conc_base = param('conc_base');
	my $vol_acid = sprintf("%.2f", param('vol_acid') + param('vol_acid_added'));
	my $vol_base = sprintf("%.2f", param('vol_base'));
	my $cond = Conductivity($conc_acid, $vol_acid, $conc_base, $vol_base);
	print <<EOF;
	<form action="/~pfleming/cgi-bin/Conduct.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td>The conductivity is:</td> <td>$cond S/m</td>
		</tr>
		<tr>
			<td>Volume of base used:</td> <td>$vol_base mL</td>
		</tr>
		<tr>
			<td>Volume of acid added so far:</td> <td>$vol_acid mL</td>
		</tr>
		<tr>
			<td>Acid concentration:</td> <td>$conc_acid M</td>
		</tr>
		<tr>
			<td>How many mL of acid do you wish to add?</td> <td><input name="vol_acid_added"> mL</td>
		</tr>
		<tr>
			<td><input type="radio" name="control_1" value="continue" checked>Add the acid<br>
			    <input type="radio" name="control_1" value="finish">Finish and filter BaSO<sub>4</sub></td> 
			<td><align="center"><input type="submit" value="Continue"></td>
		</tr>
	</table>
	<input type="hidden" name="conc_acid" value="$conc_acid">
	<input type="hidden" name="conc_base" value="$conc_base">
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	</form>
EOF
} elsif ($flow eq 'finish') {
	# Read inputs
	my $conc_acid = param('conc_acid');
	my $conc_base = param('conc_base');
	my $vol_acid = sprintf("%.2f", param('vol_acid'));
	my $vol_base = sprintf("%.2f", param('vol_base'));
	my $mass = 0;
	if ($conc_acid * $vol_acid < $conc_base * $vol_base) {
		# under titrated, so mass of BaSO4 is limited by acid
		my $mol_baso4 = $conc_acid * $vol_acid;
		$mass = $mol_baso4 * 233.38;
	} else {
		# over (or perfectly) titrated, so mass of BaSO4 is determined by base
		my $mol_baso4 = $conc_base * $vol_base;
		$mass = sprintf("%.4f", $mol_baso4 * 233.38 / 1000);
	}
	my $filter = sprintf("%.4f", (rand(1)*0.06 - 0.03) + 0.95);
	my $filter_full = $filter + $mass;
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Filtration Data</b></font></td>
		</tr>
		<tr>
			<td>Volume of base used:</td> <td>$vol_base mL</td>
		</tr>
		<tr>
			<td>Volume of acid used:</td> <td>$vol_acid mL</td>
		</tr>
		<tr>
			<td>Acid concentration:</td> <td>$conc_acid M</td>
		</tr>
		<tr>
			<td>Mass of filter paper:</td> <td>$filter g</td>
		</tr>
		<tr>
			<td>Mass of filter paper + dry BaSO<sub>4</sub>:</td> <td>$filter_full g</td>
		</tr>
	</table>
	<hr>
	<form action="/~pfleming/cgi-bin/Conduct.pl">
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Your Results</b></font></td>
		</tr>
		<tr>
			<td>[Ba(OH)<sub>2</sub>] based on titration</td> 
			<td><input name="conc_tit"> M</td>
		</tr>
		<tr>
			<td>[Ba(OH)<sub>2</sub>] based mass of BaSO<sub>4</sub> collected</td>
			<td><input name="conc_mass"> M</td>
		</tr>
	</table>
	<input type="hidden" name="conc_base" value="$conc_base">
	<input type="hidden" name="control_1" value="check">
	<input type="submit" value="Am I right?">
	</form>
	
EOF
} elsif ($flow eq 'check') {
	# read params
	my $conc_base = param('conc_base');
	my $conc_tit = param('conc_tit');
	my $conc_mass = param('conc_mass');
	my $tit_result = "You are not within 5%";
	my $mass_result = "You are not within 5%";
	if (abs($conc_tit - $conc_base)/$conc_base < 0.05) {
		$tit_result = "You are correct within 5%";
	}
	if (abs($conc_mass - $conc_base)/$conc_base < 0.05) {
		$mass_result = "You are correct within 5%";
	}
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ffcccc" colspan="3"><font size="+1"><b>Results</b></font></td>
		</tr>
		<tr>
			<td>[Ba(OH)<sub>2</sub>] based on conductivity titration</td> 
			<td>$conc_tit M</td>
			<td>$tit_result</td>
		</tr>
		<tr>
			<td>[Ba(OH)<sub>2</sub>] based mass of BaSO<sub>4</sub> collected</td>
			<td>$conc_mass M</td>
			<td>$mass_result</td>
		</tr>
	</table>
EOF
	if ($tit_result eq $mass_result and $tit_result eq 'You are correct within 5%') {
		print "The correct concentration of BaSO<sub>4</sub> was $conc_base M.\n";
	}
} else {
	print "No Part Specified!";

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

sub Conductivity {
	my $ cacid = $_[0];
	my $ vacid = $_[1];
	my $ cbase = $_[2];
	my $ vbase = $_[3];
	my $ion_conc = abs($cacid * $vacid - $cbase * $vbase);
	if ($cacid * $vacid < $cbase * $vbase) {
		$ion_conc = $ion_conc / 1.4;
	}
	return (sprintf("%.1f", $ion_conc * 5000 + (rand(10)-5)));
}

