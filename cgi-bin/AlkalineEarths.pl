#!/usr/bin/perl -wT

# A Virtual Lab: Alkaline Earths and Halogens
# Patrick E. Fleming
# California State University, East Bay
# May 31, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');						# Determines part
my $i = 0;										# looping variable
my @metal = ("Ba(NO<sub>3</sub>)<sub>2</sub>", "Ca(NO<sub>3</sub>)<sub>2</sub>", "Mg(NO<sub>3</sub>)<sub>2</sub>", "Sr(NO<sub>3</sub>)<sub>2</sub>");
my @test_anion = ("H<sub>2</sub>SO<sub>4</sub>", "Na<sub>2</sub>CO<sub>3</sub>", "(NH<sub>4</sub>)<sub>2</sub>C<sub>2</sub>O<sub>4</sub>", "KIO<sub>3</sub>");
my @halogen = ("Cl<sub>2</sub>", "Br<sub>2</sub>", "I<sub>2</sub>");
my @halide = ("NaCl", "NaBr", "NaI");
my @precipitate =(["P", "P", "P", "P"],
                  ["NR", "P", "P", "NR"],
                  ["NR", "P", "NR", "NR"],
                  ["P", "P", "P", "NR"]);
my @extract = (["<font color=\"gray\">colorless</font>", "<font color=\"brown\">brown</font>",   "<font color=\"purple\">purple</font>"],
               ["<font color=\"brown\">brown</font>",    "<font color=\"brown\">brown</font>",   "<font color=\"purple\">purple</font>"],
               ["<font color=\"purple\">purple</font>",  "<font color=\"purple\">purple</font>", "<font color=\"purple\">purple</font>"]);
my @unknown = (["BaCl<sub>2</sub>", "CaCl<sub>2</sub>", "MgCl<sub>2</sub>", "SrCl<sub>2</sub>"], 
               ["BaBr<sub>2</sub>", "CaBr<sub>2</sub>", "MgBr<sub>2</sub>", "SrBr<sub>2</sub>"],
               ["BaI<sub>2</sub>",  "CaI<sub>2</sub>",  "MgI<sub>2</sub>",  "SrI<sub>2</sub>"]);

# Begin html output
print header;
print start_html("The Alkaline Earth Metals and the Halogens");
print "<h1>The Alkaline Earth Metals and the Halogens</h1>\n";

if ($flow eq 'PartA') {
	print <<EOF;
	<h2>Part A - Reactivity of Alkaline Earth Metal Ions</h2>
	<p>In this part, you will test combinations of known group IIA cations (Ba<sup>2+</sup>, 
	Ca<sup>2+</sup>, Mg<sup>2+</sup>, and St<sup>2+</sup>) with a set of anion sources (1 M H<sub>2</sub>SO<sub>4</sub>,
	1 M Na<sub>2</sub>CO<sub>3</sub>, 0.25 M (NH<sub>4</sub>)<sub>2</sub>C<sub>2</sub>O<sub>4</sub>, and 0.1 M KNO<sub>3</sub>)
	in order to determine reactivitiy paterns. You will then use this information to guide you though Part C of the experiment.</p>
	<form action="/~pfleming/cgi-bin/AlkalineEarths.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Known Cation Source</b></form></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Test Anion Reagent</b></form></td>
		</tr>
		<tr>
			<td>
				<input type="radio" name="cation" value="0">0.1 M Ba(NO<sub>3</sub>)<sub>2</sub><br>
				<input type="radio" name="cation" value="1">0.1 M Ca(NO<sub>3</sub>)<sub>2</sub><br>
				<input type="radio" name="cation" value="2">0.1 M Mg(NO<sub>3</sub>)<sub>2</sub><br>
				<input type="radio" name="cation" value="3">0.1 M Sr(NO<sub>3</sub>)<sub>2</sub><br>
			</td>
			<td>
				<input type="radio" name="anion" value="0">1 M H<sub>2</sub>SO<sub>4</sub><br>
				<input type="radio" name="anion" value="1">1 M Na<sub>2</sub>CO<sub>3</sub><br>
				<input type="radio" name="anion" value="2">0.25 M (NH<sub>4</sub>)<sub>2</sub>C<sub>2</sub>O<sub>4</sub><br>
				<input type="radio" name="anion" value="3">0.1 M KIO<sub>3</sub><br>
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="Test these reagents!"></td> 
			<td><input type="reset" value="Start over"></td>
		</tr>
	</table>
	<input type="hidden" name="control_1" value="PartA2">
	</form>
EOF
} elsif ($flow eq 'PartA2') {
	# read form inputs
	my $cation = param('cation');
	my $anion = param('anion');
	
	print "<h2>Part A - Reactivity of Alkaline Earth Metal Ions</h2>\n";
	print "<p>You chose to test $metal[$cation] with $test_anion[$anion].</p>\n";
	if ($precipitate[$cation][$anion] eq 'P') {
		print "<p>You see a white precipitate form.</p>\n";
	} else {
		print "<p>You see no evidence of reaction.</p>\n";
	}

} elsif ($flow eq 'PartB') {
	print <<EOF;
	<h2>Part B - Reactivity of the Halgens</h2>
	<form action="/~pfleming/cgi-bin/AlkalineEarths.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Known Halide Source</b></form></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Known Halogen Reagent</b></form></td>
		</tr>
		<tr>
			<td>
				<input type="radio" name="test_halide" value="0">NaCl<br>
				<input type="radio" name="test_halide" value="1">NaBr<br>
				<input type="radio" name="test_halide" value="2">NaI<br>
			</td>
			<td>
				<input type="radio" name="test_halogen" value="0">Cl<sub>2</sub><br>
				<input type="radio" name="test_halogen" value="1">Br<sub>2</sub><br>
				<input type="radio" name="test_halogen" value="2">I<sub>2</sub><br>
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="Test these reagents!"></td> 
			<td><input type="reset" value="Start over"></td>
		</tr>
	</table>
	<input type="hidden" name="control_1" value="PartB2">
	</form>
EOF
} elsif ($flow eq 'PartB2') {
	# read form inputs
	my $test_halogen = param('test_halogen');
	my $test_halide = param('test_halide');
	
	print "<h2>Part B - Reactivity of the Halgens</h2>\n";
	print "<p>You chose to test $halide[$test_halide] with $halogen[$test_halogen].</p>\n";
	print "<p>After mixing the reagents and extracting the residual halgen into hexane, ";
	print "the hexane layer is $extract[$test_halide][$test_halogen].</p>\n";

} elsif ($flow eq 'PartC') {
	# Make up a random string to "identify" the unknown
	my $unk_id = 20000 + int(rand(1)*1000);

	# Assign the unkown now!
	my $unk_cation = int(random_value(3,0)+0.5);
	my $unk_halide = int(random_value(2,0)+0.5);

	print <<EOF;
	<h2>Part C - Identify an unknown cation</h2>
	<p>In this part, you will identify an known cation using tests
	from Part A of this experiment. You shoudl be able to deduce the
	identy of your unknown cation using only two reagents. In order to 
	do this, you must use the results from your first test to inform which
	reagent you will use for the second test.</p>

	<form action="/~pfleming/cgi-bin/AlkalineEarths.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Your unknown</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Choose a reagent</b></font></td>
		</tr>
		<tr>
			<td>#$unk_id</td>
			<td>
				<input type="radio" name="anion" value="0">1 M H<sub>2</sub>SO<sub>4</sub><br>
				<input type="radio" name="anion" value="1">1 M Na<sub>2</sub>CO<sub>3</sub><br>
				<input type="radio" name="anion" value="2">0.25 M (NH<sub>4</sub>)<sub>2</sub>C<sub>2</sub>O<sub>4</sub><br>
				<input type="radio" name="anion" value="3">0.1 M KIO<sub>3</sub><br>
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="Test my Unknown!"></td>
			<td><input type="reset" value="Clear choice"></td>
		</tr>
	</table>
	<input type="hidden" name="unk_id" value="$unk_id">
	<input type="hidden" name="unk_cation" value="$unk_cation">
	<input type="hidden" name="unk_halide" value="$unk_halide">
	<input type="hidden" name="control_1" value="PartC2">
	</form>
EOF

} elsif ($flow eq 'PartC2') {
	#Parse inputs
	my $unk_id = param('unk_id');
	my $unk_cation = param('unk_cation');
	my $unk_halide = param('unk_halide');
	my $anion = param('anion');
	
	print "<h2>Part C - Identify an unknown cation</h2>\n";
	print "<p>You tested your unknown with $test_anion[$anion].<p>\n";
	if ($precipitate[$unk_cation][$anion] eq "P") {
		print "<p>You see a precipitate form.</p>\n";
	} else {
		print "<p>You see no evidence of a reaction.</p>\n";
	}
	print <<EOF;
	<hr>
	<p>Now, based on the results of the test you just did, which reagent would you liek to use now?</p>
	
	<form action="/~pfleming/cgi-bin/AlkalineEarths.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Your unknown</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Choose a reagent</b></font></td>
		</tr>
		<tr>
			<td>#$unk_id</td>
			<td>
				<input type="radio" name="anion" value="0">1 M H<sub>2</sub>SO<sub>4</sub><br>
				<input type="radio" name="anion" value="1">1 M Na<sub>2</sub>CO<sub>3</sub><br>
				<input type="radio" name="anion" value="2">0.25 M (NH<sub>4</sub>)<sub>2</sub>C<sub>2</sub>O<sub>4</sub><br>
				<input type="radio" name="anion" value="3">0.1 M KIO<sub>3</sub><br>
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="Test my Unknown!"></td>
			<td><input type="reset" value="Clear choice"></td>
		</tr>
	</table>
	<input type="hidden" name="unk_id" value="$unk_id">
	<input type="hidden" name="unk_cation" value="$unk_cation">
	<input type="hidden" name="unk_halide" value="$unk_halide">
	<input type="hidden" name="control_1" value="PartC2">
	</form>
	<hr>
	<p>When you have a handle on which cation you have, you can move on to Part D, and determine the identity of your anion.</p>
	<form action="/~pfleming/cgi-bin/AlkalineEarths.pl" method="post">
	<input type="hidden" name="unk_id" value="$unk_id">
	<input type="hidden" name="unk_cation" value="$unk_cation">
	<input type="hidden" name="unk_halide" value="$unk_halide">
	<input type="hidden" name="control_1" value="PartD">
	<input type="submit" value="I am ready to move on to Part D">
	</form>
	
EOF

} elsif ($flow eq 'PartD') {
	#Parse inputs
	my $unk_id = param('unk_id');
	my $unk_cation = param('unk_cation');
	my $unk_halide = param('unk_halide');
	
	print <<EOF;
	<h2>Part D - Identify an unknown halide</h2>
	<p> In this part, you wilk identify the halide anion on your unknown compound. If you paid close attention to the 
	results of Part B, you can do this with a single test!</p>
	
	<form action="/~pfleming/cgi-bin/AlkalineEarths.pl" method="post">
	<table border="2" cellpadding="2">
		<tr>
			<td bgcolor="ccffcc"><font size="+1"><b>Your unknown</b></font></td>
			<td bgcolor="ccffcc"><font size="+1"><b>Choose a reagent</b></font></td>
		</tr>
		<tr>
			<td>#$unk_id</td>
			<td>
				<input type="radio" name="test_halogen" value="0">Cl<sub>2</sub><br>
				<input type="radio" name="test_halogen" value="1">Br<sub>2</sub><br>
				<input type="radio" name="test_halogen" value="2">I<sub>2</sub><br>
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="Test my Unknown!"></td>
			<td><input type="reset" value="Clear choice"></td>
		</tr>
	</table>
	<input type="hidden" name="unk_id" value="$unk_id">
	<input type="hidden" name="unk_cation" value="$unk_cation">
	<input type="hidden" name="unk_halide" value="$unk_halide">
	<input type="hidden" name="control_1" value="PartD2">
	</form>
EOF

} elsif ($flow eq 'PartD2') {
	my $unk_id = param('unk_id');
	my $unk_cation = param('unk_cation');
	my $unk_halide = param('unk_halide');
	my $test_halogen = param('test_halogen');
	
	print "<h2>Part D - Identify an unknown halide</h2>\n";
	print "<p>You chose to test your unkown with $halogen[$test_halogen].</p>\n";
	print "<p>After mixing the reagents and extracting the residual halgen into hexane, ";
	print "the hexane layer is $extract[$unk_halide][$test_halogen].</p>\n";
	
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
	return (rand(1) * ($max - $min) + $min);
}
