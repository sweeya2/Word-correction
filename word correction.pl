#!/usr/bin/perl

#use strict;  
use warnings;  
use List::Util 'min';
use Text::Levenshtein qw(distance);     #library to find edit distance

my %cache;

#dictionary.txt contains all the words from which we will be searching
open(MFILE, "dictionary.txt") || die "dictionary.txt is required\n";

@number = <MFILE>; #store the file in an array
@arr = ();

for($i=0; $i < $#number; $i++){
    chomp $number[$i]; #remove \n  
	push @arr, $number[$i];  
}

#take the input
print "Enter your input paragraph.\n";
$input = <STDIN>;
chomp $input;
@input_arr = split(/\s+/, $input);

@ans_arr = ();

OUTERLOOP: foreach  $elem (@input_arr){
    $elem = lc $elem; #convert to lower case
    print "Do you want to change $elem?\n";
    $choices = <>;     
      chomp $choices; #removes \n
      if($choices eq "N" || $choices eq "n"){
        push @ans_arr, $elem;
        next OUTERLOOP; #exit this iteration   
    }
    
INNERLOOP: foreach $y (@arr){
    $y =~ s/[^\w]//g;  #remove any non alphanumeric
    if($y eq $elem){  #if equal:
        print "Found the right word\nIs $y the word you wanted?\nType Y/N\n^";
        $choice = <>;     
        chomp $choice;
        if($choice eq "Y" || $choice eq "y"){
            push @ans_arr, $y;
            next OUTERLOOP; #exit this iteration   
        }
    }else{
    $distances = distance($y,$elem); # edit distance should give 1
	if($distances==1 || $distances==2){
      print "Do you want to replace $elem with $y?\nType Y/N\n^";
      $choice = <>;     
      chomp $choice; #removes \n 
      if($choice eq "Y" || $choice eq "y"){
          push @ans_arr, $y;
        next OUTERLOOP; #exit this iteration   
      }
	}
    }   
}
   #if all the words are searched having a distance of 1 or less
   print "Could not find anymore corrections for the word $elem, will be using the same word.\n"; 
   push @ans_arr, $elem;
}

print "\n";
print "Your final corrected output is:\n";

#printing elements of final ans_arr
foreach (@ans_arr)
{
    print "$_ ";
}
print "\n";