/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Calculates an units camo value based on the terrain -
	and the worn uniform.

	Parameters:
		_this # 0: OBJECT - Unit to calculate a new camo coefficient for

	Usage: player call DYNCAS_fnc_updateCamo;

	Returns: The units new camo coefficient.
*/

private _unit = param [0, objNull, [objNull]];

// Error checks
if (_unit isEqualTo objNull) exitWith {false};
if !(isNull objectParent _unit) exitWith {_unit setUnitTrait ["camouflageCoef", 1]; false};

private _t = dayTime;
private _isNight = (_t < DYNCAS_lastSunriseTime) || { _t > DYNCAS_lastSunsetTime };

// Texture averages are cached for performance
private _texCache = DYNCAS_texInfoCache;

// Get player texture data
private _playerTex = getObjectTextures _unit;
if (_playerTex isEqualTo [] || {_playerTex # 0 isEqualTo ""}) exitWith {_unit setUnitTrait ["camouflageCoef", 1]; false};

private _playerTexAvg = _texCache get (_playerTex # 0);
if (isNil "_playerTexAvg") then {
	_playerTexAvg = (getTextureInfo (_playerTex # 0)) # 2;
	DYNCAS_texInfoCache set [(_playerTex # 0), _playerTexAvg, true];
	publicVariableServer "DYNCAS_texInfoCache";
};

// Get ground texture data
private _groundTex = surfaceTexture getPosASL _unit;
if (_groundTex isEqualTo "") exitWith {_unit setUnitTrait ["camouflageCoef", 1]; false};

private _groundTexAvg = _texCache get _groundTex;
if (isNil "_groundTexAvg") then {
	_groundTexAvg = (getTextureInfo _groundTex) # 2;
	DYNCAS_texInfoCache set [_groundTex, _groundTexAvg, true];
	publicVariableServer "DYNCAS_texInfoCache";
};

// Night compensation
// Average the ground colour so it is darker
if (DYNCAS_nightCompensation) then {
	if (_isNight) then {
		private _groundTexAvgNew = [];
		for "_i" from 0 to 2 do {
			_groundTexAvgNew pushBack ((_groundTexAvg # _i + (_groundTexAvg # _i / 2)) / 2);
		};
		_groundTexAvg = _groundTexAvgNew;
	};
};

private _averages = [];
for "_i" from 0 to 2 do {
	// Always calculate (bigger - smaller) / bigger
	if !(_playerTexAvg # _i > _groundTexAvg # _i) then {
		_averages pushBack ((_groundTexAvg # _i - _playerTexAvg # _i) / _groundTexAvg # _i);
	} else {
		_averages pushBack ((_playerTexAvg # _i - _groundTexAvg # _i) / _playerTexAvg # _i);
	};
};

_averages sort false;
// Old, exponential model
//private _result = 0.35 + ((exp (sqrt(2) * _averages # 0)) - 1);

// New sinusoidal model
private _val = deg (pi * _averages # 0);
private _result = 1.1 + ((sin(_val - 89.95))/2);

// Night compensation 2: electric boogaloo
// Reduce visibility by 20% because camo doesn't matter as much at night
if (DYNCAS_nightCompensation) then {
	if (_isNight) then {
		_result = _result * 0.8;
	};
};

// Floor and ceiling result
if (_result < DYNCAS_lowerLimit) then {_result = DYNCAS_lowerLimit};
if (_result > DYNCAS_upperLimit) then {_result = DYNCAS_upperLimit};

// Ghillie suit exception
if (DYNCAS_ghillieReduction) then {
	if ("ghillie" in (toLowerANSI (getText (configFile >> "cfgWeapons" >> uniform _unit >> "displayName")))) then {
		_result = _result - 0.2;
	};
};

// Hard coded minimum to prevent invisibility
if (_result < 0.1) then {_result = 0.1};

[_unit, ["camouflageCoef", _result]] remoteExec ["setUnitTrait", _unit];

_result
