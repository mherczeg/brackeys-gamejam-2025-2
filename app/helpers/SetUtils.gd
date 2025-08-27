class_name SetUtils
extends RefCounted
# SetUtils.gd - A collection of helper functions to treat Dictionaries as Sets.

# Returns the difference between two sets (items in set_a that are not in set_b).
static func difference(
	set_a: Dictionary[Variant, bool],
	set_b: Dictionary[Variant, bool]) -> Dictionary[Variant, bool]:
	var result: Dictionary[Variant, bool] = {}
	for item: Variant in set_a.keys():
		if set_a[item] && not set_b.has(item):
			result[item] = true
	return result

# Returns the intersection of two sets (items that are in both sets).
static func intersection(
	set_a: Dictionary[Variant, bool],
	set_b: Dictionary[Variant, bool]) -> Dictionary[Variant, bool]:
	var result: Dictionary[Variant, bool] = {}
	for item: Variant in set_a.keys():
		if set_a[item] && set_b.has(item):
			result[item] = true
	return result

# Returns the union of two sets (all unique items from both sets).
static func union(
	set_a: Dictionary[Variant, bool],
	set_b: Dictionary[Variant, bool]) -> Dictionary[Variant, bool]:
	var result: Dictionary[Variant, bool] = {}

	for item: Variant in set_a.keys():
		if set_a[item]:
			result[item] = true # Add all items from the first set

	for item: Variant in set_b.keys():
		if set_b[item]:
			result[item] = true # Add all items from the second set
	return result

static func array_to_set(array: Array[Variant]) -> Dictionary[Variant, bool]:
	var result: Dictionary[Variant, bool] = {}

	for item: Variant in array:
		result[item] = true

	return result

static func is_a_subset_of_b(
	set_a: Dictionary[Variant, bool],
	set_b: Dictionary[Variant, bool]) -> bool:
	return difference(set_a, set_b).size() == 0
