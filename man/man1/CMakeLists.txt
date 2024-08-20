execute_process(
    COMMAND sed -n "s/^.*(\\(.*\\)).*$/\\1/p;q" ${CMAKE_HOME_DIRECTORY}/ChangeLog
    OUTPUT_VARIABLE MANDATE
)

set (MANPAGES "")
foreach (FILE dbt3
              dbt3-report
              dbt3-run
        )
configure_file(${FILE}.1.rst.in ${CMAKE_BINARY_DIR}/man/man1/${FILE}.1.rst)
    execute_process(
            COMMAND rst2man ${CMAKE_BINARY_DIR}/man/man1/${FILE}.1.rst
            OUTPUT_FILE ${CMAKE_BINARY_DIR}/man/man1/${FILE}.1
    )
    set (MANPAGES ${MANPAGES} ${CMAKE_BINARY_DIR}/man/man1/${FILE}.1)
endforeach()

install(FILES ${MANPAGES} DESTINATION "share/man/man1")
