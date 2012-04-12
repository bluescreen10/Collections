#!perl

use strict;
use warnings;
use Test::More tests => 9;
use Collections::Set;
use Test::Exception;

# From array
my $col = Collections::Set->from_array( 2, 1, 1, 1 ,3 );

is( $col->size,  3,   'Size' );

# another collection
my $another_col = Collections::Ordered->from_array( 1, 2, 3, 423 );

$col->add_all($another_col);

is( $col->size, 4,   'Only one unique element added' );

# remove some elements
$col->remove(1);
is( $col->size, 3, 'New size');

# Conversion
my $sorted = $col->to_sorted(sub { $_[1] <=> $_[0] });
is ( ref($sorted), 'Collections::Sorted', 'Converted to Collections::Sorted');
is ( $sorted->size, 3, 'Sorted\'s size');
is ( $sorted->first, 423, 'Sorted first element');

my $ordered = $col->to_ordered;
is ( ref($ordered), 'Collections::Ordered', 'Converted to Collections::Ordered');
is ( $ordered->size, 3, 'Ordered\'s size');
is ( $ordered->first, 2, 'Ordered first element');
