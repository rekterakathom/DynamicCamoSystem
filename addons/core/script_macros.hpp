#include "\x\cba\addons\main\script_macros_common.hpp"

#define CBA_SETTING(var) DOUBLES(PREFIX,var)
#define QCBA_SETTING(var) QUOTE(CBA_SETTING(var))

#define MIN_VISIBILITY 0.1

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif
