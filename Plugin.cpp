#include "UnionAfx.h"
#include "resource.h"

namespace GOTHIC_ENGINE {

    // External function for Daedalus scripts
    int __cdecl BIT_UpdateMenuItem_External() {
        zSTRING itemName, value;
        parser->GetParameter(itemName);
        parser->GetParameter(value);
        
        BonusIndependentTrainingCore::UpdateMenuItem(itemName.ToChar(), value.ToChar());
        return 0;
    }

    void Game_Entry() {
    }
    
    void Game_Init() {
        if (zoptions) {
            BonusIndependentTrainingCore::ReadOptions();
        }
        BonusIndependentTrainingCore::Init();
    }

    void Game_Exit() {
    }

    void Game_PreLoop() {
    }

    void Game_Loop() {
        if (!player || !screen || !zinput || !ogame) return;
        if (ogame->inScriptStartup || ogame->inLoadSaveGame || ogame->inLevelChange) return;

        BonusIndependentTrainingCore::Update();
    }

    void Game_PostLoop() {
    }

    void Game_MenuLoop() {
    }

    TSaveLoadGameInfo& SaveLoadGameInfo = UnionCore::SaveLoadGameInfo;

    void Game_SaveBegin() {
    }

    void Game_SaveEnd() {
    }

    void LoadBegin() {
    }

    void LoadEnd() {
        // Character menu might need refresh after loading
        if (BonusIndependentTrainingCore::showRealStatsInCharMenu) {
            BonusIndependentTrainingCore::UpdateCharacterMenu();
        }
    }

    void Game_LoadBegin_NewGame() {
        LoadBegin();
    }

    void Game_LoadEnd_NewGame() {
        LoadEnd();
    }

    void Game_LoadBegin_SaveGame() {
        LoadBegin();
    }

    void Game_LoadEnd_SaveGame() {
        LoadEnd();
    }

    void Game_LoadBegin_ChangeLevel() {
        LoadBegin();
    }

    void Game_LoadEnd_ChangeLevel() {
        LoadEnd();
    }

    void Game_LoadBegin_Trigger() {
    }
    
    void Game_LoadEnd_Trigger() {
    }
    
    void Game_Pause() {
    }
    
    void Game_Unpause() {
    }
    
    void Game_DefineExternals() {
        // Export function to Daedalus scripts
        parser->DefineExternal("BIT_UpdateMenuItem", 
                              (int(__cdecl*)())BIT_UpdateMenuItem_External, 
                              zPAR_TYPE_VOID, 
                              zPAR_TYPE_STRING, 
                              zPAR_TYPE_STRING, 
                              zPAR_TYPE_VOID);
    }

    void Game_ApplyOptions() {
        BonusIndependentTrainingCore::ReadOptions();
    }

#define AppDefault True
    CApplication* lpApplication = !CHECK_THIS_ENGINE ? Null : CApplication::CreateRefApplication(
        Enabled( AppDefault ) Game_Entry,
        Enabled( AppDefault ) Game_Init,
        Enabled( AppDefault ) Game_Exit,
        Enabled( AppDefault ) Game_PreLoop,
        Enabled( AppDefault ) Game_Loop,
        Enabled( AppDefault ) Game_PostLoop,
        Enabled( AppDefault ) Game_MenuLoop,
        Enabled( AppDefault ) Game_SaveBegin,
        Enabled( AppDefault ) Game_SaveEnd,
        Enabled( AppDefault ) Game_LoadBegin_NewGame,
        Enabled( AppDefault ) Game_LoadEnd_NewGame,
        Enabled( AppDefault ) Game_LoadBegin_SaveGame,
        Enabled( AppDefault ) Game_LoadEnd_SaveGame,
        Enabled( AppDefault ) Game_LoadBegin_ChangeLevel,
        Enabled( AppDefault ) Game_LoadEnd_ChangeLevel,
        Enabled( AppDefault ) Game_LoadBegin_Trigger,
        Enabled( AppDefault ) Game_LoadEnd_Trigger,
        Enabled( AppDefault ) Game_Pause,
        Enabled( AppDefault ) Game_Unpause,
        Enabled( AppDefault ) Game_DefineExternals,
        Enabled( AppDefault ) Game_ApplyOptions
    );
}