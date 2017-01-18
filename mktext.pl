#!/usr/bin/perl


use strict;
use warnings;
use Carp;


sub loaddict {	
	my $dict = shift;
	
	open my $fh, $dict or croak "can't open $dict: $!";
	my @words = <$fh>;
	chomp @words;
		
	return \@words;
}

#######################
# main

my $testdir = $ARGV[0] 
	or die "usage : $0 <test folder> <number of files>";
	
my $filecount = $ARGV[1] 
	or die "usage : $0 <test folder> <number of files>";

my $seed = 0;
$seed = $ARGV[2] if defined  $ARGV[2];

# force number
$filecount += 0;

if ( not -d "$testdir" ) {
	mkdir "$testdir" or die "can't mkdir $testdir";
}

my $wordlist = loaddict("/usr/share/dict/words");
srand(42 + $seed );

for ( 1 .. $filecount ) {
	open my $file, '>', "$testdir/$_" or croak "can't open file : $!";
	
	my $filesize = int( rand(10000) ) + 5000 ;
	for ( 1 .. $filesize ) {
		my $dice = int( rand($#{$wordlist}) ) ;
		print $file $wordlist->[$dice] . " ";
		if ( $_ % 12 == 0 ) {
			print $file "\n";
		}
	}
}

