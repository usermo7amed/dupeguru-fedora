PYTHON ?= python3
PYRCC5 ?= pyrcc5
PREFIX ?= /usr/local

# Linux/Fedora-only development build.
VENV_PYTHON = ./.venv/bin/python
packages = hscommon core qt
localedirs = $(wildcard locale/*/LC_MESSAGES)
pofiles = $(wildcard locale/*/LC_MESSAGES/*.po)
mofiles = $(patsubst %.po,%.mo,$(pofiles))

vpath %.po $(localedirs)
vpath %.mo $(localedirs)

all: .venv modules qt/dg_rc.py i18n
	@echo "Build complete! Run 'make run' to launch dupeGuru."

.venv:
	${PYTHON} -m venv --system-site-packages .venv
	${VENV_PYTHON} -m pip install --upgrade pip setuptools wheel
	${VENV_PYTHON} -m pip install -r requirements.txt -r requirements-extra.txt

run: all
	${VENV_PYTHON} run.py

pyc: all
	${VENV_PYTHON} -m compileall ${packages}

reqs:
	@${PYTHON} -c 'import sys; assert sys.version_info >= (3, 7), "Python 3.7+ required"'
	@${PYTHON} -c 'import PyQt5' >/dev/null 2>&1 || \
		{ echo "PyQt5 is required; install Fedora's PyQt5 packages first."; exit 1; }

modules: .venv
	${VENV_PYTHON} build.py --modules

qt/dg_rc.py: qt/dg.qrc
	${PYRCC5} qt/dg.qrc > qt/dg_rc.py

i18n: $(mofiles)

%.mo: %.po
	msgfmt -o $@ $<

install: all pyc
	install -d ${DESTDIR}${PREFIX}/share/dupeguru
	cp -rf ${packages} locale ${DESTDIR}${PREFIX}/share/dupeguru
	install -m 755 run.py ${DESTDIR}${PREFIX}/share/dupeguru/run.py
	install -d ${DESTDIR}${PREFIX}/bin
	ln -sf ${PREFIX}/share/dupeguru/run.py ${DESTDIR}${PREFIX}/bin/dupeguru
	install -d ${DESTDIR}${PREFIX}/share/applications
	install -m 644 pkg/dupeguru.desktop ${DESTDIR}${PREFIX}/share/applications/dupeguru.desktop
	install -d ${DESTDIR}${PREFIX}/share/pixmaps
	install -m 644 images/dgse_logo_128.png ${DESTDIR}${PREFIX}/share/pixmaps/dupeguru.png

uninstall:
	rm -rf "${DESTDIR}${PREFIX}/share/dupeguru"
	rm -f "${DESTDIR}${PREFIX}/bin/dupeguru"
	rm -f "${DESTDIR}${PREFIX}/share/applications/dupeguru.desktop"
	rm -f "${DESTDIR}${PREFIX}/share/pixmaps/dupeguru.png"

clean:
	rm -rf build
	rm -f locale/*/LC_MESSAGES/*.mo
	rm -f core/pe/*.so qt/pe/*.so

.PHONY: all clean i18n install modules pyc reqs run uninstall
