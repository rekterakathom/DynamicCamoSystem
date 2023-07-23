// No script component, CBA is not required for this function
/*
    Author: ThomasAngel
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom

    Description:
	Client reports their current texture data to the server.

    Parameters:
        _this # 0: BOOLEAN - Send player texture data?
		_this # 1: BOOLEAN - Send ground texture data?

    Usage: call DYNCAS_core_clientSendTextures;

    Returns: Nothing.
*/

params [
	["_sendPlayerTexture", false, [false]],
	["_sendGroundTexture", false, [false]]
];

if (!hasInterface) exitWith {};

if (_sendPlayerTexture) then {
	// Get unit texture data
	private _playerTex = (getObjectTextures player) param [0, ""];

	// Something weird is going on, let's not proceed
	if (_playerTex isEqualTo "") exitWith {};

	// Player texture
	_playerTexAvg = (getTextureInfo _playerTex) # 2;

	// Don't save opacity
	_playerTexAvg deleteAt 3;
	_playerTexAvg = _playerTexAvg apply {parseNumber (_x toFixed 3)}; // Cut down the accuracy to a thousandth

	// Publish result to server
	missionNamespace setVariable [format ["DYNCAS_playerTextureCache_%1", _playerTex], _playerTexAvg, [0, 2] select isMultiplayer];
};

if (_sendGroundTexture) then {
	// Get ground texture data
	private _groundTex = surfaceTexture getPosASL player;

	// Ground texture
	_groundTexAvg = (getTextureInfo _groundTex) # 2;

	// Don't save opacity
	_groundTexAvg deleteAt 3;
	_groundTexAvg = _groundTexAvg apply {parseNumber (_x toFixed 3)}; // Cut down the accuracy to a thousandth

	// Publish result to server
	missionNamespace setVariable [format ["DYNCAS_groundTextureCache_%1", _groundTex], _groundTexAvg, [0, 2] select isMultiplayer];
};
