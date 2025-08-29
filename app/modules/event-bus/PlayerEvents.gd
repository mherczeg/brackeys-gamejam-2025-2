class_name PlayerEvents
extends Node

signal health_changed(new_health: int)
signal money_changed(new_money: float, old_money: float)
signal ingredient_stock_changed(ingredient: Ingredient)
signal bases_available_changed
