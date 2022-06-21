#!/usr/bin/perl -wT

# A Virtual Lab: Hydrate
# Patrick E. Fleming
# California State University, East Bay
# April 11, 2020 

# this virtual Hydrate experiment is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

#parse the input
my $flow = param('control_1');

# Set some parameters
my @salts = ( "BaCl<sub>2</sub>", "CuSO<sub>4</sub>", "CdSeO<sub>4</sub>",
              "CaCl<sub>2</sub>", "Ce(SO<sub>4</sub>)<sub>2</sub>", "Cr(NO<sub>3</sub>)<sub>3</sub>", 
              "Co(CN)<sub>2</sub>", "Eu<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub>", "GdBr<sub>3</sub>", 
              "Au(CN)<sub>3</sub>", "HfOCl<sub>2</sub>", "In(ClO<sub>4</sub>)<sub>3</sub>",
              "Ir(SH)<sub>3</sub>", "Fe<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub>", "La<sub>2</sub>(CO<sub>3</sub>)<sub>3</sub>",
              "Pb(ClO<sub>4</sub>)<sub>2</sub>", "LiVO<sub>3</sub>", "MgCl<sub>2</sub>",
              "MnBr<sub>2</sub>", "Hg(NO<sub>3</sub>)<sub>2</sub>", "Nd<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub)",
              "NiSO<sub>4</sub>", "OsCl<sub>3</sub>", "PdSO<sub>4</sub>",
              "Pt(OH)<sub>4</sub>", "K<sub>4</sub>Fe(CN)<sub>6</sub>", "Pr(BrO<sub>3</sub>)<sub>3</sub>",
              "Rh<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub>", "SmBr<sub>2</sub>", "Sc<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub>",
              "Na<sub>2</sub>CrO<sub>4</sub>", "Sr(OH)<sub>2</sub>", "TeF<sub>3</sub>",
              "Tl<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub>", "ThP<sub>2<</sub>O<sub>6</sub>", "SnCl<sub>2</sub>",
              "U(SO<sub>4</sub>)<sub>2</sub>", "VSO<sub>4</sub>", "YCl<sub>3</sub>",
              "Zn(NO<sub>3</sub>)<sub>2</sub>" );
my @FWs = ( "208.23", "159.61", "255.37", "110.98", "332.24", "238.01", "110.97", "592.12", "396.96",
            "275.02", "265.40", "413.17", "291.44", "399.88", "457.84", "406.10", "105.88",  "95.21",
            "214.75", "324.60", "576.67", "154.76", "296.59", "202.48", "263.11", "368.34", "524.61",
            "494.00", "310.17", "378.10", "161.97", "121.63", "184.60", "696.95", "389.98", "189.62",
            "430.15", "147.00", "195.26", "189.40" );
my @waters = (  "2", "12", "2", "6",  "4", "9", "3", "8", "6", "6", "8", "8",  "2", "9", "3",
                "3",  "2", "6", "4",  "2", "8", "7", "3", "2", "2", "3", "9", "15", "6", "5",
               "10",  "8", "4", "7", "11", "2", "8", "7", "6", "6" );
my $nsalts = scalar(@salts);

# Print html page
print header;
print start_html("Virtual Hydrate Lab");
print "<h1>Virtual Hydrate Lab</h1>\n";


if ($flow eq '') {
######################################################
######                  Part A                  ######
# Select a random compound and set the data values.  #
######################################################
  # Choose a random salt from the list and calculate %mass of the anhydrous residue and of water
  my $unknown = int(rand() * $nsalts);
  my $percent_anhyd = int($FWs[$unknown]/($FWs[$unknown] + $waters[$unknown] * 18.016) * 10000 + 0.5)/100; 
  my $percent_water = 100 - $percent_anhyd;
  # Choose a random mass of sample and crucible to be used in the experiment
  my $mass_sample = int(rand() * 0.5 * 1000 +0.5)/1000 + 1;
  my $mass_crucible = int((rand() * 5 + 25.432) * 1000 +0.5) / 1000;
  # Calculate answers for convenience
  my $mass_water = $percent_water * $mass_sample / 100;
  my $mass_anhyd = $mass_sample - $mass_water;
  my $moles_anhyd = $mass_anhyd / $FWs[$unknown];
  my $moles_water = $mass_water / 18.016;

  # Print table containing data
  print "<table border=\"2\" cellpadding=\"2\">\n";
  print "  <tr>\n    <td colspan=\"2\" bgcolor=\"ffccff\"><b><center>Data</center><b></td>\n  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of crucible:</td>\n";
  print "    <td> $mass_crucible g</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of crucible + hydrate sample:</td>\n ";
  print "    <td>";
  print $mass_crucible + $mass_sample;
  print " g</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of crucible + anhydrous salt:</td>\n";
  print "    <td>";
  print int(($mass_crucible + $mass_sample * $percent_anhyd / 100) * 1000 + 0.5) / 1000;
  print " g</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td colspan=\"2\">Your anhydrous salt is $salts[$unknown]</td>\n";
  print "  </tr>\n";
  print "</table>\n<p></p>\n";
  # Create form with table for results
  print "<form action=\"/~pfleming/cgi-bin/hydrate.pl\" method=\"post\">\n";
  print "<table border=\"2\" cellpadding=\"2\">\n";
  print "  <tr>\n";
  print "    <td colspan=\"2\" bgcolor=\"ccffcc\"><b><center> $salts[$unknown] * n H<sub>2</sub>O</center></b></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Formula Weight for Anhydrous Salt</td>\n";
  print "    <td><input name=\"answer_FW\"> g/mol\n";
  print "    <input type=\"hidden\" name=\"FW\" value=\"$FWs[$unknown]\"></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of hydrate sample</td>\n";
  print "    <td><input name=\"answer_mass_sample\"> g\n";
  print "    <input type=\"hidden\" name=\"mass_hyd\" value=\"$mass_sample\"></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of water lost</td>\n";
  print "    <td><input name=\"answer_mass_water\"> g\n";
  print "    <input type=\"hidden\" name=\"mass_water\" value=\"$mass_water\"></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of anhydrous residue remaining</td>\n";
  print "    <td><input name=\"answer_mass_anhyd\"> g\n";
  print "    <input type=\"hidden\" name=\"mass_anhyd\" value=\"$mass_anhyd\"></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Moles of water lost</td>\n";
  print "    <td><input name=\"answer_moles_water\"> mol\n";
  print "    <input type=\"hidden\" name=\"moles_water\" value=\"$moles_water\"></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Moles of anhydrous residue remaining</td>\n";
  print "    <td><input name=\"answer_moles_anhyd\"> mol\n";
  print "    <input type=\"hidden\" name=\"moles_anhyd\" value=\"$moles_anhyd\"></td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Ratio of moles of water :  moles of anyhydrous residue</td>\n";
  print "    <td><input name=\"answer_moles_hydrate\"> : 1\n";
  print "    <input type=\"hidden\" name=\"moles_hydrate\" value=\"$waters[$unknown]\"></td>\n";
  print "  </tr>\n";
  print "</table>\n<p>\n";
  # Pass some information to the grading phase
  print "<input type=\"hidden\" name=\"anhyd\" value=\"$salts[$unknown]\">\n";
  print "<input type=\"hidden\" name=\"mass_crucible\" value=\"$mass_crucible\">\n";
  print "<input type=\"hidden\" name=\"mass_sample\" value=\"$mass_sample\">\n";
  print "<input type=\"hidden\" name=\"control_1\" value=\"grade\">\n";
  print "<input type=\"submit\" value=\"Grade my Answers!\">\n";
  print "</form>\n";
} elsif ($flow eq "grade") {
######################################################
######                  Part B                  ######
# Check the results.                                 #
######################################################

  # Parse the inputs
  my $anhyd             = param('anhyd');
  my $mass_crucible     = param('mass_crucible');
  my $FW                = param('FW');
  my $mass_sample       = param('mass_sample');
  my $mass_water        = param('mass_water');
  my $mass_anhyd        = param('mass_anhyd');
  my $moles_water       = param('moles_water');
  my $moles_anhyd       = param('moles_anhyd');
  my $moles_hydrate     = param('moles_hydrate');
  my $ans_FW            = param('answer_FW');
  my $ans_mass_sample   = param('answer_mass_sample');
  my $ans_mass_water    = param('answer_mass_water');
  my $ans_mass_anhyd    = param('answer_mass_anhyd');
  my $ans_moles_water   = param('answer_moles_water');
  my $ans_moles_anhyd   = param('answer_moles_anhyd');
  my $ans_moles_hydrate = param('answer_moles_hydrate');
  
  my $total_mass = int(($mass_crucible + $mass_anhyd + $mass_water) * 1000 +0.5) / 1000;
  my $mass_2 = int(($mass_crucible + $mass_anhyd) * 1000 + 0.5) / 1000;

# Reprint table containing data
  print "<table border=\"2\" cellpadding=\"2\">\n";
  print "  <tr>\n    <td colspan=\"2\" bgcolor=\"ffccff\"><b><center>Data</center><b></td>\n  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of crucible</td>\n";
  print "    <td> $mass_crucible g</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of crucible + hydrate sample</td>\n ";
  print "    <td>$total_mass g</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of crucible + anhydrous salt</td>\n";
  print "    <td>$mass_2 g</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td colspan=\"2\">Your anhydrous salt is $anhyd</td>\n";
  print "  </tr>\n";
  print "</table>\n<p></p>\n";
  
  print "<table border=\"2\" cellpadding=\"2\">\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"ccffcc\"><b><center>$anhyd * n H<sub>2</sub>O</center></b></td>\n";
  print "    <td colspan=\"2\">Your answer</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Formula Weight for Anhydrous Salt</td>\n";
  print "    <td>$ans_FW g/mol</td>\n";
  print "    <td>";
  if (abs($ans_FW - $FW) <= 0.1) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of hydrate sample</td>\n";
  print "    <td>$ans_mass_sample g</td>\n";
  print "    <td>";
  if (abs($ans_mass_sample - $mass_sample) <= 0.001) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of water lost</td>\n";
  print "    <td>$ans_mass_water g </td>\n";
  print "    <td>";
  if (abs($ans_mass_water - $mass_water) <= 0.001) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Mass of anhydrous residue remaining</td>\n";
  print "    <td>$ans_mass_anhyd g</td>\n";
  print "    <td>";
  if (abs($ans_mass_anhyd - $mass_anhyd) <= 0.001) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Moles of water lost</td>\n";
  print "    <td>$ans_moles_water mol</td>\n";
  print "    <td>";
  if (abs($ans_moles_water - $moles_water) / $moles_water <= 0.001) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Moles of anhydrous residue remaining</td>\n";
  print "    <td>$ans_moles_anhyd mol</td>\n";
  print "    <td>";
  if (abs($ans_moles_anhyd - $moles_anhyd) / $moles_anhyd <= 0.001) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "  <tr>\n";
  print "    <td>Ratio of moles of water :  moles of anyhydrous residue</td>\n";
  print "    <td>$ans_moles_hydrate : 1</td>\n";
  print "    <td>";
  if ($ans_moles_hydrate eq $moles_hydrate) {
    print "<font color=\"green\"><b>You are Correct!</b></font>";
  } else {
    print "<font color=\"red\">You are incorrect.</font>";
  }
  print "</td>\n";
  print "  </tr>\n";
  print "</table><p>\n";

} elsif ($flow eq 'print_salts') {
  my $i = 0;		# Looping variable
  print "<table border=\"2\" cellpadding=\2\">\n";
  print "  <tr>\n";
  print "    <td bgcolor=\"cccccc\">i</td> <td bgcolor=\"cccccc\">Anhydrous Salt</td> <td bgcolor=\"cccccc\">n Waters</td> <td bgcolor=\"cccccc\">Anhyd. FW</td>\n";
  print "  </tr>\n";
  while ($i < $nsalts) {
	  print "  <tr>\n";
	  print "    <td bgcolor=\"cccccc\">$i</td> <td>$salts[$i]</td> <td>$waters[$i]</td> <td>$FWs[$i]</td>\n";
	  print "  </tr>\n";
	  $i += 1;
  }
  print "</table>\n";
  
} else {
	print "Go to hell!\n";
}

print "<footer>\n";
print "		<hr>\n";
print "		Patrick E. Fleming<br>\n";
print "		Department of Chemistry and Biochemistry<br>\n";
print "		California State University, East Bay<br>\n";
print "		<a href=\"mailto:patrick.fleming\@csueastbay.edu\">patrick.fleming\@csueastbay.edu</a>\n";
print "</footer>\n";

print end_html;

