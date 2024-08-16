====================================
Database Test 3 (DBT-3) User's Guide
====================================

.. image:: osdl-logo.png
   :width: 600
   :alt: OSDL Logo

Copyright (c) 2002 by The Open Source Development Laboratory, Inc. This
material may be distributed only subject to the terms and conditions set forth
in the Open Publication License, v1.0 or later (the latest version is currently
available at http://www.opencontent.org/openpub/). Distribution of
substantively modified versions of this document is prohibited without the
explicit permission of the copyright holder.

Other company, product or service names may be trademarks or service marks of
others.

Contributors to this document include:

* Jenny Zhang (OSDL)
* Mary Edie Meredith (OSDL)
* Mark Wong (OSDL)

.. contents:: Table of Contents

------------
Introduction
------------

This document provides instructions on how to set up and use the Open Source
Development Lab's Database Test 3 (DBT-3) kit.  This kit provides what is
needed to execute a workload similar to the TPC-H workload.

----------------
Installing DBT-3
----------------

The latest stable and development version of the kit can be found on GitHub:
https://github.com/osdldbt/dbt3

The TPC's TPC-H Tools cannot be redistributed with DBT-3 and must be downloaded
by the tester:
https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp

Required Software
=================

In addition to the database management system software, the following is also
required:

* bc
* SQLite https://www.sqlite.org/index.html
* **sar**, **pidstat** http://pagesperso-orange.fr/sebastien.godard/ (While the
  scripts assume this particular version of **sar** and **pidstat**, it is
  possible to run on non-Linux based operating systems with some modifications
  to the kit.)

------------
User's Guide
------------

Building TPC-H Tools
====================

The kit requires the TPC-H Tools to be built for the specific database
management system to be tested.  The TPC-H Tools is developed in such a way
that it needs to rebuilt or another copy needs to be built if a different
database management system is to be tested.

DBT-3 provides a script to apply patches and compile the TPC-H Tools.  The
patches that are applied are minor code changes and query templates to make the
TPC-H Tools work with the databases supposed by DBT-3.

For example, to build the TPC-H Tools for PostgreSQL (pgsql), unzip the TPC-H
Tools zip file and run `dbt3-build-dbgen` against the resulting directory::

    unzip *-tpc-h-tool.zip
    dbt3-build-dbgen pgsql "TPC-H V3.0.1"/

Quick Start
-----------

Once the TPC-H Tools is built, only one command needs to be issued to run a
complete test::

    dbt3-run --tpchtools="TPC-H V3.0.1" pgsql /tmp/results

This will run the generate the data files for a 1 GB scale factor database
load, power and throughput test, with 2 streams, against PostgreSQL and save
the results of the test in `/tmp/results`.

The *dbt3-run* script can be used to run any combination of a load test, power
test, and throughput test.  A load tests must be run in order to create the
database before a power or throughput tests can be run individually.

Advanced Notes
==============

Setting DBT-3 Environment Variables
-----------------------------------

**dbgen**, **qgen** require specific environment variables to be set in order
to function properly.  The following environment variables are required to be
set if run manually, otherwise the *dbt3-run* script will set the variables
based on the given command line arguments:

* `DSS_PATH=/tmp/dss` - Absolute path in which to build flat files.
* `DSS_QUERY=${TPCHTOOLS}/dbgen/queries` - Absolute path in which to find query
  templates.
* `DSS_CONFIG=${TPCHTOOLS}/dbgen` - Directory in which to find **dbgen**
  configuration files.

Testers can choose to run all the tests in DBT-3 as well as part of the tests.
The following section describes how to run all the tests.

Tester may also create several databases so that several scale factors can be
tested or various implementation strategies compared.  They will only need to
change environment variables to point to the correct database prior to
executing the test kit scripts.

Each DBMS may have additional environment variables that may need to be set.
See the database management system specific section for details.

--------------
Workload Notes
--------------

Sizing the System
=================

The scale factor can actually be any decimal number (like 1.1 or 50) so that
if the tester wishes, the tester can create a database whose size is not one
of the officially permitted scale factors.  This might be desirable for
development purposes.  Any results should be advertised with the scale factor
used, since the performance varies based on the amount of data required for
processing the queries.  The database size is defined with reference to scale
factor.  For example, for scale factor 1, the raw data files' total size is
roughly 1 GB.

Note:  This kit does not support scale factors less than 1.  Although you can
build a database using scale factors less than 1, the query generator
(**qgen**) will not generate the proper variable values that correspond to
scale factors less than 1.

The tester needs to allocate space for the flat files generated by **dbgen**
used to load the database.  Once the database is loaded and backed up, there is
no need to retain these flat files.

-----------------------------------------
Database Management System Specific Notes
-----------------------------------------

MonetDB
=======

Environment Variables
---------------------

* `DBDATA=/tmp/monetdb` - This defines where to initialize the MonetDB data
  directory
* `DBNAME=dbt3` - This is the database name to use.

MySQL/MariaDB
=============

When using **mysqladmin** to start the database, options will be loaded from one
of these locations, if they exist: `/etc/my.cnf`, `/etc/mysql/my.cnf`, or
`~/.my.cnf`.  The environment variable `MYSQL_HOME` can also be used to
specify where a *my.cnf* file exists.

Environment Variables
---------------------

* `DBNAME=dbt3` - This is the database name to use.
* `MYDATA=/tmp/mydata` - This defines where to initialize the MySQL data
  directory

PostgreSQL
==========

Environment Variables
---------------------

* `PGDATABASE=dbt3` - This is the database name to use.
* `PGDATA=/tmp/pgdata` - This defines where the PostgreSQL instance will be
  created.
* `DEFAULT_LOAD_PARAMETERS="-c shared_buffers=1GB"` - This defines the
  database parameters to be set for the load test.  The syntax is that same as
  that used to set parameters from the command line as if using **pg_ctl**.
  (e.g. "-c shared_buffers=1GB")
* `DEFAULT_POWER_PARAMETERS=""` - This defines the database parameters to set
  for the power test.
* `DEFAULT_THROUGHPUT_PARAMETERS=""` - This defines the database parameters
  to be set for the throughput test.

Query Execution Plans
---------------------

There is an additional `--explain` flag that can be used for testing PostgreSQL
with the *dbt3-* script that will execute the queries in the power and
throughput tests using `EXPLAIN (ANALYZE, BUFFERS)` thus returning actual
execution plans instead of the query results.

If the `--explain` flag is used, an additional plan disaster report will be
generating showing which queries grossly misestimated the number of rows
returned at each node of the plan.

Postgres-XL
===========

Environment Variables
---------------------

In addition to the PostgreSQL environment variables, Postgres-XL requires the
following:

* `GTMHOST="pgxl"` - Hostname for the GTM master and Coordinator node.
* `HOSTNAMES="pgxl1 pgxl2"` - A space-delimited list of hostnames for the
  Datanodes.export GTMDATA="$PGDATA/gtm"
* `COORDINATORDATA="$PGDATA/coordinator"` - Data directory for the Coordinator.
* `GTMPROXYDATA="$PGDATA/gtm_proxy."` - Data directory prefix for the GTM
  proxy.  The node number will be automatically appended to the end.
* `DATANODEDATA="$PGDATA/datanode."` - Data directory prefix for the Datanode.
   The node number will be automatically appended to the end.
* `DNPN=2` - Number of datanodes to create per system node.
* `DNBP=15432` - Starting listener port number for datanodes.
* `DNBPP=25432` - Starting listener port number for datanode pooler.

Postgres-XL Architecture
------------------------

See additional notes for the base PostgreSQL version for items that also apply
to Postgres-XL.

A Postgres-XL cluster can be built in many different ways.  The scripts in this
kit builds them only in one specific configuration::

                       +-------------+
                       | GTM Master  |
                       | Coordinator |
                       +-------------+
                      /       |       \
                     /        |        \
                    /         |         \
                   /          |          \
    +-------------+    +-------------+    ...
    |  GTM Proxy  |    |  GTM Proxy  |
    |  Datanode   |----|  Datanode   |----
    +-------------+    +-------------+

Virtuoso
========

In order to keep the scripts simple, the installation of this software needs to
be the same as the user that will be executing the test kit.  The reason for
this is because the database location is tied to the parameters set when
running the Virtuoso configure script.

Environment Variables
---------------------

* `VADDIR=/usr/local/virtuoso-opensource/var/lib/virtuoso/db` - Location of
  *virtuoso.ini* file.

-------
Results
-------

The results directory created from running tests with the *dbt3-run* script
will contain the calculated metrics of the test.

The primary metrics will be in the `score.txt` file::

           Composite Score:     3746.61
    Load Test Time (hours):        1.87
          Power Test Score:     3634.28
     Throughput Test Score:     3862.43

More detailed query results will be in the `summary.rst` file::

    Power Test
    ----------

    * Seed: 517231038

    +--------------------+------------------------+------------------------+------------------------+
    | Duration (seconds) |    Query Start Time    |     RF1 Start Time     |     RF2 Start Time     |
    |                    +------------------------+------------------------+------------------------+
    |                    |     Query End Time     |      RF1 End Time      |      RF2 End Time      |
    +====================+========================+========================+========================+
    |              18.16 | 2023-05-17 23:10:43.47 | 2023-05-17 23:10:38.87 | 2023-05-17 23:10:56.98 |
    |                    +------------------------+------------------------+------------------------+
    |                    | 2023-05-17 23:10:56.98 | 2023-05-17 23:10:43.46 | 2023-05-17 23:10:57.02 |
    +--------------------+------------------------+------------------------+------------------------+

    =======  =========================
     Query    Response Time (seconds)
    =======  =========================
          1                       2.20
          2                       0.34
          3                       0.51
          4                       0.17
          5                       0.54
          6                       0.36
          7                       0.61
          8                       0.23
          9                       1.33
         10                       0.67
         11                       0.16
         12                       0.62
         13                       1.61
         14                       0.38
         15                       0.72
         16                       0.31
         17                       0.02
         18                       1.93
         19                       0.03
         20                       0.13
         21                       0.33
         22                       0.08
        RF1                       4.58
        RF2                       0.04
    =======  =========================

    Throughput Test
    ---------------

    Stream execution summary:

    +-----------+-----------+------------------------+------------------------+------------------------+
    |  Stream   | Duration  |    Query Start Time    |     RF1 Start Time     |     RF2 Start Time     |
    +-----------+ (seconds) +------------------------+------------------------+------------------------+
    |   Seed    |           |     Query End Time     |      RF1 End Time      |      RF2 End Time      |
    +===========+===========+========================+========================+========================+
    |         1 |     14.38 | 2023-05-17 23:10:57.60 | 2023-05-17 23:10:57.06 | 2023-05-17 23:11:01.42 |
    +-----------+           +------------------------+------------------------+------------------------+
    | 517231039 |           | 2023-05-17 23:11:11.97 | 2023-05-17 23:11:01.41 | 2023-05-17 23:11:01.46 |
    +-----------+-----------+------------------------+------------------------+------------------------+
    |         2 |     14.47 | 2023-05-17 23:10:57.59 | 2023-05-17 23:11:01.47 | 2023-05-17 23:11:05.74 |
    +-----------+           +------------------------+------------------------+------------------------+
    | 517231040 |           | 2023-05-17 23:11:12.05 | 2023-05-17 23:11:05.73 | 2023-05-17 23:11:05.78 |
    +-----------+-----------+------------------------+------------------------+------------------------+

    Query execution duration (seconds):

    ========  ========  ========  ========  ========  ========  ========  ========
     Stream      Q1        Q2        Q3        Q4        Q5        Q6        Q7
    ========  ========  ========  ========  ========  ========  ========  ========
           1      2.19      0.31      0.53      0.17      0.65      0.36      0.66
           2      2.16      0.49      0.51      0.17      0.57      0.36      0.62
         Min      2.16      0.49      0.51      0.17      0.57      0.36      0.62
         Max      2.16      0.49      0.51      0.17      0.57      0.36      0.62
         Avg      1.08      0.24      0.26      0.09      0.28      0.18      0.31
    ========  ========  ========  ========  ========  ========  ========  ========

    ========  ========  ========  ========  ========  ========  ========  ========
     Stream      Q8        Q9        Q10       Q11       Q12       Q13       Q14
    ========  ========  ========  ========  ========  ========  ========  ========
           1      0.24      1.30      0.64      0.22      0.63      2.28      0.37
           2      0.24      1.39      0.65      0.17      0.62      2.30      0.39
         Min      0.24      1.39      0.65      0.17      0.62      2.30      0.39
         Max      0.24      1.39      0.65      0.17      0.62      2.30      0.39
         Avg      0.12      0.69      0.32      0.08      0.31      1.15      0.20
    ========  ========  ========  ========  ========  ========  ========  ========

    ========  ========  ========  ========  ========  ========  ========  ========
     Stream      Q15       Q16       Q17       Q18       Q19       Q20       Q21
    ========  ========  ========  ========  ========  ========  ========  ========
           1      0.76      0.31      0.02      1.95      0.03      0.14      0.32
           2      0.75      0.31      0.02      1.96      0.03      0.14      0.33
         Min      0.75      0.31      0.02      1.96      0.03      0.14      0.33
         Max      0.75      0.31      0.02      1.96      0.03      0.14      0.33
         Avg      0.38      0.16      0.01      0.98      0.02      0.07      0.17
    ========  ========  ========  ========  ========  ========  ========  ========

    ========  ========  ========  ========
     Stream      Q22       RF1       RF2
    ========  ========  ========  ========
           1      0.08      4.35      0.04
           2      0.08      4.26      0.04
         Min      0.08      4.26      0.04
         Max      0.08      4.35      0.04
         Avg      0.04      4.30      0.04
    ========  ========  ========  ========

A comprehensive HTML report can be generated with the **dbt3-report** script by
specifying the DBT-3 `results` directory::

    dbt3-report results

This report will have:

* charts for system statistics, if collected
* charts for database statistics, if collected
* chart of the power and throughput test query execution times

-----------------
Developer's Guide
-----------------

Query Templates
===============

The TPC-H Tools includes the official query syntax for the benchmarks in
`dbgen/queries`.  DBT-3's `dbt3-build-dbgen` script populates the TPC-H Tools
subdirectory with query templates for the databases it supports from DBT-3's
`queries` directory.

For example the PostgreSQL queries are in DBT-3 `queries/pgsql` and is copied
to TPC-H Tools' `dbgen/queries/pgsql` when `dbt3-build-dbgen` is executed.

QGEN
====

The `qgen` program can be manually run to inspect the SQL statement to that
will be executed by the test.

For example (see `qgen -h` for option descriptions) to see what the first query
to be executed, which is supposed to match the predefined order for set 0 (via
`-p 0`) as shown in Appendix A of the benchmark specification::

    qgen -c -r 0 -p 0 -s 1 1

Results in the following query for PostgreSQL::

    -- using 0 as a seed to the RNG
    -- @(#)14.sql	2.1.8.1
    -- TPC-H/TPC-R Promotion Effect Query (Q14)
    -- Functional Query Definition
    -- Approved February 1998
    BEGIN;
 
 
 
    select
 	   100.00 * sum(case
 		   when p_type like 'PROMO%'
 			   then l_extendedprice * (1 - l_discount)
 		   else 0
 	   end) / sum(l_extendedprice * (1 - l_discount)) as promo_revenue
    from
 	   lineitem,
 	   part
    where
 	   l_partkey = p_partkey
 	   and l_shipdate >= date '1993-01-01'
 	   and l_shipdate < cast(date '1993-01-01' + interval '1 month' as date);
    COMMIT;

Testing Individual Queries
==========================

Running the individual parts of the benchmark, i.e. the Power Test of the
Throughput Test, much less the entire benchmark, don't lend it itself to making
it easy to evaluate individual query performance.  There may be times when the
developer wants to focus on an individual query to evaluate the effects of a
different index, or database system parameters.

The *run-query* script is intended to allow a developer to generate and execute
1 query at a time.

A database needs to be created first, but only needs to be loaded once if
testing individual queries.  This can be done with the run script using the
`--load` flag.  A PostgreSQL example::

    dbt3 run --load pgsql load-results

Then any query can be tested.  For example running Query 4::

    dbt3 run-query 4 pgsql

Here is an example of the output query output, the results, and the execution
time::

    BEGIN;
    BEGIN
    select
	    o_orderpriority,
	    count(*) as order_count
    from
	    orders
    where
	    o_orderdate >= date '1995-12-01'
	    and o_orderdate < cast(date '1995-12-01' + interval '3 month' as date)
	    and exists (
		    select
			    *
		    from
			    lineitem
		    where
			    l_orderkey = o_orderkey
			    and l_commitdate < l_receiptdate
	    )
    group by
	    o_orderpriority
    order by
	    o_orderpriority;
     o_orderpriority | order_count
    -----------------+-------------
     1-URGENT        |       10348
     2-HIGH          |       10424
     3-MEDIUM        |       10330
     4-NOT SPECIFIED |       10490
     5-LOW           |       10361
    (5 rows)

    COMMIT;
    COMMIT

    Query 4 executed in 0.175 second(s).

Additional flags can be used to capture system statistics (`--stats`), software
profiles (`--profile`), or explain plans (`--explain`).
