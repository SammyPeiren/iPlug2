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
 
#include "config.h"   // This is your plugin's config.h.
#include <AudioUnit/AudioUnit.r>

#define UseExtendedThingResource 1

#include <CoreServices/CoreServices.r>

// this is a define used to indicate that a component has no static data that would mean 
// that no more than one instance could be open at a time - never been true for AUs
#ifndef cmpThreadSafeOnMac
#define cmpThreadSafeOnMac  0x10000000
#endif

#undef  TARGET_REZ_MAC_X86
#if defined(__i386__) || defined(i386_YES)
  #define TARGET_REZ_MAC_X86        1
#else
  #define TARGET_REZ_MAC_X86        0
#endif

#undef  TARGET_REZ_MAC_X86_64
#if defined(__x86_64__) || defined(x86_64_YES)
  #define TARGET_REZ_MAC_X86_64     1
#else
  #define TARGET_REZ_MAC_X86_64     0
#endif

#if TARGET_OS_MAC
   #if TARGET_REZ_MAC_X86 && TARGET_REZ_MAC_X86_64
    #define TARGET_REZ_FAT_COMPONENTS_2 1
    #define Target_PlatformType     platformIA32NativeEntryPoint
    #define Target_SecondPlatformType platformX86_64NativeEntryPoint
  #elif TARGET_REZ_MAC_X86
    #define Target_PlatformType     platformIA32NativeEntryPoint
  #elif TARGET_REZ_MAC_X86_64
    #define Target_PlatformType     platformX86_64NativeEntryPoint
  #else
    #error you gotta target something
  #endif
  #define Target_CodeResType    'dlle'
  #define TARGET_REZ_USE_DLLE   1
#else
  #error get a real platform type
#endif // not TARGET_OS_MAC

#ifndef TARGET_REZ_FAT_COMPONENTS_2
  #define TARGET_REZ_FAT_COMPONENTS_2   0
#endif

#ifndef TARGET_REZ_FAT_COMPONENTS_4
  #define TARGET_REZ_FAT_COMPONENTS_4   0
#endif

// ----------------

//#ifdef _DEBUG
//  #define PLUG_PUBLIC_NAME PLUG_NAME "_DEBUG"
//#else
#define PLUG_PUBLIC_NAME PLUG_NAME
//#endif

#define RES_ID 1000
#define RES_NAME PLUG_MFR ": " PLUG_PUBLIC_NAME

resource 'STR ' (RES_ID, purgeable) {
  RES_NAME
};

resource 'STR ' (RES_ID + 1, purgeable) {
  PLUG_PUBLIC_NAME " AU"
};

resource 'dlle' (RES_ID) {
  AUV2_ENTRY_STR
};

resource 'thng' (RES_ID, RES_NAME) {
#if PLUG_IS_INSTRUMENT
kAudioUnitType_MusicDevice,
#elif PLUG_IS_MFX
'aumi',
#elif PLUG_DOES_MIDI_IN
kAudioUnitType_MusicEffect,
#else
kAudioUnitType_Effect,
#endif
  PLUG_UNIQUE_ID,
  PLUG_MFR_ID,
  0, 0, 0, 0,               //  no 68K
  'STR ', RES_ID,
  'STR ', RES_ID + 1,
  0,  0,      // icon 
  PLUG_VERSION_HEX,
  componentHasMultiplePlatforms | componentDoAutoVersion,
  0,
  {
    cmpThreadSafeOnMac, 
    Target_CodeResType, RES_ID,
    Target_PlatformType,
#if TARGET_REZ_FAT_COMPONENTS_2 || TARGET_REZ_FAT_COMPONENTS_4
    cmpThreadSafeOnMac, 
    Target_CodeResType, RES_ID,
    Target_SecondPlatformType,
#endif
  }
};

#undef RES_ID
