#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main"
        };
        author = "ThomasAngel";
        authors[] = {"ThomasAngel"};
        url = "https://github.com/rekterakathom/DynamicCamoSystem";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
