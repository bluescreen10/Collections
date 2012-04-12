#!perl

use strict;
use warnings;
use Test::More tests => 9;
use Test::Exception;
use Collections::Ordered;

# Empty Collection
my $col = Collections::Ordered->new;

$col->add_all( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 );

# Collect
my $square = $col->collect( sub { $_[0] * $_[0] } );

is( $square->first, 1,   'First element' );
is( $square->last,  100, 'Last Element' );

# detect
my $first_even_greather_than_five = $col->detect( sub { $_[0] % 2 == 0 and $_[0] > 5 } );
is( $first_even_greather_than_five, 6, 'Detect results' );
throws_ok(
    sub {
        $col->detect( sub { $_[0] % 2 == 0 and $_[0] > 10 } );
    },
    'Collections::Error::ElementNotFound',
    'Detect exception'
);

# detect and if none
my $value = $col->detect_and_if_none( sub { $_[0] % 2 == 0 and $_[0] > 10 }, sub { undef } );
is( $value, undef, 'Detect and if none' );

# do
my $result = 0;
$col->do( sub { $result += $_[0] if ( $_[0] < 3 ) } );
is( $result, 3, 'Do results' );

# inject
$result = $col->inject_into( -10, sub { $_[0] + $_[1] } );
is( $result, 45, 'Inject' );

# join
is( $col->join(','), '1,2,3,4,5,6,7,8,9,10', 'Join without block' );
is( $col->join( ',', sub { chr( $_[0] + 64 ) } ), 'A,B,C,D,E,F,G,H,I,J', 'Join with block' );
