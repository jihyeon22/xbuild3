###############################################################################
# Path

DESTDIR		:= $(CURDIR)/out

PREFIX		:= /system
BINDIR		:= $(PREFIX)/sbin
LINKPATH	:= /data/mds/system/sbin

###############################################################################
# Compile

CC	:= $(CROSS_COMPILE)gcc

CFLAGS	:= $(EXTRA_CFLAGS)
LDFLAGS	:= $(EXTRA_LDFLAGS)

###############################################################################
# Target rules

DTG_ENV	?= DTG_UPD_STAT

CFLAGS	+= -DDTG_ENV_VAL=\"$(DTG_ENV)\"
CFLAGS	+= -DBOARD_$(BOARD)

LDFLAGS	+=

OBJS	:=	src/checker.o src/md5.o
APP		:=	devinit2

all:		$(APP)

$(APP):		$(OBJS)
	$(Q)$(CC) $(CFLAGS) -o $@ $^

install:	$(APP)
	$(Q)$(call check_install_dir, $(DESTDIR)$(BINDIR))
	$(Q)fakeroot cp -v $(APP) $(DESTDIR)$(BINDIR)/$(APP)
	$(Q)fakeroot cp -v recov_scv.sh $(DESTDIR)$(BINDIR)/recov_scv.sh
	@ln -sf $(LINKPATH)/$(APP) $(DESTDIR)$(PREFIX)/$(APP)

clean:
	$(Q)rm -vrf $(APP) $(OBJS)

uninstall:
	$(Q)rm -vrf $(DESTDIR)$(BINDIR)/$(APP)
	$(Q)rm -vrf $(DESTDIR)$(PREFIX)/init

###############################################################################
# Functions

define check_install_dir
	if [ ! -d "$1" ]; then mkdir -p $1; fi
endef

