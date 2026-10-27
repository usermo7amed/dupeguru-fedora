# Fedora 44 support

This fork is being prepared for Fedora 44 and its system Python/Qt stack. A successful
source checkout or successful compilation of one module is not, by itself, proof that the
application is ready to install or run.

## Validation stages

1. **Reproducible baseline:** run the `.github/workflows/fedora44.yml` workflow in a
   Fedora 44 container and record the exact failing step, Python version, Qt/PyQt versions,
   and dependency versions.
2. **Python compatibility:** fix source/API and dependency constraints only where the
   Fedora 44 build or tests demonstrate a real incompatibility. Do not raise the minimum
   supported Python version without checking the project's intended cross-platform support.
3. **Qt integration:** verify that the resource compiler is available, generated resources
   import correctly, and the UI can start with Qt's offscreen platform in headless CI.
4. **Regression tests:** run the existing core/helper tests, add focused tests for each
   compatibility fix, and check that native extensions are built for the interpreter used
   by the application.
5. **RPM packaging:** add a Fedora RPM spec after the dependency and install layout are
   confirmed. Prefer Fedora system packages for Python dependencies and Qt, declare runtime
   requirements explicitly, install files under standard system paths, and provide a desktop
   entry/icon. The package must not depend on a developer virtual environment.
6. **Install/uninstall verification:** build the RPM in a clean Fedora 44 environment, inspect
   it with RPM tools, install it, launch the app, verify desktop integration, and uninstall it.
7. **Documentation/release:** document the supported Fedora release, install/build commands,
   known limitations, and a reproducible version/release procedure.

## Local baseline

Install the Fedora build tools and Qt/PyQt development packages corresponding to the names
used in the workflow. Then run:

```bash
python3 -m venv --system-site-packages .venv
.venv/bin/python -m pip install --upgrade pip setuptools wheel
.venv/bin/python -m pip install -r requirements.txt -r requirements-extra.txt
.venv/bin/python build.py --modules
pyrcc5 qt/dg.qrc > qt/dg_rc.py
.venv/bin/python -m pytest -q core hscommon
.venv/bin/python build.py
```

Run these commands from the repository root. The CI workflow is the canonical baseline;
package names and dependency constraints should be adjusted based on actual Fedora 44
job results rather than assumptions.

## Readiness criteria

Fedora 44 support is considered ready only when all of the following are true:

- The full build and test workflow passes on Fedora 44.
- The application starts and performs a basic duplicate scan in a clean desktop session.
- The RPM installs and uninstalls cleanly and does not overwrite user data.
- Runtime dependencies are declared, and no build-only tools are required to run the app.
- The package's license, desktop file, icon, and installed file paths are verified.
- Known limitations and tested versions are documented.
