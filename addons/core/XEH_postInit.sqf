#include "script_component.hpp"

if (!isServer) exitWith {};

// Create texture cache
GVAR(texInfoCache) = createHashMap;

// Create unit cache
GVAR(unitCache) = createHashMap;

// Create uniform name cache
GVAR(uniformCache) = createHashMap;
