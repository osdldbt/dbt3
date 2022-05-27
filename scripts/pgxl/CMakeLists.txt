set (CWD "${CMAKE_SOURCE_DIR}/scripts/pgxl")

install (
    PROGRAMS
    ${CWD}/dbt3-pgxl-create-db
    ${CWD}/dbt3-pgxl-create-tables
    ${CWD}/dbt3-pgxl-dbstat
    ${CWD}/dbt3-pgxl-drop-tables
    ${CWD}/dbt3-pgxl-load-data
    ${CWD}/dbt3-pgxl-start-db
    ${CWD}/dbt3-pgxl-stop-db
    ${CWD}/dbt3-pgxl-time-statistics
    DESTINATION "bin"
)
