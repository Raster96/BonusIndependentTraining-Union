META
{
	Parser = Game;
	MergeMode = True;
	Engine = G2A;
};

const string BIT_PLUGIN_ID = "BonusIndependentTraining";

const int REAL_STRENGTH = 90;
const int REAL_DEXTERITY = 91;
const int REAL_MANA_MAX = 92;
const int REAL_TALENT_1H = 93;
const int REAL_TALENT_2H = 94;
const int REAL_TALENT_BOW = 95;
const int REAL_TALENT_CROSSBOW = 96;

const string BIT_INI_SECTION = "BONUS_INDEPENDENT_TRAINING";
const string BIT_INI_SHOWSTATSWHENTRAINING = "show_stats_when_training";
const string BIT_INI_TRAINERMAXONEFFECTIVE = "trainer_max_against_effective";
const string BIT_INI_SHOWREALSTATSINCHARMENU = "show_real_stats_in_char_menu";

var int BIT_ShowStatsWhenTraining;
var int BIT_TrainerMaxOnEffective;
var int BIT_ShowRealStatsInCharMenu;

// ============================================================================
// Configuration Functions
// ============================================================================

func void BIT_LoadConfig()
{
	BIT_ShowStatsWhenTraining = Hlp_ReadOptionInt("Mod", BIT_INI_SECTION, BIT_INI_SHOWSTATSWHENTRAINING, 0);
	BIT_TrainerMaxOnEffective = Hlp_ReadOptionInt("Mod", BIT_INI_SECTION, BIT_INI_TRAINERMAXONEFFECTIVE, 0);
	BIT_ShowRealStatsInCharMenu = Hlp_ReadOptionInt("Mod", BIT_INI_SECTION, BIT_INI_SHOWREALSTATSINCHARMENU, 1);
};

// ============================================================================
// Utility Functions
// ============================================================================

func int BIT_GetRealFightTalentPercent(var C_NPC oth, var int talent)
{
	if (talent == NPC_TALENT_1H)      { return oth.aivar[REAL_TALENT_1H]; }
	else if (talent == NPC_TALENT_2H)      { return oth.aivar[REAL_TALENT_2H]; }
	else if (talent == NPC_TALENT_BOW)     { return oth.aivar[REAL_TALENT_BOW]; }
	else if (talent == NPC_TALENT_CROSSBOW) { return oth.aivar[REAL_TALENT_CROSSBOW]; }
	else { return -1; };
};

func int BIT_GetHitChance(var C_NPC oth, var int talent)
{
	if (talent == NPC_TALENT_1H)      { return oth.Hitchance[NPC_TALENT_1H]; }
	else if (talent == NPC_TALENT_2H)      { return oth.Hitchance[NPC_TALENT_2H]; }
	else if (talent == NPC_TALENT_BOW)     { return oth.Hitchance[NPC_TALENT_BOW]; }
	else if (talent == NPC_TALENT_CROSSBOW) { return oth.Hitchance[NPC_TALENT_CROSSBOW]; }
	else { return -1; };
};

func int BIT_GetRealAttribute(var C_NPC oth, var int attrib)
{
	if (attrib == ATR_STRENGTH)  { return oth.aivar[REAL_STRENGTH]; }
	else if (attrib == ATR_DEXTERITY) { return oth.aivar[REAL_DEXTERITY]; }
	else if (attrib == ATR_MANA_MAX)  { return oth.aivar[REAL_MANA_MAX]; }
	else { return -1; };
};

func int BIT_GetAttribute(var C_NPC oth, var int attrib)
{
	if (attrib == ATR_STRENGTH)  { return oth.attribute[ATR_STRENGTH]; }
	else if (attrib == ATR_DEXTERITY) { return oth.attribute[ATR_DEXTERITY]; }
	else if (attrib == ATR_MANA_MAX)  { return oth.attribute[ATR_MANA_MAX]; }
	else { return -1; };
};

func string BIT_TalentToString(var int talent)
{
	if (talent == NPC_TALENT_1H)      { return "One-Handed"; }
	else if (talent == NPC_TALENT_2H)      { return "Two-Handed"; }
	else if (talent == NPC_TALENT_BOW)     { return "Bow"; }
	else if (talent == NPC_TALENT_CROSSBOW) { return "Crossbow"; }
	else { return "Unknown"; };
};

func string BIT_AttributeToString(var int attrib)
{
	if (attrib == ATR_STRENGTH)  { return "Strength"; }
	else if (attrib == ATR_DEXTERITY) { return "Dexterity"; }
	else if (attrib == ATR_MANA_MAX)  { return "Mana"; }
	else { return "Unknown"; };
};

func void BIT_ModAttribute(var C_NPC oth, var int attrib, var int points)
{
	if (attrib == ATR_STRENGTH)  { oth.attribute[ATR_STRENGTH] = oth.attribute[ATR_STRENGTH] + points; }
	else if (attrib == ATR_DEXTERITY) { oth.attribute[ATR_DEXTERITY] = oth.attribute[ATR_DEXTERITY] + points; }
	else if (attrib == ATR_MANA_MAX)  { oth.attribute[ATR_MANA_MAX] = oth.attribute[ATR_MANA_MAX] + points; };
};

func void B_RaiseRealAttributeLearnCounter(var C_NPC oth, var int attrib, var int points)
{
	if (attrib == ATR_STRENGTH)  { oth.aivar[REAL_STRENGTH] = oth.aivar[REAL_STRENGTH] + points; }
	else if (attrib == ATR_DEXTERITY) { oth.aivar[REAL_DEXTERITY] = oth.aivar[REAL_DEXTERITY] + points; }
	else if (attrib == ATR_MANA_MAX)  { oth.aivar[REAL_MANA_MAX] = oth.aivar[REAL_MANA_MAX] + points; };
};

func void B_RaiseRealFightTalentPercent(var C_NPC oth, var int talent, var int percent)
{
	if (talent == NPC_TALENT_1H)      { oth.aivar[REAL_TALENT_1H] = oth.aivar[REAL_TALENT_1H] + percent; }
	else if (talent == NPC_TALENT_2H)      { oth.aivar[REAL_TALENT_2H] = oth.aivar[REAL_TALENT_2H] + percent; }
	else if (talent == NPC_TALENT_BOW)     { oth.aivar[REAL_TALENT_BOW] = oth.aivar[REAL_TALENT_BOW] + percent; }
	else if (talent == NPC_TALENT_CROSSBOW) { oth.aivar[REAL_TALENT_CROSSBOW] = oth.aivar[REAL_TALENT_CROSSBOW] + percent; };
};

// ============================================================================
// Hook Functions
// ============================================================================

func int b_getlearncostattribute(var C_NPC oth, var int attribut)
{
	var int kosten;
	kosten = 0;
	
	if (attribut == ATR_STRENGTH)
	{
		if (oth.aivar[REAL_STRENGTH] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_STRENGTH] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_STRENGTH] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_STRENGTH] >= 30) { kosten = 2; }
		else { kosten = 1; };
	};
	
	if (attribut == ATR_DEXTERITY)
	{
		if (oth.aivar[REAL_DEXTERITY] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_DEXTERITY] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_DEXTERITY] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_DEXTERITY] >= 30) { kosten = 2; }
		else { kosten = 1; };
	};
	
	if (attribut == ATR_MANA_MAX)
	{
		if (oth.aivar[REAL_MANA_MAX] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_MANA_MAX] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_MANA_MAX] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_MANA_MAX] >= 30) { kosten = 2; }
		else { kosten = 1; };
	};
	
	return kosten;
};

func int b_getlearncosttalent(var C_NPC oth, var int talent, var int skill)
{
	var int kosten;
	kosten = 0;
	
	if (talent == NPC_TALENT_1H)
	{
		if (oth.aivar[REAL_TALENT_1H] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_TALENT_1H] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_TALENT_1H] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_TALENT_1H] >= 30) { kosten = 2; }
		else { kosten = 1; };
		kosten = kosten * skill;
		return kosten;
	};
	
	if (talent == NPC_TALENT_2H)
	{
		if (oth.aivar[REAL_TALENT_2H] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_TALENT_2H] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_TALENT_2H] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_TALENT_2H] >= 30) { kosten = 2; }
		else { kosten = 1; };
		kosten = kosten * skill;
		return kosten;
	};
	
	if (talent == NPC_TALENT_BOW)
	{
		if (oth.aivar[REAL_TALENT_BOW] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_TALENT_BOW] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_TALENT_BOW] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_TALENT_BOW] >= 30) { kosten = 2; }
		else { kosten = 1; };
		kosten = kosten * skill;
		return kosten;
	};
	
	if (talent == NPC_TALENT_CROSSBOW)
	{
		if (oth.aivar[REAL_TALENT_CROSSBOW] >= 120) { kosten = 5; }
		else if (oth.aivar[REAL_TALENT_CROSSBOW] >= 90) { kosten = 4; }
		else if (oth.aivar[REAL_TALENT_CROSSBOW] >= 60) { kosten = 3; }
		else if (oth.aivar[REAL_TALENT_CROSSBOW] >= 30) { kosten = 2; }
		else { kosten = 1; };
		kosten = kosten * skill;
		return kosten;
	};
	
	return b_getlearncosttalent_Old(oth, talent, skill);
};

func int b_teachattributepoints(var C_NPC slf, var C_NPC oth, var int attrib, var int points, var int teachermax)
{
	var int realAttr; realAttr = BIT_GetRealAttribute(oth, attrib);
	var int attr; attr = BIT_GetAttribute(oth, attrib);
	var int diff; diff = attr - realAttr;

	if (!BIT_TrainerMaxOnEffective) {
		BIT_ModAttribute(oth, attrib, -diff);
	};

	var int result; result = b_teachattributepoints_Old(slf, oth, attrib, points, teachermax);

	if (!BIT_TrainerMaxOnEffective) {
		BIT_ModAttribute(oth, attrib, diff);
	};

	if (result == FALSE) {
		return FALSE;
	};

	var int raiseTo; raiseTo = points;
	if (realAttr < 10) {
		raiseTo = 10 - realAttr + points;
	};
	B_RaiseRealAttributeLearnCounter(oth, attrib, raiseTo);

	var string message;
	message = ConcatStrings(BIT_AttributeToString(attrib), " trained:");
	message = ConcatStrings(message, IntToString(realAttr));
	message = ConcatStrings(message, "->");
	message = ConcatStrings(message, IntToString(BIT_GetRealAttribute(oth, attrib)));
	message = ConcatStrings(message, " effective:");
	message = ConcatStrings(message, IntToString(attr));
	message = ConcatStrings(message, "->");
	message = ConcatStrings(message, IntToString(BIT_GetAttribute(oth, attrib)));

	if (BIT_ShowStatsWhenTraining) {
		Print(message);
	};

	return result;
};

func int b_teachfighttalentpercent(var C_NPC slf, var C_NPC oth, var int talent, var int percent, var int teachermax)
{
	var int realTalent; realTalent = BIT_GetRealFightTalentPercent(oth, talent);
	var int fightSkill; fightSkill = BIT_GetHitChance(oth, talent);
	var int diff; diff = fightSkill - realTalent;

	if (!BIT_TrainerMaxOnEffective) {
		B_AddFightSkill(oth, talent, -diff);
	};

	var int result; result = b_teachfighttalentpercent_Old(slf, oth, talent, percent, teachermax);

	if (!BIT_TrainerMaxOnEffective) {
		B_AddFightSkill(oth, talent, diff);
	};

	if (result == FALSE) {
		return FALSE;
	};

	var int raiseTo; raiseTo = percent;
	if (realTalent < 10) {
		raiseTo = 10 - realTalent + percent;
	};
	B_RaiseRealFightTalentPercent(oth, talent, raiseTo);

	var string message;
	message = ConcatStrings(BIT_PLUGIN_ID, " ");
	message = ConcatStrings(message, BIT_TalentToString(talent));
	message = ConcatStrings(message, " trained:");
	message = ConcatStrings(message, IntToString(realTalent));
	message = ConcatStrings(message, "->");
	message = ConcatStrings(message, IntToString(BIT_GetRealFightTalentPercent(oth, talent)));
	message = ConcatStrings(message, " effective:");
	message = ConcatStrings(message, IntToString(fightSkill));
	message = ConcatStrings(message, "->");
	message = ConcatStrings(message, IntToString(BIT_GetHitChance(oth, talent)));

	if (BIT_ShowStatsWhenTraining) {
		Print(message);
	};

	return result;
};

func void b_raiseattribute(var C_NPC oth, var int attrib, var int points)
{
	var int oldReal; oldReal = BIT_GetRealAttribute(oth, attrib);

	b_raiseattribute_Old(oth, attrib, points);

	if (oldReal != -1) {
		var int diff; diff = BIT_GetRealAttribute(oth, attrib) - oldReal;
		B_RaiseRealAttributeLearnCounter(oth, attrib, -diff);
	};
};

func void b_blessattribute(var C_NPC oth, var int attrib, var int points)
{
	b_raiseattribute(oth, attrib, points);
};

func void b_raisefighttalent(var C_NPC oth, var int talent, var int percent)
{
	var int oldReal; oldReal = BIT_GetRealFightTalentPercent(oth, talent);
	
	b_raisefighttalent_Old(oth, talent, percent);

	if (oldReal != -1) {
		var int diff; diff = BIT_GetRealFightTalentPercent(oth, talent) - oldReal;
		B_RaiseRealFightTalentPercent(oth, talent, -diff);
	};
};

func event GameInit()
{
	BIT_LoadConfig();
};