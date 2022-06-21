#!/usr/bin/perl -wT

# A Virtual Lab: Determination of an Equilibrium Constant
# Patrick E. Fleming
# California State University, East Bay
# July 8, 2020 

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
my $e447 = 6120;					# M-1 cm-1

# Begin html output
print header;
print start_html("Determination of an Equilibrium Constant");
print "<h1>Determination of an Equilibrium Constant</h1>\n";

if ($flow eq 'begin') {
	# Set initial parameters
	my $Fe_conc = 0;		# M
	my $SCN_conc = 0;		# M
	my $vol_tot = 0;		# mL
	my $Keq = random_value(460, 390);
	
	# Now get input
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Contents of your large test tube</b></font></td>
		</tr>
		<tr>
			<td>[Fe<sup>3+</sup>]<sub>0</sub></td> 
			<td>$Fe_conc M</td>
		</tr>
		<tr>
			<td>[SCN<sup>-</sup>]<sub>0</sub></td>
			<td>$SCN_conc M</td>
		</tr>
		<tr>
			<td>Volume</td>
			<td>$vol_tot mL</td>
		</tr>
	</table>

	<form action="/~pfleming/cgi-bin/equilibrium.pl" method="post">
		<!-- List reagents here -->
		<h3>Select your regent</h3>
		<input type="radio" name="reagent" value="fresh">Start with a clean test tube<br>
		<input type="radio" name="reagent" value="water">water<br>
		<input type="radio" name="reagent" value="0.002 M SCN">0.00200 M KSCN<br>
		<input type="radio" name="reagent" value="0.002 M Fe">0.00200 M Fe(NO<sub>3</sub>)<sub>3</sub><br>
		<input type="radio" name="reagent" value="0.200 M Fe">0.200 M Fe(NO<sub>3</sub>)<sub>3</sub><br>
		<!-- List glassware here -->
		<h3>Select your pipet</h3>
		<input type="radio" name="pipet" value="1">1.00 mL<br>
		<input type="radio" name="pipet" value="2">2.00 mL<br>
		<input type="radio" name="pipet" value="5">5.00 mL<br>
		<input type="radio" name="pipet" value="10">10.00 mL<br>
		<input type="radio" name="pipet" value="20">20.00 mL<br>
		<input type="hidden" name="Fe_conc" value="$Fe_conc">
		<input type="hidden" name="SCN_conc" value="SCN_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="Keq" value="$Keq">
		<input type="hidden" name="control_1" value="add_reagent">
		<input type="submit" value="Add the reagent">
		<input type="reset" value="Reset my choices">
	</form>
	<p><form action="/~pfleming/cgi-bin/equilibrium.pl" method="post">
		<input type="hidden" name="Fe_conc" value="$Fe_conc">
		<input type="hidden" name="SCN_conc" value="SCN_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="Keq" value="$Keq">
		<input type="hidden" name="control_1" value="measure">
		<input type="submit" value="Measure the absorbance!">
	</form></p>
EOF

} elsif ($flow eq 'add_reagent') {
	# read parameters from form
	my $Fe_conc = param('Fe_conc');
	my $SCN_conc = param('SCN_conc');
	my $vol_tot = param('vol_tot');
	my $Keq = param('Keq');
	my $reagent = param('reagent');
	my $pipet = param('pipet');
	
	# Now, a descision tree based on the input values
	if ($vol_tot + $pipet > 40) {
		print "<font color=\"red\">You have over-filled your test tube and made a mess!<br>You must start with a fresh test tube.</font><br>\n";
		$reagent = 'fresh';
		$pipet = '';
	}
	if ($reagent eq '') {
		print "<font color=\"red\">You must select a reagent!</font><br>\n";
	}
	if (($pipet eq '') and ($reagent ne 'fresh')) {
		print "<font color=\"red\">You must select a pipet!</font><br>\n";
	} 
	if ($reagent eq 'fresh') {
		$Fe_conc = 0;
		$SCN_conc = 0;
		$vol_tot = 0;
	}

	if (($pipet ne '') and ($reagent ne '')) {
		if ($reagent eq 'water') {
			$Fe_conc = ($Fe_conc * $vol_tot) / ($vol_tot + $pipet);
			$SCN_conc = ($SCN_conc * $vol_tot) / ($vol_tot + $pipet);
			$vol_tot = sprintf("%.2f", $vol_tot + $pipet);
		} elsif ($reagent eq '0.002 M SCN') {
			$Fe_conc = ($Fe_conc * $vol_tot) / ($vol_tot + $pipet);
			$SCN_conc = ($SCN_conc * $vol_tot + 0.002 * $pipet) / ($vol_tot + $pipet);
			$vol_tot = sprintf("%.2f", $vol_tot + $pipet);
		} elsif ($reagent eq '0.002 M Fe') {
			$Fe_conc = ($Fe_conc * $vol_tot + 0.002 * $pipet) / ($vol_tot + $pipet);
			$SCN_conc = ($SCN_conc * $vol_tot) / ($vol_tot + $pipet);
			$vol_tot = sprintf("%.2f", $vol_tot + $pipet);
		} elsif ($reagent eq '0.200 M Fe') {
			$Fe_conc = ($Fe_conc * $vol_tot + 0.200 * $pipet) / ($vol_tot + $pipet);
			$SCN_conc = ($SCN_conc * $vol_tot) / ($vol_tot + $pipet);
			$vol_tot = sprintf("%.2f", $vol_tot + $pipet);
		}
	}
	
	my $Fe_report = sprintf("%.6f", $Fe_conc);
	my $SCN_report = sprintf("%.6f", $SCN_conc);
	
	# Add more reagents!
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Contents of your large test tube</b></font></td>
		</tr>
		<tr>
			<td>[Fe<sup>3+</sup>]<sub>0</sub></td> 
			<td>$Fe_report M</td>
		</tr>
		<tr>
			<td>[SCN<sup>-</sup>]<sub>0</sub></td>
			<td>$SCN_report M</td>
		</tr>
		<tr>
			<td>Volume</td>
			<td>$vol_tot mL</td>
		</tr>
	</table>

	<form action="/~pfleming/cgi-bin/equilibrium.pl" method="post">
		<!-- List reagents here -->
		<h3>Select your regent</h3>
		<input type="radio" name="reagent" value="fresh">Start with a clean test tube<br>
		<input type="radio" name="reagent" value="water">water<br>
		<input type="radio" name="reagent" value="0.002 M SCN">0.00200 M KSCN<br>
		<input type="radio" name="reagent" value="0.002 M Fe">0.00200 M Fe(NO<sub>3</sub>)<sub>3</sub><br>
		<input type="radio" name="reagent" value="0.200 M Fe">0.200 M Fe(NO<sub>3</sub>)<sub>3</sub><br>
		<!-- List glassware here -->
		<h3>Select your pipet</h3>
		<input type="radio" name="pipet" value="1">1.00 mL<br>
		<input type="radio" name="pipet" value="2">2.00 mL<br>
		<input type="radio" name="pipet" value="5">5.00 mL<br>
		<input type="radio" name="pipet" value="10">10.00 mL<br>
		<input type="radio" name="pipet" value="20">20.00 mL<br>
		<input type="hidden" name="Fe_conc" value="$Fe_conc">
		<input type="hidden" name="SCN_conc" value="$SCN_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="Keq" value="$Keq">
		<input type="hidden" name="control_1" value="add_reagent">
		<input type="submit" value="Add the reagent">
		<input type="reset" value="Reset my choices">
	</form>

	<p><form action="/~pfleming/cgi-bin/equilibrium.pl" method="post">
		<input type="hidden" name="Fe_conc" value="$Fe_conc">
		<input type="hidden" name="SCN_conc" value="$SCN_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="Keq" value="$Keq">
		<input type="hidden" name="control_1" value="measure">
		<input type="submit" value="Measure the absorbance!">
	</form></p>
EOF

} elsif ($flow eq 'measure') {
	# Read the parameters
	my $Fe_conc = param('Fe_conc');
	my $SCN_conc = param('SCN_conc');
	my $vol_tot = param('vol_tot');
	my $Keq = param('Keq');

	my $Fe_report = sprintf("%.6f", $Fe_conc);
	my $SCN_report = sprintf("%.6f", $SCN_conc);
	
	# Calculate the [FeSCN2+] concentration
	# First, find a, b, and c for the quadratic equation
	my $a = 1;
	my $b = -($Fe_conc + $SCN_conc + 1 / $Keq);
	my $c = $Fe_conc * $SCN_conc;
	
	# Now call the quadratic equation subroutine to find the roots
	my @x = quadratic($a, $b, $c);
	my $A = sprintf("%.3f", $e447 * $x[1]);
	# Allow for non-linear response above an absorbance of 1.2
	if ($A > 1.2) {
		$A = sprintf("%.3f", 1.2 + 0.5 * (1 - exp(-(($x[1] - 0.00028)/0.0005))))
	}
	
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Contents of your large test tube</b></font></td>
		</tr>
		<tr>
			<td>[Fe<sup>3+</sup>]<sub>0</sub></td> 
			<td>$Fe_report M</td>
		</tr>
		<tr>
			<td>[SCN<sup>-</sup>]<sub>0</sub></td>
			<td>$SCN_report M</td>
		</tr>
		<tr>
			<td>Volume</td>
			<td>$vol_tot mL</td>
		</tr>
		<tr>
			<td colspan="2">Absorbance = $A</td>
		</tr>
	</table>
	<form action="/~pfleming/cgi-bin/equilibrium.pl" method="post">
		<input type="hidden" name="control_1" value="begin">
		<input type="submit" value="Prepare another sample!">
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
	my ($max, $min) = @_;
	my $value = rand(1) * ($max - $min) + $min;
	return $value;
}

sub quadratic {
	my ($a, $b, $c) = @_;
	my @x = (0, 0);
	my $root = sqrt($b**2 - 4*$a*$c);
	$x[0] = (-$b + $root) / (2*$a);
	$x[1] = (-$b - $root) / (2*$a);
	return @x;
}

