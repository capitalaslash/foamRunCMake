find_path(OpenFOAM11_OpenFOAM_INCLUDE_DIR foamVersion.H
  PATHS
    ${OpenFOAM11_DIR}/src/OpenFOAM/lnInclude
    $ENV{WM_PROJECT_DIR}/src/OpenFOAM/lnInclude
)
mark_as_advanced(OpenFOAM11_OpenFOAM_INCLUDE_DIR)

find_path(OpenFOAM11_finiteVolume_INCLUDE_DIR fv.H
  PATHS
    ${OpenFOAM11_DIR}/src/finiteVolume/lnInclude
    $ENV{WM_PROJECT_DIR}/src/finiteVolume/lnInclude
)
mark_as_advanced(OpenFOAM11_finiteVolume_INCLUDE_DIR)

find_path(OpenFOAM11_OSspecific_INCLUDE_DIR POSIX.H
  PATHS
    ${OpenFOAM11_DIR}/src/OSspecific/POSIX/lnInclude
    $ENV{WM_PROJECT_DIR}/src/OSspecific/POSIX/lnInclude
)
mark_as_advanced(OpenFOAM11_OSspecific_INCLUDE_DIR)

find_library(OpenFOAM11_OpenFOAM_LIBRARY
  NAMES libOpenFOAM.so
  PATHS
    ${OpenFOAM11_DIR}/platforms/linux64GccDPInt32Opt/lib
    $ENV{WM_PROJECT_DIR}/platforms/linux64GccDPInt32Opt/lib
)
mark_as_advanced(OpenFOAM11_OpenFOAM_LIBRARY)

find_library(OpenFOAM11_finiteVolume_LIBRARY
  NAMES libfiniteVolume.so
  PATHS
    ${OpenFOAM11_DIR}/platforms/linux64GccDPInt32Opt/lib
    $ENV{WM_PROJECT_DIR}/platforms/linux64GccDPInt32Opt/lib
)
mark_as_advanced(OpenFOAM11_finiteVolume_LIBRARY)

if (OpenFOAM11_OpenFOAM_INCLUDE_DIR AND OpenFOAM11_OpenFOAM_LIBRARY)
  set(OpenFOAM11_INCLUDE_DIRS
    ${OpenFOAM11_OpenFOAM_INCLUDE_DIR}
    ${OpenFOAM11_finiteVolume_INCLUDE_DIR}
    ${OpenFOAM11_OSspecific_INCLUDE_DIR}
  )

  set(OpenFOAM11_LIBRARIES
    ${OpenFOAM11_OpenFOAM_LIBRARY}
    ${OpenFOAM11_finiteVolume_LIBRARY}
  )

  if(NOT TARGET OpenFOAM11::OpenFOAM11)
    add_library(OpenFOAM11::OpenFOAM11 UNKNOWN IMPORTED)

    set_target_properties(OpenFOAM11::OpenFOAM11 PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES CXX
      INTERFACE_INCLUDE_DIRECTORIES "${OpenFOAM11_INCLUDE_DIRS}"
      IMPORTED_LOCATION ${OpenFOAM11_OpenFOAM_LIBRARY}
      POSITION_INDEPENDENT_CODE True
    )

    target_compile_definitions(OpenFOAM11::OpenFOAM11
      INTERFACE
        LIB_NAME=libNULL.so
        linux64
        WM_ARCH_OPTION=64
        WM_DP
        WM_LABEL_SIZE=32
        NoRepository
  )

    target_link_libraries(OpenFOAM11::OpenFOAM11
      INTERFACE
        ${OpenFOAM11_finiteVolume_LIBRARY}
        dl
        m
    )
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OpenFOAM11
  FOUND_VAR OpenFOAM11_FOUND
  REQUIRED_VARS OpenFOAM11_LIBRARIES OpenFOAM11_INCLUDE_DIRS
  VERSION_VAR "11"
)