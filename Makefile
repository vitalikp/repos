
PROJECT = repos
VERSION = $(shell awk '/Version:/ { print $$2 }' $(SPECFILE))
RELEASE = $(shell awk '/Release:/ { print $$2 }' $(SPECFILE))

PACKAGE = vitalikp-$(PROJECT)-$(VERSION)
SPECFILE = $(PROJECT).spec

ARCH = $(PACKAGE).tar.xz

REPOS = $(wildcard *.repo)

RPMFILE = $(PACKAGE)-$(RELEASE).noarch.rpm
RPMBUILD = rpmbuild --nodeps --define "_topdir $(BUILDDIR)" --define "_builddir $(BUILDDIR)"

all: rpm

rpm: $(RPMFILE)

$(RPMFILE): $(ARCH)
	@$(eval export BUILDDIR = $(shell mktemp -d /tmp/build.XXXXXX))
	@ln -s $(PWD)/$(ARCH) $(BUILDDIR)/
	@cd $(BUILDDIR) &&  $(RPMBUILD) -tb $(ARCH)
	@mv $(BUILDDIR)/RPMS/noarch/$(RPMFILE) .
	@rm -rf $(BUILDDIR)

.INTERMEDIATE: $(PACKAGE)

$(ARCH): $(PACKAGE)
	@echo "archive “$@” created"

$(PACKAGE): $(SPECFILE) $(REPOS)
	@tar --transform "s/^/$@\//" -cf $@.tar $(SPECFILE) rpm-gpg $(REPOS)
	@xz $@.tar

sign: $(RPMFILE)
	rpmsign --addsign $(RPMFILE)

clean:
	@rm -f $(ARCH)
	@rm -f $(RPMFILE)
