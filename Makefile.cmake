# vim: set ft=make :

.PHONY: appimage clean dbgen debug default package release

# Default database to build the appimage for, since dbgen can only be patched
# for one DBMS as a time.
DBMS = pgsql

default:
	@echo "targets: appimage (Linux only), clean, debug, package, release"

appimage:
	cmake -H. -Bbuilds/appimage -DCMAKE_INSTALL_PREFIX=/usr
	cd builds/appimage && make install DESTDIR=../AppDir
	if [ "$(DBGEN)" = "" ]; then \
		cd builds/appimage && make DBMS= appimage; \
	else \
		mkdir -p builds/AppDir/opt; \
		unzip -d builds/AppDir/opt "$(DBGEN)"; \
		mv builds/AppDir/opt/TPC-H* builds/AppDir/opt/dbgen; \
		builds/AppDir/usr/bin/dbt3-build-dbgen --patch-dir=patches \
				--query-dir=queries $(DBMS) builds/AppDir/opt/dbgen; \
		sed -i -e "s#/usr#././#g" builds/AppDir/opt/dbgen/dbgen/dbgen \
				builds/AppDir/opt/dbgen/dbgen/qgen; \
		export DBMS=$(DBMS); \
		cd builds/appimage && make DBMS=$(DBMS) appimage; \
	fi

dbgen-pgsql:
	cmake -H. -Bbuilds/appimage -DCMAKE_INSTALL_PREFIX=/usr
	cd builds/appimage && make -s
	cd builds/appimage && make -s install DESTDIR=AppDir
	mkdir -p /usr/local/AppDir/opt/
	cp -pr dbgen /usr/local/AppDir/opt/
	builds/appimage/AppDir/usr/bin/dbt3-build-dbgen --patch-dir=patches \
			--query-dir=queries/pgsql pgsql /usr/local/AppDir/opt/dbgen
	cp -p queries/pgsql/*.sql /usr/local/AppDir/opt/dbgen/dbgen/queries/
	cd builds/appimage && make -s appimage-podman

debug:
	cmake -H. -Bbuilds/debug -DCMAKE_BUILD_TYPE=Debug
	cd builds/debug && make

clean:
	-rm -rf builds

package:
	git checkout-index --prefix=builds/ -a
	cmake -Hbuilds -Bbuilds
	cd builds && make package_source

release:
	cmake -H. -Bbuilds/release
	cd builds/release && make
