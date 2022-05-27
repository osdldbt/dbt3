set (CWD "${CMAKE_SOURCE_DIR}/scripts/pgsql")

install (
    PROGRAMS
    ${CWD}/dbt3-pgsql-create-db
    ${CWD}/dbt3-pgsql-create-tables
    ${CWD}/dbt3-pgsql-dbstat
    ${CWD}/dbt3-pgsql-drop-db
    ${CWD}/dbt3-pgsql-drop-tables
    ${CWD}/dbt3-pgsql-get-query-time
    ${CWD}/dbt3-pgsql-get-version
    ${CWD}/dbt3-pgsql-load-data
    ${CWD}/dbt3-pgsql-plan-disaster
    ${CWD}/dbt3-pgsql-report
    ${CWD}/dbt3-pgsql-rf1
    ${CWD}/dbt3-pgsql-rf2
    ${CWD}/dbt3-pgsql-start-db
    ${CWD}/dbt3-pgsql-stop-db
    ${CWD}/dbt3-pgsql-time-statistics
    DESTINATION "bin"
)
