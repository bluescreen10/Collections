#!perl

use strict;
use warnings;
use Test::More tests => 19;
use Collections::Ordered;
use Test::Exception;

# Empty Collection
my $col = Collections::Ordered->new;

ok( $col->is_empty, 'New collections must be empty' );

# Add one element
$col->add('hello');

is( $col->size, 1, 'One element collection' );
ok( !$col->is_empty, 'Collection is not empty' );

# Add another element
$col->add(3.43);

is( $col->size,  2,       'Two element collection' );
is( $col->first, 'hello', 'First element' );
is( $col->last,  3.43,    'Last element' );

# Add a bunch of elements
$col->add_all( 'I', 'like', 'smalltalk' );    #Array
$col->add_all( [ 234, 21, 23 ] );             # Array ref

# Create the other collection from array
my $hash = { Key => 'value' };
my $another_col = Collections::Ordered->from_array( $hash, 'Name' );

$col->add_all($another_col);

is( $col->size, 10,     'Ten element collection' );
is( $col->last, 'Name', 'Last element' );

# Accessing elements
is( $col->at(1),           'hello', 'First element' );
is( $col->index_of($hash), 9,       'Find element' );
ok( $col->exists('hello'),       'Existent element' );
ok( !$col->exists('hello world'), 'Inexistent element' );
throws_ok( sub { $col->index_of('hello world') },
           'Collections::Error::ElementNotFound',
           'Index of inexistent element' 
       );



# Removing elements
$col->remove('hello');
$col->remove(3.43);

is( $col->size,  8,   'Two less elements' );
is( $col->first, 'I', 'First element' );

# Removing a bunch of elements
$col->remove_all( [ 'like', 21 ] );
$col->remove_all( 23, 234 );
$col->remove_all($another_col);
is( $col->size,  2,           'Removed a bunch of elements' );
is( $col->first, 'I',         'First element remaining' );
is( $col->last,  'smalltalk', 'Last element remaining' );

# Convert to aray
ok( eq_array( [ $col->to_array ], [ 'I', 'smalltalk' ] ), 'Convert to array' );
