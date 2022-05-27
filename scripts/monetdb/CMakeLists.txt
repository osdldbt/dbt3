set (CWD "${CMAKE_SOURCE_DIR}/scripts/monetdb")

install (
    PROGRAMS
    ${CWD}/dbt3-monetdb-create-db
    ${CWD}/dbt3-monetdb-create-tables
    ${CWD}/dbt3-monetdb-dbstat
    ${CWD}/dbt3-monetdb-drop-tables
    ${CWD}/dbt3-monetdb-get-query-time
    ${CWD}/dbt3-monetdb-get-version
    ${CWD}/dbt3-monetdb-load-data
    ${CWD}/dbt3-monetdb-load-test
    ${CWD}/dbt3-monetdb-rf1
    ${CWD}/dbt3-monetdb-rf2
    ${CWD}/dbt3-monetdb-start-db
    ${CWD}/dbt3-monetdb-stop-db
    ${CWD}/dbt3-monetdb-time-statistics
    DESTINATION "bin"
)
