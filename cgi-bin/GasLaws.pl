#!/usr/bin/perl -wT

# A Virtual Lab: Gas Laws
# Patrick E. Fleming
# California State University, East Bay
# June 5, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');						# Determines part
my $i = 0;										# looping variable

# Begin html output
print header;
print start_html("Gas Laws");
print "<h1>Gas Laws</h1>\n";

if ((substr $flow, 0, 5) eq 'PartA') {
	print "<h2>Part A - Boyle's Law</h2>\n";
	my $dead_vol = param('dead_vol');
	my $vol = sprintf("%.1f", param('vol')); 
	if ($dead_vol == 0) {
		$dead_vol = (rand(1) * 0.2);
	}
	if ($vol != 0) {
		# report pressure and prepare to measure at a new volume
		my $pres = sprintf("%.2f", ((10 + $dead_vol)/($vol + $dead_vol) + rand(1) * 0.1) * 101.325);
		print <<EOF;
<p><table border="2" cellpadding="2">
	<tr>
		<td bgcolor="ccffcc"><font size="+1"><b>Volume (mL)</b></font></td> 
		<td bgcolor="ccffcc"><font size="+1"><b>Pressure (kPa)</b></font></td> 
	</tr>
	<tr>
		<td>$vol</td> <td>$pres</td>
	</tr>
</table></p>
<form action="/~pfleming/cgi-bin/GasLaws.pl" method="post">
	<p>Indicate your desired volume at which to measure the pressure.</p>
	<input name="vol"> mL
	<input type="hidden" name="dead_vol" value="$dead_vol">
	<input type="hidden" name="control_1" value="PartA">
	<input type="submit" value="Measure the Pressure">
</form>
EOF
	} else {
		# no Volume has been indicated (perhaps because this is the first time through)
		print <<EOF;
<form action="/~pfleming/cgi-bin/GasLaws.pl" method="post">
	<p>Indicate your desired volume at which to measure the pressure.</p>
	<input name="vol"> mL
	<input type="hidden" name="dead_vol" value="$dead_vol">
	<input type="hidden" name="control_1" value="PartA">
	<input type="submit" value="Measure the Pressure">
</form>
EOF
	}
	
} elsif ($flow eq 'PartB') {
	print "<h2>Part B - Determination of R</h2>\n";
	my $volume = sprintf("%.2f", 136.34 + rand(10) - 5);                       # mL
	my $pressure = sprintf("%.2f", (0.965 + rand(1) * 0.2 - 0.1) * 101.325);   #kPa
	# my $temperature = 23.0         # C
	
	# Let's work on volume first
	my $p1 = $pressure;
	my $p2 = sprintf("%.2f", $pressure * ($volume + 20) / $volume);
	print <<EOF;
	<h2>Volume</h2>
	<form action="/~pfleming/cgi-bin/GasLaws.pl" method="post">
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Pressure (kPa)</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Volume</b></font></td>
		</tr>
		<tr>
			<td>$p1</td> <td>V + 20.0 mL</td>
		</tr>
		<tr>
			<td>$p2</td> <td>V</td>
		</tr>
		<tr>
			<td>What is the value of V?</td> <td><input name="V2"> mL</td>
		</tr>
	</table></p>
	<input type="hidden" name="pressure" value="$pressure">
	<input type="hidden" name="volume" value="$volume">
	<input type = "hidden" name="control_1" value="PartB_V">
	<input type="submit" value="Am I correct?">
	</form>
EOF

} elsif ($flow eq 'PartB_V') {
	# read some parameters
	my $pressure = param('pressure');
	my $volume = param('volume');
	my $V2 = param('V2');
	my $response = '<font color="red">You are incorrect.</font>';
	if (abs($volume-$V2)/$volume < 0.01) {
		$response = '<font color="green">You are correct!</font>';
	}
	my $p1 = $pressure;
	my $p2 = sprintf("%.2f", $pressure * $volume / ($volume - 20));
	print <<EOF;
	<h2>Volume</h2>
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Pressure (kPa)</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Volume</b></font></td>
			<td bgcolor ="ccffcc"></td>
		</tr>
		<tr>
			<td>$p1</td> <td>V + 20.0 mL</td> <td bgcolr="cccccc"></td>
		</tr>
		<tr>
			<td>$p2</td> <td>V</td> <td bgcolr="cccccc"></td>
		</tr>
		<tr>
			<td>What is the value of V?</td> <td>$V2 mL</td> <td>$response</td>
		</tr>
	</table></p>
	<p><i>Note</i>: Remember that the volume you use in your calculations will be 5.0 mL 
	smaller than what you just calculated in order to account for the 5.0 mL of HCl solution.</p>
EOF

# Now on to the calculation of the number of moles
	my $mass_mg = sprintf("%.4f", 0.0157 + rand(1) * 0.001 - 0.005);           # g
	print <<EOF;
	<h2>Moles</h2>
	<form action="/~pfleming/cgi-bin/GasLaws.pl" method="post">
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Item</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Value</b></font></td>
		</tr>
		<tr>
			<td>Volume</td> <td>$V2 mL</td>
		</tr>
		<tr>
			<td>Mass of Mg (24.31 g/mol)</td> <td>$mass_mg g</td>
		</tr>
		<tr>
			<td>How many mol of H<sub>2</sub> gas will be produced??</td> 
			<td><input name="mol_H2"> mol</td>
		</tr>
	</table></p>
	<input type="hidden" name="pressure" value="$pressure">
	<input type="hidden" name="volume" value="$volume">
	<input type="hidden" name="mass_mg" value="$mass_mg">
	<input type="hidden" name="V2" value="$V2">
	<input type = "hidden" name="control_1" value="PartB_mol">
	<input type="submit" value="Am I correct?">
	</form>
EOF

} elsif ($flow eq 'PartB_mol') {
	# read some parameters
	my $pressure = param('pressure');
	my $volume = param('volume');
	my $mass_mg = param('mass_mg');
	my $V2 = param('V2');
	my $mol_H2 = param('mol_H2');
	my $mol = sprintf("%6f", $mass_mg / 24.31);
	my $response = '<font color="red">You are incorrect.</font>';
	if (abs($mol-$mol_H2)/$mol < 0.01) {
		$response = '<font color="green">You are correct!</font>';
	}
	
	print <<EOF;
	<h2>Moles</h2>
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Item</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Value</b></font></td>
			<td bgcolor="ccffcc"></td>
		</tr>
		<tr>
			<td>Volume</td> <td>$V2 mL</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Mass of Mg (24.31 g/mol)</td> <td>$mass_mg g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>mol of H<sub>2</sub></td> 
			<td>$mol_H2 mol</td>
			<td>$response</td>
		</tr>
	</table></p>
	<input type="hidden" name="pressure" value="$pressure">
	<input type="hidden" name="volume" value="$volume">
	<input type="hidden" name="mass_mg" value="$mass_mg">
	<input type="hidden" name="V_student" value="$V2">
	<input type = "hidden" name="control_1" value="PartB_mol">
EOF

	my $temperature = sprintf("%.1f", 293 + rand(1) * 4 - 273.15);
	my $p2 = sprintf("%.2f", ($pressure * $volume) / ($volume - 5) + ($mass_mg/24.31)*(0.08206)*($temperature)/($volume - 5) * 101.325);
	my $p_tru = $p2 - $pressure;
	my $V_tru = $volume - 5;
	my $n_tru = $mass_mg / 24.31;
	my $T_tru = $temperature;
	my $n_student = $mol_H2;
	print <<EOF;
	<h2>Pressure, Volume, and Temperature</h2>
	<form action="/~pfleming/cgi-bin/GasLaws.pl" method="post">
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Item</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Value</b></font></td>
		</tr>
		<tr>
			<td>Pressure before reaction</td> <td>$pressure kPa</td>
		</tr>
		<tr>
			<td>Pressure after reaction</td> <td>$p2 kPa</td>
		</tr>
		<tr>
			<td>Partial pressure of H<sub>2</sub> produced</td> 
			<td><input name="p_student"> kPa</td>
		</tr>
		<tr>
			<td>Flask Volume</td> <td>$V2 mL</td>
		</tr>
		<tr>
			<td>Volume available to H<sub>2</sub></td> 
			<td><input name="V_student"> mL</td>
		</tr>
		<tr>
			<td>mol of H<sub>2</sub></td> <td>$n_student mol</td>
		</tr>
		<tr>
			<td>Temperature</td> <td>$T_tru <sup>o</sup>C</td>
		</tr>
		<tr>
			<td>Value of R</td> 
			<td><input name="R_student"> atm L amol<sup>-1</sup> K<sup>-1</sup></td>
		</tr>
	</table></p>
	<input type="hidden" name="p_tru" value="$p_tru">
	<input type="hidden" name="V_tru" value="$V_tru">
	<input type="hidden" name="n_tru" value="$n_tru">
	<input type="hidden" name="T_tru" value="$T_tru">
	<input type="hidden" name="n_student" value="$n_student">
	<input type="hidden" name="T_student" value="$T_tru">
	<input type = "hidden" name="control_1" value="PartB_R">
	<input type="submit" value="Am I correct?">
	</form>
EOF

} elsif ($flow eq 'PartB_R') {
	# Read some parameters
	my $p_student = param('p_student');
	my $V_student = param('V_student');
	my $n_student = param('n_student');
	my $T_student = param('T_student');
	my $R_student = param('R_student');
	my $p_tru = param('p_tru');
	my $V_tru = param('V_tru');
	my $n_tru = param('n_tru');
	my $T_tru = param('T_tru');
	my $R_tru = ($p_tru / 101.325) * ($V_tru / 1000) / $n_tru / ($T_tru + 273.15);
	
	my $response_p = '<font color="red">This value is incorrect.</font>';
	my $response_V = '<font color="red">This value is incorrect.</font>';
	my $response_n = '<font color="red">This value is incorrect.</font>';
	my $response_R = '<font color="red">This value is incorrect.</font>';

	if (abs($p_tru - $p_student)/$p_tru < 0.01) {
		$response_p = '<font color="green">This value is correct!</font>';
	}
	if (abs($V_tru - $V_student)/$V_tru < 0.01) {
		$response_V = '<font color="green">This value is correct!</font>';
	}
	if (abs($n_tru - $n_student)/$n_tru < 0.01) {
		$response_n = '<font color="green">This value is correct!</font>';
	}
	if (abs($R_tru - $R_student)/$R_tru < 0.01) {
		$response_R = '<font color="green">This value is correct!</font>';
	}
	
	print <<EOF;
	<h2>Final Results</h2>
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ffcccc"><font size="+1"><b>Parameter</b></font></td>
			<td bgcolor="ffcccc" colspan="2"><font size="+1"><b>Value</b></font></td>
		</tr>
		<tr>
			<td>presure</td>
			<td>$p_student kPa</td>
			<td>$response_p</td>
		</tr>
		<tr>
			<td>Volume</td>
			<td>$V_student mL</td>
			<td>$response_V</td>
		</tr>
		<tr>
			<td>mol H<sub>2</sub></td>
			<td>$n_student mol</td>
			<td>$response_n</td>
		</tr>
		<tr>
			<td>Temperature</td>
			<td>$T_student <sup>o</sup>C</td>
			<td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>R</td>
			<td>$R_student atm L mol<sup>-1</sup> K<sup>-1</sup></td>
			<td>$response_R</td>
		</tr>
	</table></p>
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

