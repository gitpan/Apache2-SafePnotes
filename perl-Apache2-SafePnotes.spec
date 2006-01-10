Name:         perl-Apache2-SafePnotes
License:      Artistic License
Group:        Development/Libraries/Perl
Provides:     p_Apache2_SafePnotes
Obsoletes:    p_Apache2_SafePnotes
Requires:     perl = %{perl_version}
Requires:     p_mod_perl >= 1.999022
Autoreqprov:  on
Summary:      Apache2::SafePnotes
Version:      0.02
Release:      1
Source:       Apache2-SafePnotes-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
Apache2::SavePnotes



Authors:
--------
    Torsten Foertsch <torsten.foertsch@gmx.net>

%prep
%setup -n Apache2-SafePnotes-%{version}
# ---------------------------------------------------------------------------

%build
perl Makefile.PL
make && make test
# ---------------------------------------------------------------------------

%install
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT;
make DESTDIR=$RPM_BUILD_ROOT install_vendor
%{_gzipbin} -9 $RPM_BUILD_ROOT%{_mandir}/man3/Apache2::SafePnotes.3pm || true
%perl_process_packlist

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT;

%files
%defattr(-, root, root)
%{perl_vendorlib}/Apache2
%{perl_vendorarch}/auto/Apache2
%doc %{_mandir}/man3/Apache2::SafePnotes.3pm.gz
/var/adm/perl-modules/perl-Apache2-SafePnotes
%doc MANIFEST README
