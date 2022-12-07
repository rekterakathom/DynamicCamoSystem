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

if (!CBA_SETTING(enabled)) exitWith {};

// Main loop
GVAR(PFHID) = [{
    // Stop PFH if CBA setting is disabled
    if (!CBA_SETTING(enabled)) exitWith {
        GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
        GVAR(PFHID) = nil;

        // If DYNCAS was disabled, reset the camo coef to 1 (only reset units that were altered by DYNCAS)
        {
            [_x, ["camouflageCoef", 1]] remoteExecCall ["setUnitTrait", _x];
        } forEach (allUnits select {alive _x && {(GVAR(unitCache) getOrDefault [hashValue _x, 1]) != 1}});

        // Reset cache
        GVAR(unitCache) = createHashMap;
    };

    // Get all affected units
    private _targets = switch (CBA_SETTING(targetList)) do {
        case 0: {call CBA_fnc_players};
        case 1: {flatten ((allGroups select {isPlayer leader _x}) apply {units _x})};
        default {allUnits};
    };

    {
        _x call FUNC(updateCamo);
    } forEach (_targets select {alive _x});
}, CBA_SETTING(updateFrequency)] call CBA_fnc_addPerFrameHandler;
