add_subdirectory (monetdb)
add_subdirectory (mysql)
add_subdirectory (pgsql)
add_subdirectory (pgxl)
add_subdirectory (virtuoso)

configure_file(
    dbt3.in
    ${CMAKE_BINARY_DIR}/dbt3
    @ONLY
)

set (CWD "${CMAKE_SOURCE_DIR}/scripts")

install (
    PROGRAMS
    ${CMAKE_BINARY_DIR}/dbt3
    ${CWD}/dbt3-compare-results
    ${CWD}/dbt3-generate-report
    ${CWD}/dbt3-get-config
    ${CWD}/dbt3-load-test
    ${CWD}/dbt3-plot-results
    ${CWD}/dbt3-post-process
    ${CWD}/dbt3-power-score
    ${CWD}/dbt3-power-test
    ${CWD}/dbt3-run-workload
    ${CWD}/dbt3-sysstats
    ${CWD}/dbt3-throughput-score
    ${CWD}/dbt3-throughput-stream
    ${CWD}/dbt3-throughput-stream-wrapper
    ${CWD}/dbt3-throughput-test
    DESTINATION "bin"
)
