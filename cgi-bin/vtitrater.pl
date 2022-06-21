#!/usr/bin/perl -wT

# A virtual titrater
# Patrick E. Fleming
# December 16, 2015

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the form:
my $branch = param('branch');
my $macid = param('macid');
my $mmacid = param('mmacid');
my $cbase = param('cbase');
my $vbase = param('vbase');
my $vadded = param('vadded');

print header;
print start_html("Virtual Titrater");
print h2("Virtual Titrator"),"\n";

if ($branch eq "") {
  # Begin by setting things up
  print "<div name=\"decorate\">\n";
  print "<img src=\"/~pfleming/chem/titrate/sn1setup.gif\" align=\"right\">\n";   # Let's decorate the place
  print "</div>\n";
  my $mKHP = 204.23;                                                 # molar mass (g/mol)
  my $macid = int((rand(0.2)+0.7)*10000+0.5)/10000;                  # mass of KHP (g)
  my $cbase = int((rand(0.01)+0.19)*10000+0.5)/10000;                # conc. base (M)
  my $mmacid = $macid/$mKHP*1000;                                    # mmol of acid
  my $vbase = 0;                                                     # volume of base added
  #-----------------------------------------------------------------------------
  print "<form action=\"/~pfleming/cgi-bin/vtitrater.pl\" method=\"post\">\n";
  print "<input type=\"hidden\" name=\"macid\" value=\"$macid\">\n";
  print "<input type=\"hidden\" name=\"mmacid\" value=\"$mmacid\">\n";
  print "<input type=\"hidden\" name=\"cbase\" value=\"$cbase\">\n";
  print "<input type=\"hidden\" name=\"vbase\" value=\"$vbase\">\n";
  print "<input type=\"hidden\" name=\"branch\" value=\"continue\">\n";
  my $avbase = int($mmacid/0.2*100+0.5)/100;
  print "You have used $macid g of KHP. If the NaOH concentration is 0.2 M, you will need $avbase mL of base.<p>\n";
  print "How many mL would you like to add?<br>\n";
  print "<input type=\"input\" name=\"vadded\" autofocus> mL<br>\n";
  print "<input type=\"submit\" value=\"Titrate!\">\n";
  print "</form>\n";
  #-----------------------------------------------------------------------------
} 
if ($branch eq "continue") {
  # Continue the titration
  $vbase = $vbase + $vadded;
  print "You have added <u> $vbase mL</u> of base.<p>\n";
  if ($vbase * $cbase > $mmacid) {
    #You have passed the endpoint, so give the results
    print "<img src=\"/~pfleming/chem/titrate/endpoint.jpg\" height=\"300\" width=\"500\"><p>\n";   # replace with endpoint.gif or over.gif
    print "You have passed the endpoint.<br>\n";
    my $vused = 0;
    if ($vbase = $vadded) {
      $vused = $vbase;
    } else {
      $vused = $vbase-$vadded;
    }
    my $calc = int($mmacid/$vused*10000+0.5)/10000;
    $mmacid = int($mmacid*10000+0.5)/10000;
    print "\nResults\n";
    print "<pre>\n";
    print "-----------------------------------------------------------\n";
    print "Amount of acid used : $macid g\n";
    print "                    : $mmacid mmol\n";
    print "Volume of base used : $vused mL (last volume before endpoint)\n\n";
    print "Calculated [base] = $calc M.\n";
    print "    Actual [base] = $cbase M.\n";
    print "-----------------------------------------------------------\n";
    print "</pre><p>\n";
    print "Would you like to try <a href=\"/~pfleming/cgi-bin/vtitrater.pl\">another titration<a>?\n";
    print "Would you like to return to the <a href=\"/~pfleming/chem/\">Chemistry Help</a> page?\n";
  }
  if ($vbase * $cbase <= $mmacid) {
    #You not yet reached the endpoint
    print "You are short of the endpoint.<p>\n";
    print "<img src=\"/~pfleming/chem/titrate/close.gif\"><br>\n";   # replace with under.gif
    if ($vbase*$cbase > 0.98 * $mmacid) {
      print "<b>You are very close to the end point.</b><p>\n";
    }
    #-----------------------------------------------------------------------------
    print "<form action=\"/~pfleming/cgi-bin/vtitrater.pl\" method=\"post\">\n";
    print "<input type=\"hidden\" name=\"macid\" value=\"$macid\">\n";
    print "<input type=\"hidden\" name=\"mmacid\" value=\"$mmacid\">\n";
    print "<input type=\"hidden\" name=\"cbase\" value=\"$cbase\">\n";
    print "<input type=\"hidden\" name=\"vbase\" value=\"$vbase\">\n";
    print "<input type=\"hidden\" name=\"branch\" value=\"continue\">\n";
    print "How many mL would you like to add?<br>\n";
    print "<input type=\"input\" name=\"vadded\" autofocus> mL<br>\n";
    print "<input type=\"submit\" value=\"Titrate!\">\n";
    print "</form>\n";
    #-----------------------------------------------------------------------------
  }
  
}
if ($branch ne "" && $branch ne "continue") {
  print "<a hreg=/~pfleming/>Get outta here!</a>\n";
}

print "<div name=\"sig\">\n";
print "<hr>\n";
print "Patrick E. Fleming<br>\n";
print "Department of Chemistry and Biochemistry<br>\n";
print "California State University, East Bay<br>\n";
print "<a href=\"mailto:patrick.fleming\@csueastbay.edu\">patrick.fleming\@csueastbay.edu</a>\n";
print "</div>\n";

print end_html;
