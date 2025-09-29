class_name PlayerEvents
extends Node

signal health_changed(new_health: int, old_health: int)
signal money_changed(new_money: float, old_money: float)
signal ingredient_stock_changed(ingredient: Ingredient)
signal product_types_available_changed
