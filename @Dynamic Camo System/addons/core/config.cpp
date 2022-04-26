class CfgPatches
{
	class DYNCAScore
	{
		name = "Dynamic Camo System Core";
		author = "ThomasAngel";
		requiredVersion = 2.08;
		requiredAddons[] = {"CBA_main"};
		units[] = {};
		weapons[] = {};
	};
};

class CfgFunctions {
	class DYNCAS {
		tag="DYNCAS";
		class CamoSys {
			file="@Dynamic Camo System\addons\core\functions";
            class debug {};
			class updateCamo {};
            class sendDebugInfo {};
			class mainLoop {};
		};
	};
};

class Extended_PostInit_EventHandlers {
	class DYNCAS_functions_f {
        init = "call compileScript ['@Dynamic Camo System\addons\core\XEH_init.sqf', true]";
	};
};