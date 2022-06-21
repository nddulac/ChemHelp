#!/usr/bin/perl -wT

# A Virtual Lab: Determination of pKa for a weak acid
# Patrick E. Fleming
# California State University, East Bay
# June 11, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');						# Determines part
my $i = 0;											# looping variable

my $name = 0;
my $form = 1;
my $pKa = 2;
my $acid_mmass = 3;
my @acid = (["acetic acid",             "HOAc",     4.75,  60.05],
            ["lactic acid",             "HOLc",     3.86,  90.08],
            ["benzoic acid",            "HOBz",     4.20, 122.12],
            ["acetylsalicyilc acid",    "HOAsl",    3.48, 180.15],
            ["meta-aminobenzoic acid",  "m-HOABz",  4.78, 137.13],
            ["ortho-aminobenzoic acid", "o-HOABz",  6.97, 137.13],
            ["para-aminobenzoic acid",  "p-HOABz",  4.92, 137.13],
            ["meta-chlorobenzoic acid", "m-HOClBz", 3.82, 156.57],
            ["para-chlorobenzoic acid", "p-HOClBz", 3.98, 156.57],
            ["ortho-nitrobenzoic acid", "o-HONBz",  2.16, 167.12],
            ["phenylacetic acid",       "HOPAc",    4.25, 136.14]);

# Begin html output
print header;
print start_html("pKa Determination");
print "<h1>Determination of pK<sub>a</sub></h1>\n";

if ($flow eq 'calibrate') {
	print <<EOF;
	<h2>Calibration</h2>
	<form action="/~pfleming/cgi-bin/pKa1.1.pl" method="post">
	<select name="time">
		<option value="5"> 5 seconds</option>
		<option value="10">10 seconds</option>
		<option value="15">15 seconds</option>
		<option value="20">20 seconds</option>
		<option value="25">25 seconds</option>
		<option value="30">30 seconds</option>
		<option value="35">35 seconds</option>
		<option value="40">40 seconds</option>
		<option value="45">45 seconds</option>
		<option value="50">50 seconds</option>
		<option value="55">55 seconds</option>
		<option value="60">60 seconds</option>
	</select>
	<input type="hidden" name="control_1" value="continue">
	<input type="submit" value="Calibrate the Dropper!">
	</form>
EOF
	
	
} elsif ($flow eq 'continue') {
	# Read parameters
	my $time = param('time');
	
	my $n_drops = int(5.31/9.79 * random_value(4.7, 3.1) * $time);
	my $mass = sprintf("%.4f", 1/18 * $n_drops);
	my $vol_rate = $mass / $time;
	
	print <<EOF;
	<h2>Titration</h2>
	You chose to calibrate for $time seconds.<br>
	You count $n_drops drops of water in that time.<br>
	You measure a mass of $mass g.<br>
	<p><form action="/~pfleming/cgi-bin/pKa1.1.pl" method="post">
	<input type="hidden" name="control_1" value="calibrate">
	<input type="submit" value="Repeat the calibration">
	</form></p>
	<p><form action="/~pfleming/cgi-bin/pKa1.1.pl" method="post">
	<p>For how long would you liek to run the titration?<br>
	<input name="tit_time"> sec</p>
	<input type="hidden" name="time" value="$time">
	<input type="hidden" name="n_drops" value="$n_drops">
	<input type="hidden" name="mass" value="$mass">
	<input type="hidden" name="control_1" value="titrate">
	<input type="submit" value="Perform the titration!">
	</form></p>
EOF
	
} elsif ($flow eq 'titrate') {
	# read parameters
	my $tit_time = param('tit_time');
	my $time = param('time');
	my $n_drops = param('n_drops');
	my $mass = param('mass');
	
	# Use this info to calculate titration vaariables
	my $vol_rate = $mass / $time;		# mL/sec at which base is delivered
	
	my $unknown = int(random_value(scalar(@acid),0));
	my $acid_conc = sprintf("%.4f", random_value(0.12, 0.09));
	my $base_conc = sprintf("%.4f", random_value(0.12, 0.09));
	my @pH = (0) x $tit_time;
	my @vol_tot = (0) x $tit_time;
	my $acid_mass_used = sprintf("%.4f", $acid_conc * 0.1 * $acid[$unknown][$acid_mmass]);
	
	my $answer1 = ($acid_conc * 10 / $base_conc);
	my $answer2 = ($acid_conc * 0.100);
	print <<EOF;
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc" colspan="2"><font size="+1"><b>Initial Data</b></font></td>
		</tr>
		<tr>
			<td>Your Acid ($acid[$unknown][$name])</td> <td>$acid[$unknown][$form]</td>
		</tr>
		<tr>
			<td>Mass of acid disolved in 100.00 mL</td> <td>$acid_mass_used g</td>
		</tr>
		<tr>
			<td>Acid Solution Volume Used in Titration</td> <td>10.00 mL</td>
		</tr>
		<tr>
			<td>Base Concentration</td> <td>$base_conc M</td>
		</tr>
	</table></p>
	
	<form action="/~pfleming/cgi-bin/pKa1.1.pl" method="post">
	<p><table border="2" cellpadding"2">
		<tr>
			<td bgcolor="ffcccc" colspan="2"><font size="+1"><b>Calculations</b></font></td>
		</tr>
		<tr>
			<td>Volume of base at endpoint</td>
			<td><input name="base_vol_ans"> mL</td>
		</tr>
		<tr>
			<td>Concetration of acid solution</td>
			<td><input name="conc_acid_ans"> M</td>
		</tr>
		<tr>
			<td>Moles of acid in 100.0 mL</td>
			<td><input name="mol_acid_ans"> mol</td>
		</tr>
		<tr>
			<td>Molar mass acid</td>
			<td><input name="mmass_acid_ans"> g/mol</td>
		</tr>
		<tr>
			<td>pK<sub>a</sub> of acid</td>
			<td><input name="pKa_acid_ans"></td>
		</tr>
	</table></p>
	<input type="hidden" name="base_vol" value="$answer1">
	<input type="hidden" name="conc_acid" value="$acid_conc">
	<input type="hidden" name="mol_acid" value="$answer2">
	<input type="hidden" name="mmass_acid" value="$acid[$unknown][$acid_mmass]">
	<input type="hidden" name="pKa_acid" value="$acid[$unknown][$pKa]">
	<input type="hidden" name="control_1" value="grade">
	<input type="submit" value="Am I right?">
	</form>
EOF
	
	# Now for the titration proper
	for ($i=0; $i <= $tit_time; $i += 1) {
		my $acid_mmol = $acid_conc * 10;	# use 10 mL of acid solution
		my $base_mmol = $base_conc * $vol_rate * $i;
		my $Ka = 10**(-$acid[$unknown][$pKa]);
		my $Kb = 1E-14 / 10**(-$acid[$unknown][$pKa]);
		my ($a, $b, $c);
		my @x;
		$vol_tot[$i] = sprintf("%.2f", 10 + ($i * $vol_rate));
		
		if ($base_mmol == 0) {
			# Region 1 - no base added

			# x is small method
			# $pH[$i] = sprintf("%.2f", -log10(sqrt($acid_conc * $Ka)));
			
			# Quadraic Method
			$a = 1;
			$b = $Ka;
			$c = -$acid_conc * $Ka;
			@x = quadratic($a, $b, $c);
			$pH[$i] = sprintf("%.2f", -log10($x[0]));

		} elsif ($base_mmol < $acid_mmol) {
			# Region 2 - some base added (buffer)

			# Quadratic equation mothod
			$a = 1;
			$b = $base_mmol + $Ka * $vol_tot[$i];
			$c = -$Ka * $vol_tot[$i] * ($acid_mmol - $base_mmol);
			@x = quadratic($a, $b, $c);
			$pH[$i] = sprintf("%.2f", -log10($x[0]));
			
			# "X is small" method
			# my $x = $Ka * $vol_tot[$i] * ($acid_mmol - $base_mmol) / $base_mmol;
			# $pH[$i] = sprintf("%.2f", -log10($x));
			
			# Henderson-Hasselbalch method
			# $pH[$i] = sprintf("%.2f", $acid[$unknown][$pKa] + log10($base_mmol/($acid_mmol - $base_mmol)));;

		} elsif ($base_mmol == $acid_mmol) {
			# Region 3 - Equivalence point
			my $OH_conc = sqrt(($base_mmol/$vol_tot[$i]) * $Kb);
			$pH[$i] = sprintf("%.2f", 14 + log10($OH_conc));

		} else {
			# Region 4 - Excess base
			my $OH_conc = ($base_mmol - $acid_mmol)/$vol_tot[$i];
			$pH[$i] = sprintf("%.2f", 14 + log10($OH_conc));
		}
	}
	
=for comment
	# Now, let's create a graph
	my @data = ([@vol_tot],
	            [@pH]);
	my $mygraph = GD::Graph::lines->new(600, 300);
	$mygraph->set(
		x_label     => 'Total Volume (mL)',
		y_label     => 'pH',
		title       => 'Titration of $acid[$unknown][0] with NaOH',
    
		# Draw datasets in 'solid', 'dashed' and 'dotted-dashed' lines
		line_types  => 1,
    
		# Set the thickness of line
		line_width  => 2,
		
		# Set colors for datasets
		dclrs       => 'blue',
		
	) or warn $mygraph->error;
	
	my $myimage = $mygraph->plot(\@data) or die $mygraph->error;
	print "Content-type: image/png\n\n";
	print $myimage->png;
=cut
	
	# Now, print the results
	print <<EOF;
	<h2>Titration Data</h2>
	<p><table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Time (sec)</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Volume of Base (mL)</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>pH</b></font></td>
		</tr>
EOF
	for ($i=0; $i <= $tit_time; $i +=1) {
		my $Vb = sprintf("%.2f", $vol_tot[$i] - 10);
		print "		<tr>\n";
		print "			<td>$i</td> <td>$Vb</td> <td>$pH[$i]</td>\n";
		print "		</tr>\n";
	}
	print "	</table></p>\n";
	
} elsif ($flow eq 'grade') {
	# Read parameters
	my $base_vol = param('base_vol');
	my $conc_acid = param('conc_acid');
	my $mol_acid = param('mol_acid');
	my $mmass_acid = param('mmass_acid');
	my $pKa_acid = param('pKa_acid');
	my $base_vol_ans = param('base_vol_ans');
	my $conc_acid_ans = param('conc_acid_ans');
	my $mol_acid_ans = param('mol_acid_ans');
	my $mmass_acid_ans = param('mmass_acid_ans');
	my $pKa_acid_ans = param('pKa_acid_ans');
	
	my $response_1 = '';
	my $response_2 = '';
	my $response_3 = '';
	my $response_4 = '';
	my $response_5 = '';
	
	if (abs($base_vol - $base_vol_ans)/$base_vol < 0.02) {
		$response_1 = "<font color=\"green\">You are correct!</font>"
	} else {
		$response_1 = "<font color=\"red\">You are incorrect.</font>"
	}
	if (abs($conc_acid - $conc_acid_ans)/$conc_acid < 0.02) {
		$response_2 = "<font color=\"green\">You are correct!</font>"
	} else {
		$response_2 = "<font color=\"red\">You are incorrect.</font>"
	}
	if (abs($mol_acid - $mol_acid_ans)/$mol_acid < 0.02) {
		$response_3 = "<font color=\"green\">You are correct!</font>"
	} else {
		$response_3 = "<font color=\"red\">You are incorrect.</font>"
	}
	if (abs($mmass_acid - $mmass_acid_ans)/$mmass_acid < 0.02) {
		$response_4 = "<font color=\"green\">You are correct!</font>"
	} else {
		$response_4 = "<font color=\"red\">You are incorrect.</font>"
	}
	if (abs($pKa_acid - $pKa_acid_ans) < 0.02) {
		$response_5 = "<font color=\"green\">You are correct!</font>"
	} else {
		$response_5 = "<font color=\"red\">You are incorrect.</font>"
	}

	print <<EOF;
	<p><table border="2" cellpadding"2">
		<tr>
			<td bgcolor="ffcccc" colspan="3"><font size="+1"><b>Calculations</b></font></td>
		</tr>
		<tr>
			<td>Volume of base at endpoint</td>
			<td>$base_vol_ans mL</td>
			<td>$response_1</td>
		</tr>
		<tr>
			<td>Concetration of acid solution</td>
			<td>$conc_acid_ans M</td>
			<td>$response_2</td>
		</tr>
		<tr>
			<td>Moles of acid in 100.0 mL</td>
			<td>$mol_acid_ans mol</td>
			<td>$response_3</td>
		</tr>
		<tr>
			<td>Molar mass acid</td>
			<td>$mmass_acid_ans g/mol</td>
			<td>$response_4</td>
		</tr>
		<tr>
			<td>pK<sub>a</sub> of acid</td>
			<td>$pKa_acid_ans</td>
			<td>$response_5</td>
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

sub random_value {
	my ($max, $min) = @_;
	return rand(1) * ($max - $min) + $min;
}

sub log10 {
	my $x = $_;
	return log($x)/log(10);
}

sub quadratic {
	my ($a, $b, $c) = @_;
	my $root = sqrt($b*$b - 4*$a*$c);
	my $x1 = (-$b + $root)/(2*$a);
	my $x2 = (-$b - $root)/(2*$a);
	return ($x1, $x2);
}
