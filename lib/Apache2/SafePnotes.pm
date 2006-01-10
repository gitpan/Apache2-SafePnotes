package Apache2::SafePnotes;

use 5.008;
use strict;
use warnings;
use Apache2::RequestUtil;

our $VERSION = '0.01';

BEGIN {
  my $pn=\&Apache2::RequestRec::pnotes;
  no warnings 'redefine';
  *Apache2::RequestRec::pnotes=sub {
    my $r=shift;
    $r->$pn(@_==2 ? ($_[0], my $x=$_[1]) : @_);
  }
}

1;
__END__

=head1 NAME

Apache2::SafePnotes - a safer replacement for Apache2::RequestUtil::pnotes

=head1 SYNOPSIS

  use Apache2::SafePnotes;

=head1 DESCRIPTION

This module cures a problem with C<Apache2::RequestUtil::pnotes>. This
function stores perl variables making them accessible from various
phases of the Apache request cycle.

Unfortunately, the function does not copy a passed variable but only
increments its reference counter and saves a reference.

Thus, the following situation could lead to unexpected results:

  my $v=1;
  $r->pnotes( 'v'=>$v );
  $v++;
  my $x=$r->pnotes('v');

I'd expect C<$x> to be C<1> after that code snipped but it turns out to be
C<2>. The same goes for the tied hash interface:

  my $v=1;
  $r->pnotes->{v}=$v;
  $v++;
  my $x=$r->pnotes->{v};

Even now C<$x> is C<2>.

With C<Apache2::SafePnotes> the problem goes away and C<$x> will be C<1>
in both cases.

=head2 EXPORT

None.

=head1 SEE ALSO

modperl2, C<Apache2::RequestUtil>

=head1 AUTHOR

Torsten Foertsch, E<lt>torsten.foertsch@gmx.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Torsten Foertsch

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
