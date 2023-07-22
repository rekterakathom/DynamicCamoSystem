#include "script_component.hpp"

// Create texture cache, to speed up getting of texture colors
// Clients have their own as well
GVAR(texInfoCache) = createHashMap;

if (hasInterface) then {call FUNC(clientLoop)};

if (!isServer) exitWith {};

// Create unit cache, to store which units have been affected by this mod
GVAR(unitCache) = createHashMap;

// Create uniform name cache, to avoid always having to look up uniform names in the config
GVAR(uniformCache) = createHashMap;

// Used for checking if the CBA setting for whom the script runs for has changed
GVAR(previousTargetSetting) = 0;

["CBA_settingsInitialized", {
    GVAR(previousTargetSetting) = CBA_SETTING(targetList);
}] call CBA_fnc_addEventHandler;
