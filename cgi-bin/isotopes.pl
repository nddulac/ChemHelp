#!/usr/bin/perl -wT

# A Virtual Lab: Determination of an Equilibrium Constant
# Patrick E. Fleming
# California State University, East Bay
# January 29, 2022 

# this virtual isotope practice is based on my own ridiculous
# notion that this was a good idea.

use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use strict;

# parse the input and set global varialbes
my $flow = param('control_1');		# Determines part

# Begin html output
print header;
print start_html("Isotope Abundance Calculations");
print "<h1>Isotope Abundance Calculations</h1>\n";

if ($flow eq '') {
  print <<EOF;
    There are four variables in a typical isotope mass/abundance problem.<br>
    <ol>
      <li>Mass of Isotope A</li>
      <li>Mass of Isotope B</li>
      <li>Percent Abundance of Isotope A</li>
      <li>Average Mass of Element</li>
    </ol>
    <p>You may choose a problem to determine any of these. You will be given three of the inputs, 
    and be asked to solve for the missing piece of information.</p>
    <h2>Which type of problem would you like to solve?</h2>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
      <input type="radio" name="problem_type" value="A">Determine Mass of Isotope A<br>
      <input type="radio" name="problem_type" value="B">Determine Mass of Isotope B<br>
      <input type="radio" name="problem_type" value="C">Determine Percent Abundance of Isotope A<br>
      <input type="radio" name="problem_type" value="D" checked>Determine Average Mass of Element<br>
      <input type="hidden" name="control_1" value="Problem">
      <input type="submit" value="Let's Go!">
      <input type="reset" value="Clear Form">
    </form>
EOF
} elsif ($flow eq 'Problem') {
  my $problem_type = param('problem_type'); #problem type - what are you solving for?
  my $massA = param('massA');       # atomic mass of isotope A (amu)
  my $massB = param('massB');       # atomic mass of isotope B (amu)
  my $percentA = param('percentA'); # percent abundance of isotope A
  my $massAvg = param('massAvg');   # average atomic mass of element (amu)
  my $massNo = param('massNo');     # mass number of isotope A
  my $massNoB = param('massNoB');   # mass number of isotope B
  my $noNeut = param('noNeut');     # number of excess neutrons in isotope B
  if ($massA eq '') {
    # Set some paramters since they have not yet been set
    $massNo = int(random_value(350, 250));     # Nominal mass number
    $noNeut = int(random_value(1,3));          # Number of excess neutrons in heavier isotope
    $massNoB = $massNo + $noNeut;              # mass number of isotope B
    $massA = $massNo + sprintf("%.4f", random_value(0.01, -0.01));             # mass of A
    $massB = $massNo + $noNeut + sprintf("%.4f", random_value(0.01, -0.01));   # mass of B
    $percentA = sprintf("%.2f", random_value(90, 10));      # percent abundance of isotope A 
    $massAvg = sprintf("%.3f", ($massA * $percentA + $massB *(100 - $percentA)) / 100);     # Average atomic mass
  }
    if ($problem_type eq 'A') {
      print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has an unknown mass,
    and Eastbayium-$massNoB has a mass of $massB amu. The percent abundance of Eastbayium-$massNo is $percentA %. The
    average mass of Eastbayium is $massAvg amu.</p>
    <p>What is the mass of Eastbayium-$massNo?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
      </tr>
      <tr>
        <td bgcolor="ccffcc">Mass of Eastbayium-$massNo</td>  
        <td bgcolor="ccffcc"><input name="Answer"> amu</td>
      </tr>      
      <tr>
        <td>Mass of Eastbayium-$massNoB</td>  
        <td>$massB amu</td>
      </tr>      
      <tr>
        <td>Percent abundance of Eastbayium-$massNo</td>  
        <td>$percentA %</td>
      </tr>      
      <tr>
        <td>Average Atomic Mass</td>  
        <td>$massAvg amu</td>
      </tr>      
    </table>
EOF
    } elsif ($problem_type eq 'B') {
      print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has a mass of $massA amu,
    and Eastbayium-$massNoB has an unknow mass. The percent abundance of Eastbayium-$massNo is $percentA %. The
    average mass of Eastbayium is $massAvg amu.</p>
    <p>What is the mass of Eastbayium-$massNoB?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
      </tr>
      <tr>
        <td>Mass of Eastbayium-$massNo</td>  
        <td>$massA amu</td>
      </tr>      
      <tr>
        <td bgcolor="ccffcc">Mass of Eastbayium-$massNoB</td>  
        <td bgcolor="ccffcc"><input name="Answer"> amu</td>
      </tr>      
      <tr>
        <td>Percent abundance of Eastbayium-$massNo</td>  
        <td>$percentA %</td>
      </tr>      
      <tr>
        <td>Average Atomic Mass</td>  
        <td>$massAvg amu</td>
      </tr>      
    </table>
EOF
    } elsif ($problem_type eq 'C') {
      print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has a mass of $massA amu,
    and Eastbayium-$massNoB has a mass of $massB amu. The average mass of Eastbayium is $massAvg amu.</p>
    <p>What is the percent abundance of Eastbayium-$massNo?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
      </tr>
      <tr>
        <td>Mass of Eastbayium-$massNo</td>  
        <td>$massA amu</td>
      </tr>      
      <tr>
        <td>Mass of Eastbayium-$massNoB</td>  
        <td>$massB amu</td>
      </tr>      
      <tr>
        <td bgcolor="ccffcc">Percent abundance of Eastbayium-$massNo</td>  
        <td bgcolor="ccffcc"><input name="Answer"> %</td>
      </tr>      
      <tr>
        <td>Average Atomic Mass</td>  
        <td>$massAvg amu</td>
      </tr>      
    </table>
EOF
    } elsif ($problem_type eq 'D') {
      print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has a mass of $massA amu,
    and Eastbayium-$massNoB has a mass of $massB amu. The percent abundance of Eastbayium-$massNo is $percentA %.</p>
    <p>What is the average atomic mass of Eastbayium?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
      </tr>
      <tr>
        <td>Mass of Eastbayium-$massNo</td>  
        <td>$massA amu</td>
      </tr>      
      <tr>
        <td>Mass of Eastbayium-$massNoB</td>  
        <td>$massB amu</td>
      </tr>      
      <tr>
        <td>Percent abundance of Eastbayium-$massNo</td>  
        <td>$percentA %</td>
      </tr>      
      <tr>
        <td bgcolor="ccffcc">Average Atomic Mass</td>  
        <td bgcolor="ccffcc"><input name="Answer"> amu</td>
      </tr>      
    </table>
EOF
    } else {
      print "No Problem Specified. Bogus!\n";
    }
    print <<EOF;
    <input type="hidden" name="massA" value="$massA">
    <input type="hidden" name="massB" value="$massB">
    <input type="hidden" name="percentA" value="$percentA">
    <input type="hidden" name="massAvg" value="$massAvg">
    <input type="hidden" name="massNo" value="$massNo">
    <input type="hidden" name="noNeut" value="$noNeut">
    <input type="hidden" name="massNoB" value="$massNoB ">
    <input type="hidden" name="problem_type" value="$problem_type">
    <input type="hidden" name="control_1" value="Grade">
    <input type="submit" value="Am I right?">
    <input type="reset" value="Reset the Form">
    </form>
EOF
} elsif ($flow eq 'Grade' ) {
  my $problem_type = param('problem_type'); #problem type - what are you solving for?
  my $Answer = param('Answer');     # User's answer
  my $massA = param('massA');       # atomic mass of isotope A (amu)
  my $massB = param('massB');       # atomic mass of isotope B (amu)
  my $percentA = param('percentA'); # percent abundance of isotope A
  my $massAvg = param('massAvg');   # average atomic mass of element (amu)
  my $massNo = param('massNo');     # mass number of isotope A
  my $massNoB = param('massNoB');   # mass number of isotope B
  my $noNeut = param('noNeut');     # number of excess neutrons in isotope B
  my $response = "<font color=\"red\">You are incorrect.</font>";
  if ($problem_type eq 'A') {
    if (abs($Answer - $massA)/$massA <= 0.00001) {
      $response = "<font color=\"green\"><b>You are correct!</b></font>";
    }
    print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has an unknown mass,
    and Eastbayium-$massNoB has a mass of $massB amu. The percent abundance of Eastbayium-$massNo is $percentA %. The
    average mass of Eastbayium is $massAvg amu.</p>
    <p>What is the mass of Eastbayium-$massNo?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
        <td bgcolor="ffccff" Colspan="2"><b>Correct Answer</b></td>
      </tr>
      <tr>
        <td bgcolor="ffcccc">Mass of Eastbayium-$massNo</td>  
        <td bgcolor="ffcccc">$Answer amu</td>
        <td>$massA amu</td>
        <td>$response</td>
      </tr>      
      <tr>
        <td>Mass of Eastbayium-$massNoB</td>  
        <td>$massB amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td>Percent abundance of Eastbayium-$massNo</td>  
        <td>$percentA %</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td>Average Atomic Mass</td>  
        <td>$massAvg amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
    </table>
EOF
  } elsif ($problem_type eq 'B') {
    if (abs($Answer - $massB)/$massB <= 0.00001) {
      $response = "<font color=\"green\"><b>You are correct!</b></font>";
    }
    print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has a mass of $massA amu,
    and Eastbayium-$massNoB has an unknow mass. The percent abundance of Eastbayium-$massNo is $percentA %. The
    average mass of Eastbayium is $massAvg amu.</p>
    <p>What is the mass of Eastbayium-$massNoB?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
        <td bgcolor="ffccff" Colspan="2"><b>Correct Answer</b></td>
      </tr>
      <tr>
        <td>Mass of Eastbayium-$massNo</td>  
        <td>$massA amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td bgcolor="ffcccc">Mass of Eastbayium-$massNoB</td>  
        <td bgcolor="ffcccc">$Answer amu</td>
        <td>$massB amu</td>
        <td>$response</td>
      </tr>      
      <tr>
        <td>Percent abundance of Eastbayium-$massNo</td>  
        <td>$percentA %</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td>Average Atomic Mass</td>  
        <td>$massAvg amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
    </table>
EOF
  } elsif ($problem_type eq 'C') {
    if (abs($Answer - $percentA)/$percentA <= 0.001) {
      $response = "<font color=\"green\"><b>You are correct!</b></font>";
    }
    print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has a mass of $massA amu,
    and Eastbayium-$massNoB has a mass of $massB amu. The average mass of Eastbayium is $massAvg amu.</p>
    <p>What is the percent abundance of Eastbayium-$massNo?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
        <td bgcolor="ffccff" Colspan="2"><b>Correct Answer</b></td>
      </tr>
      <tr>
        <td>Mass of Eastbayium-$massNo</td>  
        <td>$massA amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td>Mass of Eastbayium-$massNoB</td>  
        <td>$massB amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td bgcolor="ffcccc">Percent abundance of Eastbayium-$massNo</td>  
        <td bgcolor="ffcccc">$Answer</td>
        <td>$percentA %</td>
        <td>$response</td>
      </tr>      
      <tr>
        <td>Average Atomic Mass</td>  
        <td>$massAvg amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
    </table>
EOF
  } elsif ($problem_type eq 'D') {
    if (abs($Answer - $massAvg)/$massAvg <= 0.000001) {
      $response = "<font color=\"green\"><b>You are correct!</b></font>";
    }
    print <<EOF;
    <p>A new element, Eastbayium, has been discovered and has two isotopes. Eastbayium-$massNo has a mass of $massA amu,
    and Eastbayium-$massNoB has a mass of $massB amu. The percent abundance of Eastbayium-$massNo is $percentA %.</p>
    <p>What is the average atomic mass of Eastbayium?</p>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
    <table border="2" cellpadding="2">
      <tr>
        <td bgcolor="ffccff"><b>Parameter</b></td>  
        <td bgcolor="ffccff"><b>Value</b></td>
        <td bgcolor="ffccff" Colspan="2"><b>Correct Answer</b></td>
      </tr>
      <tr>
        <td>Mass of Eastbayium-$massNo</td>  
        <td>$massA amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td>Mass of Eastbayium-$massNoB</td>  
        <td>$massB amu</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td>Percent abundance of Eastbayium-$massNo</td>  
        <td>$percentA %</td>
        <td bgcolor="cccccc" colspan="2"></td>
      </tr>      
      <tr>
        <td bgcolor="ffcccc">Average Atomic Mass</td>  
        <td bgcolor="ffcccc">$Answer amu</td>
        <td>$massAvg amu</td>
        <td>$response</td>
      </tr>      
    </table>
EOF
  } else {
      print "No Problem Specified. Bogus!\n";
  }
  print <<EOF;
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
      <input type="hidden" name="massA" value="$massA">
      <input type="hidden" name="massB" value="$massB">
      <input type="hidden" name="percentA" value="$percentA">
      <input type="hidden" name="massAvg" value="$massAvg">
      <input type="hidden" name="massNo" value="$massNo">
      <input type="hidden" name="noNeut" value="$noNeut">
      <input type="hidden" name="massNoB" value="$massNoB ">
      <input type="hidden" name="problem_type" value="$problem_type">
      <input type="hidden" name="control_1" value="Problem">
      <input type="submit" value="Try again">
    </form>
    <form action="/~pfleming/cgi-bin/isotopes.pl" method="post">
      <input type="submit" value="Try a new Problem">
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

sub random_value {
	my ($max, $min) = @_;
	my $value = rand(1) * ($max - $min) + $min;
	return $value;
}



