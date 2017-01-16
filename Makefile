PYTHON=`which python`
CYTHON=`which cython`
DESTDIR=/
PROJECT=python-scattnlay
VERSION=2.1
BUILDIR=$(CURDIR)/debian/$(PROJECT)
SRCDIR=$(CURDIR)/src
MULTIPREC=100

all:
	@echo "make source - Create source package for Python extension"
	@echo "make cython - Convert Cython code to C++"
	@echo "make python_ext - Create Python extension using C++ code"
	@echo "make python_ext_mp - Create miltiprecision Python extension using C++ code"
	@echo "make cython_ext - Create Python extension using Cython code"
	@echo "make install - Install Python extension on local system"
	@echo "make buildrpm - Generate a rpm package for Python extension"
	@echo "make builddeb - Generate a deb package for Python extension"
	@echo "make builddebmp - Generate a deb package for Python extension with multiprecision"
	@echo "make standalone - Create standalone programs (scattnlay and fieldnlay)"
	@echo "make standalonemp - Create standalone programs (scattnlay and fieldnlay) with multiprecision"
	@echo "make clean - Delete temporal files"
#	make standalone

source:
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../

cython: scattnlay.pyx
	$(CYTHON) --cplus scattnlay.pyx
	mv scattnlay.cpp $(SRCDIR)/

python_ext: $(SRCDIR)/nmie.cc $(SRCDIR)/py_nmie.cc $(SRCDIR)/scattnlay.cpp
	export CFLAGS='-std=c++11' && $(PYTHON) setup.py build_ext --inplace

python_ext_mp: $(SRCDIR)/nmie.cc $(SRCDIR)/py_nmie.cc $(SRCDIR)/scattnlay.cpp
	export CFLAGS='-std=c++11 -DMULTI_PRECISION=$(MULTIPREC)' && $(PYTHON) setup-mp.py build_ext --inplace

cython_ext: $(SRCDIR)/nmie.cc $(SRCDIR)/py_nmie.cc scattnlay.pyx
	export CFLAGS='-std=c++11' && $(PYTHON) setup.py build_ext --inplace

install:
	$(PYTHON) setup.py install --root $(DESTDIR) $(COMPILE)

buildrpm:
	#$(PYTHON) setup.py bdist_rpm --post-install=rpm/postinstall --pre-uninstall=rpm/preuninstall
	$(PYTHON) setup.py bdist_rpm --dist-dir=../

builddeb:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
	$(PYTHON) setup.py sdist $(COMPILE) --dist-dir=../ --prune
	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
	dpkg-buildpackage -i -I -rfakeroot

#builddebmp:
	# build the source package in the parent directory
	# then rename it to project_version.orig.tar.gz
#	$(PYTHON) setup-mp.py sdist $(COMPILE) --dist-dir=../ --prune
#	rename -f 's/$(PROJECT)-(.*)\.tar\.gz/$(PROJECT)_$$1\.orig\.tar\.gz/' ../*
	# build the package
#	export CFLAGS='-std=c++11 -DMULTI_PRECISION=$(MULTIPREC)' && dpkg-buildpackage -i -I -rfakeroot

standalone: $(SRCDIR)/farfield.cc $(SRCDIR)/nearfield.cc $(SRCDIR)/nmie.cc
	export CFLAGS='-std=c++11' && c++ -DNDEBUG -O2 -Wall -std=c++11 $(SRCDIR)/farfield.cc $(SRCDIR)/nmie.cc  -lm -o scattnlay
	mv scattnlay ../
	export CFLAGS='-std=c++11' && c++ -DNDEBUG -O2 -Wall -std=c++11 $(SRCDIR)/nearfield.cc $(SRCDIR)/nmie.cc  -lm -o fieldnlay
	mv fieldnlay ../

standalonemp: $(SRCDIR)/farfield.cc $(SRCDIR)/nearfield.cc $(SRCDIR)/nmie.cc
	export CFLAGS='-std=c++11' && c++ -DNDEBUG -DMULTI_PRECISION=$(MULTIPREC) -O2 -Wall -std=c++11 $(SRCDIR)/farfield.cc $(SRCDIR)/nmie.cc  -lm -o scattnlay-mp
	mv scattnlay-mp ../
	export CFLAGS='-std=c++11' && c++ -DNDEBUG -DMULTI_PRECISION=$(MULTIPREC) -O2 -Wall -std=c++11 $(SRCDIR)/nearfield.cc $(SRCDIR)/nmie.cc  -lm -o fieldnlay-mp
	mv fieldnlay-mp ../

clean:
	$(PYTHON) setup.py clean
	$(MAKE) -f $(CURDIR)/debian/rules clean
	rm -rf build/ MANIFEST
	find . -name '*.pyc' -delete
	find . -name '*.o' -delete
	find . -name '*.so' -delete
