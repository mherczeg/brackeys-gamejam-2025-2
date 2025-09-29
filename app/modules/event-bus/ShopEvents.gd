class_name ShopEvents
extends Node

signal product_type_purchased(product_type: ProductType)
signal ingredient_purchased(ingredient: Ingredient, count: int)
signal repair_purchased