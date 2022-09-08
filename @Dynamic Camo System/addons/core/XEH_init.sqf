
// ADVANCED SETTINGS

	// Base multiplier
	// This modifies the camo result linearly
	[
		"DYNCAS_baseMultiplier",
		"Slider",
		["Camo multiplier", "The camo effectiveness multiplier"],
		["Dynamic Camo System", "Advanced Settings"],
		[0, 2, 1, 2],
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Lower limit
	// This is the minimum below which the camo coefficient can't go.
	[
		"DYNCAS_lowerLimit",
		"Slider",
		["Camo coefficient lower limit", "The minimum visibility value that you can achieve without a ghillie suit."],
		["Dynamic Camo System", "Advanced Settings"],
		[0, 1, 0.6, 1],
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Upper limit
	// This is the maximum above which the camo coefficient can't go.
	[
		"DYNCAS_upperLimit",
		"Slider",
		["Camo coefficient upper limit", "The maximum visibility you can have."],
		["Dynamic Camo System", "Advanced Settings"],
		[1, 2, 1.4, 1],
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Crouched effectiveness
	// The amount your visibility is reduced when crouching
	[
		"DYNCAS_crouchReduction",
		"Slider",
		["Crouch Effectiveness", "How much your visibility is reduced when crouched"],
		["Dynamic Camo System", "Advanced Settings"],
		[0, 1, 0.05, 2],
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Prone effectiveness
	// The amount your visibility is reduced when proning
	[
		"DYNCAS_proneReduction",
		"Slider",
		["Prone Effectiveness", "How much your visibility is reduced when prone"],
		["Dynamic Camo System", "Advanced Settings"],
		[0, 1, 0.1, 2],
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Run the script for
	// Selects if the script should run for all players, player groups or all units
	[
		"DYNCAS_targetList",
		"List",
		["Units affected by the mod", "Toggles the mod between all players, players and their groups (including their AI) and all units. More units = less performance"],
		["Dynamic Camo System", "Advanced Settings"],
		[[0, 1, 2], ["Players", "Player groups", "All units"], 0],
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Update frequency
	// How often should the script run
	[
		"DYNCAS_updateFrequency",
		"Slider",
		["Update frequency", "Determines how often the script runs in seconds. Higher values yield better performance at the cost of accuracy."],
		["Dynamic Camo System", "Advanced Settings"],
		[0.5, 10, 1, 1],
		nil,
		{}
	] call CBA_fnc_addSetting;

// BASIC SETTINGS

	// Dyncas enabled
	[
		"DYNCAS_enabled", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
		"Checkbox", // setting type
		["Dynamic Camo System enabled", "Toggles the mod on and off"], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
		["Dynamic Camo System", "Basic Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
		true, // data for this setting
		nil, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
		{  
			[] spawn DYNCAS_fnc_mainLoop;
		} // function that will be executed once on mission start and every time the setting is changed.
	] call CBA_fnc_addSetting;

	// Ghillie suit reduction
	// Ghillie suits give a flat 0.2 reduction to camo coefficient when enabled
	[
		"DYNCAS_ghillieReduction",
		"Checkbox",
		["Ghillie suits reduce visibility", "Ghillie suits reduce visibility by a flat amount, and can potentially go below the minimum value."],
		["Dynamic Camo System", "Basic Settings"],
		true,
		nil,
		{}
	] call CBA_fnc_addSetting;

	// Night compensation
	// The mod will make the ground texture darker in the calculations between 8PM and 4AM to account for the night.
	[
		"DYNCAS_nightCompensation",
		"Checkbox",
		["Take night into account in calculations", "Favour dark clothing and reduce all visibility by 20% during the night"],
		["Dynamic Camo System", "Basic Settings"],
		true,
		nil,
		{}
	] call CBA_fnc_addSetting;
