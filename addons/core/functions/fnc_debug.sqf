#include "script_component.hpp"
/*
    Author: ThomasAngel
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom

    Description:
    Shows debug information like cache size, current coefficients etc.

    Parameters:
        NONE

    Usage: call DYNCAS_core_fnc_debug;

    Returns: Nothing.
*/

// Send to server to retrieve info like cache etc.
if !(isServer || {isRemoteExecuted && {remoteExecutedOwner == 2}}) exitWith {
    clientOwner remoteExecCall [QFUNC(sendDebugInfo), 2];
};

private _playerTex = getObjectTextures player # 0;
private _groundTex = surfaceTexture getPosASL player;

hint ([
    "Dynamic Camo System Debug",
    "",
    format ["DYNCAS enabled: %1", CBA_SETTING(enabled)],
    format ["Ghillie reduction: %1", CBA_SETTING(ghillieReduction)],
    format ["Night compensation: %1", CBA_SETTING(nightCompensation)],
    format ["Current lower limit: %1", CBA_SETTING(lowerLimit)],
    format ["Current upper limit: %1", CBA_SETTING(upperLimit)],
    "",
    format ["Current uniform texture:\n%1", _playerTex],
    "",
    format ["Current uniform colour average:\n%1", (getTextureInfo _playerTex) # 2],
    "",
    format ["Current ground texture:\n%1", _groundTex],
    "",
    format ["Current ground colour average:\n%1", (getTextureInfo _groundTex) # 2],
    "",
    format ["Current camo coefficient: %1", player getUnitTrait "camouflageCoef"],
    "",
    format ["Texture cache size: %1 entries", count GVAR(texInfoCache)],
    "",
    format ["Unit cache size: %1 entries", count GVAR(unitCache)],
    "",
    format ["Uniform cache size: %1 entries", count GVAR(uniformCache)]
] joinString "\n");

// Print to RPT log
diag_log text "";

{
    diag_log text _x;
} forEach [
    "[Dynamic Camo System Debug]",
    format ["DYNCAS enabled: %1", CBA_SETTING(enabled)],
    format ["Ghillie reduction: %1", CBA_SETTING(ghillieReduction)],
    format ["Night compensation: %1", CBA_SETTING(nightCompensation)],
    format ["Current lower limit: %1", CBA_SETTING(lowerLimit)],
    format ["Current upper limit: %1", CBA_SETTING(upperLimit)],
    format ["Current uniform texture: %1", _playerTex],
    format ["Current uniform colour average: %1", (getTextureInfo _playerTex) # 2],
    format ["Current ground texture: %1", _groundTex],
    format ["Current ground colour average: %1", (getTextureInfo _groundTex) # 2],
    format ["Current camo coefficient: %1", player getUnitTrait "camouflageCoef"],
    format ["Texture cache size: %1 entries", count GVAR(texInfoCache)],
    format ["Unit cache size: %1 entries", count GVAR(unitCache)],
    format ["Uniform cache size: %1 entries", count GVAR(uniformCache)],
    format ["Texture cache: %1", GVAR(texInfoCache)],
    format ["Unit cache: %1", GVAR(unitCache)],
    format ["Uniform cache: %1", GVAR(uniformCache)]
];

diag_log text "";
