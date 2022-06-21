#!/usr/bin/perl -wT

# A simple question-response script for simple quiz questions
# Patrick E. Fleming
# California State University, East Bay
# May 1, 2019 (Jonathan Coulton says, "It's the first of May . . ")

# this virtual Nuclear Laboratory is based on the excelent simulation at
# https://www.uccs.edu/vgcl/nuclear-chemistry/

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# Set some parameters

# parse the form:
# my %form;
my $dis = param('distance');
my $burl = param('burl');

my $counts = (1 - rand() / 20) * (1000 / $dis ** 2);
# round
$counts = int($counts * 100 + 0.5) / 100;

print header;
print start_html("Virtual Nuclear Lab");

print "<h1>Virtual Geiger Counter Measurement</h1>\n";

print "Nuclide: <sup>67</sup>Ga <br>\n";
print "Distance: $dis cm<br>\n";
print "<p>The Gieger counter reads:";
print " $counts ";
print " counts per second.<p>\n";

print "<hr>Return to the <a href=\" $burl \">Virtual Nuclear Laboratory</a>\n";


print end_html;