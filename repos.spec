Name:		vitalikp-repos
Version:	0.4
Release:	1
Summary:	rpm packages repository

Group:		System Environment/Base
License:	MIT
URL:		https://github.com/vitalikp/repos
Source0:	%{name}-%{version}.tar.xz
BuildArch:	noarch

%description
vitalikp rpm packages repository.

%prep
%setup -q

%build

%install
# install public keys
install -d -m 755 %{buildroot}/etc/pki/rpm-gpg
install -m 644 rpm-gpg/RPM-GPG-KEY-vitalikp %{buildroot}/etc/pki/rpm-gpg/RPM-GPG-KEY-vitalikp-%{version}

# install repos
install -d -m 755 %{buildroot}%{_sysconfdir}/yum.repos.d
for file in vitalikp*repo ; do
  install -m 644 $file %{buildroot}%{_sysconfdir}/yum.repos.d
done

%files
%dir %{_sysconfdir}/pki/rpm-gpg
%{_sysconfdir}/pki/rpm-gpg/RPM-GPG-KEY-vitalikp-%{version}
%dir %{_sysconfdir}/yum.repos.d
%config(noreplace) %{_sysconfdir}/yum.repos.d/vitalikp.repo
