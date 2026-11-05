class_name ShopItem
extends Resource

enum Kind { POTION, SECONDARY, UPGRADE }

@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var kind: Kind = Kind.POTION
@export var price: int = 10
@export var loot: LootType
@export var upgrade_id: String
@export var max_level: int = 1
@export var price_step: int = 0

func current_price() -> int:
	return price + price_step * PlayerState.upgrade_level(upgrade_id)
