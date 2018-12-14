/*
 ==============================================================================
 
 This file is part of the iPlug 2 library
 
 Oli Larkin et al. 2018 - https://www.olilarkin.co.uk
 
 iPlug 2 is an open source library subject to commercial or open-source
 licensing.
 
 The code included in this file is provided under the terms of the WDL license
 - https://www.cockos.com/wdl/
 
 ==============================================================================
 */

#pragma once

/**
 * @file
 * @brief Include to get consistently named preprocessor macros for different platforms and logging functionality
 */

#ifdef _WIN32
  #define OS_WIN
#elif defined __APPLE__
  #include <TargetConditionals.h>
  #if TARGET_OS_IPHONE
    #define OS_IOS
  #elif TARGET_OS_MAC
    #define OS_MAC
  #endif
#elif defined __linux || defined __linux__ || defined linux
  #define OS_LINUX
#elif defined EMSCRIPTEN
  #define OS_WEB
#else
  #error "No OS defined!"
#endif

#if defined(_WIN64) || defined(__LP64__)
  #define ARCH_64BIT
#endif

#if __cplusplus == 201402L
#define IPLUG_CPP14
#endif

//these two components of the c standard library are used thoughtout IPlug/WDL 
#include <cstring>
#include <cstdlib>

#ifdef PARAMS_MUTEX
  #define ENTER_PARAMS_MUTEX mParams_mutex.Enter(); Trace(TRACELOC, "%s", "ENTER_PARAMS_MUTEX")
  #define LEAVE_PARAMS_MUTEX mParams_mutex.Leave(); Trace(TRACELOC, "%s", "LEAVE_PARAMS_MUTEX")
  #define ENTER_PARAMS_MUTEX_STATIC _this->mParams_mutex.Enter(); Trace(TRACELOC, "%s", "ENTER_PARAMS_MUTEX")
  #define LEAVE_PARAMS_MUTEX_STATIC _this->mParams_mutex.Leave(); Trace(TRACELOC, "%s", "LEAVE_PARAMS_MUTEX")
#else
  #define ENTER_PARAMS_MUTEX
  #define LEAVE_PARAMS_MUTEX
  #define ENTER_PARAMS_MUTEX_STATIC
  #define LEAVE_PARAMS_MUTEX_STATIC
#endif
