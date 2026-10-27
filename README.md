# dupeGuru — Fedora/Linux development fork

[dupeGuru][dupeguru] is a desktop application for finding duplicate files. This fork focuses on
building, testing, packaging, and running dupeGuru on Linux, with **Fedora 44 as the primary target**.

## Project scope

This fork's active CI and packaging work targets Fedora 44. Windows- and macOS-specific build
instructions and packaging checks are intentionally out of scope here. The upstream project may
continue to support other operating systems; this fork does not claim to validate them.

## Source layout

- `core`: duplicate detection and application logic.
- `qt`: Qt desktop UI and resources.
- `hscommon`: shared helper code.
- `images`: application artwork.
- `pkg`: packaging support files.
- `help`: application documentation.
- `locale`: translations.

## Fedora 44 system dependencies

Install the Fedora development tools and Qt/PyQt packages:

```bash
sudo dnf install git make gcc gcc-c++ python3 python3-devel python3-pip \
  python3-qt5 python3-qt5-devel qt5-qttools-devel gettext
```

Package names can vary by Fedora release/repository. If a package is unavailable, verify the
current Fedora 44 package name before substituting another package.

## Build and run locally

From the repository root:

```bash
python3 -m venv --system-site-packages .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r requirements.txt -r requirements-extra.txt
.venv/bin/python build.py --modules
pyrcc5 qt/dg.qrc > qt/dg_rc.py
.venv/bin/python build.py --loc
.venv/bin/python run.py
```

The workflow uses Fedora 44 and is the canonical automated baseline:
[Fedora 44 CI workflow](.github/workflows/fedora44.yml).

## Tests

```bash
QT_QPA_PLATFORM=offscreen .venv/bin/python -m pytest -q core hscommon
```

The tox configuration runs the project checks using the available Python interpreter. Fedora 44
CI is the release-target validation; this fork does not maintain a Windows/macOS test matrix.

## Fedora 44 readiness

See [Fedora 44 support notes](docs/fedora44.md) for the staged compatibility work, RPM packaging
requirements, clean installation/uninstallation checks, and release criteria. Fedora 44 support
must not be considered complete until CI passes and the application has been tested in a clean
Fedora desktop environment.

[dupeguru]: https://dupeguru.voltaicideas.net/
