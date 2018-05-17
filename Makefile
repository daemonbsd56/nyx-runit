CC=		gcc
SCRIPTS=	1 2 3 ctrlaltdel rc.local rc.shutdown
BINARY=		halt pause shutdown
CONF=		modules runit.conf
MAN1=		pause.1
MAN8=		shutdown.8

all:
	$(CC) $(CFLAGS) pause.c -o pause

install:
	install -d $(DESTDIR)/sbin
	install -m755 $(BINARY) $(DESTDIR)/sbin
	install -d $(DESTDIR)/etc/runit
	install -m755 $(SCRIPTS) $(DESTDIR)/etc/runit
	install -m644 $(CONF) $(DESTDIR)/etc/runit
	install -d $(DESTDIR)/usr/share/man/man1
	install -m644 $(MAN1) $(DESTDIR)/usr/share/man/man1
	install -d $(DESTDIR)/usr/share/man/man8
	install -m644 $(MAN8) $(DESTDIR)/usr/share/man/man8
	install -d $(DESTDIR)/etc/sv
	cp -r services/* $(DESTDIR)/etc/sv
	chmod 755 $(DESTDIR)/etc/sv/*/{run,finish}
	install -d $(DESTDIR)/etc/runit/runsvdir/default
	ln -sv default $(DESTDIR)/etc/runit/runsvdir/current
	install -d $(DESTDIR)/var
	ln -sv /etc/runit/runsvdir/current $(DESTDIR)/var/service
	touch $(DESTDIR)/etc/runit/{reboot,stopit}
	chmod 0 $(DESTDIR)/etc/runit/{reboot,stopit}
	ln -sv /etc/sv/getty-tty1 $(DESTDIR)/etc/runit/runsvdir/default

clean:
	rm -f pause

.PHONY: all install clean