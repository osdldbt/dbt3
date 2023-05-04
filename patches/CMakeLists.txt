set(CWD "${CMAKE_SOURCE_DIR}/patches/")

install(
    FILES ${CWD}/dbt3-TPC-H_v3.0.1-monetdb.diff
          ${CWD}/dbt3-TPC-H_v3.0.1-mysql.diff
          ${CWD}/dbt3-TPC-H_v3.0.1-postgresql.diff
          ${CWD}/dbt3-TPC-H_v3.0.1-stdout.diff
          ${CWD}/dbt3-TPC-H_v3.0.1-virtuoso.diff
          ${CWD}/series
    DESTINATION "share/dbt3/patches"
)
