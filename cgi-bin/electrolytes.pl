#!/usr/bin/perl -wT

# A Virtual Lab: Conductivity and Electrolytes
# Patrick E. Fleming
# California State University, East Bay
# January 25, 2021 

# this conductivity lab simulator is based on my own ridiculous
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
print start_html("Conductivity and Electrolytes");
print "<h1>Conductivity and Electrolytes</h1>\n";

my @solution = (["0.1 M HC<sub>2</sub>H<sub>3</sub>O<sub>2</sub", "weak"],
                ["0.1 M Al(NO<sub>3</sub>)<sub>3</sub>",          "strong"],
                ["0.1 M NH<sub>3</sub>",                          "weak"],
                ["saturated Ca(OH)<sub>2</sub>",                  "strong"],
                ["0.1 M Citric Acid",                             "weak"],
                ["0.1 M Cu(NO<sub>3</sub>)<sub>2</sub>",          "strong"],
                ["0.1 M CuSO<sub>4</sub>",                        "strong"],
                ["0.1 M ethanol",                                 "none"],
                ["0.1 M HCl",                                     "strong"],
                ["0.1 M FeCl<sub>3</sub>",                        "strong"],
                ["0.1 M FeSO<sub>4</sub>",                        "strong"],
                ["0.1 M isopropyl alcohol",                       "none"],
                ["saturated Mg(OH)<sub>2</sub>",                  "strong"],
                ["0.1 M MgSO<sub>4</sub>",                        "strong"],
                ["0.1 M HNO<sub>3</sub>",                         "strong"],
                ["0.1 M KI",                                      "strong"],
                ["0.1 M NaCl",                                    "strong"],
                ["0.1 M NaOH",                                    "strong"],
                ["0.1 M NaNO<sub>3</sub>",                        "strong"],
                ["0.1 M Na<sub>2</sub>SO<sub>4</sub>",            "strong"],
                ["0.1 M sucrose",                                 "none"]);
my $solutions = scalar(@solution);

if ($flow eq 'PartA') {
	my $contents = param('contents');
	if ($contents eq '') {
		$contents = 'empty';
	}
	my $reagent = param('reagent');
	if ($reagent ne '') {
		if ($contents eq 'empty') {
			$contents = 0;
		}
		if ($reagent eq 'water') {
			$contents = $contents + 100;
		}
		if ($reagent eq 'NaCl') {
			if (int($contents/10) - int($contents/100)*10 == 1) {
				print "<font color=\"red\">There is no need to add more than 0.2 g NaCl.</font><br>\n";
			} else {
				$contents = $contents + 10;
			}
		}
		if ($reagent eq 'CaCO3') {
			if ($contents - int($contents/10)*10 == 1) {
				print "<font color=\"red\">There is no need to add more than 0.2 g CaCO<sub>3</sub>.</font><br>\n";
			} else {
				$contents = $contents + 1;
			}
		}
	}
	if (int($contents/100) > 4) {
		print "<font color=\"red\">You have over-filled your beaker and made a mess. You must begin with a fresh beaker.</font><br>\n";
		$contents = 'empty';
	}
	
	print <<EOF;
	<h2>Part A</h2>
	<p>In order for a substance to conduct electricity, it must have 1) charged particles to carry charges, 
	and 2) those particles must have mobility so that they can move freely. In this part, you will measure 
	the conductivity of a couple of types of substances to see if they meet the criteria. You will then be asked
	to draw a meaningful conclusion based on what you have observed.</p>

	<table border="2">
	  <tr>
	    <td bgcolor="ffcccc"><font size="+1"><b><u>Contents</u></b></font></td>
	  </tr>
EOF
	my $beaker = '';
	my $cond = 'none';
	if (int($contents/100) != 0) {
		$beaker = 'water';
		if ($contents - int($contents/100)*100 > 0) {
			$beaker = $beaker . ', ';
		}
	}
	if (int($contents/10) - int($contents/100)*10 == 1) {
		$beaker = $beaker . 'NaCl';
		if ($contents - int($contents/10)*10 > 0) {
			$beaker = $beaker . ', ';
		}
	}
	if ($contents - int($contents/10)*10 == 1) {
		$beaker = $beaker . 'CaCO<sub>3</sub>';
	}
	if ((int($contents/10) - int($contents/100)*10 > 0) && (int($contents/100) > 0)) {
		$cond = "strong";
	}
	if ($contents eq 'empty') {
		print <<EOF;
	  <tr>
	    <td>Your beaker is empty.</td>
	  </tr>
	  <tr>
	    <td>Conductivity: none</td>
	  </tr>
	</table><p>
EOF
	} else {
		print <<EOF;
	  <tr>
	    <td>$beaker</td>
	  </tr>
	  <tr>
	    <td>Conductivity: $cond</td>
	  </tr>
	</table><p>
EOF
	}
	

	print <<EOF;
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	Select something to put into your 20 mL beaker:<br>
	<input type="radio" name="reagent" value="water"> 5.0 mL H<sub>2</sub>O<br>
	<input type="radio" name="reagent" value="NaCl"> 0.2 g NaCl(s)<br>
	<input type="radio" name="reagent" value="CaCO3"> 0.2 g CaCO<sub>3</sub><br>
	<input type="hidden" name="contents" value="$contents">
	<input type="hidden" name="control_1" value="PartA">
	<input type="submit" value="Add and Test">
	<input type="reset" value="Reset">
	</form>
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="contents" value="empty">
	<input type="hidden" name="control_1" value="PartA">
	<input type="submit" value="Start with a Fresh beaker">
	</form>
	<hr>
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="control_1" value="PartB">
	<input type="submit" value="Move on to Part B">
	</form>
	<hr>
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="control_1" value="PartC">
	<input type="submit" value="Move on to Part C">
	</form>
EOF
	
} elsif ($flow eq 'PartB') {
	my $sample = param('sample');
	
	print <<EOF;
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="control_1" value="PartA">
	<input type="submit" value="Move back to Part A">
	</form>
	<hr>
	<h2>Part B</h2>
	<p>In this part, you will observe the conductivity of several solutions. Based on the consudtivity, you will write a net ionic reaction for 
	the formation of an aqueous solution of the solute.</p>
	
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<table border="2">
	  <tr>
	    <td colspan="2" bgcolor="ffcccc"><b><u>Choose a solution</u></b>:</td>
	  </tr>
EOF
	for ($i=0; $i < $solutions; $i++) {
		print "		<tr>\n";
		print "		  <td><input type=\"radio\" name=\"sample\" value=\"$i\"></td>  <td>$solution[$i][0]</td>\n";
		print "		</tr>\n"
	}
	if ($sample ne '') {
		print "		  <tr>\n";
		print "		    <td bgcolor=\"ccffcc\">$solution[$sample][0]</td>  <td bgcolor=\"ccffcc\">Conductivity: $solution[$sample][1]</td>\n";
		print "		  </td>\n";
	}
	print <<EOF;
	</table>
	<input type="hidden" name="control_1" value="PartB">
	<input type="submit" value="Measure Conductivity">
	<input type="reset" value="Reset">
	</form>
	<hr>
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="control_1" value="PartC">
	<input type="submit" value="Move on to Part C">
	</form>
EOF
	
} elsif ($flow eq 'PartC') {
	my $sample = param('sample');
	my @test = (["2.0 mL 0.010 M Ba(OH)<sub>2</sub>", "strong"],
	            ["2.0 mL 0.010 M H<sub>2</sub>SO<sub>4</sub>", "strong"],
	            ["Mixture of above two solutions", "none"]);
	
	print <<EOF;
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="control_1" value="PartA">
	<input type="submit" value="Move back to Part A">
	</form>
	<hr>
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<input type="hidden" name="control_1" value="PartB">
	<input type="submit" value="Move back to Part B">
	</form>
	<hr>
	<h2>Part C</h2>
	<p>In this part, you will use conductivity to determine the effects of mixing two reactants. Based on your result, 
	suggest a reaction consistent with your observation, and construct a net ionic reaction.</p>
	
	<form action="/~pfleming/cgi-bin/electrolytes.pl" method="post">
	<table border="2">
	  <tr>
	    <td colspan="2" bgcolor="ffcccc"><font size="+1"><b>Solution</b></font></td>
	  <tr>
	  <tr>
	    <td><input type="radio" name="sample" value="0"></td>  <td>2.0 mL 0.010 M Ba(OH)<sub>2</sub></td>
	  </tr>
	  <tr>
	    <td><input type="radio" name="sample" value="1"></td>  <td>2.0 mL 0.010 M H<sub>2</sub>SO<sub>4</sub></td>
	  </tr>
	  <tr>
	    <td><input type="radio" name="sample" value="2"></td>  <td>Mixture of above two solutions</td>
	  </tr>
EOF
	if ($sample ne '') {
		print "	  <tr>\n";
		print "		<td bgcolor=\"ccffcc\">$test[$sample][0]</td>  <td bgcolor=\"ccffcc\">Conductivity: $test[$sample][1]";
	}
	if ($sample == 2) {
		print "<br>There is a white precipitate.";
	}
	print "    </td>\n";
	print "  </tr>\n";
	print <<EOF;
	</table>
	<input type="hidden" name="control_1" value="PartC">
	<input type="submit" value="Test the solution">
	<input type="reset" value="Reset">
	</form>
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

