cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(foamRunCMake
  VERSION 0.1
  LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wpedantic")

include(FetchContent)
FetchContent_Declare(fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG master
)
FetchContent_MakeAvailable(fmt)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(FeatureSummary)

find_package(OpenFOAM11 REQUIRED)

feature_summary(WHAT ALL)

add_executable(${PROJECT_NAME})

set(SRC_FILES
  ${PROJECT_NAME}.C
  setDeltaT.C
)
set(HEADER_FILES
  setDeltaT.H
)

target_sources(${PROJECT_NAME}
	PRIVATE ${SRC_FILES}
	PUBLIC ${HEADER_FILES}
)

target_link_libraries(${PROJECT_NAME}
  PUBLIC
    fmt::fmt
    OpenFOAM11::OpenFOAM11
)

target_include_directories(${PROJECT_NAME}
  PUBLIC
    $ENV{WM_PROJECT_DIR}/src/finiteVolume/lnInclude
    $ENV{WM_PROJECT_DIR}/src/OpenFOAM/lnInclude
    $ENV{WM_PROJECT_DIR}/src/OSspecific/POSIX/lnInclude
)

# set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE True)

find_program(CLANGFORMAT clang-format)
if (CLANGFORMAT)
  add_custom_target(format
    COMMAND ${CLANGFORMAT}
    --verbose -i
    ${SRC_FILES} ${HEADER_FILES}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  )
else()
  add_custom_target(format
    COMMAND echo "clang-format could not be found"
  )
endif()
