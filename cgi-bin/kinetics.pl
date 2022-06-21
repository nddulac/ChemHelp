#!/usr/bin/perl -wT

# A Virtual Lab: The Rate of Iodination of Acetone
# Patrick E. Fleming
# California State University, East Bay
# July 6, 2020 

# this virtual kinetics is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part
my $i = 0;							# looping variable

# Som global parameters
my $e_I2 = 746;											# M-1 cm-1 at 430 nm
my $Ace_stock = 4.0;									# M
my $I2_stock = 0.0050; 									# M
my $HCl_stock = 1.0;									# M

# The rate law is given by
#  rate = k[accetone][H+]
# The absorbance is given by A = $e_I2 * [I2] * 1 cm

# Begin html output
print header;
print start_html("Rate of Iodination of Acetone");
print "<h1>Rate of Iodination of Acetone</h1>";

if ($flow eq 'begin') {
	my $rate_constant = random_value(1.1, 0.9) * 2.32e-5;	# M-1 s-1
	print <<EOF;
	<h2>Initial Volumes</h2>
	<p>Select the initial volumes of each reagent:</p>
	<form action="/~pfleming/cgi-bin/kinetics.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td>Acetone (4.0 M)</td>
			<td>I<sub>2</sub> (0.0050 M)</td>
			<td>HCl (1.0 M)</td>
			<td>water</td>
			<td>Time (sec)</td>
		</tr>
		<tr>
			<td><input name="Ace_vol"> mL</td>
			<td><input name="I2_vol"> mL</td>
			<td><input name="HCl_vol"> mL</td>
			<td><input name="H2O_vol"> mL</td>
			<td><input name="time"> sec</td>
		</tr>
	</table>
	<input type="hidden" name="rate_constant" value="$rate_constant">
	<input type="hidden" name="control_1" value="run">
	<input type="submit" value="Get the data!">
	<input type="reset" value="Clear the form">
	</form>
EOF

} elsif ($flow eq 'run') {
	# let's do a run based on inputs!
	my $rate_constant = param('rate_constant');
	my $Ace_vol = param('Ace_vol');
	my $I2_vol = param('I2_vol');
	my $HCl_vol = param('HCl_vol');
	my $H2O_vol = param('H2O_vol');
	my $time = param('time');
	
	# Calculate volume and initial concentrations
	my $total_vol = $Ace_vol + $I2_vol + $HCl_vol + $H2O_vol;
	my $Ace_conc = sprintf("%.3f", $Ace_vol * $Ace_stock / $total_vol);
	my $I2_conc = sprintf("%.5f", $I2_vol * $I2_stock / $total_vol);
	my $HCl_conc = sprintf("%.3f", $HCl_vol * $HCl_stock / $total_vol);
	
	print "<h2>Results of Run</h2>\n";
	print "[Acetone]<sub>0</sub> = $Ace_conc M<br>\n";
	print "[I<sub>2</sub>]<sub>0</sub> = $I2_conc M<br>\n";
	print "[HCl]<sub>0</sub> = $HCl_conc M<br><br>\n";
	
	print "<table border=\"2\" cellpadding=\"2\">\n";
	print "	<tr>\n";
	print "		<td>Time (sec)</td> <td>Absorbance</td>\n";
	print "	</tr>\n";
	
	# Add a random delay to get the reaction mixture into the spectrometer
	my $delay = int(random_value(20, 10));

	# Now calculate concentration each second for 300 seconds
	for ($i; $i <= $time; $i += 1) {
		my $Abs = sprintf("%.3f", $e_I2 * $I2_conc);
		if ($i > $delay) {
			print "	<tr>\n";
			print "		<td>$i</td> <td>$Abs</td>\n";
			print "	</tr>\n";
		}
		# Now calculate the new absorbance
		my $delta_conc = $rate_constant * $Ace_conc * $HCl_conc;
		$Ace_conc = $Ace_conc - $delta_conc;
		$I2_conc = $I2_conc - $delta_conc;
		$HCl_conc = $HCl_conc - $delta_conc;
		if ($Ace_conc < 0) {
			$Ace_conc = 0;
		}
		if ($I2_conc < 0) {
			$I2_conc = 0;
		}
		if ($HCl_conc < 0) {
			$HCl_conc = 0;
		}
	}
	print "</table><br><br>\n";

	print <<EOF;
	<h2>Perfom Another Run</h2>
	<p>Select the initial volumes of each reagent:</p>
	<form action="/~pfleming/cgi-bin/kinetics.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td>Acetone (4.0 M)</td>
			<td>I<sub>2</sub> (0.0050 M)</td>
			<td>HCl (1.0 M)</td>
			<td>water</td>
			<td>Time</td>
		</tr>
		<tr>
			<td><input name="Ace_vol" value="$Ace_vol"> mL</td>
			<td><input name="I2_vol" value="$I2_vol"> mL</td>
			<td><input name="HCl_vol" value="$HCl_vol"> mL</td>
			<td><input name="H2O_vol" value="$H2O_vol"> mL</td>
			<td><input name="time" value="$time"> sec</td>
		</tr>
	</table>
	<input type="hidden" name="rate_constant" value="$rate_constant">
	<input type="hidden" name="control_1" value="run">
	<input type="submit" value="Get the data!">
	<input type="reset" value="Clear the form">
	</form>
EOF
	
	print "<table>\n";

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

