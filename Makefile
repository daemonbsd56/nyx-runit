CC=		gcc
SCRIPTS=	1 2 3 ctrlaltdel startup.local shutdown.local startup shutdown
BINARY=		halt pause shutdown-bin
CONF=		modules runit.conf
MAN1=		pause.1
MAN8=		shutdown.8
OSNAME=		GNU/Linux

all:
	$(CC) $(CFLAGS) pause.c -o pause

install:
	install -d $(DESTDIR)/sbin
	install -m755 $(BINARY) $(DESTDIR)/sbin
	mv $(DESTDIR)/sbin/shutdown-bin $(DESTDIR)/sbin/shutdown
	ln -sf halt $(DESTDIR)/sbin/reboot
	ln -sf halt $(DESTDIR)/sbin/poweroff
	install -d $(DESTDIR)/etc/runit
	install -m755 $(SCRIPTS) $(DESTDIR)/etc/runit
	sed -i 's:GNU/Linux:$(OSNAME):' $(DESTDIR)/etc/runit/startup
	install -m644 $(CONF) $(DESTDIR)/etc/runit
	install -d $(DESTDIR)/usr/share/man/man1
	install -m644 $(MAN1) $(DESTDIR)/usr/share/man/man1
	install -d $(DESTDIR)/usr/share/man/man8
	install -m644 $(MAN8) $(DESTDIR)/usr/share/man/man8
	install -d $(DESTDIR)/etc/sv
	cp -r services/* $(DESTDIR)/etc/sv
	chmod 755 $(DESTDIR)/etc/sv/*/{run,finish}
	install -d $(DESTDIR)/etc/runit/runsvdir/{default,single}
	[ -L $(DESTDIR)/etc/runit/runsvdir/current ] || ln -s default $(DESTDIR)/etc/runit/runsvdir/current
	install -d $(DESTDIR)/var
	[ -L $(DESTDIR)/var/service ] || ln -s /etc/runit/runsvdir/current $(DESTDIR)/var/service
	touch $(DESTDIR)/etc/runit/{reboot,stopit}
	chmod 0 $(DESTDIR)/etc/runit/{reboot,stopit}
	ln -sf /etc/sv/getty-tty1 $(DESTDIR)/etc/runit/runsvdir/default
	ln -sf /etc/sv/sulogin $(DESTDIR)/etc/runit/runsvdir/single

clean:
	rm -f pause

.PHONY: all install clean