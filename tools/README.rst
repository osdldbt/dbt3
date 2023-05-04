These scripts and container files are for testing and evaluating DBT-3.  While
DBT-3 is compatible with multiple database systems, this initial set of scripts
is just for PostgreSQL.

These scripts are currently designed to work only with v3.0.1 of the TPC-H
tools, which must be obtained by the user from the TPC.  Other versions may
work but will need manual editing of the script.

The quickest way to try out the kit is to run::

    tools/build-pgsql <tpchtools.zip>
    tools/run-test pgsql 1

* `build-pgsql` - Build a container image prepared for running tests against
                  PostgreSQL.
* `run-test` - Script to run a test.
