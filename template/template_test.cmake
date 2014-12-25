#
# Include CTest Ext module
#

include("${CTEST_SCRIPT_DIRECTORY}/../ctest_ext.cmake")

#
# Initialize testing
#

set_ifndef(CTEST_DASHBOARD_ROOT     "${CTEST_SCRIPT_DIRECTORY}/dashboard")
set_ifndef(CTEST_SOURCE_DIRECTORY   "${CTEST_SCRIPT_DIRECTORY}")

set_ifndef(CTEST_WITH_UPDATE        FALSE)

ctest_ext_init()

#
# Check supported targets and models
#

check_if_matches(CTEST_TARGET_SYSTEM    "^Linux")
check_if_matches(CTEST_MODEL            "^Experimental$" "^Nightly$")

#
# Configure the testing model (set options, not specified by user, to default values)
#

set_ifndef(CTEST_UPDATE_CMAKE_CACHE     TRUE)
set_ifndef(CTEST_EMPTY_BINARY_DIRECTORY TRUE)
set_ifndef(CTEST_WITH_TESTS             TRUE)
set_ifndef(CTEST_WITH_COVERAGE          FALSE)

if(CTEST_MODEL MATCHES "Nightly")
    set_ifndef(CTEST_WITH_GCOVR         TRUE)
    set_ifndef(CTEST_WITH_MEMCHECK      TRUE)
else()
    set_ifndef(CTEST_WITH_GCOVR         FALSE)
    set_ifndef(CTEST_WITH_MEMCHECK      FALSE)
endif()

set_ifndef(CTEST_WITH_SUBMIT            FALSE)

#
# Configure cmake options
#

if(CTEST_UPDATE_CMAKE_CACHE)
    set_ifndef(CTEST_CMAKE_GENERATOR "Unix Makefiles")
    set_ifndef(CTEST_CONFIGURATION_TYPE "Debug")

    if(CTEST_WITH_COVERAGE OR CTEST_WITH_GCOVR)
        add_cmake_option("CMAKE_CXX_FLAGS" "STRING" "--coverage")
    endif()
endif()

#
# Start testing
#

ctest_ext_set_default()

ctest_ext_start()

#
# Clean binary directory if needed
#

ctest_ext_clean_build()

#
# Configure
#

ctest_ext_configure()

#
# Build
#

ctest_ext_build()

#
# Test
#

ctest_ext_test(EXCLUDE "Test3")

#
# Coverage
#

ctest_ext_coverage(
    GCOVR_OPTIONS HTML VERBOSE OPTIONS "-f" ".*/main.cpp")

#
# MemCheck
#

ctest_ext_memcheck()

#
# Submit
#

ctest_ext_submit()
