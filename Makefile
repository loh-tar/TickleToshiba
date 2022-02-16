PROG ?= tickle-toshiba
PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man
DOCDIR ?= $(PREFIX)/share/doc

SYSTEMD_USERSERVICE_DIR ?= $(LIBDIR)/systemd/user

BINDIR ?= $(PREFIX)/bin

all:
	@echo "$(PROG) is a shell script and does not need compilation."
	@echo "To install, simply try \"make install\"."

install:
	@install -vd "$(DESTDIR)$(SYSTEMD_USERSERVICE_DIR)/" "$(DESTDIR)$(BINDIR)"
	@install -vm 0755 "$(PROG)" "$(DESTDIR)$(BINDIR)/$(PROG)"
	@install -vm 0644 "tickle-@.service" "$(DESTDIR)$(SYSTEMD_USERSERVICE_DIR)"
	@install -vm 0444 "tickle-toshiba.txt" "$(DESTDIR)$(DOCDIR)"
	@echo
	@echo "Installation of $(PROG) is complete!"
	@echo "Reading tip: $(DESTDIR)$(DOCDIR)/tickle-toshiba.txt"

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(BINDIR)/$(PROG)" \
		"$(DESTDIR)$(SYSTEMD_USERSERVICE_DIR)/tickle-@.service" \
		"$(DESTDIR)$(DOCDIR)/tickle-toshiba.txt"

.PHONY: install uninstall
