add_subdirectory (monetdb)
add_subdirectory (mysql)
add_subdirectory (pgsql)
add_subdirectory (pgxl)
add_subdirectory (virtuoso)

set (PROGRAMFILES "")

foreach (FILE dbt3
              dbt3-build-dbgen
              dbt3-compare-results
              dbt3-get-config
              dbt3-load-test
              dbt3-plot-results
              dbt3-post-process
              dbt3-power-score
              dbt3-power-test
              dbt3-report
              dbt3-run
              dbt3-run-query
              dbt3-throughput-score
              dbt3-throughput-stream
              dbt3-throughput-stream-wrapper
              dbt3-throughput-test
        )
    configure_file(${FILE}.in ${CMAKE_BINARY_DIR}/${FILE} @ONLY)
    set (PROGRAMFILES ${PROGRAMFILES} ${CMAKE_BINARY_DIR}/${FILE})
endforeach()

install (PROGRAMS ${PROGRAMFILES} DESTINATION "bin")
