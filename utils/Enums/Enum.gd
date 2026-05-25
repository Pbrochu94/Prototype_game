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
#enum attackSource{
#	SUMMONER,
#	UNIT
#}
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
	SHOP,
	HEAL,
}
