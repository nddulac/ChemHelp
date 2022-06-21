#!/usr/bin/perl -wT

# A Virtual Lab: Kinetics to Dye For
# Patrick E. Fleming
# California State University, East Bay
# December 1, 2020 

# this virtual kinetics lab is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part
my $i = 0;							# looping variable

# Begin html output
print header;
print start_html("Decomposition of Dye");
print "<h1>Decomposition of Dye</h1>\n";

if ($flow eq 'begin') {
	# Set initial parameters
	my $Dye_conc = 0;		# %
	my $bleach_conc = 0;	# %
	my $vol_tot = 0;		# mL
	my $rate_const = random_value(0.00012, 0.00023); # %-1 s-1
	
	# Now get input
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Contents of your large test tube</b></font></td>
		</tr>
		<tr>
			<td>Dye Concentration (% of stock concentration)</td> 
			<td>$Dye_conc %</td>
		</tr>
		<tr>
			<td>Bleach Concentration (% of stock concentration)</td>
			<td>$bleach_conc %</td>
		</tr>
		<tr>
			<td>Volume</td>
			<td>$vol_tot mL</td>
		</tr>
	</table>

	<form action="/~pfleming/cgi-bin/dye_kinetics.pl" method="post">
		<!-- List reagents here -->
		<h3>Select your regent</h3>
		<input type="radio" name="reagent" value="fresh">Start with a clean test tube<br>
		<input type="radio" name="reagent" value="water">water<br>
		<input type="radio" name="reagent" value="Stock Dye">Stock Dye Solution (100%)<br>
		<input type="radio" name="reagent" value="Stock Bleach">Stock Bleach Solution (100 %)<br>
		<!-- List glassware here -->
		<h3>Select your pipet</h3>
		<input type="radio" name="pipet" value="1">1.00 mL<br>
		<input type="radio" name="pipet" value="2">2.00 mL<br>
		<input type="radio" name="pipet" value="5">5.00 mL<br>
		<input type="radio" name="pipet" value="10">10.00 mL<br>
		<input type="radio" name="pipet" value="20">20.00 mL<br>
		<input type="hidden" name="Dye_conc" value="$Dye_conc">
		<input type="hidden" name="bleach_conc" value="$bleach_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="rate_const" value="$rate_const">
		<input type="hidden" name="control_1" value="add_reagent">
		<input type="submit" value="Add the reagent">
		<input type="reset" value="Reset my choices">
	</form>
	<p><form action="/~pfleming/cgi-bin/dye_kinetics.pl" method="post">
		<input type="hidden" name="Dye_conc" value="$Dye_conc">
		<input type="hidden" name="bleach_conc" value="$bleach_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="rate_const" value="$rate_const">
		<input type="hidden" name="control_1" value="measure">
		<input type="submit" value="Measure the absorbance!">
	</form></p>
EOF

} elsif ($flow eq 'add_reagent') {
	# read parameters from form
	my $Dye_conc = param('Dye_conc');
	my $bleach_conc = param('bleach_conc');
	my $vol_tot = param('vol_tot');
	my $rate_const = param('rate_const');
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
		$Dye_conc = 0;
		$bleach_conc = 0;
		$vol_tot = 0;
	}

	if (($pipet ne '') and ($reagent ne '')) {
		if ($reagent eq 'water') {
			$Dye_conc = ($Dye_conc * $vol_tot) / ($vol_tot + $pipet);
			$bleach_conc = ($bleach_conc * $vol_tot) / ($vol_tot + $pipet);
		} elsif ($reagent eq 'Stock Dye') {
			$Dye_conc = ($Dye_conc * $vol_tot + 100 * $pipet) / ($vol_tot + $pipet);
			$bleach_conc = ($bleach_conc * $vol_tot) / ($vol_tot + $pipet);
		} elsif ($reagent eq 'Stock Bleach') {
			$Dye_conc = ($Dye_conc * $vol_tot) / ($vol_tot + $pipet);
			$bleach_conc = ($bleach_conc * $vol_tot + 100 * $pipet) / ($vol_tot + $pipet);
		}
		$vol_tot = sprintf("%.2f", $vol_tot + $pipet);
	}
	
	my $Dye_report = sprintf("%.2f", $Dye_conc);
	my $bleach_report = sprintf("%.2f", $bleach_conc);
	
	# Add more reagents!
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Contents of your large test tube</b></font></td>
		</tr>
		<tr>
			<td>Dye Concentration (% of stock concentration)</td> 
			<td>$Dye_report %</td>
		</tr>
		<tr>
			<td>Bleach Concentration (% of stock concentration)</td>
			<td>$bleach_report %</td>
		</tr>
		<tr>
			<td>Volume</td>
			<td>$vol_tot mL</td>
		</tr>
	</table>

	<form action="/~pfleming/cgi-bin/dye_kinetics.pl" method="post">
		<!-- List reagents here -->
		<h3>Select your regent</h3>
		<input type="radio" name="reagent" value="fresh">Start with a clean test tube<br>
		<input type="radio" name="reagent" value="water">water<br>
		<input type="radio" name="reagent" value="Stock Dye">Stock Dye Solution (100%)<br>
		<input type="radio" name="reagent" value="Stock Bleach">Stock Bleach Solution (100 %)<br>
		<!-- List glassware here -->
		<h3>Select your pipet</h3>
		<input type="radio" name="pipet" value="1">1.00 mL<br>
		<input type="radio" name="pipet" value="2">2.00 mL<br>
		<input type="radio" name="pipet" value="5">5.00 mL<br>
		<input type="radio" name="pipet" value="10">10.00 mL<br>
		<input type="radio" name="pipet" value="20">20.00 mL<br>
		<input type="hidden" name="Dye_conc" value="$Dye_conc">
		<input type="hidden" name="bleach_conc" value="$bleach_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="rate_const" value="$rate_const">
		<input type="hidden" name="control_1" value="add_reagent">
		<input type="submit" value="Add the reagent">
		<input type="reset" value="Reset my choices">
	</form>
	<p><form action="/~pfleming/cgi-bin/dye_kinetics.pl" method="post">
		<input type="hidden" name="Dye_conc" value="$Dye_conc">
		<input type="hidden" name="bleach_conc" value="$bleach_conc">
		<input type="hidden" name="vol_tot" value="$vol_tot">
		<input type="hidden" name="rate_const" value="$rate_const">
		<input type="hidden" name="control_1" value="measure">
		<input type="submit" value="Measure the absorbance!">
	</form></p>
EOF

} elsif ($flow eq 'measure') {
	# Read the parameters
	my $Dye_conc = param('Dye_conc');
	my $bleach_conc = param('bleach_conc');
	my $vol_tot = param('vol_tot');
	my $rate_const = param('rate_const');

	my $Dye_report = sprintf("%.6f", $Dye_conc);
	my $bleach_report = sprintf("%.6f", $bleach_conc);
	
	# Calculate concentration as a function of time
	# Let's calculate the concentrations after each 5 seconds for five minutes, 
	# skipping a randome portion of the first 20 seconds.
	my $time_skip = random_value(20, 10);
	my $Abs = 0;
	print "<table border=\"2\">\n";
	print "  <tr>\n";
	print "    <td>Time (sec)</td>  <td>Absorbance</td>\n";
	print "  </tr>\n";
	for ($i = 0; $i <= 300; $i += 5) {
		if ($i >= $time_skip) {
			print "  <tr>\n";
			print "    <td>$i</td> ";
			$Abs = sprintf("%.3f", ($Dye_conc/ 100) * exp(-$rate_const * $bleach_conc * $i));
			print "<td>$Abs</td>\n";
			print "  </tr>\n";
		}
	}
	print "</table><hr>\n";
	
	# Add a form to set up a fresh run with the same rate constant!
	print <<EOF;
	<p><form action="/~pfleming/cgi-bin/dye_kinetics.pl" method="post">
		<input type="hidden" name="Dye_conc" value="0">
		<input type="hidden" name="bleach_conc" value="0">
		<input type="hidden" name="vol_tot" value="0">
		<input type="hidden" name="rate_const" value="$rate_const">
		<input type="hidden" name="reagent" value=" ">
		<input type="hidden" name="pipet" value=" ">
		<input type="hidden" name="control_1" value="add_reagent">
		<input type="submit" value="Start again with a fresh sample">
	</form></p>
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

