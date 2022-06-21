#!/usr/bin/perl -wT

# A simple question-response script for simple quiz questions
# Patrick E. Fleming
# California State University, East Bay
# May 1, 2019 (Jonathan Coulton says, "It's the first of May . . ")

# this virtual Nuclear Laboratory is based on the excelent simulation at
# https://www.uccs.edu/vgcl/nuclear-chemistry/experiment-2-types-of-radiation

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# Set some parameters
my @nuclides = ( "<sup>59</sup>Fe","<sup>67</sup>Ga", "<sup>125</sup>I", "<sup>32</sup>P", "<sup>222</sup>Rn", "<sup>85</sup>Sr", "none" );
my @shields = ( "none", "paper", "1 mm cardboard", "1 mm aluminum", "1 mm lead" );
my @matrix = (
	[79, 74, 34, 7, 0.9],
	[1000, 1000, 1000, 1000, 820],
	[29, 29, 29, 29, 24],
	[510, 470, 200, 40, 0.9],
	[250, 0.9, 0.9, 0.9, 0.9],
	[40, 40, 40, 40, 34],
	[0, 0, 0, 0, 0]
); 

# parse the form:
# my %form;
my $nuc = param('nuclide');
my $shi = param('shield');
my $burl = param('burl');
my $counts = (100 - 10 * rand()) * $matrix[$nuc][$shi] / 100;
# round
$counts = int($counts * 100 + 0.5) / 100;

print header;
print start_html("Virtual Nuclear Lab");

print "<h1>Virtual Geiger counter Measurement</h1>\n";

print "Nuclide: $nuclides[$nuc] <br>\n";
print "Shielding: $shields[$shi] <br>\n";
print "<p>The Gieger counter reads:";
print " $counts ";
print " counts per second.<p>\n";

print "<hr>Return to the <a href=\" $burl \">Virtual Nuclear Laboratory</a>\n";


print end_html;