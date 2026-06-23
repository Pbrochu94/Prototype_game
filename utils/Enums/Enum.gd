extends Node

enum Faction{
	PLAYER,
	ENEMY
}
enum AbilityType {
	ATTACK,
	HEAL,
	EFFECT
}
enum StatusEffect {
	NONE,
	INVULNERABLE,
	STAT_MODIFIER,
	HEAL,
	RETALIATION,
	POISON,
	BURN,
	FREEZE
}
enum FocusType {
	SELF,
	ENEMY_SINGLE,
	ENEMY_MULTIPLE,
	ALLY_SINGLE,
	ALLY_MULTIPLE,
	ENEMY_AOE,
	ALLY_AOE
}
enum SpellType{
	ATTACK,
	EFFECT
}
enum targetPartySelection{
	ALLY,
	ENEMY,
	ALL
}
enum Caster{
	SUMMONER,
	UNIT
}
enum SummonerSpellStartingPoint {
	SUMMONER,
	UNIT
}
enum EncounterType{
	COMBAT,
	ELITE,
	MINI_BOSS,
	BOSS,
	SPELL,
	SHOP,
	HEAL,
}
enum UnitRank{
	BASE,
	ELITE,
	MINI_BOSS,
	BOSS
}
enum UnitLocation{
	INTRO,
	FIRST_WORLD,
}
enum Element{
	WHITE,
	RED,
}
enum RewardType{
	LIGHT_SHARD,
	ITEM,
	SUMMON,
	SPELL
}
enum CurrencyType{
	LIGHT_SHARD
}
