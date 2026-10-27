Name:           dupeguru
Version:        4.3.1
Release:        1%{?dist}
Summary:        Find duplicate files on Fedora Linux

License:        GPL-3.0-only
URL:            https://github.com/usermo7amed/dupeguru-fedora
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc
BuildRequires:  python3
BuildRequires:  python3-devel
BuildRequires:  python3-setuptools
BuildRequires:  python3-qt5
BuildRequires:  python3-qt5-devel
BuildRequires:  python3-pytest
BuildRequires:  python3-sphinx
BuildRequires:  python3-polib
BuildRequires:  qt5-qttools-devel
BuildRequires:  gettext
BuildRequires:  desktop-file-utils

Requires:       python3
Requires:       python3-qt5
Requires:       python3-distro
Requires:       python3-mutagen
Requires:       python3-semantic_version
Requires:       python3-send2trash
Requires:       python3-xxhash

%description
dupeGuru is a cross-platform desktop tool for finding duplicate files.
This Fedora-focused build integrates with the GNOME application menu and
uses Fedora's system Python, Qt, and packaged Python dependencies.

%prep
%setup -q -n %{name}-%{version}

%build
python3 build.py

%check
QT_QPA_PLATFORM=offscreen python3 -m pytest -q core hscommon
desktop-file-validate pkg/dupeguru.desktop

%install
install -d %{buildroot}%{_libexecdir}/dupeguru
cp -a core hscommon qt locale images help %{buildroot}%{_libexecdir}/dupeguru/
install -m 0644 LICENSE %{buildroot}%{_libexecdir}/dupeguru/LICENSE

install -d %{buildroot}%{_bindir}
cat > %{buildroot}%{_bindir}/dupeguru <<'EOF'
#!/bin/sh
exec /usr/bin/python3 /usr/libexec/dupeguru/run.py "$@"
EOF
chmod 0755 %{buildroot}%{_bindir}/dupeguru
install -m 0644 run.py %{buildroot}%{_libexecdir}/dupeguru/run.py

install -Dpm 0644 pkg/dupeguru.desktop \
    %{buildroot}%{_datadir}/applications/dupeguru.desktop
install -Dpm 0644 images/dgse_logo_128.png \
    %{buildroot}%{_datadir}/icons/hicolor/128x128/apps/dupeguru.png

%files
%license LICENSE
%{_bindir}/dupeguru
%{_datadir}/applications/dupeguru.desktop
%{_datadir}/icons/hicolor/128x128/apps/dupeguru.png
%{_libexecdir}/dupeguru/
