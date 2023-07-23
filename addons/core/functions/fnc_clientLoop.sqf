#include "script_component.hpp"
/*
    Author: ThomasAngel
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom

    Description:
    Runs the Dynamic Camo System client loop.
	It is responsible for gathering texture data.
	Server's results are inaccurate in case of dedicated server

    Parameters:
        NONE

    Usage: call DYNCAS_core_fnc_clientLoop;

    Returns: Nothing.
*/

if (!hasInterface) exitWith {};
if !(isClass (configFile >> "cfgPatches" >> "cba_common")) exitWith {}; // Client doesn't have CBA

// If PFH is already running, stop the previous one
if (!isNil QGVAR(CLIENT_PFHID)) then {
    GVAR(CLIENT_PFHID) call CBA_fnc_removePerFrameHandler;
};

if (isNil QGVAR(texInfoCache)) then {
	GVAR(texInfoCache) = createHashMap;
};

GVAR(CLIENT_PFHID) = [{

	// Get unit texture data
	private _playerTex = (getObjectTextures player) param [0, ""];

	// Get ground texture data
	private _groundTex = surfaceTexture getPosASL player;

	// Something weird is going on, let's not proceed
	if (_playerTex isEqualTo "" || _groundTex isEqualTo "") exitWith {};

	// New texture discovered
	if !(_playerTex in GVAR(texInfoCache)) then {
		_playerTexAvg = (getTextureInfo _playerTex) # 2;

		// Don't save opacity
		_playerTexAvg deleteAt 3;
		_playerTexAvg = _playerTexAvg apply {parseNumber (_x toFixed 3)}; // Cut down the accuracy to a thousandth
		GVAR(texInfoCache) set [_playerTex, _playerTexAvg];

		// Check if result is already known
		if (isNil {missionNamespace getVariable format ["DYNCAS_playerTextureCache_%1", _playerTex]}) then {
			// Publish result
			missionNamespace setVariable [format ["DYNCAS_playerTextureCache_%1", _playerTex], _playerTexAvg, true];
		};
	};

	// New ground texture discovered
	if !(_groundTex in GVAR(texInfoCache)) then {
		_groundTexAvg = (getTextureInfo _groundTex) # 2;

		// Don't save opacity
		_groundTexAvg deleteAt 3;
		_groundTexAvg = _groundTexAvg apply {parseNumber (_x toFixed 3)}; // Cut down the accuracy to a thousandth
		GVAR(texInfoCache) set [_groundTex, _groundTexAvg];

		// Check if result is already known
		if (isNil {missionNamespace getVariable format ["DYNCAS_groundTextureCache_%1", _groundTex]}) then {
			// Publish result
			missionNamespace setVariable [format ["DYNCAS_groundTextureCache_%1", _groundTex], _groundTexAvg, true];
		};
	};
}, 5] call CBA_fnc_addPerFrameHandler;