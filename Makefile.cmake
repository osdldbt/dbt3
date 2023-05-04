.PHONY: appimage clean debug default package release

default:
	@echo "targets: appimage (Linux only), clean, debug, package, release"

appimage:
	cmake -H. -Bbuilds/appimage -DCMAKE_INSTALL_PREFIX=/usr
	cd builds/appimage && make -s
	cd builds/appimage && make -s install DESTDIR=AppDir
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
