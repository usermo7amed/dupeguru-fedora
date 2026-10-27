# Fedora 44 support

This fork focuses on Fedora 44 and Linux. Windows/macOS CI matrices, packaging work, and platform-
specific build instructions are out of scope. This does not mean upstream has dropped support for
those systems; it means this fork only validates Fedora/Linux.

## Validation stages

1. **Reproducible baseline:** run the `.github/workflows/fedora44.yml` workflow in a Fedora 44
   container and record the exact failing step, Python version, Qt/PyQt versions, and dependency versions.
2. **Python compatibility:** fix source/API and dependency constraints only where the Fedora 44
   build or tests demonstrate a real incompatibility. Avoid unnecessary version changes.
3. **Qt integration:** verify that the resource compiler is available, generated resources import
   correctly, and the UI can start in a headless test environment.
4. **Linux regression tests:** run the core/helper test suite and add focused tests for each
   compatibility fix. Native extensions must be built for the same interpreter used by the app.
5. **RPM packaging:** add a Fedora RPM spec after dependency and install layout are confirmed.
   Prefer Fedora system packages for Python dependencies and Qt, declare runtime requirements,
   install files under standard system paths, and provide a desktop entry and icon. The installed
   package must not depend on a developer virtual environment.
6. **Install/uninstall verification:** build the RPM in a clean Fedora 44 environment, inspect it
   with RPM tools, install it, launch the app, verify desktop integration, and uninstall it without
   removing user data.
7. **Documentation/release:** document tested Fedora versions, installation/build commands, known
   limitations, and a reproducible version/release procedure.

## Local baseline

Install the Fedora build tools and Qt/PyQt development packages listed in the workflow. Then run:

```bash
python3 -m venv --system-site-packages .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r requirements.txt -r requirements-extra.txt
.venv/bin/python build.py --modules
pyrcc5 qt/dg.qrc > qt/dg_rc.py
.venv/bin/python -m pytest -q core hscommon
.venv/bin/python build.py
```

Run these commands from the repository root. The CI workflow is the canonical baseline; adjust
dependency constraints only in response to reproducible Fedora 44 failures.

## Readiness criteria

Fedora 44 support is ready only when:

- The Fedora 44 build and regression-test workflow passes.
- The application starts and performs a basic duplicate scan in a clean Fedora desktop session.
- The RPM installs and uninstalls cleanly without overwriting user data.
- Runtime dependencies are declared; build-only tools are not required to run the app.
- License, desktop entry, icon, and installed file paths are verified.
- Known limitations and tested versions are documented.
