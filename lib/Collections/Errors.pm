=head1 NAME

Collections::Errors - Exception classes for collections

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

     try {
        $collection->detect($not_existent_element);
     } catch Collections::Error::ElementNotFound with {
        # Element not found block
        print 'element does not exists';
     };

=head1 AUTHOR

Mariano Wahlmann, C<< <dichoso at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-collections-ordered at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Collections>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mariano Wahlmann, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

package Collections::Error::ElementNotFound;

use strict;
use warnings;
use base qw(Error::Simple);
1;

#################################################################################

package Collections::Error::InvalidArgument;

use strict;
use warnings;
use base qw(Error::Simple);
1;
#################################################################################


package Collections::Error::InvalidSize;
use strict;
use warnings;
use base qw(Error::Simple);
1;

#################################################################################

