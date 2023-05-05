configure_file(
    dbt3-pgxl-create-db.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-create-db
    @ONLY
)
configure_file(
    dbt3-pgxl-create-tables.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-create-tables
    @ONLY
)
configure_file(
    dbt3-pgxl-drop-tables.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-drop-tables
    @ONLY
)
configure_file(
    dbt3-pgxl-load-data.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-load-data
    @ONLY
)
configure_file(
    dbt3-pgxl-start-db.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-start-db
    @ONLY
)
configure_file(
    dbt3-pgxl-stop-db.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-stop-db
    @ONLY
)
configure_file(
    dbt3-pgxl-time-statistics.in
    ${CMAKE_BINARY_DIR}/dbt3-pgxl-time-statistics
    @ONLY
)

install (
    PROGRAMS ${CMAKE_BINARY_DIR}/dbt3-pgxl-create-db
             ${CMAKE_BINARY_DIR}/dbt3-pgxl-create-tables
             ${CMAKE_BINARY_DIR}/dbt3-pgxl-drop-tables
             ${CMAKE_BINARY_DIR}/dbt3-pgxl-load-data
             ${CMAKE_BINARY_DIR}/dbt3-pgxl-start-db
             ${CMAKE_BINARY_DIR}/dbt3-pgxl-stop-db
             ${CMAKE_BINARY_DIR}/dbt3-pgxl-time-statistics
    DESTINATION "bin"
)
