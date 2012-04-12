
=head1 NAME

Collections::Ordered - Easy to use iterator

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Collections::Ordered;
    use Collections::Sorted;

    # Ordered collection
    my $colection = Collections::Ordered->new;

    $colection->add($item);
    $colection->do(sub { print $_[0] });
    $colection->remove($item);

    # Access first element
    print $sorted_collection->first;

=head1 HIERARCHY

     Collections::Ordered
      +Collections::Sorted
      +Collections::Set

=cut

package Collections::Ordered;

use strict;
use warnings;
use Collections::Errors;
use Collections::Set;
use Collections::Sorted;
use overload '@{}' => \&to_array, 'fallback' => 1;

our $VERSION = '0.01';

=head1 CLASS METHODS

=head2 new()

Returns a new instace of a Collection

  my $collection = Collections::Ordered->new;

=cut

sub new {
    my ($class) = @_;
    return bless( { elements => [] }, $class );
}

=head2 from_array(\@array)

Returns a new instace of a Collection filled with \@array

  my $collection = Collections::Ordered->new(34,23,12,443);

=cut

sub from_array {
    my $class = shift;
    my $self  = $class->new;
    $self->add_all(@_);
    return $self;
}

=head1 INSTANCE METHODS

=head2 add($element)

Add $element as part of receiver's elements

  $colection->add(1);

=cut

sub add {
    my $self    = shift;
    my $element = \(shift);
    push( @{ $self->{elements} }, $$element );
    return $$element;
}

=head2 add_all($elements)

Add all $collection's element as part of receiver's elements

  $colection->add_all($another_collection);
  ... or ...
  $collection->add_all(1,2,3);
  ... or ...
  $colection->add_all([1,2,3]);

=cut

sub add_all {
    my $self = shift;

    my @elements = $self->_parameter_to_array(@_);

    splice( @{ $self->{elements} }, $self->size, 0, @elements );
    return @_;
}

=head2 at($index)

Returns element at the $index location, if location doesn't exists it throws 
Collection::Error::InvalidSize error, first element index is 1

  my $third_element = $collection->at(3);

=cut

sub at {
    my ( $self, $index ) = @_;

    $index--;

    if ( $index < 0 and $index > $self->size ) {
        Collections::Error::InvalidSize->throw('Invalid collection size');
    } else {
        return $self->_elements->[$index];
    }
}

=head2 collect($sub)

Returns a new object like the receiver whose elements are the result of evaluating $sub over each element of the receiver

  my $names = $employees->collect(sub { $_[0]->name});

  # First name in the name list
  $names->first

=cut

sub collect {
    my ( $self, $block ) = @_;
    my $class = ref($self);
    my @new_elements = map { &$block($_) } @{ $self->_elements };
    return $class->from_array( \@new_elements );
}

=head2 detect($sub)

Returns the first element that evaluated agains $sub is true, if no element is 
detect throws an error

  my $employee = $employees->detect(sub { $_[0]->name eq 'John' });

=cut

sub detect {
    my ( $self, $block ) = @_;
    return $self->detect_and_if_none( 
        $block, 
        sub { Collections::Error::ElementNotFound->throw('Element not found') } 
    );
}

=head2 detect_and_if_none($sub,$another_sub) 

Returns the first element of the receiver that evaluated agains $sub is true, 
if no element is true evaluates $another_sub and returns the results

  my $employee = $employees->detect (
      sub { $_[0]->name eq 'John' },
      sub { $employees->add(Employee->new('John') }
  );

=cut

sub detect_and_if_none {
    my ( $self, $block, $ifnone_block ) = @_;
    grep { return $_ if ( &$block($_) ) } @{ $self->_elements };
    return &$ifnone_block;
}

=head2 do($sub)

Iterate over each of the receiver elements evaluating $sub for each element

  # print all elements
  $collection->do(sub { print $_[0] });

=cut

sub do {
    my ( $self, $block ) = @_;
    foreach ( @{ $self->_elements } ) {
        $block->($_);
    }
}

=head2 exists($element)

Returns a true value if an element $element exists

  if($collection->exists($element) {
    print 'Hey $element exists!';
  }

=cut

sub exists {
    my ( $self, $element ) = @_;
    foreach ( @{ $self->{elements} } ) {
        if ( $_ eq $element ) {
            return 1;
        }
    }
}

=head2 first()

Returns the first element of the receiver's elements if it can't be retrieve 
throws an Error::InvalidSize exception

  my $first_element = $collection->first;

=cut

sub first {
    my $self = shift;
    if ( not $self->is_empty ) {
        return $self->_elements->[0];
    }
    Collections::Error::InvalidSize->throw('Collection is empty');
}

=head2 index_of($element)

Returns the index of an $element, if the element is not part of the receiver's 
elements throws an Error::ElementNotFound exception, first element's index is 1

  $collection->add('hello');
  $collection->add('bye');
  ...
  $collection->index_of('bye');
  # This will return 2 (as it is the second element)

=cut

sub index_of {
    my ( $self, $element ) = @_;
    $self->index_of_and_if_none(
        $element,
        sub {
            Collections::Error::ElementNotFound->throw('Element not found');
        }
    );
}

=head2 index_of_and_if_none($element,$sub)

Returns the index of $element element, if the element is not part of the 
receiver's elements evaluates $sub

  $collection->index_of_and_if_none('hello', sub { print 'Not found!' });

=cut

sub index_of_and_if_none {
    my ( $self, $element, $ifnone_block ) = @_;
    grep { return $_ + 1 if ( $self->_elements->[$_] eq $element ) } 0 .. ( $self->size - 1 );
    return &$ifnone_block() if ( defined $ifnone_block );
}

=head2 inject_into($value,$sub)

Inject $value and iterate over each of receiver's elements using $sub, finally 
answer the result, this method is usefull for accumulator tasks

  # elements are 1, 5, 8, 9
  my $sum = $collection->inject_into(3, sub { $_[0] + $_[1] });

  # $sum is 26

=cut

sub inject_into {
    my ( $self, $value, $block ) = @_;
    my $result = $value;
    foreach ( @{ $self->_elements } ) {
        $result = $block->( $result, $_ );
    }
    return $result;
}

=head2 is_empty()

Returns true value if the receiver's has no elements

  if($collection->is_empty) {
    $collection->add($some_element);
  }

=cut

sub is_empty {
    my $self = shift;
    return !$self->size;
}

=head2 join($separator,$sub)

Iterate over each of receiver's element, evaluating $sub over each element, 
finally concatenate results using $separator

  my $all_names = $employees->join(',', sub { $_[0]->name });

=cut

sub join {
    my ( $self, $separator, $block ) = @_;
    if ($block) {
        return join( $separator, map { $block->($_) } @{ $self->_elements } );
    } else {
        return join( $separator, @{ $self->_elements } );
    }
}

=head2 last()

Returns the last element of the receiver's elements if it can't be retrieve 
throws an Collections::Error::InvalidSize exception

  my $last_element = $collection->last;

=cut

sub last {
    my $self = shift;
    if ( $self->size > 0 ) {
        return $self->_elements->[-1];
    }
    Collections::Error::InvalidSize->throw('Invalid collection size');
}

=head2 remove($element)

Removes $element from receiver's elements if the element doesn't exists 
throws Collections::Error::ElementNotFound exception

  $employees->remove($employees->first);

=cut

sub remove {
    my ( $self, $old_element ) = @_;

    splice( @{ $self->{elements} }, ( $self->index_of($old_element) - 1 ), 1 );
    return $old_element;
}

=head2 remove_all($elements)

Removes all $elements from receiver's elements if any of the elements to be 
removed doesn't exists throws Collections::Error::ElementNotFound exception

  my $elements = [1 2 3];
  $collection->remove_all($elements);
  ...
  $collection->remove_all($another_collection);

=cut

sub remove_all {
    my $self     = shift;
    my @elements = $self->_parameter_to_array(@_);

    foreach (@elements) {
        $self->remove($_);
    }

    return @_;

}

=head2 reverse()

Returns a collection like this one but with elements in reverse order

=cut

sub reverse {
    my $self  = shift;
    my $class = ref($self);
    return $class->from_array( reverse $self->to_array );
}

=head2 second()

Returns the second element of the receiver's elements if it doesn't exists 
throws an Error::InvalidSize exception

  my $second_element = $collection->second;

=cut

sub second {
    my $self = shift;
    if ( $self->size > 1 ) {
        return $self->_elements->[1];
    }
    Collections::Error::InvalidSize->throw('Invalid collection size');
}

=head2 size()

Returns the number of collection's elements

  print $collection->size;

=cut

sub size {
    my $self = shift;
    return scalar( @{ $self->{elements} } );
}

=head2 to_array()

Returns an array or array_ref (depending on the context) with all the elements

  print $collection->size;

=cut

sub to_array {
    my $self = shift;
    if ( wantarray() ) {
        return @{ $self->_elements };
    } else {
        return $self->_elements;
    }
}

=head2 to_ordered()

Returns the same object

  my $col = $collection->to_ordered;

=cut

sub to_ordered {
    shift();
}

=head2 to_set()

Returns a new Collections::Set with the elements of this collection

  my $set = $collection->to_set;

=cut

sub to_set {
    my $self = shift;

    my $new = Collections::Set->new;
    $new->add_all($self);
    return $new;
}

=head2 to_sorted($block)

Returns a new Collections::Sorted with the elements of this collection, first 
argument is the sort block if none specified it will use the default sorting
block

  my $sorted = $collection->to_sorted;

=cut

sub to_sorted {
    my $self = shift;

    my $new = Collections::Sorted->new(@_);
    $new->add_all($self);
    return $new;
}

#- Private ----------------------------------------------------------------------

sub _elements {
    return $_[0]->{elements};
}

sub _is_native_datatype {
    my ( $self, $ref ) = @_;
    return $ref =~ /^(SCALAR|ARRAY|HASH|CODE|REF|GLOB|LVALUE|FORMAT|IO|VSTRING|Regexp)$/;
}

sub _parameter_to_array {
    my $self = shift;

    # inline array
    if ( scalar(@_) > 1 ) {
        return @_;
    }

    my $ref = ref( $_[0] );

    # array ref
    if ( $ref eq 'ARRAY' ) {
        return @{ $_[0] };
    }

    # another Collections::*
    if ( not $self->_is_native_datatype($ref)
        and $_[0]->isa('Collections::Ordered') ) {
        return $_[0]->to_array;
    }

    # Nothing of above
    Collections::Error::InvalidArgument->throw('Invalid datatype');
}

1;

__END__ 

=head1 AUTHOR

Mariano Wahlmann, C<< <dichoso at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<dichoso at gmail.com>. 
I will be notified, and then you'll be notified of progress on your bug as I 
make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mariano Wahlmann, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
