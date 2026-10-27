# Fedora 44 / GNOME support

This fork targets Fedora 44 with GNOME. It uses Fedora's system Python and Qt/PyQt packages and
produces an RPM rather than installing into a developer virtual environment.

## Build and test

Install the build dependencies listed in the repository README, then run:

```bash
python3 build.py
QT_QPA_PLATFORM=offscreen python3 -m pytest -q core hscommon
desktop-file-validate pkg/dupeguru.desktop
```

## Build the RPM

From the repository root, ensure the source checkout is clean and the dependencies are installed.
The CI workflow creates a versioned source archive and builds the package with:

```bash
VERSION="$(python3 -c 'from core import __version__; print(__version__)')"
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
git archive --format=tar.gz --prefix="dupeguru-$VERSION/" HEAD > "rpmbuild/SOURCES/dupeguru-$VERSION.tar.gz"
rpmbuild -bb --define "_topdir $PWD/rpmbuild" pkg/rpm/dupeguru.spec
```

Install the resulting RPM with DNF to test dependency resolution. The package provides a
`dupeguru` launcher, a GNOME application-menu entry, and an hicolor icon. Its source and native
extensions are installed under `/usr/libexec/dupeguru`; it does not depend on a local `.venv`.

## Automated validation

The Fedora 44 GitHub Actions workflow:

1. Installs the Fedora build and runtime dependency packages.
2. Builds native extensions, Qt resources, translations, and help using the system Python.
3. Runs the core/helper regression tests with Qt in offscreen mode.
4. Validates the desktop entry.
5. Builds the RPM, installs it using DNF, checks installed paths and imports, and removes it again.

The container cannot prove that a user can complete an interactive scan in a real GNOME session.
Before publishing a release, manually launch the app from GNOME, scan a disposable test folder,
verify duplicate results and trash handling, and check that user preferences/data survive an
upgrade and are not deleted on uninstall.

## Readiness criteria

- Fedora 44 CI and RPM install/remove checks pass.
- RPM runtime dependencies resolve through Fedora repositories.
- The desktop entry and icon are valid and installed in standard paths.
- The app opens in a real GNOME session and completes a basic duplicate scan.
- License and user-data behavior are verified before publishing a release.
