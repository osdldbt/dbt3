.PHONY: clean default package

default:
	@echo "targets: clean, package"

clean:
	-rm -rf builds

package:
	git checkout-index --prefix=builds/ -a
	cmake -Hbuilds -Bbuilds
	cd builds && make package_source
