// ADVANCED SETTINGS

    // Lower limit
    // This is the minimum below which the camo coefficient can't go.
    [
        QCBA_SETTING(lowerLimit),
        "SLIDER",
        ["Camo coefficient lower limit", "The minimum visibility value that you can achieve without a ghillie suit."],
        [COMPONENT_NAME, "Advanced Settings"],
        [0, 1, 0.6, 1]
    ] call CBA_fnc_addSetting;

    // Upper limit
    // This is the maximum above which the camo coefficient can't go.
    [
        QCBA_SETTING(upperLimit),
        "SLIDER",
        ["Camo coefficient upper limit", "The maximum visibility you can have."],
        [COMPONENT_NAME, "Advanced Settings"],
        [1, 2, 1.4, 1]
    ] call CBA_fnc_addSetting;

    // Run the script for
    // Selects if the script should run for all players, player groups or all units
    [
        QCBA_SETTING(targetList),
        "LIST",
        ["Units affected by the mod", "Toggles the mod between all players, players and their groups (including their AI) and all units. More units = less performance"],
        [COMPONENT_NAME, "Advanced Settings"],
        [[0, 1, 2], ["Players", "Player groups", "All units"], 0]
    ] call CBA_fnc_addSetting;

    // Update frequency
    // How often should the script run
    [
        QCBA_SETTING(updateFrequency),
        "SLIDER",
        ["Update frequency", "Determines how often the script runs in seconds. Higher values yield better performance at the cost of accuracy."],
        [COMPONENT_NAME, "Advanced Settings"],
        [0, 10, 1, 1],
        0,
        {
            call FUNC(loop);
        }
    ] call CBA_fnc_addSetting;

// BASIC SETTINGS

    // Dyncas enabled
    [
        QCBA_SETTING(enabled), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
        "CHECKBOX", // setting type
        ["Dynamic Camo System enabled", "Toggles the mod on and off."], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
        [COMPONENT_NAME, "Basic Settings"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
        true, // data for this setting
        0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
        {
            call FUNC(loop);
        } // function that will be executed once on mission start and every time the setting is changed.
    ] call CBA_fnc_addSetting;

    // Ghillie suit reduction
    // Ghillie suits give a flat 0.2 reduction to camo coefficient when enabled
    [
        QCBA_SETTING(ghillieReduction),
        "SLIDER",
        ["Ghillie suit visibility reduction", "Ghillie suits reduce visibility by this setting's amount, and can potentially go below the minimum value.\n0 means reduction doesn't apply."],
        [COMPONENT_NAME, "Basic Settings"],
        [0, 2, 0.2, 2]
    ] call CBA_fnc_addSetting;

    // Ambient light compensation
    // The mod will make the ground texture darker in the calculations between 8PM and 4AM to account for the night.
    [
        QCBA_SETTING(nightCompensation),
        "SLIDER",
        ["Take ambient lighting reduction", "Favour dark clothing and reduce all visibility by this setting's amount in low light level areas.\n0 means reduction doesn't apply."],
        [COMPONENT_NAME, "Basic Settings"],
        [0, 2, 0.8, 2, true]
    ] call CBA_fnc_addSetting;
