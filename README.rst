Since this kit is derived from a TPC benchmark specification, TPC Policy on
fair-use must be observed:

http://www.tpc.org/information/about/documentation/TPC_Policies_v5.13.htm#_Toc124863463

See the QuickStart for a brief introduction on using the kit.

TPC Source Code
===============

The TPC currently restricts redistribution of their code but it can be freely
downloaded from:
https://www.tpc.org/tpc_documents_current_versions/current_specifications5.asp

After downloading and unpacking the TPC supplied code, unpack the code under
the top level directory of this kit such that `TPC-H_Tools_v3.0.0` is a
subdirectory of this kit.

The TPC source code needs to be patched to be used for this kit.

Apply the supplied patches to dbgen (in the suggested order)::

    patch -p1 < patches/dbt3-TPC-H_Tools_v3.0.0-postgresql.diff
    patch -p1 < patches/dbt3-TPC-H_Tools_v3.0.0-stdout.diff
    patch -p1 < patches/dbt3-TPC-H_Tools_v3.0.0-mysql.diff
    patch -p1 < patches/dbt3-TPC-H_Tools_v3.0.0-virtuoso.diff
    patch -p1 < patches/dbt3-TPC-H_Tools_v3.0.0-monetdb.diff

Patch descriptions:

* `dbt3-TPC-H_Tools_v3.0.0-postgresql.diff` add support for building dbgen and
   qgen for PostgreSQL.
* `dbt3-TPC-H_Tools_v3.0.0-stdout.diff` gives dbgen the ability to write to
  stdout when generating data.
* `dbt3-TPC-H_Tools_v3.0.0-mysql.diff` add support for building dbgen and qgen
  for MySQL.
* `dbt3-TPC-H_Tools_v3.0.0-virtuoso.diff` add support for building dbgen and
  qgen for Virtuoso.
* `dbt3-TPC-H_Tools_v3.0.0-monetdb.diff` add support for building dbgen and
  qgen for MonetDB.
