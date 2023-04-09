#include "script_component.hpp"
/*
    Author: ThomasAngel
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom

    Description:
    Sends info to a client for debugging.
    If you are the server, use "DYNCAS_core_fnc_debug" directly instead.

    Parameters:
        _this # 0: NETWORK ID/OBJECT - Client to send debug info to

    Usage: clientOwner remoteExecCall ["DYNCAS_core_fnc_sendDebugInfo", 2];

    Returns: Nothing.
*/

params [["_requesterNetworkID", 2, [0, objNull]]];

// Ignore remote requests with network ID = 2 (= server) and 0 (= everyone)
if (_requesterNetworkID in [0, 2]) exitWith {};

if (!isServer) exitWith {
    _requesterNetworkID remoteExecCall [QFUNC(sendDebugInfo), 2];
};

// Convert from object to network ID
if (_requesterNetworkID isEqualType objNull) then {
    _requesterNetworkID = owner _requesterNetworkID;
};

// Broadcast variables to requester
_requesterNetworkID publicVariableClient QGVAR(texInfoCache);
_requesterNetworkID publicVariableClient QGVAR(unitCache);
_requesterNetworkID publicVariableClient QGVAR(uniformCache);

// Make sure that variables have been broadcast before calling function on requester
[{
    remoteExecCall [QFUNC(debug), _this];
}, _requesterNetworkID, 0.5] call CBA_fnc_waitAndExecute;
