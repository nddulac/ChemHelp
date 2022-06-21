
# Simulated titration
# Patrick Fleming
# December 8, 2015

# Set up some initial parameters
$mKHP = 204.23;                                                 # molar mass (g/mol)
$macid = int((rand(0.2)+0.7)*10000+0.5)/10000;                  # mass of KHP (g)
$cbase = int((rand(0.01)+0.19)*10000+0.5)/10000;                # conc. base (M)
$mmacid = $macid/$mKHP*1000;                                    # mmol of acid

$i = 1;
do {
    print "\n";
    $i = $i + 1;
} until ($i == 23);
print "mass KHP: $macid g\n";
print "conc. base: $cbase M\n\n";
$apx = int($mmacid/0.2*100+.5)/100;
print "Approximate volume of base needed: $apx mL.\n\n";

$vbase = 0;                                                     # inital volume of base (mL)
do {
	print "\nTotal volume of base added: $vbase mL.\n";
	print "How many mL of base do you want to add?\n";
	$vadded = <STDIN>;
	$vbase = $vbase + $vadded;
	if ($vbase*$cbase < $mmacid) {
		print "Undertitrated!\n";
		if ($vbase*$cbase > $mmacid*0.98) {
			print "Very near the end point!!\n";
		}
	}
	if ($vbase*$cbase > $mmacid) {
		if ($vbase*$cbase < $mmacid*1.02) {
			print "Near the endpoint.\n";
		}
		print "Overtitrated!\n";
	}
} while ($vbase*$cbase < $mmacid);

$vused = $vbase-$vadded;
$calc = $mmacid/$vused;
$calc = int($calc*10000+0.5)/10000;
$mmacid = int($mmacid*10000+0.5)/10000;

print "\nResults\n";
print "-------\n";
print "Amount of acid used : $macid g\n";
print "                    : $mmacid mmol\n";
print "Volume of base used : $vused mL (last volume before endpoint)\n\n";
print "Calculated [base] = $calc M.\n";
print "    Actual [base] = $cbase M.\n";
print "Done!\n\n";
