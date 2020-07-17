# Location of the ESMF makefile fragment for this component:
aqm_mk = $(AQM_BINDIR)/aqm.mk
all_component_mk_files+=$(aqm_mk)

# Location of source code and installation
AQM_SRCDIR?=$(ROOTDIR)/AQM
AQM_BINDIR?=$(ROOTDIR)/AQM_INSTALL

# Make sure the expected directories exist and are non-empty:
$(call require_dir,$(AQM_SRCDIR),AQM source directory)

ifneq (,$(findstring DEBUG=Y,$(AQM_MAKEOPT)))
  override AQM_CONFOPT += --enable-debug
endif

########################################################################

# Rule for building this component:

build_AQM: $(aqm_mk)

$(aqm_mk): configure
	$(MODULE_LOGIC) ; export $(AQM_ALL_OPTS)              ; \
	set -e                                                ; \
	cd $(AQM_SRCDIR)                                      ; \
	./configure --prefix=$(AQM_BINDIR)                      \
	  --datarootdir=$(AQM_BINDIR) --libdir=$(AQM_BINDIR)    \
	  $(AQM_CONFOPT)
	+$(MODULE_LOGIC) ; cd $(AQM_SRCDIR) ; exec $(MAKE)
	+$(MODULE_LOGIC) ; cd $(AQM_SRCDIR) ; exec $(MAKE) install
	test -d "$(AQM_BINDIR)"

########################################################################

# Rule for cleaning the SRCDIR and BINDIR:

clean_AQM:
	+cd $(AQM_SRCDIR) ; test -f Makefile && exec $(MAKE) -k distclean || echo "Nothing to clean up"

distclean_AQM: clean_AQM
	rm -rf $(AQM_BINDIR) $(aqm_mk)
