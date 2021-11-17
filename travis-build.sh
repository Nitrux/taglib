#! /bin/sh

apt -qq update
apt -qq -yy install equivs curl git

deps=$(sed -e '/^#.*$/d; /^$/d; /^\s*$/d' package/dependencies | paste -sd ,)
git_commit=$(git rev-parse --short HEAD)

> configuration printf "%s\n" \
	"Section: misc" \
	"Priority: optional" \
	"Homepage: https://nxos.org" \
	"Package: taglib-compat" \
	"Version: 0.0.1-$git_commit" \
	"Maintainer: Uri Herrera <uri_herrera@nxos.org>" \
	"Depends: $deps" \
	"Conflicts: libtag1v5, libtag1v5-vanilla, libtag1-dev" \
	"Provides: libtag1v5, libtag1v5-vanilla, libtag1-dev" \
	"Architecture: amd64" \
	"Description: Transitional package for taglib."

equivs-build configuration
