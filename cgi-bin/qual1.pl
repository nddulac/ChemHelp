#!/usr/bin/perl -wT

# A Virtual Lab: Qual Scheme: group 1
# Patrick E. Fleming
# California State University, East Bay
# July 2, 2020 

# this virtual titration experiment is based on my own ridiculous
# notion that this was a good idea.

# This experiment is described at 
# https://chem.libretexts.org/Bookshelves/Ancillary_Materials/Laboratory_Experiments/Wet_Lab_Experiments/General_Chemistry_Labs/Online_Chemistry_Lab_Manual/Chem_12_Experiments/06%3A_Qualitative_Analysis_of_Group_I_Ions_(Experiment)

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part
my $i = 0;							# looping variable

# Begin html output
print header;
print start_html("Qualitative Analysis of Group 1 Cations");
print "<h1>Qualitative Analysis of Group 1 Cations</h1>\n";

if ($flow eq 'knowns') {
	print <<EOF;
	<h2>Create a known solution</h2>
	<form action="/~pfleming/cgi-bin/qual1.pl" method="post">
	Select the cations present in your solution:<br>
	<input type="checkbox" name="Ag" value="1">Ag<sup>+</sup><br>
	<input type="checkbox" name="Hg" value="1">Hg<sub>2</sub><sup>2+</sup><br>
	<input type="checkbox" name="Pb" value="1">Pb<sup>2+</sup><br>
	<input type="hidden" name="unknown" value="known">
	<input type="hidden" name="phase" value="fresh">
	<input type="hidden" name="control_1" value="test">
	<input type="submit" value="Generate my solution!">
	<input type="reset" value="Clear the form">
	</form>
EOF

} elsif ($flow eq 'unknown') {
	# Generate an unkown with at least one ion, as many as three
	my $unk = int(random_value(7, 1));
	
	# Here's the key:
	# 11 - Ag(NH3)2+,      Pb2+, Hg22+
	# 10 - Ag(NH3)2+,      Pb2+
	#  9 - Ag(NH3)2+,            Hg22+
	#  8 - Ag(NH3)2+
	#  7 -            Ag+, Pb2+, Hg22+
	#  6 -            Ag+, Pb2+
	#  5 -            Ag+,       Hg22+
	#  4 -            Ag+
	#  3 -                 Pb2+, Hg22+
	#  2 -                 Pb2+
	#  1 -                       Hg22+
	#  0 - no ions present

	print <<EOF;
	<h2>Create an unknown solution</h2>
	Your solution will contain one or more of the following ions:<br>
	Ag<sup>+</sup>, Hg<sub>2</sub><sup>2+</sup>, Pb<sup>2+</sup><br>
	<form action="/~pfleming/cgi-bin/qual1.pl" method="post">
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="phase" value="fresh">
	<input type="hidden" name="unknown" value="unknown">
	<input type="hidden" name="control_1" value="test">
	<input type="submit" value="Generate my solution!">
	</form>
EOF

} elsif ($flow eq 'test') {
	# parse input
	my $ag = param('Ag');
	my $pb = param('Pb');
	my $hg = param('Hg');
	my $unk = param('unk');						# which ions are present in solution
	my $unknown = param('unknown');				# is this a known or unknown solution?
	my $phase = param('phase');					# which phase is being tested
	my $solution = param('solution');			# what is in the solution
	my $precipitate = param('precipitate');		# what is in the precipitate
	my $reagent = param('reagent');				# which test is being performed
	
	if ($unk eq '') {
		# generate $unk from known selections
		if ($ag == 1) {
			$unk = 4;
		}
		if ($pb == 1) {
			$unk += 2;
		}
		if ($hg == 1) {
			$unk +=1;
		}
	}
	
	if ($phase eq 'fresh') {
		# this is a new solution so all cations are in the solution phase
		$solution = $unk;
		$precipitate = 0;
		$phase = "solution";
	} elsif ($phase eq 'solution') {
		$precipitate = 0;
	} elsif ($phase eq 'precipitate') {
		$solution = 0;
	} else {
		print "You must indicate which sample you are testing!<br>\n";
	}
	if (($reagent ne '') and ($phase ne '')) {
		#test the system
		if ($reagent eq '6 M HCl') {
			if ($solution >= 8) {
				$solution -= 4;								# break up the silver complex if present
			}
			if ($solution != 0) {
				$precipitate = $precipitate + $solution;	# move any solution ions to the precipitate
				$solution = 0;
			} else {
				print "You see no evidence of a reaction.<br>/n";
			}
			print "You see a white precipitate form.<br>\n";
		} elsif ($reagent eq 'Hot water') {
			# The only effect of hot water is to dissolve PbCl2
			if ($precipitate & 2) {
				$precipitate = $precipitate - 2;
				$solution = $solution + 2;
				print "Some precipitate dissolves.<br>\n";
			} else {
				print "You see no evidence of a reaction.<br>\n";
			} 
		} elsif ($reagent eq '6 M NH3') {
			# The effect of NH3 is to 1) dissolve AgCl, and 2) form Ag(NH3)+ in solution
			if ($precipitate & 4) {
				$precipitate = $precipitate - 4;
				$solution = $solution + 8;
				if ($precipitate == 0) {
					print "All of the precipitate dissolves.<br>\n";
				} else {
					print "Some of the precipitate dissolves.<br>\n";
				}
			}
			if ($precipitate & 1) {
				print "There is a gray preciptate remaining.<br>\n";
			}
			if ($solution & 4) {
				$solution = $solution + 4;
				if (~ $solution & 1) {
					print "You see no evidence of a reaction.<br>\n";
				}
			}
			if ($solution & 1) {
				print "A gray precipitate forms.<br>\n";
			}
		} elsif ($reagent eq 'chromate') {
			# chromate will precipitate pretty much all of the ions.
			# The user should start with a fresh sample after this test
			my $color = "";
			if ($solution & 13) {
				$color = "brown";
			}
			if ($solution & 2) {
				$color = "yellow";
			}
			if ($color ne '') {
				print "You see a $color pecipitate form.<br>\n";
			}
			if ($solution = 0) {
				print "You see no evidence of a reaction.<br>\n";
			}
			$solution = 0;
			$precipitate = 0;
			print "You must start with a fresh sample after this test.<br>\n";
		} elsif ($reagent eq '6 M HNO3') {
			# Nitric acid will break up the diamine silver I complex and reprecipitate AgCl
			if ($solution & 8) {
				print "You see a white precipitate form.</br>\n";
			} else {
				print "You see no evidence of a reaction.<br>\n";
			}
			$solution = 0;
			$precipitate = 0;
			print "You must start with a fresh sample after this test.<br>\n";
		}
	} else {
		if ($reagent eq '') {
			print "You must indicate your test reagent!<br>\n";
		}
	}
	
	print <<EOF;
	<hr>
	<form action="/~pfleming/cgi-bin/qual1.pl" method="post">
	Select the phase you wish to test:<br>
	<input type="radio" name="phase" value="fresh">Use a fresh sample of the original solution<br>
	<input type="radio" name="phase" value="solution">The solution following the previous step<br>
	<input type="radio" name="phase" value="precipitate">The precipitate following the previous step<br><br>
	Choose a test:<br>
	<input type="radio" name="reagent" value="6 M HCl">Add 6 M HCl, centefuge<br>
	<input type="radio" name="reagent" value="Hot water">Add hot water, centefuge<br>
	<input type="radio" name="reagent" value="6 M NH3">Add 6M NH<sub>3</sub>, centefuge<br>
	<input type="radio" name="reagent" value="chromate">Add CrO<sub>4</sub><sup>2-</sup><br>
	<input type="radio" name="reagent" value="6 M HNO3">Add 6 M HNO<sub>3</sub><br>
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="unknown" value="$unknown">
	<input type="hidden" name="solution" value="$solution">
	<input type="hidden" name="precipitate" value="$precipitate">
	<input type="hidden" name="control_1" value="test">
	<input type="submit" value="Perform the Test!">
	<input type="reset" value="Reset the form">
	</form>
	<hr>
EOF

	if ($unknown eq 'unknown') {
		print <<EOF;
	<h3>Grading</h3>
	<p>When you are ready to indetify the ions in your solution, choose in the form below:</p>
	<form action="/~pfleming/cgi-bin/qual1.pl" method="post">
	<input type="checkbox" name="Ag" value="1">Ag<sup>+</sup><br>
	<input type="checkbox" name="Pb" value="1">Pb<sup>2+</sup><br>
	<input type="checkbox" name="Hg" value="1">Hg<sub>2</sub><sup>2+</sup><br>
	<input type="hidden" name="unk" value="$unk">
	<input type="hidden" name="control_1" value="grade">
	<input type="submit" value="Am I right?">
	<input type="reset" value="Reset form">
	</form>
EOF
	}

} elsif ($flow eq 'grade') {
	# read some parameters
	my $Ag = param('Ag');
	my $Pb = param('Pb');
	my $Hg = param('Hg');
	my $unk = param('unk');
	my $unk_ans = 0;
	if ($Ag ==1) {
		$unk_ans += 4;
	}
	if ($Pb == 1) {
		$unk_ans += 2;
	}
	if ($Hg == 1) {
		$unk_ans += 1;
	}
	my $Ag_ans = "<font color=\"red\">You are incorrect.</font>";
	my $Pb_ans = "<font color=\"red\">You are incorrect.</font>";
	my $Hg_ans = "<font color=\"red\">You are incorrect.</font>";
	if (($unk & 4) and ($Ag eq "1")) {
		$Ag_ans = "<font color=\"green\">You are correct!</font>";
	}
	if ((~ $unk & 4) and ($Ag eq '')) {
		$Ag_ans = "<font color=\"green\">You are correct!</font>";
	}
	if (($unk & 2) and ($Pb eq "1")) {
		$Pb_ans = "<font color=\"green\">You are correct!</font>";
	}
	if ((~ $unk & 2) and ($Pb eq '')) {
		$Pb_ans = "<font color=\"green\">You are correct!</font>";
	}
	if (($unk & 1) and ($Hg eq "1")) {
		$Hg_ans = "<font color=\"green\">You are correct!</font>";
	}
	if ((~ $unk & 1) and ($Hg eq '')) {
		$Hg_ans = "<font color=\"green\">You are correct!</font>";
	}
	print "<h2>Grade</h2>\n";
	print "<table border=\"2\" cellpadding=\"2\">\n";
	print "<tr>\n";
	print "	<td colspan=\"3\" bgcolor=\"ffcccc\"><font size=\"+1\"><b>Results</b></font></td>\n";
	print "</tr>\n";
	print "<tr>\n";
	print "	<td>Ag<sup>+</sup></td>\n";
	if ($Ag == 1) {
		print " <td>You said it was present.</td>\n";
	} else {
		print " <td>You said it was not present.</td>\n";
	}
	print "	<td>$Ag_ans</td>\n";
	print "</tr>\n";
	print "<tr>\n";
	print "	<td>Pb<sup>2+</sup></td>\n";
	if ($Pb == 1) {
		print " <td>You said it was present.</td>\n";
	} else {
		print " <td>You said it was not present.</td>\n";
	}
	print "	<td>$Pb_ans</td>\n";
	print "</tr>\n";
	print "<tr>\n";
	print "	<td>Hg<sub>2</sub><sup>2+</sup></td>\n";
	if ($Hg == 1) {
		print " <td>You said it was present.</td>\n";
	} else {
		print " <td>You said it was not present.</td>\n";
	}
	print "	<td>$Hg_ans</td>\n";
	print "</tr>\n";
	print "</table>\n";
	
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

