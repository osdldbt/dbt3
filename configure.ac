AC_PREREQ(2.59)

dnl Process this file with autoconf to produce a configure script.
AC_INIT(dbt3, 1.10_beta1, osdldbt-general@lists.sourceforge.net)
AM_INIT_AUTOMAKE

dnl Checks for programs.
AC_PROG_AWK
AC_PROG_CC

dnl Checks for header files.
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS(strings.h sys/time.h)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T
AC_HEADER_TIME
AC_STRUCT_TM

dnl Large file support?
AC_SYS_LARGEFILE

CFLAGS="-Wall $CFLAGS"
AC_CHECK_LIB(m, main)

AC_PATH_PROGS([SAR], [sar bsdsar], ,
             [$PATH:/usr/local/bin:/usr/bin])
if test -z "$SAR"; then
  AC_MSG_WARN([*** sar or bsdsar not found some scripts may not be usable])
  SAR=
fi

AC_ARG_WITH(postgresql,
	[AC_HELP_STRING([--with-postgresql], [])],
	[PGSQL_PATH=$withval DATABASE_TO_USE="pgsql" DATABASE_DEF="PGSQL=1"],
	[])
AC_SUBST(PGSQL_PATH)

AC_ARG_WITH(mysql,
	[AC_HELP_STRING([--with-mysql=DIR], [])],
	[MYSQL_PATH=$withval DATABASE_TO_USE="mysql" DATABASE_DEF="MYSQL=1"],
	[])

AC_ARG_WITH(sapdb,
	[  --with-sapdb],
	[DATABASE_TO_USE="sapdb" DATABASE_DEF="SABDB=1"], [])

AC_DEFINE(DBNAME, "dss")
AC_DEFINE(TPCH)
AC_DEFINE(LINUX)
TOPDIR=`pwd`
AC_SUBST(TOPDIR)
AC_SUBST(DATABASE_TO_USE)

if test "$DATABASE_TO_USE" = "mysql"; then
  dnl check if the user has the mysql binaries we need
  if test "$MYSQL_PATH" = "yes"; then
    MYSQL_TEST_PATH=$PATH
    MYSQL_BASEDIR_CNF=
    MYSQL_BASEDIR=.
  else
    MYSQL_TEST_PATH=$MYSQL_PATH/bin:$MYSQL_PATH/sbin:$MYSQL_PATH/libexec:$MYSQL_PATH/scripts
    MYSQL_BASEDIR_CNF="basedir=$MYSQL_PATH"
    MYSQL_BASEDIR="$MYSQL_PATH"
  fi

  AC_PATH_PROGS(MYSQL_CONFIG, mysql_config, , [$MYSQL_TEST_PATH])
  AC_PATH_PROGS(MYSQL_CLIENT, mysql, , [$MYSQL_TEST_PATH])
  AC_PATH_PROGS(MYSQL_ADMIN, mysqladmin, , [$MYSQL_TEST_PATH])
  AC_PATH_PROGS(MYSQLIMPORT, mysqlimport, , [$MYSQL_TEST_PATH])
  AC_PATH_PROGS(MYSQL_INSTALL_DB, mysql_install_db, , [$MYSQL_TEST_PATH])
  AC_PATH_PROGS(MYSQLD_SAFE, mysqld_safe, , [$MYSQL_TEST_PATH])
  AC_PATH_PROGS(MYSQLD, mysqld, , [$MYSQL_TEST_PATH])

  AC_SUBST(MYSQLD)
  AC_SUBST(MYSQLD_SAFE)

  AC_ARG_WITH(mysql-datadir,
	[ AC_HELP_STRING([ --with-mysql-datadir=DIR],[])],
	[ MYSQL_DATADIR=$withval],
	[ MYSQL_DATADIR=${TOPDIR}/scripts/mysql/mydata ])
  AC_SUBST(MYSQL_DATADIR)
  AC_ARG_WITH(mysql-engine,
	[ AC_HELP_STRING([ --with-mysql-engine=ENGINE],[Default MyISAM])],
	[ MYSQL_ENGINE=$withval],
	[ MYSQL_ENGINE=MyISAM])
  myengine=`echo $MYSQL_ENGINE | tr 'A-Z' 'a-z'`
  case $myengine in
    myisam)
      MYSQL_ENGINE_TUNING="--skip-innodb --key-buffer-size=500M"
      ;;
    innodb)
      MYSQL_ENGINE_TUNING="--key-buffer-size=16M --innodb_log_file_size=100M --innodb_buffer_pool_size=500M --innodb-doublewrite=false --innodb_flush_method=O_DIRECT "
      ;;
    nitro)
      MYSQL_ENGINE_TUNING="--skip-innodb --nitro_attempt_query_rewrite=0 --nitro_batch_enabled=1 --nitro_bulk_load_enabled=1 --sql-mode='TRADITIONAL' "
      ;;
    *)
      MYSQL_ENGINE_TUNING=""
      ;;
  esac
  AC_SUBST(MYSQL_ENGINE)  
  AC_SUBST(MYSQL_ENGINE_TUNING)

  MYSQL_PID=$MYSQL_DATADIR/mysql.pid
  MYSQL_SOCK=$MYSQL_DATADIR/mysql.sock
  AC_SUBST(MYSQL_PID)
  AC_SUBST(MYSQL_SOCK)

  AC_DEFINE(MYSQL, 1)
elif test "$DATABASE_TO_USE" = "pgsql"; then
  AC_DEFINE(PGSQL, 1)
elif test "$DATABASE_TO_USE" = "sapdb"; then
  AC_DEFINE(SAPDB, 1)

  AC_CONFIG_FILES([scripts/sapdb/build_db.sh],
      [chmod +x scripts/sapdb/build_db.sh])
  AC_CONFIG_FILES([scripts/sapdb/create_db.sh],
      [chmod +x scripts/sapdb/create_db.sh])
  AC_CONFIG_FILES([scripts/sapdb/create_indexes.sh],
      [chmod +x scripts/sapdb/create_indexes.sh])
  AC_CONFIG_FILES([scripts/sapdb/create_tables.sh],
      [chmod +x scripts/sapdb/create_tables.sh])
  AC_CONFIG_FILES([scripts/sapdb/drop_tables.sh],
      [chmod +x scripts/sapdb/drop_tables.sh])
  AC_CONFIG_FILES([scripts/sapdb/load_db.sh],
      [chmod +x scripts/sapdb/load_db.sh])
  AC_CONFIG_FILES([scripts/sapdb/sapdb_profile],
      [chmod +x scripts/sapdb/sapdb_profile])
  AC_CONFIG_FILES([scripts/sapdb/update_statistics.sh],
      [chmod +x scripts/sapdb/update_statistics.sh])
fi

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([doc/Makefile])
AC_CONFIG_FILES([scripts/Makefile])
AC_CONFIG_FILES([scripts/mysql/Makefile])
AC_CONFIG_FILES([scripts/pgsql/Makefile])
AC_CONFIG_FILES([scripts/sapdb/Makefile])
AC_CONFIG_FILES([src/Makefile])
AC_CONFIG_FILES([src/dbgen/Makefile])

AC_OUTPUT
