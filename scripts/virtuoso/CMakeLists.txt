set (CWD "${CMAKE_SOURCE_DIR}/scripts/virtuoso")

install (
    PROGRAMS
    ${CWD}/dbt3-virtuoso-create-db
    ${CWD}/dbt3-virtuoso-create-tables
    ${CWD}/dbt3-virtuoso-dbstat
    ${CWD}/dbt3-virtuoso-drop-tables
    ${CWD}/dbt3-virtuoso-get-query-time
    ${CWD}/dbt3-virtuoso-get-version
    ${CWD}/dbt3-virtuoso-load-data
    ${CWD}/dbt3-virtuoso-load-test
    ${CWD}/dbt3-virtuoso-rf1
    ${CWD}/dbt3-virtuoso-rf2
    ${CWD}/dbt3-virtuoso-start-db
    ${CWD}/dbt3-virtuoso-stop-db
    ${CWD}/dbt3-virtuoso-time-statistics
    DESTINATION "bin"
)
