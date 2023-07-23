#include "script_component.hpp"

if (!isServer) exitWith {};

GVAR(clientLoop) = compileScript ["x\DYNCAS\addons\core\functions\fnc_clientLoop.sqf", true];
publicVariable QGVAR(clientLoop);
[] remoteExecCall [QGVAR(clientLoop), [0, -2] select isDedicated, true];

// Create texture cache, to speed up getting of texture colors
GVAR(texInfoCache) = createHashMap;

// Create unit cache, to store which units have been affected by this mod
GVAR(unitCache) = createHashMap;

// Create uniform name cache, to avoid always having to look up uniform names in the config
GVAR(uniformCache) = createHashMap;

// Used for checking if the CBA setting for whom the script runs for has changed
GVAR(previousTargetSetting) = 0;

["CBA_settingsInitialized", {
    GVAR(previousTargetSetting) = CBA_SETTING(targetList);
}] call CBA_fnc_addEventHandler;
