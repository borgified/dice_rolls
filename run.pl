#!/usr/bin/env perl

use strict;
use warnings;


#this script tries to answer the question:
#what is more preferrable to get a higher total on average?
#4d5 or 5d4

#on paper, 4d5 uses a 5 sided dice. a 5 sided dice has an avg of (1+2+3+4+5)/5=3
#we have 4 of them, so 4*3=12, our average total.

#for 5d4, a 4 sided dice is involved. each having an avg of (1+2+3+4)/4 = 2.5
#we have 5 of them, so 5*2.5=12.5, our average total.


sub dice{
#for a five sided dice, use n=5
	my $n = shift @_;
	return (int(rand($n))+1);
}

sub xdy {
	my $x=shift @_;
	my $y=shift @_;
	my $total=0;
	my $count=0;

	while($count < $x){
		$total=$total+&dice($y);
		$count++;
	}
  return $total;
}

sub run_experiment{
	my $sample_size=shift @_;
	my $x=shift @_;
	my $y=shift @_;

	my $i=0;
	my %hash;
	while($i<$sample_size){	
		my $a=&xdy($x,$y);
		if(exists($hash{$a})){
			$hash{$a}=$hash{$a}+1;
		}else{
			$hash{$a}=1;
		}
		$i++;
	}
	return \%hash;
}

#my $hashref=&run_experiment(100000,5,5);
#my $hashref=&run_experiment(100000,1,30);

#foreach my $key (sort {$a<=>$b} keys $hashref){
#	print "$key : $$hashref{$key}\n";
#}

sub damage_test{
#damage test will run 2 experiments side by side and see which reaches X amount of damage first
	my $pen = 0;
	my $knife = 0;
	my $max_damage=40000;

	while(($pen<$max_damage) && ($knife<$max_damage)){
		$pen=$pen+&xdy(1,30);
		$knife=$knife+&xdy(5,5);
		#print "pen damage: $pen\t knife damage: $knife\n";
	}
	if($pen<$knife){
		return "knife";
	}elsif($pen>$knife){
		return "pen";
	}else{
		return "draw";
	}
}

sub run_experiment2{
	my %results;
	my $count=shift @_;
	my $x=0;

	$results{'pen'}=0;
	$results{'knife'}=0;
	$results{'draw'}=0;

	while($x<$count){
		my $winner=&damage_test;
		$results{$winner}=$results{$winner}+1;
		$x++;
	}
	print "pen: $results{'pen'}\n";
	print "knife: $results{'knife'}\n";
	print "draw: $results{'draw'}\n";
}

&run_experiment2(100);
