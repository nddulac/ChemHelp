#!/usr/bin/perl -wT

# A Virtual Lab: Light and Spectroscopy
# Patrick E. Fleming
# California State University, East Bay
# April 3, 2021 

# this virtual spectroscopy lab is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part
my $i = 0;							# looping variable

# Some global parameters
my @dye_data = (['yellow', 428, 0.911,  0.212,  0,      0,      0],
	            ['orange', 482, 0.393,  0.902,  0.786,  0.0207, 0],
	            ['red'   , 506, 0.297,  0.717,  0.830,  0.363,  0.0273],
	            ['violet', 555, 0.0269, 0.0496, 0.198,  0.792,  0.150],
	            ['blue',   631, 0.0315, 0.0327, 0.0655, 0.273,  0.979],
	            ['green',  631, 0,      0,      0.0357, 0.138,  0.829]);
my @lambda = (428, 482, 506, 555, 631);

# Begin html output
print header;
print start_html("Light and Spectroscopy");
print "<h1>Light and Spectroscopy</h1>\n";

if ($flow eq 'PartA') {
    #Parse the input
    my $dye = param('dye');
    
	print "<h2>Part A - Light and Color</h2>\n";
	if ($dye ne '') {
		print "<h3> Dye color: $dye</h3>\n";
		print "<img src=\"/~pfleming/chem/light/$dye.png\"><hr>\n";
	}
	print <<EOF;
	<form action="/~pfleming/cgi-bin/light.pl" method="post">
	Choose a dye solution to measure:<br>
	<input type="radio" name="dye" value="red">Red<br>
	<input type="radio" name="dye" value="orange">Orange<br>
	<input type="radio" name="dye" value="yellow">Yellow<br>
	<input type="radio" name="dye" value="green">Green<br>
	<input type="radio" name="dye" value="blue">Blue<br>
	<input type="radio" name="dye" value="violet">Violet<br>
    <input type="submit" value="Let's see the spectrum!">
    <input type="hidden" name="control_1" value="PartA">
	</form>
EOF

} elsif ($flow eq 'PartB') {
	my $dye = param('dye');
	my $lmax = param('lmax');
	my $measure = param('measure');
	my $water = param('water');
	my $solut = param('solut');
	
	print "<h2>Part B - Beer's Law</h2>\n";
	# If no dye is passed, choose an unnkown solution for the student
	if ($dye eq '') {
		# choose a dye
		$dye = int(random_value(5,0) + 0.5);
		print "Your unknown solution is $dye_data[$dye][0].<br>\n";
		if ($lmax ne '') {
			print "Your spectrometer is set to measure Abs at $lambda[$lmax] nm.<br>\n"; 
		}
		print "<hr>\n";
		
		# Have the student choose a lambda_max
		print <<EOF;
    Choose a value of &lambda;<sub>max</sub> at which to measure your absorbances.
	<form action="/~pfleming/cgi-bin/light.pl" method="post">
		<input type="radio" name="lmax" checked value="0">428 nm<br>
		<input type="radio" name="lmax" value="1">482 nm<br>
		<input type="radio" name="lmax" value="2">506 nm<br>
		<input type="radio" name="lmax" value="3">555 nm<br>
		<input type="radio" name="lmax" value="4">631 nm<br>
		<input type="hidden" name="dye" value="$dye">
		<input type="hidden" name="control_1" value="PartB2">
		<input type="submit" value="Continue with Part B">
	</form>
EOF
	}
	
} elsif ($flow eq 'PartB2') {
	# Parse the input 
	my $dye = param('dye');
	my $lmax = param('lmax');
	my $measure = param('measure');
	my $water = param('water');
	my $solut = param('solut');
	
	print "Your unknown solution is $dye_data[$dye][0].<br>\n";
	print "Your &lambda;<sub>max</sub> is set to $lambda[$lmax] nm.<br><br>\n";
	if ($measure eq 'yes') {
		# measure the absorbance
		if ($solut + $water == 0) {
			print "Nothing to measure!<br>\n";
		} else {
			my $conc = sprintf("%.2f", $solut/($solut + $water) * 100);
			my $eps = $lmax + 2;
			my $Abs = sprintf("%.3f", $dye_data[$dye][$eps] * $conc / 100);
			print <<EOF;
	Your concentration is $conc%.<br>
	Your measured absorbance is $Abs.<br>
	<form action="/~pfleming/cgi-bin/light.pl" method="post">
		<input type="hidden" name="dye" value="$dye">
		<input type="hidden" name="lmax" value="$lmax">
		<input type="hidden" name="control_1" value="PartB2">
		<input type="submit" value="Continue with Part B">
	</form>
EOF
		}
	} else { 
		#create the solution to measure
		print <<EOF;
	<form action="/~pfleming/cgi-bin/light.pl" method="post">
		<table border="2" cellpadding="2">
			<tr>
				<td>Select a volume of water to add to sample:</td>
				<td>Select a volume of dye solution to add to sample:</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="0" checked> 0 mL</td>
				<td><input type="radio" name="solut" value="0" checked> 0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="1"> 1.0 mL</td>
				<td><input type="radio" name="solut" value="1"> 1.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="2"> 2.0 mL</td>
				<td><input type="radio" name="solut" value="2"> 2.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="3"> 3.0 mL</td>
				<td><input type="radio" name="solut" value="3"> 3.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="4"> 4.0 mL</td>
				<td><input type="radio" name="solut" value="4"> 4.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="5"> 5.0 mL</td>
				<td><input type="radio" name="solut" value="5"> 5.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="6"> 6.0 mL</td>
				<td><input type="radio" name="solut" value="6"> 6.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="7"> 7.0 mL</td>
				<td><input type="radio" name="solut" value="7"> 7.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="8"> 8.0 mL</td>
				<td><input type="radio" name="solut" value="8"> 8.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="9"> 9.0 mL</td>
				<td><input type="radio" name="solut" value="9"> 9.0 mL</td>
			</tr>
			<tr>
				<td><input type="radio" name="water" value="10"> 10.0 mL</td>
				<td><input type="radio" name="solut" value="10"> 10.0 mL</td>
			</tr>
		</table><br>
		<input type="hidden" name="dye" value="$dye">
		<input type="hidden" name="lmax" value="$lmax">
		<input type="hidden" name="measure" value="yes">
		<input type="hidden" name="control_1" value="PartB2">
		<input type="submit" value="Measure the solution!">
	</form>
	<hr>
	<form action="/~pfleming/cgi-bin/light.pl" method="post">
		<input type="hidden" name="dye" value="$dye">
		<input type="hidden" name="lmax" value="$lmax">
		<input type="hidden" name="measure" value="yes">
		<input type="hidden" name="control_1" value="PartB3">
		<input type="submit" value="Measure the unknown solution!">
	</form>
	
EOF
	}
} elsif ($flow eq 'PartB3') {
	# Parse the input 
	my $dye = param('dye');
	my $lmax = param('lmax');
	
	# Determine an unknown concentration
	my $unk_conc = random_value(80, 20);
	my $eps = $lmax + 2;
	my $Abs = sprintf("%.3f", $dye_data[$dye][$eps] * $unk_conc / 100);
	my $unk_no = int(int(random_value(9, 1)) * 1000 + 2 * $unk_conc);

	# print results
	print "Your unknown Number is $unk_no.<br>\n";
	print "Your unknown solution is $dye_data[$dye][0].<br>\n";
	print "You measured the absorption of the solution at $lambda[$lmax] nm.<br>\n";
	print "The measured absorbance is $Abs.<br>\n";
	
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


