set (CWD "${CMAKE_SOURCE_DIR}/scripts/mysql")

install (
    PROGRAMS
    ${CWD}/dbt3-mysql-create-db
    ${CWD}/dbt3-mysql-create-tables
    ${CWD}/dbt3-mysql-dbstat
    ${CWD}/dbt3-mysql-drop-db
    ${CWD}/dbt3-mysql-drop-tables
    ${CWD}/dbt3-mysql-get-query-time
    ${CWD}/dbt3-mysql-get-version
    ${CWD}/dbt3-mysql-load-data
    ${CWD}/dbt3-mysql-rf1
    ${CWD}/dbt3-mysql-rf2
    ${CWD}/dbt3-mysql-start-db
    ${CWD}/dbt3-mysql-stop-db
    ${CWD}/dbt3-mysql-time-statistics
    DESTINATION "bin"
)
