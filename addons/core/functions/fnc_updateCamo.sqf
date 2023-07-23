#include "script_component.hpp"
/*
    Author: ThomasAngel, johnb43
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom

    Description:
    Calculates an units camo value based on the terrain -
    and the worn uniform.

    Parameters:
        _this # 0: OBJECT - Unit to calculate a new camo coefficient for

    Usage: player call DYNCAS_core_fnc_updateCamo;

    Returns: Nothing.
*/

params [["_unit", objNull, [objNull]]];

// Check if valid unit
if (isNull _unit) exitWith {};

private _key = hashValue _unit;

// Get unit texture data
private _playerTex = (getObjectTextures _unit) param [0, ""];

// Get ground texture data
private _groundTex = surfaceTexture getPosASL _unit;

// If unit is in a vehicle or a texture isn't defined, reset camo coef
if (!isNull objectParent _unit || _playerTex isEqualTo "" || _groundTex isEqualTo "") exitWith {
    // Cache the previous result, in order to not spam messages across the network
    if ((GVAR(unitCache) getOrDefault [_key, -1]) == 1) exitWith {};

    GVAR(unitCache) set [_key, 1];

    [_unit, ["camouflageCoef", 1]] remoteExecCall ["setUnitTrait", _unit];
};

// Texture averages are cached for performance
private _playerTexAvg = GVAR(texInfoCache) get _playerTex;

if (isNil "_playerTexAvg") then {
    // Try to retrieve the data for the texture
    _playerTexAvg = missionNamespace getVariable format ["DYNCAS_playerTextureCache_%1", _playerTex];

    // Retrieve successful
    if !(isNil "_playerTexAvg") then {
        GVAR(texInfoCache) set [_playerTex, _playerTexAvg];
    };
};

// Retrieval unsuccessful -> we don't know the average, so exit by asking the client
// Don't reset to 1 because this might cause a sharp increase in visibility and player gets spotted :(
if (isNil "_playerTexAvg") exitWith {
    // Don't ask for dedicated server owned units
    if (isMultiplayer && !(isDedicated && {owner _unit isEqualTo 2})) then {
        // Ask for both
        [true, true] remoteExecCall [QGVAR(clientSendTextures), _unit, false];
    } else {
        [true, true] call GVAR(clientSendTextures);
    };
};

private _groundTexAvg = GVAR(texInfoCache) get _groundTex;

if (isNil "_groundTexAvg") then {
    // Try to retrieve the data for the texture
    _groundTexAvg = missionNamespace getVariable format ["DYNCAS_groundTextureCache_%1", _groundTex];

    // Retrieve successful
    if !(isNil "_groundTexAvg") then {
        GVAR(texInfoCache) set [_groundTex, _groundTexAvg];
    };
};

// Retrieval unsuccessful -> we don't know the average, so exit by asking the client
// Don't reset to 1 because this might cause a sharp increase in visibility and player gets spotted :(
if (isNil "_groundTexAvg") exitWith {
    // Don't ask for dedicated server owned units
    if (isMultiplayer && !(isDedicated && {owner _unit isEqualTo 2})) then {
        // We only need to get the ground texture, function would have exited if the uniform wasn't known
        [false, true] remoteExecCall [QGVAR(clientSendTextures), _unit, false];
    } else {
        [false, true] call GVAR(clientSendTextures);
    };
};

// Check ambient lighting to see if dark
private _isNight = CBA_SETTING(nightCompensation) > 0 && {
    (getLightingAt _unit) params ["", "_ambientLightBrightness", "", "_dynamicLightBrightness"];

    _ambientLightBrightness + _dynamicLightBrightness < 100
};

// Night compensation
// Average the ground colour so it is darker
if (_isNight) then {
    _groundTexAvg = _groundTexAvg vectorMultiply 0.75;
};

private _averages = [];

for "_i" from 0 to 2 do {
    _playerTex = _playerTexAvg # _i;
    _groundTex = _groundTexAvg # _i;

    // Always calculate (bigger - smaller) / bigger
    _averages pushBack (abs (_groundTex - _playerTex) / ([_playerTex, _groundTex] select (_playerTex <= _groundTex)));
};

// Old, exponential model
// private _result = 0.35 + ((exp (sqrt(2) * _averages # 0)) - 1);

// New sinusoidal model
private _result = 1.1 + sin (deg (pi * selectMax _averages) - 89.95) / 2;

// Night compensation 2: electric boogaloo
// Reduce visibility by CBA setting's amount because camo doesn't matter as much at night
if (_isNight) then {
    _result = _result * CBA_SETTING(nightCompensation);
};

// Floor and ceiling result
_result = (_result max CBA_SETTING(lowerLimit)) min CBA_SETTING(upperLimit);

// Ghillie suit exception
if (CBA_SETTING(ghillieReduction) > 0) then {
    private _uniform = uniform _unit;

    if (_uniform == "") exitWith {};

    private _uniformName = GVAR(uniformCache) get _uniform;

    if (isNil "_uniformName") then {
        _uniformName = toLowerANSI (getText (configFile >> "CfgWeapons" >> _uniform >> "displayName"));
        GVAR(uniformCache) set [_uniform, _uniformName];
    };

    if ("ghillie" in _uniformName) then {
        _result = _result - CBA_SETTING(ghillieReduction);
    };
};

// Hard coded minimum to prevent invisibility
_result = _result max MIN_VISIBILITY;

// Cache the previous result, in order to not spam messages across the network
if ((GVAR(unitCache) getOrDefault [_key, -1]) == _result) exitWith {};

GVAR(unitCache) set [_key, _result];

[_unit, ["camouflageCoef", _result]] remoteExecCall ["setUnitTrait", _unit];
