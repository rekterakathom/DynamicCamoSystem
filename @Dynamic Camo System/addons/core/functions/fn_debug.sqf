/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Shows debug information like cache size, current coefficients etc.

	Parameters:
		NONE

	Usage: call DYNCAS_fnc_debug;

	Returns: True if successful.
*/

// Send to server to retrieve info like cache etc.
if !(isServer) exitWith {[player] remoteExec ["DYNCAS_fnc_sendDebugInfo", 2, false]};

// Get the cache size
private _cacheSize = param [0, count DYNCAS_texInfoCache, [0]];

private _debugInfo = [
	"Dynamic Camo System Debug",
	"",
	format ["DYNCAS enabled: %1", DYNCAS_enabled],
	format ["Ghillie reduction enabled: %1", DYNCAS_ghillieReduction],
	format ["Night compensation enabled: %1", DYNCAS_nightCompensation],
	format ["Current lower limit: %1", DYNCAS_lowerLimit],
	format ["Current upper limit: %1", DYNCAS_upperLimit],
	"",
	format ["Cache size: %1 entries", _cacheSize],
	"",
	format ["Current uniform texture:\n%1", (getObjectTextures player) # 0],
	"",
	format ["Current uniform colour average:\n%1", (getTextureInfo ((getObjectTextures player) # 0)) # 2],
	"",
	format ["Current ground texture:\n%1", surfaceTexture getPosASL player],
	"",
	format ["Current ground colour average:\n%1", (getTextureInfo (surfaceTexture getPosASL player)) # 2],
	"",
	format ["Current camo coefficient: %1", player getUnitTrait "camouflageCoef"]
];

private _hint = _debugInfo joinString "\n";
hint _hint;

true
