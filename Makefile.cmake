.PHONY: clean debug default package release

default:
	@echo "targets: clean, package"

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
