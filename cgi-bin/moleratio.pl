#!/usr/bin/perl -wT

# A Virtual Lab: Mole Ratios in a Chemical Reaction
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
print start_html("Mole Ratios in a Chemical Reaction");
print "<h1>Mole Ratios in a Chemical Reaction</h1>\n";

if ($flow eq 'fresh') {
	# set unknown
	my $unk = param('unk');
	if ($unk eq '') {
		$unk = int(random_value(3,1)+0.5);
	}
	my $temp = sprintf("%.2f", random_value(22, 18));
	my $vol_acid = 0;				# mL
	my $vol_base = 0;				# mL
	my $vol_water = 0;				# mL
	my $vol_tot = 0;				# mL
	my $measured = '';

	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Calorimeter Contents</b></font><br>(before reaction)</td>
		</tr>
		<tr>
			<td>Volume of acid</td> <td>$vol_acid mL</ml>
		</tr>
		<tr>
			<td>Volume of base</td> <td>$vol_base mL</ml>
		</tr>
		<tr>
			<td>Volume of water</td> <td>$vol_water mL</ml>
		</tr>
		<tr>
			<td>Total Volume</td> <td>$vol_tot mL</ml>
		</tr>
	</table>

	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<p><B>Choose a reagent to add</b>:</p>
	<input type="radio" name="reagent" value="acid">acid<br>
	<input type="radio" name="reagent" value="base">base<br>
	<input type="radio" name="reagent" value="water">water<br>
	<p><B>Choose a volume to add</b>:</p>
	<input type="radio" name="volume" value="1">1.00 mL<br>
	<input type="radio" name="volume" value="2">2.00 mL<br>
	<input type="radio" name="volume" value="5">5.00 mL<br>
	<input type="radio" name="volume" value="10">10.00 mL<br>
	<input type="radio" name="volume" value="20">20.00 mL<br>
	<input type="radio" name="volume" value="25">25.00 mL<br>
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="measured" value="$measured">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="reagent">
	<input type="submit" value="Add the reagent">
	</form>
	
	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>

	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="measured" value="$measured">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="measure">
	<input type="submit" value="Measure the Temperature">
	</form>

EOF

} elsif ($flow eq 'reagent') {
	# Read the parameters
	my $unk = param('unk');
	my $volume = param('volume');
	my $reagent = param('reagent');
	my $vol_acid = param('vol_acid');
	my $vol_base = param('vol_base');
	my $vol_water = param('vol_water');
	my $mmol_acid = param('mmol_acid');
	my $mmol_base = param('mmol_base');
	my $temp = param('temp');
	my $measured = param('measured');
	
	my $flag = "okay";
	my $vol_tot = sprintf("%.2f", $vol_acid + $vol_base + $vol_water);
	if ($mmol_acid eq '') {
		$mmol_acid = $unk * $vol_acid * 0.1;
	}
	if ($mmol_base eq '') {
		$mmol_base = $vol_base * 0.1;
	}
	
	if ($reagent eq '') {
		print "<font color=\"red\">You must select a reagent!</font><br>\n";
		$flag = "oops!";
	}
	if ($volume eq '') {
		print "<font color=\"red\">You must select a volume!</font><br>\n";
		$flag = "oops!";
	}
	
	if ($flag eq 'okay') {
		$vol_tot = sprintf("%.2f", $vol_tot + $volume);
		if ($reagent eq 'acid') {
			$vol_acid = sprintf("%.2f", $vol_acid + $volume);
		} elsif ($reagent eq 'base') {
			$vol_base = sprintf("%.2f", $vol_base + $volume);
		} elsif ($reagent eq 'water') {
			$vol_water = sprintf("%.2f", $vol_water + $volume);
		}
		
		print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Calorimeter Contents</b></font><br>(before reaction)</td>
		</tr>
		<tr>
			<td>Volume of acid</td> <td>$vol_acid mL</ml>
		</tr>
		<tr>
			<td>Volume of base</td> <td>$vol_base mL</ml>
		</tr>
		<tr>
			<td>Volume of water</td> <td>$vol_water mL</ml>
		</tr>
		<tr>
			<td>Total Volume</td> <td>$vol_tot mL</ml>
		</tr>
EOF
		if ($measured eq 'yes') {
			print <<EOF;
		<tr>
			<td>Temperature</td> <td>$temp <sup>o</sup>C</td>
		</tr>
EOF
		}
		print <<EOF;
	</table>

	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<p><B>Choose a reagent to add</b>:</p>
	<input type="radio" name="reagent" value="acid">acid<br>
	<input type="radio" name="reagent" value="base">base<br>
	<input type="radio" name="reagent" value="water">water<br>
	<p><B>Choose a volume to add</b>:</p>
	<input type="radio" name="volume" value="1">1.00 mL<br>
	<input type="radio" name="volume" value="2">2.00 mL<br>
	<input type="radio" name="volume" value="5">5.00 mL<br>
	<input type="radio" name="volume" value="10">10.00 mL<br>
	<input type="radio" name="volume" value="20">20.00 mL<br>
	<input type="radio" name="volume" value="25">25.00 mL<br>
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="mmol_acid" value="$mmol_acid">
	<input type="hidden" name="mmol_base" value="$mmol_base">
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="measured" value="$measured">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="reagent">
	<input type="submit" value="Add the reagent">
	</form>
	
	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>

	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="measure">
	<input type="submit" value="Measure the Temperature">
	</form>

EOF
		
	}
	
} elsif ($flow eq 'measure') {
	# Read the parameters
	my $vol_acid = param('vol_acid');
	my $vol_base = param('vol_base');
	my $vol_water = param('vol_water');
	my $temp = param('temp');
	my $unk = param('unk');
	
	# Calculate mmols of acid and base to determine limiting reagent
	my $mmol_acid = $unk * $vol_acid * 0.1;			# mmol
	my $mmol_base = $vol_base * 0.1;				# mmol
	
	my $DT = 0;
	my $measured = "no";
	my $boa = "before";
	my $vol_tot = sprintf("%.2f", $vol_acid + $vol_base + $vol_water);
	if ($vol_tot != 0) {
		if (($mmol_acid > $mmol_base) and ($mmol_base != 0)) {
			$DT = 57.62 * $mmol_base / $vol_tot / 4.184;
			$boa = "after";
		}
		if (($mmol_base > $mmol_acid) and ($mmol_acid != 0)) {
			$DT = 57.62 * $mmol_acid / $vol_tot / 4.184;
			$boa = "after";
		}
		if (($mmol_acid == $mmol_base) and ($mmol_acid != 0)) {
			$DT = 57.62 * $mmol_acid / $vol_tot / 4.184;
			$boa = "after";
		}
		$measured = "yes";
	} else {
		print "<font color=\"red\">You must add a reagent before measuring the temperature!</font><br>\n";
	}
	
	$temp = sprintf("%.2f", $temp + $DT);
	
	# Now, print the results
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffcc"><font size="+1"><b>Calorimeter Contents</b></font><br>($boa reaction)</td>
		</tr>
		<tr>
			<td>Volume of acid</td> <td>$vol_acid mL</ml>
		</tr>
		<tr>
			<td>Volume of base</td> <td>$vol_base mL</ml>
		</tr>
		<tr>
			<td>Volume of water</td> <td>$vol_water mL</ml>
		</tr>
		<tr>
			<td>Total Volume</td> <td>$vol_tot mL</ml>
		</tr>
EOF
	if ($measured eq 'yes') {
			print <<EOF;
		<tr>
			<td>Temperature</td> <td>$temp <sup>o</sup>C</td>
		</tr>
EOF
	}
	print "</table>\n";
	
	if ($boa eq 'before') {
		print <<EOF;

	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<p><B>Choose a reagent to add</b>:</p>
	<input type="radio" name="reagent" value="acid">acid<br>
	<input type="radio" name="reagent" value="base">base<br>
	<input type="radio" name="reagent" value="water">water<br>
	<p><B>Choose a volume to add</b>:</p>
	<input type="radio" name="volume" value="1">1.00 mL<br>
	<input type="radio" name="volume" value="2">2.00 mL<br>
	<input type="radio" name="volume" value="5">5.00 mL<br>
	<input type="radio" name="volume" value="10">10.00 mL<br>
	<input type="radio" name="volume" value="20">20.00 mL<br>
	<input type="radio" name="volume" value="25">25.00 mL<br>
	<input type="hidden" name="vol_acid" value="$vol_acid">
	<input type="hidden" name="vol_base" value="$vol_base">
	<input type="hidden" name="vol_water" value="$vol_water">
	<input type="hidden" name="mmol_acid" value="$mmol_acid">
	<input type="hidden" name="mmol_base" value="$mmol_base">
	<input type="hidden" name="temp" value="$temp">
	<input type="hidden" name="measured" value="$measured">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="reagent">
	<input type="submit" value="Add the reagent">
	</form>
	
	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>

EOF
	} else {
		print <<EOF;
	
	<form action="/~pfleming/cgi-bin/moleratio.pl" method="post">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="fresh">
	<input type="submit" value="Start with a fresh calorimeter">
	</form>

EOF
	}

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
