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
configure_file(
    dbt3-build-dbgen.in
    ${CMAKE_BINARY_DIR}/dbt3-build-dbgen
    @ONLY
)
configure_file(
    dbt3-compare-results.in
    ${CMAKE_BINARY_DIR}/dbt3-compare-results
    @ONLY
)
configure_file(
    dbt3-generate-report.in
    ${CMAKE_BINARY_DIR}/dbt3-generate-report
    @ONLY
)
configure_file(
    dbt3-get-config.in
    ${CMAKE_BINARY_DIR}/dbt3-get-config
    @ONLY
)
configure_file(
    dbt3-load-test.in
    ${CMAKE_BINARY_DIR}/dbt3-load-test
    @ONLY
)
configure_file(
    dbt3-plot-results.in
    ${CMAKE_BINARY_DIR}/dbt3-plot-results
    @ONLY
)
configure_file(
    dbt3-post-process.in
    ${CMAKE_BINARY_DIR}/dbt3-post-process
    @ONLY
)
configure_file(
    dbt3-power-score.in
    ${CMAKE_BINARY_DIR}/dbt3-power-score
    @ONLY
)
configure_file(
    dbt3-power-test.in
    ${CMAKE_BINARY_DIR}/dbt3-power-test
    @ONLY
)
configure_file(
    dbt3-run.in
    ${CMAKE_BINARY_DIR}/dbt3-run
    @ONLY
)
configure_file(
    dbt3-throughput-score.in
    ${CMAKE_BINARY_DIR}/dbt3-throughput-score
    @ONLY
)
configure_file(
    dbt3-throughput-stream.in
    ${CMAKE_BINARY_DIR}/dbt3-throughput-stream
    @ONLY
)
configure_file(
    dbt3-throughput-stream-wrapper.in
    ${CMAKE_BINARY_DIR}/dbt3-throughput-stream-wrapper
    @ONLY
)
configure_file(
    dbt3-throughput-test.in
    ${CMAKE_BINARY_DIR}/dbt3-throughput-test
    @ONLY
)

install (
    PROGRAMS ${CMAKE_BINARY_DIR}/dbt3
             ${CMAKE_BINARY_DIR}/dbt3-build-dbgen
             ${CMAKE_BINARY_DIR}/dbt3-compare-results
             ${CMAKE_BINARY_DIR}/dbt3-generate-report
             ${CMAKE_BINARY_DIR}/dbt3-get-config
             ${CMAKE_BINARY_DIR}/dbt3-load-test
             ${CMAKE_BINARY_DIR}/dbt3-plot-results
             ${CMAKE_BINARY_DIR}/dbt3-post-process
             ${CMAKE_BINARY_DIR}/dbt3-power-score
             ${CMAKE_BINARY_DIR}/dbt3-power-test
             ${CMAKE_BINARY_DIR}/dbt3-run
             ${CMAKE_BINARY_DIR}/dbt3-throughput-score
             ${CMAKE_BINARY_DIR}/dbt3-throughput-stream
             ${CMAKE_BINARY_DIR}/dbt3-throughput-stream-wrapper
             ${CMAKE_BINARY_DIR}/dbt3-throughput-test
    DESTINATION "bin"
)
