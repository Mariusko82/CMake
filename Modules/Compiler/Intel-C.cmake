include(Compiler/Intel)
__compiler_intel(C)

string(APPEND CMAKE_C_FLAGS_MINSIZEREL_INIT " -DNDEBUG")
string(APPEND CMAKE_C_FLAGS_RELEASE_INIT " -DNDEBUG")
string(APPEND CMAKE_C_FLAGS_RELWITHDEBINFO_INIT " -DNDEBUG")

set(CMAKE_DEPFILE_FLAGS_C "-MD -MT <OBJECT> -MF <DEPFILE>")

if("x${CMAKE_C_SIMULATE_ID}" STREQUAL "xMSVC")
  set(_std -Qstd)
  set(_ext c)
else()
  set(_std -std)
  set(_ext gnu)
endif()

if (NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 15.0.0)
  set(CMAKE_C11_STANDARD_COMPILE_OPTION "${_std}=c11")
  set(CMAKE_C11_EXTENSION_COMPILE_OPTION "${_std}=${_ext}11")
endif()

if (NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 12.0)
  set(CMAKE_C90_STANDARD_COMPILE_OPTION "${_std}=c89")
  set(CMAKE_C90_EXTENSION_COMPILE_OPTION "${_std}=${_ext}89")
  set(CMAKE_C99_STANDARD_COMPILE_OPTION "${_std}=c99")
  set(CMAKE_C99_EXTENSION_COMPILE_OPTION "${_std}=${_ext}99")
endif()

if(NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 12.1)
  if (NOT CMAKE_C_COMPILER_FORCED)
    if (NOT CMAKE_C_STANDARD_COMPUTED_DEFAULT)
      message(FATAL_ERROR "CMAKE_C_STANDARD_COMPUTED_DEFAULT should be set for ${CMAKE_C_COMPILER_ID} (${CMAKE_C_COMPILER}) version ${CMAKE_C_COMPILER_VERSION}")
    endif()
    set(CMAKE_C_STANDARD_DEFAULT ${CMAKE_C_STANDARD_COMPUTED_DEFAULT})
  elseif(NOT DEFINED CMAKE_C_STANDARD_DEFAULT)
    # Compiler id was forced so just guess the default standard level.
    if (NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 15.0.0)
      set(CMAKE_C_STANDARD_DEFAULT 11)
    else()
      set(CMAKE_C_STANDARD_DEFAULT 90)
    endif()
  endif()
endif()

unset(_std)
unset(_ext)

macro(cmake_record_c_compile_features)
  macro(_get_intel_c_features std_version list)
    record_compiler_features(C "${std_version}" ${list})
  endmacro()

  set(_result 0)
  if (NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 12.1)
    if (NOT CMAKE_C_COMPILER_VERSION VERSION_LESS 15.0.0)
      _get_intel_c_features(${CMAKE_C11_STANDARD_COMPILE_OPTION} CMAKE_C11_COMPILE_FEATURES)
    endif()
    if (_result EQUAL 0)
      _get_intel_c_features(${CMAKE_C99_STANDARD_COMPILE_OPTION} CMAKE_C99_COMPILE_FEATURES)
    endif()
    if (_result EQUAL 0)
      _get_intel_c_features(${CMAKE_C90_STANDARD_COMPILE_OPTION} CMAKE_C90_COMPILE_FEATURES)
    endif()
  endif()
endmacro()

set(CMAKE_C_CREATE_PREPROCESSED_SOURCE "<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
set(CMAKE_C_CREATE_ASSEMBLY_SOURCE "<CMAKE_C_COMPILER> <DEFINES> <INCLUDES> <FLAGS> -S <SOURCE> -o <ASSEMBLY_SOURCE>")
