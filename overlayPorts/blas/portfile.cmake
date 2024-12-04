SET(VCPKG_POLICY_EMPTY_PACKAGE enabled)

# Due to the interaction between BLAS and LAPACK, we need to choose implementations consistent with
# each other.
#
# First, if we are on Apple, we use the Accelerate framework.
#
# Then, we prefer to use openblas and lapack-reference for blas and lapack, respectively.

if(VCPKG_TARGET_IS_OSX OR VCPKG_TARGET_IS_IOS)
    # Use Apple's accelerate framework where available
    set(BLA_VENDOR Apple)
    set(requires "")
    set(libs "-framework Accelerate")
    set(cflags "-framework Accelerate")
else()
    set(BLA_VENDOR OpenBLAS)
    set(requires openblas)
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/blas.pc.in" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/blas.pc" @ONLY)
if(NOT VCPKG_BUILD_TYPE)
    configure_file("${CMAKE_CURRENT_LIST_DIR}/blas.pc.in" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/blas.pc" @ONLY)
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(BLA_STATIC ON)
else()
    set(BLA_STATIC OFF)
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake.in" "${CURRENT_PACKAGES_DIR}/share/blas/vcpkg-cmake-wrapper.cmake" @ONLY)
