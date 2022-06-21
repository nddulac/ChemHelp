#!/usr/bin/perl -wT

# A Virtual Lab: Determination of a Chemical Formula
# Patrick E. Fleming
# California State University, East Bay
# June 3, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');						# Determines part
my $i = 0;										# looping variable
my @hydrate = (["CuCl<sub>2</sub> * 2 H<sub>2</sub>O", "Cu", "Cl", 2, 2, 134.45, 170.48, 63.55, 35.45, "CuCl<sub>x</sub> * y H<sub>2</sub>O"],
               ["FeCl<sub>3</sub> * 6 H<sub>2</sub>O", "Fe", "Cl", 3, 6, 162.20, 283.15, 55.84, 35.45, "FeCl<sub>x</sub> * y H<sub>2</sub>O"],
               ["FeCl<sub>2</sub> * 4 H<sub>2</sub>O", "Fe", "Cl", 2, 4, 126.75, 207.38, 55.84, 35.45, "FeCl<sub>x</sub> * y H<sub>2</sub>O"],
               ["FeBr<sub>3</sub> * 6 H<sub>2</sub>O", "Fe", "Br", 3, 6, 295.56, 416.51, 55.84, 79.90, "FeBr<sub>x</sub> * y H<sub>2</sub>O"],
               ["FeI<sub>2</sub> * 4 H<sub>2</sub>O", "Fe", "Cl", 2, 4, 309.65, 381.71, 55.84, 126.90, "FeI<sub>x</sub> * y H<sub>2</sub>O"],
               ["NiCl<sub>2</sub> * 6 H<sub>2</sub>O", "Ni", "Cl", 2, 6, 129.60, 237.69, 58.69, 35.45, "NiCl<sub>x</sub> * y H<sub>2</sub>O"],
               ["NiBr<sub>2</sub> * 3 H<sub>2</sub>O", "Ni", "Br", 2, 3, 218.50, 272.55, 58.69, 79.90, "NiBr<sub>x</sub> * y H<sub>2</sub>O"],
               ["NiBr<sub>2</sub> * 6 H<sub>2</sub>O", "Ni", "Br", 2, 6, 218.50, 326.59, 58.69, 79.90, "NiBr<sub>x</sub> * y H<sub>2</sub>O"],
               ["CoCl<sub>2</sub> * 2 H<sub>2</sub>O", "Co", "Cl", 2, 2, 129.84, 165.87, 58.93, 35.45, "CoCl<sub>x</sub> * y H<sub>2</sub>O"],
               ["CoCl<sub>2</sub> * 6 H<sub>2</sub>O", "Co", "Cl", 2, 6, 129.84, 237.93, 58.93, 35.45, "CoCl<sub>x</sub> * y H<sub>2</sub>O"],
               ["CoBr<sub>2</sub> * 6 H<sub>2</sub>O", "Co", "Br", 2, 6, 218.74, 339.69, 58.93, 79.90, "CoBr<sub>x</sub> * y H<sub>2</sub>O"],
               ["CoI<sub>2</sub> * 2 H<sub>2</sub>O", "Co", "I", 2, 2, 312.74, 348.77, 58.93, 126.90, "CoI<sub>x</sub> * y H<sub>2</sub>O"],
               ["CoI<sub>2</sub> * 6 H<sub>2</sub>O", "Co", "I", 2, 6, 312.74, 420.83, 58.93, 126.90, "CoI<sub>x</sub> * y H<sub>2</sub>O"]);

# Begin html output
print header;
print start_html("Determination of a Chemical Formula");
print "<h1>Determination of a Chemical Formula</h1>\n";

if ($flow eq 'generate') {
	# Set random parameters
	my $unknown = int(rand(1)*scalar(@hydrate));
	
	print <<EOF;
	<p>Your unknown is $hydrate[$unknown][9].</p>
	<form action="/~pfleming/cgi-bin/Formula.pl" method="post">
	<p>What do you wish to do?</p>
	<input type="radio" name="control_1" value="begin"> Start by weighing ~1 g of sample.<br>
	<input type="radio" name="control_1" value="heat"> Heat your sample in the crucible.<br>
	<input type="radio" name="control_1" value="react"> Displace the metal with aluminum.<br>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="crucible_mass" value="0">
	<input type="submit" value="Do it!"> <input type="reset"><br>
	</form>
EOF

} elsif ($flow eq 'begin') {
	#we must measure out about a gram of sample
	my $unknown = param('unknown');
	my $crucible_mass = param('crucible_mass');
	if ($crucible_mass == 0) {
		$crucible_mass = sprintf("%.4f", random_value (30, 25) );
	}
	my $sample_mass = sprintf("%.4f", random_value (1.5, 0.5) );
	my $water_mass = sprintf("%.4f", $hydrate[$unknown][4] * 18.016 / $hydrate[$unknown][6] * $sample_mass);
	my $anhydrous_mass = $sample_mass - $water_mass;
	my $water_remaining_mass = $water_mass;
	my $total_mass = $crucible_mass + $anhydrous_mass + $water_remaining_mass;
	print "<p>Your unknown is $hydrate[$unknown][9].</p>\n";
	print "Crucible mass = $crucible_mass g.<br>\n";
	print "Crucible + sample = $total_mass g<br>\n";
	print <<EOF;
	<form action="/~pfleming/cgi-bin/Formula.pl" method="post">
	<p>What do you wish to do next?</p>
	<input type="radio" name="control_1" value="begin"> Start by weighing ~1 g of sample.<br>
	<input type="radio" name="control_1" value="heat"> Heat your sample in the crucible.<br>
	<input type="radio" name="control_1" value="react"> Displace the metal with aluminum.<br>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="crucible_mass" value="$crucible_mass">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="water_remaining_mass" value="$water_remaining_mass">
	<input type="submit" value="Do it!"> <input type="reset"><br>
	</form>
EOF

} elsif ($flow eq 'heat') {
	# heat the sample to lose 97% of water
	my $unknown = param('unknown');
	my $crucible_mass = param('crucible_mass');
	my $sample_mass = param('sample_mass');
	my $anhydrous_mass = sprintf("%.4f", $hydrate[$unknown][5]/$hydrate[$unknown][6] * $sample_mass);
	my $water_remaining_mass = sprintf("%.4f", 0.03 * param('water_remaining_mass'));
	my $total_mass = sprintf("%.4f", $crucible_mass + $anhydrous_mass + $water_remaining_mass);
	if ($crucible_mass == 0) {
		print "You must first weigh out a sample!<br>\n";
		print "<form action=\"/~pfleming/cgi-bin/Formula.pl\" method=\"post\">\n";
		print "<input type=\"hidden\" name=\"control_1\" value=\"generate\">\n";
		print "<input type=\"submit\" value=\"Go back and try again\">\n";
		print "</form>\n";
	} else {
		print "<p>Your unknown is $hydrate[$unknown][9].</p>\n";
		print "<p>After heating your crucible and sample for 10 minutes and allowing it to cool, you observe:</p>\n";
		print "Crucible mass = $crucible_mass g.<br>\n";
		print "Crucible + sample = $total_mass g<br>\n";
		print <<EOF;
	<form action="/~pfleming/cgi-bin/Formula.pl" method="post">
	<p>What do you wish to do next?</p>
	<input type="radio" name="control_1" value="begin"> Start by weighing ~1 g of sample.<br>
	<input type="radio" name="control_1" value="heat"> Heat your sample in the crucible.<br>
	<input type="radio" name="control_1" value="react"> Displace the metal with aluminum.<br>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="crucible_mass" value="$crucible_mass">
	<input type="hidden" name="sample_mass" value="$sample_mass">
	<input type="hidden" name="water_remaining_mass" value="$water_remaining_mass">
	<input type="submit" value="Do it!"> <input type="reset"><br>
	</form>
EOF
	}

} elsif ($flow eq 'react') {
	my $unknown = param('unknown');
	my $crucible_mass = param('crucible_mass');
	my $sample_mass = param('sample_mass');
	my $water_remaining_mass = param('water_remaining_mass');
	my $metal_mass = sprintf("%.4f", $hydrate[$unknown][7]/$hydrate[$unknown][6] * $sample_mass);
	my $water_mass = sprintf("%.4f", $hydrate[$unknown][4] * 18.016 / $hydrate[$unknown][6] * $sample_mass);
	my $halide_mass = sprintf("%.4f", $sample_mass - $water_mass - $metal_mass);
	my $anhydrous_mass = $sample_mass - $water_remaining_mass;
	my $total_mass = $crucible_mass + $sample_mass;
	my $after_heating_mass = $crucible_mass + $sample_mass - $water_mass + $water_remaining_mass;
	my $mols_water = $water_mass / 18.016;
	my $mols_metal = $metal_mass / $hydrate[$unknown][7];
	my $mols_halide = $halide_mass / $hydrate[$unknown][8];
	if ($crucible_mass == 0) {
		print "You must first weigh out a sample!<br>\n";
		print "<form action=\"/~pfleming/cgi-bin/Formula.pl\" method=\"post\">\n";
		print "<input type=\"hidden\" name=\"control_1\" value=\"generate\">\n";
		print "<input type=\"submit\" value=\"Go back and try again\">\n";
		print "</form>\n";
	} else {
		print <<EOF;
	<form action="/~pfleming/cgi-bin/Formula.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font siz"+1"><b>Data</b></font></td>
		</tr>
		<tr>
			<td>Your Unknown</td> <td>$hydrate[$unknown][9]</td>
		</tr>
		<tr>
			<td>Crucible mass</td> <td>$crucible_mass g</td>
		</tr>
		<tr>
			<td>Crucible + sample mass</td> <td>$total_mass g</td>
		</tr>
		<tr>
			<td>Crucible + anhydrous residue mass</td> <td>$after_heating_mass g</td>
		</tr>
		<tr>
			<td>Mass of $hydrate[$unknown][1] collected after reaction with aluminum</td> <td>$metal_mass g</td>
		</tr>
		<tr>
			<td bgcolor="ffcccc" colspan="2"><font size="+1"><b>Your calculations</b></font></td>
		</tr>
		<tr>
			<td>Sample Mass</td>
			<td><input name="a1"><input type="hidden" name="a1_ans" value="$sample_mass"> g</td>
		</tr>
		<tr>
			<td>Mass of Water</td>
			<td><input name="a2"><input type="hidden" name="a2_ans" value="$water_mass"> g</td>
		</tr>
		<tr>
			<td>Mass of $hydrate[$unknown][2]</td>
			<td><input name="a3"><input type="hidden" name="a3_ans" value="$halide_mass"> g</td>
		</tr>
		<tr>
			<td>Moles of water (18.02 g/mol)</td>
			<td><input name="a4"><input type="hidden" name="a4_ans" value="$mols_water"> mol</td>
		</tr>
		<tr>
			<td>Moles of $hydrate[$unknown][1] ($hydrate[$unknown][7] g/mol)</td>
			<td><input name="a5"><input type="hidden" name="a5_ans" value="$mols_metal"> mol</td>
		</tr>
		<tr>
			<td>Moles of $hydrate[$unknown][2] ($hydrate[$unknown][8] g/mol)</td>
			<td><input name="a6"><input type="hidden" name="a6_ans" value="$mols_halide"> mol</td>
		</tr>
		<tr>
			<td>x =</td>
			<td><input name="a7"><input type="hidden" name="a7_ans" value="$hydrate[$unknown][3]"></td>
		</tr>
		<tr>
			<td>y =</td>
			<td><input name="a8"><input type="hidden" name="a8_ans" value="$hydrate[$unknown][4]"></td>
		</tr>
		<tr>
			<td><input type="submit" value="Am I right?"></td>
			<td><input type="reset" value="Reset my answers"></td>
		</tr>
	</table>
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="crucible_mass" value="$crucible_mass">
	<input type="hidden" name="total_mass" value="$total_mass">
	<input type="hidden" name="after_heating_mass" value="$after_heating_mass">
	<input type="hidden" name="metal_mass" value="$metal_mass">
	<input type="hidden" name="control_1" value="grade">
	</form>
EOF
	}
	
} elsif ($flow="grade") {
	# read some fraggin inputs
	my $unknown = param('unknown');
	my $crucible_mass = param('crucible_mass');
	my $total_mass = param('total_mass');
	my $after_heating_mass = param('after_heating_mass');
	my $metal_mass = param('metal_mass');
	my $a1 = param('a1');
	my $ans_a1 = param('a1_ans');
	my $a2 = param('a2');
	my $ans_a2 = param('a2_ans');
	my $a3 = param('a3');
	my $ans_a3 = param('a3_ans');
	my $a4 = param('a4');
	my $ans_a4 = param('a4_ans');
	my $a5 = param('a5');
	my $ans_a5 = param('a5_ans');
	my $a6 = param('a6');
	my $ans_a6 = param('a6_ans');
	my $a7 = param('a7');
	my $ans_a7 = param('a7_ans');
	my $a8 = param('a8');
	my $ans_a8 = param('a8_ans');
	my @response = ["", "", "", "", "", "", "", "", ""];
	if (abs($a1 - $ans_a1)/$ans_a1 < 0.002) {
		$response[1] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[1] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($a2 - $ans_a2)/$ans_a2 < 0.002) {
		$response[2] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[2] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($a3 - $ans_a3)/$ans_a3 < 0.002) {
		$response[3] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[3] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($a4 - $ans_a4)/$ans_a4 < 0.002) {
		$response[4] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[4] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($a5 - $ans_a5)/$ans_a5 < 0.002) {
		$response[5] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[5] = "<font color=\"red\">You are incorrect.</font>";
	}
	if (abs($a6 - $ans_a6)/$ans_a6 < 0.002) {
		$response[6] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[6] = "<font color=\"red\">You are incorrect.</font>";
	}
	if ($a7 == $ans_a7) {
		$response[7] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[7] = "<font color=\"red\">You are incorrect.</font>";
	}
	if ($a8 == $ans_a8) {
		$response[8] = "<font color=\"green\">You are correct!</font>";
	} else {
		$response[8] = "<font color=\"red\">You are incorrect.</font>";
	}
	# print some output!
	print <<EOF;
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="3"><font siz"+1"><b>Data</b></font></td>
		</tr>
		<tr>
			<td>Your Unknown</td> <td>$hydrate[$unknown][9]</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Crucible mass</td> <td>$crucible_mass g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Crucible + sample mass</td> <td>$total_mass g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Crucible + anhydrous residue mass</td> <td>$after_heating_mass g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Mass of $hydrate[$unknown][1] collected after reaction with aluminum</td> <td>$metal_mass g</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td bgcolor="ffcccc" colspan="3"><font size="+1"><b>Your calculations</b></font></td>
		</tr>
		<tr>
			<td>Sample Mass</td>
			<td>$a1 g</td>
			<td>$response[1]</td>
		</tr>
		<tr>
			<td>Mass of Water</td>
			<td>$a2 g</td>
			<td>$response[2]</td>
		</tr>
		<tr>
			<td>Mass of $hydrate[$unknown][2]</td>
			<td>$a3 g</td>
			<td>$response[3]</td>
		</tr>
		<tr>
			<td>Moles of water (18.02 g/mol)</td>
			<td>$a4 mol</td>
			<td>$response[4]</td>
		</tr>
		<tr>
			<td>Moles of $hydrate[$unknown][1] ($hydrate[$unknown][7] g/mol)</td>
			<td>$a5 mol</td>
			<td>$response[5]</td>
		</tr>
		<tr>
			<td>Moles of $hydrate[$unknown][2] ($hydrate[$unknown][8] g/mol)</td>
			<td>$a6 mol</td>
			<td>$response[6]</td>
		</tr>
		<tr>
			<td>x =</td>
			<td>$a7</td>
			<td>$response[7]</td>
		</tr>
		<tr>
			<td>y =</td>
			<td>$a8</td>
			<td>$response[8]</td>
		</tr>
		<tr>
			<td colspan=3" align="center">Your salt was $hydrate[$unknown][0]</td>
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
	my $max = $_[0];
	my $min = $_[1];
	my $value = rand(1) * ($max - $min) + $min;
	return $value;
}
