#!/usr/bin/perl

# Copyright (C) 2018  Jesse McGraw (jlmcgraw@gmail.com)
#
#-------------------------------------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see [http://www.gnu.org/licenses/].
#-------------------------------------------------------------------------------

# EFF word lists are from
# https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases
#   and were edited to remove numbers in front

# TODO
#   Make sure passphrase is of at least length X

# DONE
#   UTF-8/Unicode?
#   Limit word length by min/max lengths in word file
#   Handle case where word list doesn't have a word starting with certain character
#   Add capitol letters, special character, and numbers when requested

# Standard libraries
use strict;
use warnings;
use autodie;
use Carp;
use Config;
use Data::Dumper;
use File::Glob ':bsd_glob';
use utf8;
use open ':std', ':encoding(UTF-8)';

# Allow use of locally installed libraries in conjunction with Carton
# without executing this script via "carton exec <script>"
use FindBin '$Bin';
use lib "$FindBin::Bin/local/lib/perl5";

# Non-standard libraries
use Modern::Perl '2015';
use Params::Validate qw(:all);
use Getopt::ArgParse;    #https://github.com/mytram/perl-argparse

# Call the main subroutine and exit with its return code
exit main(@ARGV);

sub main {

    # Process the command line
    my ( $ap, $args, @ARGV ) = process_command_line();

    # Get parameter values
    my $mnemonic               = $args->mnemonic;
    my $word_list_file         = $args->wordlist;
    my $length                 = $args->length;
    my $verbose                = $args->verbose;
    my $should_capitalize      = $args->capitalize;
    my $should_include_numbers = $args->numbers;
    my $should_include_special = $args->special;

    # Default minimum and maximum word lengths, these will be adjusted
    # dynamically per wordfile
    my $min_word_length = 50;
    my $max_word_length = 1;

    my $word_count;
    my %words_by_length;
    my %words_by_first_grapheme;

    # Open the word list as UTF8
    open my $fh, '<:encoding(UTF-8)', $word_list_file
        or die "Cannot open $word_list_file: $!";

    # For each line of the word list file
    # (each line should contain only one word)
    while ( my $word = <$fh> ) {

        # Trim off leading/trailing whitespace
        $word =~ s/^\s+|\s+$//g;

        # Basic sanity checks
        # Make sure word only has alphanumeric in it
        if ( $word =~ m/[^\w\s]/ ) {
            if ($verbose) {
                say
                    "Not adding $word because it has non-alphanumeric characters in it";
            }
            next;
        }

        # Get length and first grapheme of this word
        my $first_grapheme = substr( $word, 0, 1 );
        my $word_length = length($word);

        # Adjust the min/max length possible for this word list
        if ( $word_length < $min_word_length ) {
            $min_word_length = $word_length;
        }
        if ( $word_length > $max_word_length ) {
            $max_word_length = $word_length;
        }

        # Increment our count of words
        $word_count += 1;

        # Save word in a hash of arrays indexed by word length in graphemes
        push( @{ $words_by_length{$word_length} }, $word );

        # Save word in a hash of arrars indexed by first grapheme
        push( @{ $words_by_first_grapheme{$first_grapheme} }, $word );

    }

    # More info if verbosity requested
    if ($verbose) {

        say "Word list file: $word_list_file";
        say "Word count: $word_count";
        say "Requested mnemonic length: $length";
        say "---------";

        # Dump the hash of words sorted by length
        foreach my $key ( sort { $a <=> $b } keys %words_by_length ) {
            say "Words of length $key are:";
            foreach my $word ( @{ $words_by_length{$key} } ) {
                say "\t$word";
            }
        }

        # Dump the hash of words sorted by first grapheme
        foreach my $key ( sort keys %words_by_first_grapheme ) {
            say "Words starting with \"$key\" are:";
            foreach my $word ( @{ $words_by_first_grapheme{$key} } ) {
                say "\t$word";
            }
        }
    }

    # Make sure requested word length is valid for this word list
    unless ( $min_word_length <= $length && $length <= $max_word_length ) {
        say
            "For the word list \"$word_list_file\:, the length must be between $min_word_length and $max_word_length";
        $ap->print_usage;
        return 1;
    }

    # If the user didn't supply a mnemonic then choose a random one
    if ($mnemonic) {
        say "User supplied mnemonic is \"$mnemonic\"";
    }
    else {
        # Get a random word from the array of words of length "length"
        $mnemonic = @{ $words_by_length{$length} }
            [ rand @{ $words_by_length{$length} } ];

        say "Random mnemonic word of length $length is \"$mnemonic\"";
    }

    # Split that word into graphemes
    my @grapheme_array = split( //, $mnemonic );

    my @passphrase_array;

    # For each grapheme...
    foreach my $grapheme (@grapheme_array) {
        my $mnemonic_word;

        # Find a random word that starts with that grapheme
        if ( exists $words_by_first_grapheme{$grapheme} ) {
            $mnemonic_word = @{ $words_by_first_grapheme{$grapheme} }
                [ rand @{ $words_by_first_grapheme{$grapheme} } ];
        }

# If we don't have a word that starts with this grapheme just use the grapheme
        else {
            say "No word starting with |$grapheme|" if $verbose;
            $mnemonic_word = $grapheme;
        }

        # Save that word
        push( @passphrase_array, $mnemonic_word );
    }

    # Capitalize the first grapheme of each word if user requested it
    if ($should_capitalize) {
        @passphrase_array = map { ucfirst($_) } @passphrase_array;
    }

    # Tack some numbers on end if requested
    if ($should_include_numbers) {
        my $numbers = generate_random_number_string($should_include_numbers);
        push( @passphrase_array, $numbers );
    }

    # Tack some special characters on end if requested
    if ($should_include_special) {
        my $specials
            = generate_random_specials_string($should_include_special);
        push( @passphrase_array, $specials );
    }

    # Print out all of the random words to make the passphrase
    say join( " ", @passphrase_array );
    return 0;
}

sub generate_random_number_string {
    my $length_of_randomstring = shift;    # the length of
                                           # the random string to generate

    my @chars = ( '0' .. '9' );
    my $random_string;
    foreach ( 1 .. $length_of_randomstring ) {

        # rand @chars will generate a random
        # number between 0 and scalar @chars
        $random_string .= $chars[ rand @chars ];
    }
    return $random_string;
}

sub generate_random_specials_string {
    my $length_of_randomstring = shift;

    # the length of
    # the random string to generate

    my @chars = ( '!', '@', '#', '$', '%', '^', '&', '*', '(', ')' );
    my $random_string;
    foreach ( 1 .. $length_of_randomstring ) {

        # rand @chars will generate a random
        # number between 0 and scalar @chars
        $random_string .= $chars[ rand @chars ];
    }
    return $random_string;
}

sub process_command_line {

    # Set up an argument parser
    my $ap = Getopt::ArgParse->new_parser(
        description => 'Create passphrases using mnemonics',
        epilog => 'Copyright (C) 2018  Jesse McGraw (jlmcgraw@gmail.com)',
    );

    # Add an option
    $ap->add_arg( '--mnemonic', '-m',
        help =>
            'Supply your own mnemonic word instead of choosing one randomly'
    );

    # Add an option
    $ap->add_arg(
        '--wordlist', '-w',
        default => 'eff_large_wordlist.txt',
        help    => 'The word list to use, one word per line'
    );

    # Add an option
    $ap->add_arg(
        '--length', '-l',
        default => '5',
        help    => 'The length of the mnemonic word'
    );

    # Add an option
    $ap->add_arg(
        '--capitalize', '-c',
        type => 'Bool',
        help =>
            'Capitalize the first character of each word in the passphrase'
    );

    # Add an option
    $ap->add_arg(
        '--numbers', '-n',
        default => '0',
        help =>
            'Add random string of this length of numbers to end of passphrase'
    );

    # Add an option
    $ap->add_arg(
        '--special', '-s',
        default => '0',
        help =>
            'Add random string of this length of special characters to end of passphrase'
    );

    $ap->add_arg(
        '--verbose', '-v',
        type => 'Bool',
        help => 'Output more information'
    );

    # Parse the arguments
    my $args = $ap->parse_args() or $ap->print_usage;

    # Get @ARGV after options have been removed
    @ARGV = $ap->argv;

    # Expand wildcards on command line since windows doesn't do it for us
    if ( $Config{archname} =~ m/win/ix ) {

        #Expand wildcards on command line
        say "Expanding wildcards for Windows";

        # @ARGV_unmodified = @ARGV;
        @ARGV = map { bsd_glob $_ } @ARGV;
    }

    # Print the usage message if needed
    # $ap->print_usage;
    return ( $ap, $args, @ARGV );
}
