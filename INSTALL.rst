This document covers installing the kit from source.

Prerequisites
-------------

Required software:

* C compiler
* `CMake <https://cmake.org/>`_ is the build system used
* make
* patch
* bc
* TPC-H Tools https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp

Building
--------

::

	make -f Makefile.cmake release

If `make` is not available, the `cmake` commands can be reviewed in the
`Makefile.cmake` file.

Installing
----------

::

	cd builds/release
	cmake --install . --prefix /usr/local

Uninstalling
------------

::

    xargs rm < install_manifest.txt

The file `install_manifest.txt` will be created after running `make install`.
