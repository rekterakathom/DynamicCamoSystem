/*
	Author: ThomasAngel
	Steam: https://steamcommunity.com/id/Thomasangel/
	Github: https://github.com/rekterakathom

	Description:
	Sends info to a player for debugging.

	Parameters:
		_this # 0: OBJECT - Unit to send debug info to

	Usage: [player] remoteExec ["DYNCAS_fnc_sendDebugInfo", 2, false];

	Returns: True if successful.
*/

private _requester = param [0, objNull, [objNull]];

if !(isServer) then {["Debug info requested from client instead of server by %1", _requester] call BIS_fnc_error; false};

private _cacheSize = count DYNCAS_texInfoCache;
[_cacheSize] remoteExec ["DYNCAS_fnc_debug", _requester, false];

true
