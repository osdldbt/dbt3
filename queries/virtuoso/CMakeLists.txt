set(CWD "${CMAKE_SOURCE_DIR}/queries/virtuoso")

install(
    FILES ${CWD}/1.sql
          ${CWD}/2.sql
          ${CWD}/3.sql
          ${CWD}/4.sql
          ${CWD}/5.sql
          ${CWD}/6.sql
          ${CWD}/7.sql
          ${CWD}/8.sql
          ${CWD}/9.sql
          ${CWD}/10.sql
          ${CWD}/11.sql
          ${CWD}/12.sql
          ${CWD}/13.sql
          ${CWD}/14.sql
          ${CWD}/15.sql
          ${CWD}/16.sql
          ${CWD}/17.sql
          ${CWD}/18.sql
          ${CWD}/19.sql
          ${CWD}/20.sql
          ${CWD}/21.sql
          ${CWD}/22.sql
    DESTINATION "share/dbt3/queries/virtuoso"
)
