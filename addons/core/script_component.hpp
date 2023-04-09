#define COMPONENT core
#define COMPONENT_BEAUTIFIED Core
#include "script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_DYNCAS_CORE
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_DYNCAS_CORE
    #define DEBUG_SETTINGS DEBUG_SETTINGS_DYNCAS_CORE
#endif

#include "script_macros.hpp"
