#pragma once

namespace GOTHIC_ENGINE {

    class BonusIndependentTrainingCore {
    public:
        static bool showStatsWhenTraining;
        static bool trainerMaxOnEffective;
        static bool showRealStatsInCharMenu;
        static int defaultMinAttribute;
        static int defaultMinPercent;
        
        static void Init();
        static void Update();
        static void ReadOptions();
        static void UpdateMenuItem(const char* itemName, const char* value);
        static void UpdateCharacterMenu();
        static bool IsMenuOpen();
    };
}