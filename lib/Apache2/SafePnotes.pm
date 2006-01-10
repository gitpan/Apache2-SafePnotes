package Apache2::SafePnotes;

use 5.008;
use strict;
use warnings;
use Apache2::RequestUtil;

our $VERSION = '0.02';

my $pn;
BEGIN {$pn=\&Apache2::RequestRec::pnotes;}

sub safe_pnotes {
  my $r=shift;
  $r->$pn(@_==2 ? ($_[0], my $x=$_[1]) : @_);
}

sub import {
  my $module=shift;
  my $fn=shift || 'safe_pnotes';

  no warnings 'redefine';
  no strict 'refs';

  *{'Apache2::RequestRec::'.$fn}=\&safe_pnotes;
}

1;
__END__

=head1 NAME

Apache2::SafePnotes - a safer replacement for Apache2::RequestUtil::pnotes

=head1 SYNOPSIS

  use Apache2::SafePnotes;
  use Apache2::SafePnotes qw/pnotes/;
  use Apache2::SafePnotes qw/whatever/;

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

=head2 INTERFACE

This module must be C<use>'d not C<require>'d. It does it's work in an
C<import> function.

=over 4

=item B<use Apache2::SafePnotes>

creates the function C<Apache::RequestRec::safe_pnotes> as a replacement
for C<pnotes>. The old C<pnotes> function is preserved just in case some
code relies on the odd behavior.

=item B<use Apache2::SafePnotes qw/NAME/>

creates the function C<Apache::RequestRec::I<NAME>> as a replacement
for C<pnotes>. If C<pnotes> is passed as I<NAME> the original C<pnotes>
function is replaced by the safer one.

=head1 SEE ALSO

modperl2, C<Apache2::RequestUtil>

=head1 AUTHOR

Torsten Foertsch, E<lt>torsten.foertsch@gmx.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Torsten Foertsch

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
