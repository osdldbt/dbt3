AM_CFLAGS = -Wno-unused-variable -Wno-unused-but-set-variable -Wno-parentheses \
			-Wno-unused-result

bin_PROGRAMS = dbgen qgen

dbgen_SOURCES = build.c driver.c bm_utils.c rnd.c print.c load_stub.c bcd2.c \
		speed_seed.c text.c permute.c rng64.c
qgen_SOURCES = build.c bm_utils.c qgen.c rnd.c varsub.c text.c bcd2.c permute.c speed_seed.c \
		rng64.c

EXTRA_DIST = README HISTORY PORTING.NOTES BUGS dss.ddl dss.ri dists.dss makefile.suite 
