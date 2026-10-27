# dupeGuru — Fedora 44 / GNOME

[dupeGuru][dupeguru] is a desktop application for finding duplicate files. This fork targets
Fedora 44, using the system Python and Qt packages and a native RPM install layout for GNOME.

## Install on Fedora 44

A Fedora RPM is built and validated by the [Fedora 44 GNOME workflow](.github/workflows/fedora44.yml).
Until a release RPM is published, build it from a checkout using the instructions in
[docs/fedora44.md](docs/fedora44.md). Do not treat the source tree as an installed application.

## Fedora 44 build dependencies

```bash
sudo dnf install git make gcc gcc-c++ python3 python3-devel python3-setuptools \
  python3-pytest python3-sphinx python3-polib python3-distro python3-mutagen \
  python3-semantic-version python3-send2trash python3-xxhash \
  python3-qt5 python3-qt5-devel qt5-qttools-devel gettext rpm-build desktop-file-utils
```

## Build and test from source

```bash
python3 build.py
QT_QPA_PLATFORM=offscreen python3 -m pytest -q core hscommon
desktop-file-validate pkg/dupeguru.desktop
```

## Fedora RPM / GNOME integration

The RPM spec is in `pkg/rpm/dupeguru.spec`. The package installs the app under
`/usr/libexec/dupeguru`, a launcher in `/usr/bin/dupeguru`, a desktop entry under
`/usr/share/applications`, and the icon in the hicolor icon theme. Runtime dependencies are
declared as Fedora packages; the installed app does not use a developer virtual environment.

The CI workflow builds the RPM in a Fedora 44 container, validates its desktop entry, installs it
with DNF, checks key installed files and Python imports, and removes it again. A container test
does not replace a manual interactive scan test in a real GNOME session; that remains a release
check.

## Project scope

The maintained target is Fedora 44 / Linux. Windows- and macOS-specific packaging and CI are out
of scope for this fork; this does not imply that upstream has dropped support for those platforms.

[dupeguru]: https://dupeguru.voltaicideas.net/
