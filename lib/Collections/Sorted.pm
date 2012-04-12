=head1 NAME

Collections::Sorted - Easy to use iterator with sorted elements

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Collections::Sorted;

    # Ordered collection
    my $col = Collections::Sorted->new( sub { $_[0] <=> $_[1] } );

    $col->add(101);
    $col->add(102);

    # this will return 101
    print $col->first;

=head1 NOTES

Sort blocks are expected to return -1, 0, 1 as default sort blocks on perl
if your block only return two values that can cause bad sorted sets

=cut

package Collections::Sorted;

use strict;
use warnings;
use base qw(Collections::Ordered);

=head1 CLASS METHODS

=head2 new()

Returns a new instace of a sorted Collection, first argument passed is the
sort block, if no argument passed it will use default sort block which is
sub { $_[0] <=> $_[1] }

  my $collection = Collections::Sorted->new;

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new();
    $self->_initialize(@_);
    return $self;
}

=head1 INSTANCE METHODS

=head2 add

Read Collections::Ordered

=cut


sub add {
    my $self = shift;
    $self->{is_dirty} = 1;
    return $self->SUPER::add(@_);
}

=head2 add_all

Read Collections::Ordered

=cut

sub add_all {
    my $self = shift;
    $self->{is_dirty} = 1;
    return $self->SUPER::add_all(@_);
}

=head2 reverse()

reverse method doesn't make sense for sorted collections, because order is 
imposed, so it will return an ordered collection with elements in reverse order

=cut

sub reverse {
    my $self = shift;
    return Collections::Ordered->from_array($self->to_array);
}

=head2 sort_block($sub)

If passed with $sub changes the current sort block, it also re-sort the 
entire collection, if no arguments passed it returns the sort block

  $colection->sort_block( sub { $_[0] <=> $_[1]  });

=cut

sub sort_block {
    my $self = shift;
    if (@_) {
        $self->{sort_block} = shift;
        $self->{is_dirty} = 1;
    }
    return $self->{sort_block};
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

#- Private ----------------------------------------------------------------------

sub _elements {
    my $self = shift;

    # Sort before we do any operation with the elements
    if ( $self->{is_dirty} ) {
        if( $self->size > 1) {
            $self->_sort;
        }
        $self->{is_dirty} = undef;
    }
    return $self->{elements};
}

sub _initialize {
    my $self = shift;
    $self->{is_dirty} = 1;

    if (@_) {
        $self->{sort_block} = shift;
    } else {
        $self->{sort_block} = sub { $_[0] <=> $_[1] };
    }
}

sub _sort {
    my $self = shift;
    my $sort_block = $self->{sort_block};
    $self->{elements} = [ sort { $sort_block->($a, $b) }  @{ $self->{elements} } ];
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
