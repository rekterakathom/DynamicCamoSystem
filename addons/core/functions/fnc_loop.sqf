#include "script_component.hpp"
/*
    Author: ThomasAngel, johnb43
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom

    Description:
    Runs the Dynamic Camo System main loop (server only).

    Parameters:
        NONE

    Usage: call DYNCAS_core_fnc_loop;

    Returns: Nothing.
*/

if (!isServer) exitWith {};

// If PFH is already running, stop the previous one
if (!isNil QGVAR(PFHID)) then {
    GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
};

// Main loop
GVAR(PFHID) = [{
    // Check if the CBA setting for whom the script runs for has changed or if DYNCAS has been disabled
    if (GVAR(previousTargetSetting) != CBA_SETTING(targetList) || !CBA_SETTING(enabled)) then {
        GVAR(previousTargetSetting) = CBA_SETTING(targetList);

        // Reset the camo coef to 1 (only reset units that were altered by DYNCAS)
        private _units = allUnits select {alive _x && {(GVAR(unitCache) getOrDefault [hashValue _x, 1]) != 1}};

        {
            [_x, ["camouflageCoef", 1]] remoteExecCall ["setUnitTrait", _x];
        } forEach _units;

        // Reset cache
        GVAR(unitCache) = createHashMap;

        // Add units that were just reset
        {
            GVAR(unitCache) set [hashValue _x, 1];
        } forEach _units;
    };

    // Stop PFH if CBA setting is disabled
    if (!CBA_SETTING(enabled)) exitWith {
        GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
        GVAR(PFHID) = nil;
    };

    // Get all affected units
    private _targets = switch (CBA_SETTING(targetList)) do {
        case 2: {allUnits};
        case 1: {flatten ((allGroups select {isPlayer leader _x}) apply {units _x})};
        default {call CBA_fnc_players};
    };

    // Update camo coefficients on affected units
    {
        _x call FUNC(updateCamo);
    } forEach (_targets select {alive _x});
}, CBA_SETTING(updateFrequency)] call CBA_fnc_addPerFrameHandler;
