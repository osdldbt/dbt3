cmake_minimum_required (VERSION 2.8.12)
project (dbt3 NONE)

set (PROJECT_VERSION_MAJOR 1)
set (PROJECT_VERSION_MINOR 11)
set (PROJECT_VERSION_PATCH 1)

set (PROJECT_VERSION
     ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set (SHELLOPTIONS "set -x")
endif ()

set (
    HOMEPAGE
    "Database Test 3 (DBT-3) project page: https://github.com/osdldbt/dbt3"
)

add_subdirectory (appimage)
add_subdirectory (man)
add_subdirectory (patches)
add_subdirectory (queries)
add_subdirectory (scripts)

# CPack rules for creating distribution files.

include (InstallRequiredSystemLibraries)

set (CPACK_CMAKE_GENERATOR "Unix Makefiles")
set (CPACK_SOURCE_GENERATOR "TBZ2;TXZ;ZIP")
set (
    CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "database test 3"
)
set (CPACK_PACKAGE_VENDOR "osdl")
set (CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set (CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set (CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set (CPACK_PACKAGE_DESCRIPTION_FILE "README.rst")
set (CPACK_RESOURCE_FILE_LICENSE "COPYING")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}-${PROJECT_VERSION}")
set (CPACK_INSTALL_CMAKE_PROJECTS "")

set (
    CPACK_SOURCE_IGNORE_FILES
    "\\\\.bz2\\$;\\\\.gz\\$;\\\\.xz\\$;\\\\.Z\\$;\\\\.zip\\$"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/CMakeCache\\\\.txt\\$"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/CMakeFiles/"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/cmake_install\\\\.cmake\\$"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/CPackConfig\\\\.cmake\\$"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/\\\\.gitignore\\$"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/\\\\_CPack\\\\_Packages/"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/CPackSourceConfig\\\\.cmake\\$"
)
set (
    CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES};/Makefile.package$"
)

include (CPack)

set (APPIMAGE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/appimage)

set (GNUPLOT "AppDir/usr/bin/gnuplot")
set (PSQL "AppDir/usr/bin/psql")

add_custom_target(appimage-podman
    COMMAND cp -aLr /usr/local/AppDir .
    COMMAND cp -aL ${CMAKE_BINARY_DIR}/AppRun
                   ${APPIMAGE_SOURCE_DIR}/activate
                   ${APPIMAGE_SOURCE_DIR}/dbt3.desktop
                   ${APPIMAGE_SOURCE_DIR}/dbt3.svg
            AppDir
    COMMAND mkdir -p AppDir/usr/share/metainfo
    COMMAND cp -aL ${APPIMAGE_SOURCE_DIR}/dbt3.appdata.xml
            AppDir/usr/share/metainfo
    COMMAND mkdir -p AppDir/usr/lib
    COMMAND cp -aL `ldd ${GNUPLOT} | grep libfribidi\\. | cut -d \" \" -f 3`
                   `ldd ${GNUPLOT} | grep libgraphite2\\. | cut -d \" \" -f 3`
                   `ldd ${GNUPLOT} | grep harfbuzz\\. | cut -d \" \" -f 3`
                   `ldd ${GNUPLOT} | grep libpango-1\\.0\\. | cut -d \" \" -f 3`
                   `ldd ${GNUPLOT} | grep libpangoft2-1\\.0\\. | cut -d \" \" -f 3`
                   `ldd ${GNUPLOT} | grep libpangocairo-1\\.0\\. | cut -d \" \" -f 3`
                   `ldd ${GNUPLOT} | grep libthai\\. | cut -d \" \" -f 3`
                   `ldd ${PSQL} | grep libcrypto\\. | cut -d \" \" -f 3`
                   `ldd ${PSQL} | grep libpq\\. | cut -d \" \" -f 3`
                   `ldd ${PSQL} | grep libssl\\. | cut -d \" \" -f 3`
            AppDir/usr/lib
    COMMAND VERSION=${PROJECT_VERSION} /usr/local/squashfs-root/AppRun
            --comp=xz AppDir
)
