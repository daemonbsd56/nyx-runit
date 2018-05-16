SCRIPTS=	1 2 3 ctrlaltdel

all:
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

install:
	install -d ${DESTDIR}/{sbin,usr/bin}
	install -m755 halt ${DESTDIR}/sbin
	install -m755 pause ${DESTDIR}/usr/bin
	install -m755 shutdown ${DESTDIR}/sbin
	ln -sf halt ${DESTDIR}/sbin/poweroff
	ln -sf halt ${DESTDIR}/sbin/reboot
	install -d ${DESTDIR}/usr/share/man/man1
	install -m644 pause.1 ${DESTDIR}/usr/share/man/man1
	install -d ${DESTDIR}/usr/share/man/man8
	install -m644 shutdown.8 ${DESTDIR}/usr/share/man/man8
	install -d ${DESTDIR}/etc/sv
	install -d ${DESTDIR}/etc/runit/runsvdir
	install -m755 ${SCRIPTS} ${DESTDIR}/etc/runit
	install -m644 runit.conf ${DESTDIR}/etc/runit
	install -m644 modules ${DESTDIR}/etc/runit
	install -m755 rc.local ${DESTDIR}/etc/runit
	install -m755 rc.shutdown ${DESTDIR}/etc/runit
	touch ${DESTDIR}/etc/runit/stopit
	touch ${DESTDIR}/etc/runit/reboot
	cp -R --no-dereference --preserve=mode,links -v runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	cp -R --no-dereference --preserve=mode,links -v services/* ${DESTDIR}/etc/sv/

clean:
	-rm -f pause

.PHONY: all install clean
