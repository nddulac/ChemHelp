#!/usr/bin/perl -wT

# A Virtual Exercise: Determination of an Empirical Formula
# Patrick E. Fleming
# California State University, East Bay
# February 11, 2022 

# this virtual chloride experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
# use GD::Graph::lines;
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part

my @salt = (["NaCl",                         "Na", 22.990, 1, "Cl", 35.453, 1],
            ["NaBr",                         "Na", 22.990, 1, "Br", 79,904, 1],
            ["SnCl<sub>2</sub>",             "Sn", 118.71, 1, "Cl", 35.453, 2],
            ["SnCl<sub>4</sub>",             "Sn", 118.71, 1, "Cl", 35.453, 4],
            ["CoCl<sub>2</sub>",             "Co", 58.933, 1, "Cl", 35.453, 2],
            ["CoCl<sub>3</sub>",             "Co", 58.933, 1, "Cl", 35.453, 3],
            ["CuBr<sub>2</sub>",             "Cu", 63.546, 1, "Br", 79.990, 2],
            ["CuBr",                         "Cu", 63.546, 1, "Br", 79.990, 1],
            ["FeBr<sub>2</sub>",             "Fe", 55.845, 1, "Br", 79.990, 2],
            ["FeBr<sub>3</sub>",             "Fe", 55.845, 1, "Br", 79.990, 3],
            ["Fe<sub>2</sub>S<sub>3</sub>",  "Fe", 55.845, 2, "S",  32.06,  3],
            ["FeS",                          "Fe", 55.845, 1, "S",  32.06,  1],
            ["CrCl<sub>2</sub>",             "Cr", 51.996, 1, "Cl", 35.453, 2],
            ["MgCl<sub>3</sub>",             "Cr", 51.996, 1, "Cl", 35.453, 3],
            ["Cr<sub>2</sub>S<sub>3</sub>",  "Cr", 51.996, 2, "S",  32.06 , 3],
            ["CrS",                          "Cr", 51.996, 1, "S",  32.06 , 1],
            ["MgCl<sub>2</sub>",             "Mg", 24.305, 1, "Cl", 35.453, 2],
            ["MgBr<sub>2</sub>",             "Mg", 24.305, 1, "Br", 79.904, 2],
            ["Na<sub>2</sub>O",              "Na", 22.990, 2, "O",  16.00,  1],
            ["Na<sub>2</sub>S",              "Na", 22.990, 2, "S",  32.06,  1],
            ["MgO",                          "Mg", 24.305, 1, "O",  16.00,  1],
            ["MgS",                          "Mg", 24.305, 1, "S",  32.06,  1],
            ["Na<sub>3</sub>N",              "Na", 22.990, 3, "N",  14.007, 1],
            ["Mg<sub>3</sub>N<sub>2</sub>",  "Mg", 24.305, 3, "N",  14.007, 2],
            ["AlCl<sub>3</sub>",             "Al", 26.982, 1, "Cl", 35.453, 3],
            ["AlBr<sub>2</sub>",             "Al", 26.982, 1, "Br", 79.904, 3],
            ["Al<sub>2</sub>S<sub>3</sub>",  "Al", 26.982, 2, "N",  14.007, 3]);
####################################################################
# Salt indexes: 0: formula
#               1: metal
#               2: MW of metal
#               3: number of metals
#               4: nonmetal
#               5: MW of nonmetal
#               6: number of nonmetals
####################################################################

# Begin html output
print header;
print start_html("Empirical Formula");
print "<h1>Empirical Formula</h1>\n";

if ($flow eq 'data') {
	# pick a random salt from the list ad do some quick calculations
	my $isalt = int(random_value(0, scalar(@salt)));
	my $fw = $salt[$isalt][2] * $salt[$isalt][3] + $salt[$isalt][5] * $salt[$isalt][6];
	my $pct_met = sprintf("%.3f", ($salt[$isalt][2] * $salt[$isalt][3]) / $fw * 100);
	my $pct_nmt = sprintf("%.3f", ($salt[$isalt][5] * $salt[$isalt][6]) / $fw * 100);
	
	print <<EOF;
	<p>Your salt has the formula $salt[$isalt][1]<sub>x</sub>$salt[$isalt][4]<sub>y</sub>. Your job is to find the values of x and y.</p>
	<p>Data:</p>
	<form action="/~pfleming/cgi-bin/emForm.pl" method="post">
	<table border="2" cellpadding="2">
    <tr>
      <th bgcolor="ccccff"></th>
      <th bgcolor="ccccff">Metal</th>
      <th bgcolor="ccccff">Nonmetal</th>
    </tr>
    <tr>
      <td bgcolor="cccccc">Element</td>
      <td>$salt[$isalt][1]</td>
      <td>$salt[$isalt][4]</td>
    </tr>
    <tr>
      <td bgcolor="cccccc">Molar Mass (g/mol)</td>
      <td>$salt[$isalt][2]</td>
      <td>$salt[$isalt][5]</td>
    </tr>
    <tr>
      <td bgcolor="cccccc">% by mass</td>
      <td>$pct_met %</td>
      <td>$pct_nmt %</td>
    </tr>
    <tr>
      <td bgcolor-"ffcccc">Your answers:</td>
      <td>x = <input name="x"></td>
      <td>y = <input name="y"></td>
    </tr>
    <tr>
      <td colspan="3"><input type="submit" Value="Am I right?"><input type="reset" Value="Start over"></td>
    </tr>
	</table>
	<input type="hidden" name="isalt" value="$isalt">
	<input type="hidden" name="control_1" value="grade">
	</form>
EOF
} elsif ($flow eq 'grade') {
  # Read some paramters
  my $isalt = param('isalt');
  my $x = param('x');
  my $y = param('y');
	my $fw = $salt[$isalt][2] * $salt[$isalt][3] + $salt[$isalt][5] * $salt[$isalt][6];
	my $pct_met = sprintf("%.3f", ($salt[$isalt][2] * $salt[$isalt][3]) / $fw * 100);
	my $pct_nmt = sprintf("%.3f", ($salt[$isalt][5] * $salt[$isalt][6]) / $fw * 100);
  my $response = "<font color=\"red\">You are incorrect.</font>";
  if (($x eq $salt[$isalt][3]) and ($y eq $salt[$isalt][6])) {
    $response = "<font color=\"green\" size=\"+1\"><b>You are correct!</b></font>";
  }  
  print <<EOF;
	<p>Your salt has the formula $salt[$isalt][1]<sub>x</sub>$salt[$isalt][4]<sub>y</sub>. Your job is to find the values of x and y.</p>
	<p>Data:</p>
	<table border="2" cellpadding="2">
    <tr>
      <th bgcolor="ccccff"></th>
      <th bgcolor="ccccff">Metal</th>
      <th bgcolor="ccccff">Nonmetal</th>
    </tr>
    <tr>
      <td bgcolor="cccccc">Element</td>
      <td>$salt[$isalt][1]</td>
      <td>$salt[$isalt][4]</td>
    </tr>
    <tr>
      <td bgcolor="cccccc">Molar Mass (g/mol)</td>
      <td>$salt[$isalt][2]</td>
      <td>$salt[$isalt][5]</td>
    </tr>
    <tr>
      <td bgcolor="cccccc">% by mass</td>
      <td>$pct_met %</td>
      <td>$pct_nmt %</td>
    </tr>
    <tr>
      <td bgcolor="ccffcc">Your answers:</td>
      <td>x = $x</td>
      <td>y = $y</td>
    </tr>
    <tr>
      <td colspan="3">$response<br>Your salt is $salt[$isalt][0].</td>
    </tr>
	</table>
	<form action="/~pfleming/cgi-bin/emForm.pl" method="post">
	<input type="hidden" name="control_1" value="data">
	<input type="submit" value="Try another">
	</form>
	<nav>
        [<a href="/~pfleming/chem/111/chap03/index.htm">Chapter 3</a>]
        [<a href="/~pfleming/chem/111/index.htm">Chem 111</a>]
        [<a href="/~pfleming/chem/index.htm">Chemistry Help</a>]
	</nav>
EOF
} else {
  print "No section indicated. Run for your life!\n";
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

