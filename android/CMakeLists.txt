cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0063 NEW)

# list(APPEND CMAKE_MODULE_PATH "/usr/local/share/cmake/")
message(STATUS "CMAKE_PREFIX_PATH =" ${CMAKE_PREFIX_PATH})

# -- Installing: /usr/local/libexec/corrosion-generator
# -- Installing: /usr/local/lib/cmake/Corrosion/CorrosionConfig.cmake
# -- Installing: /usr/local/lib/cmake/Corrosion/CorrosionConfigVersion.cmake
# -- Installing: /usr/local/share/cmake/Corrosion.cmake
# -- Installing: /usr/local/share/cmake/CorrosionGenerator.cmake
# -- Installing: /usr/local/share/cmake/FindRust.cmake
# set(Corrosion_DIR "/usr/local/lib/cmake/Corrosion/")
# set(Corrosion_DIR "/usr/local/share/cmake/")
add_library(gmp SHARED IMPORTED)
set_property(TARGET gmp PROPERTY IMPORTED_LOCATION "../vendor/gmp/${CMAKE_ANDROID_ARCH_ABI}/libgmp.so")

include(FetchContent)

FetchContent_Declare(
    Corrosion
    GIT_REPOSITORY https://github.com/AndrewGaspar/corrosion.git
    GIT_TAG origin/master # Optionally specify a version tag or branch here
)

FetchContent_MakeAvailable(Corrosion)

corrosion_import_crate(MANIFEST_PATH ../native/Cargo.toml)

# Flutter-specific
set(CRATE_NAME "native")

add_library($CRATE_NAME SHARED)
# target_link_libraries(${BINARY_NAME} PRIVATE ${CRATE_NAME})

list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${CRATE_NAME}-shared>)

