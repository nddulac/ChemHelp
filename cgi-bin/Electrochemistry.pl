#!/usr/bin/perl -wT

# A Virtual Lab: Electrochemistry
# Patrick E. Fleming
# California State University, East Bay
# May 18, 2020 

# this virtual Electrochemistry experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');					# Determines part
my $i = 0;										# looping variable

# Begin html output
print header;
print start_html("Virtual Electrochemistry Lab");
print "<h1>Virtual Electrochemistry Lab</h1>\n";

if ((substr $flow, 0, 5) eq 'PartA') {
	##############
	##  Part A  ##
	##############
	print "<h2>Part A - Electrolysis</h2>\n";
	# Set elecrolyte parameters for Part A
	my @electrolyte = ("Copper", "Silver", "Gold", "Nickel", "Cobalt", "Tin", "Chromium");
	my @electrolyte_charge = ("2", "1", "3", "2", "3", "4", "3");
	my @electrolyte_mass = ("63.546", "107.868", "196.967", "58.693", "58.933", "118.71", "51.996");
	my $n_electrolytes = scalar(@electrolyte);
	
	if ($flow eq 'PartA') {
	# Set a random initial key mass
	my $key_mass = sprintf("%.4f", rand(15) + 35.3467);

	# Print page with data to be analyzed
	print <<EOF;
	<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
			Enter your conditions below:<br>
			<select name="metal">
				<option value="">Select your metal to plate onto surface:</option>
EOF
	# for loop to fill in options
	for ($i=0; $i < $n_electrolytes; $i = $i + 1) {
		print "				<option value=\"$electrolyte[$i]\">$electrolyte[$i]</option>\n";
	}
	print <<EOF;
			</select><br>
			<input name="current"> ampere<br>
			<input name="time"> seconds<br>
			<input type="hidden" name="control_1" value="PartA2">
			<input type="hidden" name="key_mass" value="$key_mass"> 
			<input type="Submit" value="Get Part A data!">
		</form>
EOF
	} elsif ($flow eq 'PartA2') {
		my $metal = param('metal');
		my $key_mass = param('key_mass');
		my $current = param('current');
		my $time = param('time');
		my $charge = "1000000";
		my $mass = "0";
		for ($i=0; $i < $n_electrolytes; $i +=1) {
			if ($electrolyte[$i] eq $metal) {
				$charge = $electrolyte_charge[$i];
				$mass = $electrolyte_mass[$i];
			}
		}
		my $mass_added = sprintf("%.4f", $mass * ($current * $time / 96484 / $charge) - rand(1) / 1000);
		if ($mass_added > $mass) {
			$mass_added = $mass;
		}
		my $new_mass = sprintf("%.4f", $key_mass + $mass_added);
		if ($charge eq '1000000') {
			print "No electrolyte chosen - go back and try again!<br>\n";
		} else {
			my $correct_moles_metal = $mass_added / $mass;
			my $correct_moles_electrons = $time * $current / 96484;
			print <<EOF;
		<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
		<table border="2" cellpadding="2">
			<tr>
				<td colspan="2" bgcolor="ccffff"><b>Electroplating</b></td>
			</tr>
			<tr>
				<td>Electroplating Metal</td> <td>$metal</td>
			</tr>
			<tr>
				<td>Molar mass</td> <td>$mass g/mol</td>
			</tr>
			<tr>
				<td>Original key mass</td> <td>$key_mass g</td>
			</tr>
			<tr>
				<td>Current</td> <td>$current ampere</td>
			</tr>
			<tr>
				<td>Time</td> <td>$time seconds</td>
			</tr>
			<tr>
				<td>Key mass after electroplating</td> <td>$new_mass g</td>
			</tr>
			<tr>
				<td>Moles of $metal plated</td> <td><input name="moles_metal"> moles</td>
			</tr>
			<tr>
				<td>Moles of electrons</td> <td><input name="moles_electrons"> moles</td>
			</tr>
			<tr>
				<td>Charge on $metal ions</td> <td>+<input name="metal_charge"></td>
			</tr>
			<tr>
				<td><input type="Submit" value="Am I right?"></td> <td><input type="Reset" value="Reset Form"></td>
			</tr>
		</table>
		<input type="hidden" name="metal" value="$metal">
		<input type="hidden" name="mass" value="$mass">
		<input type="hidden" name="key_mass" value="$key_mass">
		<input type="hidden" name="current" value="$current">
		<input type="hidden" name="time" value="$time">
		<input type="hidden" name="new_mass" value="$new_mass">
		<input type="hidden" name="correct_moles_metal" value="$correct_moles_metal">
		<input type="hidden" name="correct_moles_electrons" value="$correct_moles_electrons">
		<input type="hidden" name="correct_charge" value="$charge">
		<input type="hidden" name="control_1" value="PartA3">
		</form>
EOF
		}
	} elsif ($flow eq 'PartA3') {
		my $metal = param('metal');
		my $mass = param('mass');
		my $key_mass = param('key_mass');
		my $current = param('current');
		my $time = param('time');
		my $new_mass = param('new_mass');
		my $moles_metal = param('moles_metal');
		my $moles_electrons = param('moles_electrons');
		my $metal_charge = param('metal_charge');
		my $correct_moles_electrons = param('correct_moles_electrons');
		my $correct_moles_metal = param('correct_moles_metal');
		my $correct_charge = param('correct_charge');
		my $cor_1 = "You are incorrect.";
		my $cor_2 = "You are incorrect.";
		my $cor_3 = "You are incorrect.";
		if (abs($correct_moles_metal - $moles_metal)/$correct_moles_metal < 0.005) {
			$cor_1 = "You are correct!";
		} 
		if (abs($correct_moles_electrons - $moles_electrons)/$correct_moles_electrons < 0.005) {
			$cor_2 = "You are correct!";
		} 
		if (abs($correct_charge - $metal_charge)/$correct_charge < 0.005) {
			$cor_3 = "You are correct!";
		} 
		print <<EOF;
		<table border="2" cellpadding="2">
			<tr>
				<td colspan="3" bgcolor="ccffff"><b>Electroplating</b></td>
			</tr>
			<tr>
				<td>Electroplating Metal</td> <td>$metal</td> <td bgcolor="cccccc"> </td>
			</tr>
			<tr>
				<td>Molar mass</td> <td>$mass g/mol</td> <td bgcolor="cccccc"> </td>
			</tr>
			<tr>
				<td>Original key mass</td> <td>$key_mass g</td> <td bgcolor="cccccc"> </td>
			</tr>
			<tr>
				<td>Current</td> <td>$current ampere</td> <td bgcolor="cccccc"> </td>
			</tr>
			<tr>
				<td>Time</td> <td>$time seconds</td> <td bgcolor="cccccc"> </td>
			</tr>
			<tr>
				<td>Key mass after electroplating</td> <td>$new_mass g</td> <td bgcolor="cccccc"> </td>
			</tr>
			<tr>
				<td>Moles of $metal plated</td> <td>$moles_metal moles</td> <td>$cor_1</td>
			</tr>
			<tr>
				<td>Moles of electrons</td> <td>$moles_electrons moles</td> <td>$cor_2</td>
			</tr>
			<tr>
				<td>Charge on $metal ions</td> <td>+$metal_charge</td> <td>$cor_3</td>
			</tr>
		</table>
		</form>
EOF

	}
} elsif ((substr $flow, 0, 5) eq 'PartB') {
	##############
	##  Part B  ##
	##############
	print "	<h2>Part B - Galvanic Cells</h2>\n";
	# Set some Standard Reduction Potentials
	my @reducer = ("Ag<sup>+</sup>", "Al<sup>3+</sup>", "Cu<sup>2+</sup>", "Li<sup>+</sup>", "Mg<sup>2+</sup>", "Mn<sup>2+</sup>", "Ni<sup>2+</sup>", "Pb<sup>2+</sup>", "Zn<sup>2+</sup>");
	my @reducee = ("Ag",  "Al", "Cu",  "Li", "Mg", "Mn", "Ni", "Pb", "Zn");
	my @n_elecs = ("1", "3", "2", "1", "2", "2", "2", "2",  "2");
	my @red_pot = ("0.80", "-1.66", "0.34", "-3.05", "-2.37", "-1.18", "-0.23", "-0.13", "-0.76");
	my $n_reds = scalar(@reducer);
	
	if ($flow eq 'PartB') {
		#Now to generate something to test:
		print <<EOF;
	<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffff" colspan="2"><font size="+1">Select your half-cells</font></td>
		</tr>
		<tr>
			<td bgcolor="ffcccc"><b>Red Wire</b></td> <td bgcolor="000000"><font color="white"><b>Black wire</b></font></td>
		</tr>
EOF
	for ($i=0; $i < $n_reds; $i +=1) {
		print <<EOF
		<tr>
			<td><input type="radio" name="anode"   value="$reducee[$i]">$reducee[$i] | $reducer[$i]</td>
			<td><input type="radio" name="cathode"   value="$reducee[$i]">$reducee[$i] | $reducer[$i]</td>
		</tr>
EOF
	}
		print <<EOF;
		<tr>
			<td><input type="submit" value="Measure the voltage!"></td> <td><input type="reset" value="Reset selections"></td>
		</tr>
	</table><p>
	<input type="hidden" name="control_1" value="PartB2">
	</form>
EOF
	} elsif ($flow eq 'PartB2') {
		my $anode = param('anode');
		my $cathode = param('cathode');
		my $i_anode = 1000;
		my $i_cathode = 1000;
		for ($i = 0; $i <$n_reds; $i +=1) {
			if ($anode eq $reducee[$i]) {
				$i_anode = $i;
			}
			if ($cathode eq $reducee[$i]) {
				$i_cathode = $i;
			}
		}
		# if $i_anode or $i_cathode is 1000 then that half-cell was not selected
		if ($i_anode == 1000 or $i_cathode == 1000) {
			print "You forgot to select one of the half-cells. Go back and fix the error.\n";
		} else {
			my $voltage = sprintf("%.2f", $red_pot[$i_cathode] - $red_pot[$i_anode]);
			print <<EOF;
	<p>The cell you requested is:</p>
	<p>($reducee[$i_anode] | $reducer[$i_anode] || <font color="red">$reducer[$i_cathode] | $reducee[$i_cathode]</font>)</p>
	<p><font color="black">The anode half-reaction is $reducee[$i_anode] &#8594; $reducer[$i_anode] + $n_elecs[$i_anode] e<sup>-</sup></font><br>
	<font color="red">The cathode half-reaction is $reducer[$i_cathode] + $n_elecs[$i_cathode] e<sup>-</sup> &#8594; $reducee[$i_cathode]</font></p>
	<p>The measured voltage is $voltage V</p>
	
EOF
		}
	}
} elsif ((substr $flow, 0, 5) eq 'PartC') {
	##############
	##  Part C  ##
	##############
		print <<EOF;
	<h2>Part C - the Effects of Concentration</h2>
	<p>In this part, you will measure the EMF across a pair of copper cells, in which the electrolyte solution concentration
	is different between the two cells. Based on this information, you will determine the value of the Faraday constant.<p>
	<p>Recall that the Nernst Equation for a concentration cell can be expressed by<br>
	<img src="/~pfleming/chem/Electrochemistry/nernst-conc.png"></p>
EOF
	if ($flow eq 'PartC') {
		print <<EOF;
	<p>(Cu | Cu<sup>2+</sup> (X M) || <font color="red">Cu<sup>2+</sup> (Y M) | Cu</font>)</p>
	<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
		Concnetration on Black Wire side <input name="X"> M<br>
		<font color="red">Concnetration on Red Wire side</font> <input name="Y"> M<br>
		<input type="hidden" name="control_1" value="PartC2">
		<input type="submit" value="Get the Voltage!">
	</form>
EOF
	} elsif ($flow eq 'PartC2') {
		my $X = param('X');
		my $Y = param('Y');
		my $voltage = sprintf("%.3f", -(8.314*298/2/96484)*log($X/$Y));
		print <<EOF;
	<p>(Cu | Cu<sup>2+</sup> ($X M) || <font color="red">Cu<sup>2+</sup> ($Y M) | Cu</font>)</p>
	<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffff">Concentration Cell</td>
		</tr>
		<tr>
			<td>Black wire concentration</td> <td>$X M</td>
		</tr>
		<tr>
			<td><font color="red">Red wire concentration</font></td> <td>$Y M</td>
		</tr>
		<tr>
			<td>Temperature</td> <td>298 K</td>
		</tr>
		<tr>
			<td>Measured Voltage</td> <td><b>$voltage</b> V</td>
		</tr>
		<tr>
			<td>Value of F</td> <td><input name="F"> Coulomb/mol</td>
		</tr>
		<tr>
			<td><input type="submit" value="Am I right?"></td> <td><input type="reset" value="Reset Input"></td>
		</tr>
	</table>
	<input type="hidden" name="X" value="$X">
	<input type="hidden" name="Y" value="$Y">
	<input type="hidden" name="V" value="$voltage">
	<input type="hidden" name="control_1" value="PartC3">
	</form>
EOF
	} elsif ($flow eq 'PartC3') {
		my $X = param('X');
		my $Y = param('Y');
		my $voltage = param('V');
		my $F = param('F');
		my $response = "You are incorrect.";
		if (abs($F - 96484)/96484 < 0.015) {
			$response = "You are correct!";
		}
		print <<EOF;
	<p>(Cu | Cu<sup>2+</sup> ($X M) || <font color="red">Cu<sup>2+</sup> ($Y M) | Cu</font>)</p>
	<table border="3" cellpadding="2">
		<tr>
			<td colspan="2" bgcolor="ccffff">Concentration Cell</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Black wire concentration</td> <td>$X M</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td><font color="red">Red wire concentration</font></td> <td>$Y M</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Temperature</td> <td>298 K</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Measured Voltage</td> <td>$voltage V</td> <td bgcolor="cccccc"></td>
		</tr>
		<tr>
			<td>Value of F</td> <td>$F Coulomb/mol</td> <td>$response</td>
		</tr>
	</table>
EOF
	}
} elsif ((substr $flow, 0, 5) eq 'PartD')  {
	my @salt = ("AgBr", 
	            "AgCl", 
	            "AgI", 
	            "CdS", 
	            "FeS", 
	            "MgCO<sub>3</sub>", 
	            "PbCl<sub>2</sub>", 
	            "PbI<sub>2</sub>", 
                "PbSO<sub>4</sub>", 
	            "ZnCO<sub>3</sub>",
	            "ZnS");
	my @half_a = ("Ag &#8594; Ag<sup>+</sup> + e<sup>-</sup>",
	              "Cd &#8594; Cd<sup>2+</sup> + 2 e<sup>-</sup>", 
	              "Fe &#8594; Fe<sup>2+</sup> + 2 e<sup>-</sup>", 
	              "Mg &#8594; Mg<sup>2+</sup> + 2 e<sup>-</sup>",
	              "Pb &#8594; Pb<sup>2+</sup> + 2 e<sup>-</sup>",
	              "Zn &#8594; Zn<sup>2+</sup> + 2 e<sup>-</sup>");
	my @half_c = ("AgBr + e<sup>-</sup> &#8594; Ag + Br<sup>-</sup>", 
	              "AgCl + e<sup>-</sup> &#8594; Ag + Cl<sup>-</sup>", 
	              "AgI + e<sup>-</sup> &#8594; Ag + I<sup>-</sup>",
	              "CdS + 2 e<sup>-</sup> &#8594; Cd + S<sup>2-</sup>", 
	              "FeS + 2 e<sup>-</sup> &#8594; Fe + S<sup>2-</sup>", 
	              "MgCO<sub>3</sub> + 2 e<sup>-</sup> &#8594; Mg + CO<sub>3</sub><sup>2-</sup>", 
	              "PbCl<sub>2</sub> + 2 e<sup>-</sup> &#8594; Pb + 2 Cl<sup>-</sup>",
	              "PbI<sub>2</sub> + 2 e<sup>-</sup> &#8594; Pb + 2 I<sup>-</sup>",
	              "PbSO<sub>4</sub> + 2 e<sup>-</sup> &#8594; Pb + SO<sub>4</sub><sup>2-</sup>",
	              "ZnCO<sub>3</sub> + 2 e<sup>-</sup> &#8594; Zn + CO<sub>3</sub><sup>2-</sup>",
	              "ZnS + 2 e<sup>-</sup> &#8594; Zn + S<sup>2-</sup>");
	my @red_a = (-0.7996, 0.403, 0.440, 2.356, 0.126, 0.762);
	my @red_c = (0.0825, 0.2190, -0.1372, -1.2449, -0.9856, -2.4917, -0.2678, -0.3586, -0.3553, -1.0828, -1.4405);
	my @ksp = (7.70E-13, 1.56E-10, 1.50E-16, 3.60E-19, 3.70E-19, 2.60E-5, 1.62E-5, 1.39E-8, 1.79E-8, 1.45E-11, 1.20E-23);
	print "		<h2>Part D - Connection to Equlibrium</h2>\n";
	if ($flow eq 'PartD') {
		my $isalt = int(rand() * scalar(@salt));
		print <<EOF;
		<p>Your salt is <b>$salt[$isalt]</b>.<br>Select an <b>anode</b> and <font color="red"><b>cathode</b></font> from the
		   list below to determine K<sub>sp</sub> for your salt.</p>
		<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
		<table border="2" cellpadding="2">
			<tr>
				<td bgcolor="black"><font size="+1" color="white"><b>Anode</font></b></td>
				<td bgcolor="red"><font size="+1" color="black"><b>Cathode</b></font></td>
			</tr>
			<tr>
				<td>
EOF
		for (my $j = 0; $j < scalar(@half_a); $j +=1) {
			print "					<input type=\"radio\" name=\"anode\" value=\"$half_a[$j]\"> $half_a[$j] <br>\n";
		}
		print "				</td>\n				<td>\n";
		for (my $j = 0; $j < scalar(@half_c); $j +=1) {
			print "					<input type=\"radio\" name=\"cathode\" value=\"$half_c[$j]\"> $half_c[$j] <br>\n";
		}
		print "				</td>\n			</tr>\n";
		print <<EOF;
			<tr>
				<td><input type="submit" value="Measure the cell potential!"></td>
				<td><input type="reset" value="Reset the form."></td>
			</tr>
		</table><br><br>
		<input type="hidden" name="assigned_salt" value="$salt[$isalt]">
		<input type="hidden" name="control_1" value="PartD2">
		</form>
EOF
	} elsif ($flow eq 'PartD2') {
		my $assigned_salt = param('assigned_salt');
		my $anode = param('anode'); 
		my $cathode = param('cathode'); 

		# find anode and cathode
		my $pot = 0;
		for (my $j = 0; $j < scalar(@half_a); $j += 1) {
			if ($anode eq $half_a[$j]) {
				$pot += $red_a[$j];
			}
		}
		for (my $j = 0; $j < scalar(@half_c); $j += 1) {
			if ($cathode eq $half_c[$j]) {
				$pot += $red_c[$j];
			}
		}
		$pot = sprintf("%.3f", $pot);
		print <<EOF;
		<form action="/~pfleming/cgi-bin/Electrochemistry.pl" method="post">
		<input type="hidden" name="assigned_salt" value="$assigned_salt">
		<input type="hidden" name="anode" value="$anode">
		<input type="hidden" name="cathode" value="$cathode">
		<input type="hidden" name="pot" value="$pot">
		<input type="hidden" name="control_1" value="PartD3">
		<table>
			<tr>
				<td>Your salt:</td> <td>$assigned_salt</td>
			</tr>
			<tr>
				<td>Your anode:</td> <td>$anode</td>
			</tr>
			<tr>
				<td>Your <font color="red">cathode</font>:</td> <td><font color="red">$cathode</font></td>
			</tr>
			<tr>
				<td>Measured Voltage:</td> <td>$pot V</td>
			</tr>
			<tr>
				<td>Your calculated K<sub>sp</sub>:</td> <td><input name="ksp_answer"></td>
			</tr>
		</table><br>
		<input type="submit" value="Am I right?">
		</form>
EOF
	} elsif ($flow eq 'PartD3') {
		my $assigned_salt = param('assigned_salt');
		my $anode = param('anode');
		my $cathode = param('cathode');
		my $pot = param('pot');
		my $ksp_answer = param('ksp_answer');
		print <<EOF;
		<h3>Results</h3>
		<table>
			<tr>
				<td>Your salt:</td> <td>$assigned_salt</td>
			</tr>
			<tr>
				<td>Your anode:</td> <td>$anode</td>
			</tr>
			<tr>
				<td>Your <font color="red">cathode</font>:</td> <td><font color="red">$cathode</font></td>
			</tr>
			<tr>
				<td>Measured Voltage:</td> <td>$pot V</td>
			</tr>
			<tr>
				<td>Your calculated K<sub>sp</sub>:</td> <td>$ksp_answer</td>
			</tr>
		</table><br>
EOF
		my $correct_ksp = 0;
		for (my $j = 0; $j < scalar(@salt); $j += 1) {
			if ($assigned_salt eq $salt[$j]) {
				$correct_ksp = $ksp[$j];
			}
		}
		if (abs(1 - $ksp_answer/$correct_ksp) < 0.1) {
			print "You are correct!<br>\n";
			print "Be sure to show your work on your laboratory report form!<br>\n";
		} else {
			print "You are incorrect.<br>\n";
		}
		
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


