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
	BUFF,
	DEBUFF,
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
