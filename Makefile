
BASE_PREFIX ?= /opt/dynamic-knockd
SYSTEMD_PREFIX ?= /usr/local/lib/systemd/system

.PHONY: exec all base systemd

exec:
	@echo "There is no compilation necessary."
	@echo "Run 'make all' to install everything to default locations."
	@echo "See the 'Installation' section in 'README.md' for more details."

all: base systemd

base:
	install -d $(BASE_PREFIX)/generators $(BASE_PREFIX)/etc
	install -bm 0755 update.bash $(BASE_PREFIX)
	install -bm 0755 generators/* $(BASE_PREFIX)/generators

systemd:
	install -d $(SYSTEMD_PREFIX)
	install -bm 0644 systemd/dynamic-knockd.* $(SYSTEMD_PREFIX)

