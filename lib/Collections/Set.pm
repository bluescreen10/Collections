=head1 NAME

Collections::Set - Easy to use iterator with unique elements

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Collections::Set;

    my $col = Collections::Set->new;

    # Add new element
    $col->add('some string');
    $col->add('some string');

    # Size will return 1 (One unique element)
    print $col->size;

    # Remove element
    $col>remove('some string');

    # Size will return 0
    print $col->size;

=cut

package Collections::Set;

use strict;
use warnings;
use base qw(Collections::Ordered);

our $VERSION = '0.01';

=head1 INSTANCE METHODS

=head2 add($element)

Add $element as part of receiver's elements, if the element already exists
it does nothing

  $colection->add(1);

=cut

sub add {
    my $self    = shift;
    my $element = \(shift);
    if ( !$self->exists($$element)) {
        $self->SUPER::add($$element)
    }
    return $$element;
}

=head2 add_all($elements)

Add all $collection's element as part of receiver's elements, it adds elements
that don't already exists in the collection

  $colection->add_all($another_collection);
  ... or ...
  $collection->add_all(1,2,3);
  ... or ...
  $colection->add_all([1,2,3]);

=cut

sub add_all {
    my $self = shift;
    my @elements = $self->_parameter_to_array(@_);
    foreach (@elements) {
        $self->add($_);
    }
}

=head2 to_ordered()

Returns an Collections::Ordered with the same elements of this collection

   my $col = $collection->to_ordered;

=cut

sub to_ordered {
    my $self = shift;

    my $new = Collections::Ordered->new;
    $new->add_all($self);
    return $new;
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
