#!perl

use strict;
use warnings;
use Test::More tests => 14;
use Collections::Sorted;
use Test::Exception;

# From array
my $col = Collections::Sorted->from_array( 235, 23, 1 );

is( $col->first,  1,   'First element' );
is( $col->second, 23,  'Second element' );
is( $col->last,   235, 'Last element' );

# another collection
my $another_col = Collections::Ordered->from_array( 1, 2, 3, 423 );

$col->add_all($another_col);

is( $col->second, 1,   'New second element' );
is( $col->last,   423, 'New last element' );

# Negative numbers
$col->add(-1);
$col->add_all( [ -23, 4, 5 ] );

is( $col->size,  11,  'All elements added so far' );
is( $col->first, -23, 'Negative element' );

# Change sort_block
$col->sort_block( sub { $_[1] <=> $_[0] } );
is( $col->first, 423, 'Resorted first element' );
is( $col->last,  -23, 'Resorted last element' );

# remove some elements
$col->remove(-23);
is( $col->last, -1, 'Last element after remove');

# Conversion
my $set = $col->to_set;
is ( ref($set), 'Collections::Set', 'Converted to Collections::Set');
is ( $set->size, 9, 'Set\'s size');

my $ordered = $col->to_ordered;
is ( ref($ordered), 'Collections::Ordered', 'Converted to Collections::Ordered');
is ( $ordered->size, 10, 'Ordered\'s size');
