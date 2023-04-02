/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Runs the Dynamic Camo System main loop.

	Parameters:
		NONE

	Usage: spawn DYNCAS_fnc_mainLoop;

	Returns: True if loop finished. False if not run on server.
*/

if !(isServer) exitWith {false};

private _UpdateTimeData =
{
	private _dFull = date;
	private _d = +_dFull;
	_d resize 3;

	if (_d isEqualTo DYNCAS_lastDate) exitWith {false};

	private _timeRange = _dFull call BIS_fnc_sunriseSunsetTime;
	DYNCAS_lastSunriseTime = _timeRange select 0;
	DYNCAS_lastSunsetTime = _timeRange select 1;
	_d resize 3;
	DYNCAS_lastDate = _d;
	true;
};

// Create the cache
DYNCAS_texInfoCache = createHashMap;
publicVariableServer "DYNCAS_texInfoCache";

private _timeRange = call BIS_fnc_sunriseSunsetTime
DYNCAS_lastSunriseTime = _timeRange select 0;
DYNCAS_lastSunsetTime = _timeRange select 1;
DYNCAS_lastDate = date;

// Main loop
while {DYNCAS_enabled} do {
	private _allPlayers = call CBA_fnc_players;
	private _targetOption = [_allPlayers, (allGroups select {leader _x in _allPlayers}), allUnits] # DYNCAS_targetList;

	call _UpdateTimeData;
	{
		private _currentElement = _x;
		if (_currentElement isEqualType objNull) then {
			_currentElement call DYNCAS_fnc_updateCamo;
		} else {
			{_x call DYNCAS_fnc_updateCamo} forEach units _currentElement;
		};
	} forEach _targetOption;
	sleep DYNCAS_updateFrequency;
};

// If DYNCAS was disabled, reset the camo coef to 1
if !(DYNCAS_enabled) then {
	{_x setUnitTrait ["camouflageCoef", 1]} forEach allUnits;
};

true
