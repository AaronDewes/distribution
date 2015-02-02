# Set an output prefix, which is the local directory if not specified
PREFIX?=$(shell pwd)

# Used to populate version variable in main package.
GO_LDFLAGS=-ldflags "-X `go list ./version`.Version `git describe --match 'v[0-9]*' --dirty='.m' --always`"

.PHONY: clean binaries
.DEFAULT: default

default:
	@echo Please read the make targets before using this Makefile.

AUTHORS: .mailmap .git/ORIG_HEAD .git/FETCH_HEAD .git/HEAD
	 git log --format='%aN <%aE>' | sort -fu >> $@

# This only needs to be generated by hand when cutting full releases.
version/version.go:
	./version/version.sh > $@

${PREFIX}/bin/registry: version/version.go $(shell find . -type f -name '*.go')
	go build -o $@ ${GO_LDFLAGS} ./cmd/registry

binaries: ${PREFIX}/bin/registry

clean:
	rm -rf "${PREFIX}/bin/registry"