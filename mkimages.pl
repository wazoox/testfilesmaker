#!/usr/bin/perl

use strict;
use warnings;
use Carp;

use GD::Simple;

sub loaddict {
    my $dict = shift;

    open my $fh, $dict or croak "can't open $dict: $!";
    my @words = <$fh>;
    chomp @words;

    return \@words;
}

my @dimensions = ( [ 400, 250 ], [ 1280, 1024 ], [ 64, 64 ] );

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

my @color_names = GD::Simple->color_names;

foreach my $dim (@dimensions) {
    for ( 1 .. $filecount ) {
        my $img = GD::Simple->new( $dim->[0], $dim->[1] );
        $img->font(gdLargeFont);

        my $dice = int( rand($#color_names) );
        $img->bgcolor( $color_names[$dice] );

        $dice = int( rand($#color_names) );
        $img->fgcolor( $color_names[$dice] );

        $img->rectangle(
            int( rand( $dim->[0] ) ),
            int( rand( $dim->[1] ) ),
            int( rand( $dim->[0] ) ),
            int( rand( $dim->[1] ) )
        );

        $dice = int( rand($#color_names) );
        $img->fgcolor( $color_names[$dice] );
		
		$img->moveTo( 10,20);
		my $string;
		for ( 1 .. int($dim->[0]/10) ) {
			$dice = int( rand( $#{$wordlist} ) );
			$string .= $wordlist->[$dice] . " ";
			unless ( $_ % 10 ) {
				$img->string( "$_ $string" );
				$string = "";
				$img->moveTo(10, 20 + ($_ * 2) );
			}
		}
        	

        open my $fh, '>', "$testdir/".$dim->[0]."X".$dim->[1]."-".$_.".png"
			or croak "can't open : $!";
        print $fh $img->png;
    }

}

