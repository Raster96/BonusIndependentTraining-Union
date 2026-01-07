#include "UnionAfx.h"
#include "BonusIndependentTrainingCore.h"

namespace GOTHIC_ENGINE {
    bool BonusIndependentTrainingCore::showStatsWhenTraining = false;
    bool BonusIndependentTrainingCore::trainerMaxOnEffective = false;
    bool BonusIndependentTrainingCore::showRealStatsInCharMenu = true;
    int BonusIndependentTrainingCore::defaultMinAttribute = 10;
    int BonusIndependentTrainingCore::defaultMinPercent = 10;

    // Define constants for aivar indices (these match Daedalus script constants)
    const int REAL_STRENGTH = 90;
    const int REAL_DEXTERITY = 91;
    const int REAL_MANA_MAX = 92;
    const int REAL_TALENT_1H = 93;
    const int REAL_TALENT_2H = 94;
    const int REAL_TALENT_BOW = 95;
    const int REAL_TALENT_CROSSBOW = 96;

    void BonusIndependentTrainingCore::Init() {
        ReadOptions();
    }

    void BonusIndependentTrainingCore::Update() {
        if (!player || !screen) return;
        
        // Update character menu if it's open and the option is enabled
        if (showRealStatsInCharMenu && IsMenuOpen()) {
            UpdateCharacterMenu();
        }
    }

    void BonusIndependentTrainingCore::ReadOptions() {
        if (!zoptions) return;
        
        showStatsWhenTraining = zoptions->ReadBool("BONUS_INDEPENDENT_TRAINING", "show_stats_when_training", false);
        trainerMaxOnEffective = zoptions->ReadBool("BONUS_INDEPENDENT_TRAINING", "trainer_max_against_effective", false);
        showRealStatsInCharMenu = zoptions->ReadBool("BONUS_INDEPENDENT_TRAINING", "show_real_stats_in_char_menu", true);
        defaultMinAttribute = zoptions->ReadInt("BONUS_INDEPENDENT_TRAINING", "default_min_attribute", 10);
        defaultMinPercent = zoptions->ReadInt("BONUS_INDEPENDENT_TRAINING", "default_min_percent", 10);
    }

    void BonusIndependentTrainingCore::UpdateMenuItem(const char* itemName, const char* value) {
        zSTRING itemNameStr = itemName;
        zCMenuItem* menuItem = zCMenuItem::GetByName(itemNameStr);
        
        if (menuItem) {
            zSTRING valueStr = value;
            menuItem->SetText(valueStr, 0, TRUE);
        }
    }

    void BonusIndependentTrainingCore::UpdateCharacterMenu() {
        if (!player) return;
        
        oCNpc* hero = player;
        if (!hero) return;
        
        int trainedStr = max(defaultMinAttribute, hero->aiscriptvars[REAL_STRENGTH]);
        int effectiveStr = hero->attribute[NPC_ATR_STRENGTH];
        zSTRING strText = zSTRING(trainedStr) + "  " + zSTRING(effectiveStr);
        UpdateMenuItem("MENU_ITEM_ATTRIBUTE_1", strText.ToChar());
        
        int trainedDex = max(defaultMinAttribute, hero->aiscriptvars[REAL_DEXTERITY]);
        int effectiveDex = hero->attribute[NPC_ATR_DEXTERITY];
        zSTRING dexText = zSTRING(trainedDex) + "  " + zSTRING(effectiveDex);
        UpdateMenuItem("MENU_ITEM_ATTRIBUTE_2", dexText.ToChar());
        
        int trainedMana = max(defaultMinAttribute, hero->aiscriptvars[REAL_MANA_MAX]);
        int effectiveMana = hero->attribute[NPC_ATR_MANAMAX];
        zSTRING manaText = zSTRING(trainedMana) + "  " + zSTRING(effectiveMana);
        UpdateMenuItem("MENU_ITEM_ATTRIBUTE_3", manaText.ToChar());
        
        int trained1H = max(defaultMinPercent, hero->aiscriptvars[REAL_TALENT_1H]);
        int effective1H = hero->hitChance[NPC_HITCHANCE_1H];
        zSTRING talent1HText = zSTRING(trained1H) + "%/" + zSTRING(effective1H) + "%";
        UpdateMenuItem("MENU_ITEM_TALENT_1", talent1HText.ToChar());
        
        int trained2H = max(defaultMinPercent, hero->aiscriptvars[REAL_TALENT_2H]);
        int effective2H = hero->hitChance[NPC_HITCHANCE_2H];
        zSTRING talent2HText = zSTRING(trained2H) + "%/" + zSTRING(effective2H) + "%";
        UpdateMenuItem("MENU_ITEM_TALENT_2", talent2HText.ToChar());
        
        int trainedBow = max(defaultMinPercent, hero->aiscriptvars[REAL_TALENT_BOW]);
        int effectiveBow = hero->hitChance[NPC_HITCHANCE_BOW];
        zSTRING talentBowText = zSTRING(trainedBow) + "%/" + zSTRING(effectiveBow) + "%";
        UpdateMenuItem("MENU_ITEM_TALENT_3", talentBowText.ToChar());
        
        int trainedXbow = max(defaultMinPercent, hero->aiscriptvars[REAL_TALENT_CROSSBOW]);
        int effectiveXbow = hero->hitChance[NPC_HITCHANCE_CROSSBOW];
        zSTRING talentXbowText = zSTRING(trainedXbow) + "%/" + zSTRING(effectiveXbow) + "%";
        UpdateMenuItem("MENU_ITEM_TALENT_4", talentXbowText.ToChar());
    }

    bool BonusIndependentTrainingCore::IsMenuOpen() {
        zCMenu* activeMenu = zCMenu::GetActive();
        return activeMenu != nullptr;
    }
}