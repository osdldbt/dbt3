execute_process(
    COMMAND sed -n "s/^.*(\\(.*\\)).*$/\\1/p;q" ${CMAKE_HOME_DIRECTORY}/ChangeLog
    OUTPUT_VARIABLE MANDATE
)

configure_file(
    dbt3.1.rst.in
    ${CMAKE_BINARY_DIR}/man/man1/dbt3.1.rst
)
configure_file(
    dbt3-report.1.rst.in
    ${CMAKE_BINARY_DIR}/man/man1/dbt3-report.1.rst
)
configure_file(
    dbt3-run.1.rst.in
    ${CMAKE_BINARY_DIR}/man/man1/dbt3-run.1.rst
)

execute_process(
    COMMAND rst2man.py ${CMAKE_BINARY_DIR}/man/man1/dbt3.1.rst
    OUTPUT_FILE ${CMAKE_BINARY_DIR}/man/man1/dbt3.1
)
execute_process(
    COMMAND rst2man.py ${CMAKE_BINARY_DIR}/man/man1/dbt3-report.1.rst
    OUTPUT_FILE ${CMAKE_BINARY_DIR}/man/man1/dbt3-report.1
)
execute_process(
    COMMAND rst2man.py ${CMAKE_BINARY_DIR}/man/man1/dbt3-run.1.rst
    OUTPUT_FILE ${CMAKE_BINARY_DIR}/man/man1/dbt3-run.1
)

install(
    FILES ${CMAKE_BINARY_DIR}/man/man1/dbt3.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt3-report.1
          ${CMAKE_BINARY_DIR}/man/man1/dbt3-run.1
    DESTINATION "share/man/man1"
)
