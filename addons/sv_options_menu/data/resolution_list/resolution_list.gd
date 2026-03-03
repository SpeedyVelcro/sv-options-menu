class_name ResolutionList
extends Object
## A list of display resolutions. Unlike a simple [Array] of [Vector2i], this
## list is always ordered by x and then y, provided that you do not modify its
## private [member _resolutions] variable.

## Internal list of resolutions. Do not modify this externally, or you will
## compromise its ordered nature.
var _resolutions: Array[Vector2i] = []

## Custom sorting function for use by [method Array.sort_custom]. Sorts by
## resolution's x dimension, then by its y dimension.
static var _sort_resolutions := func (a: Vector2i, b: Vector2i) -> bool:
	return (a.x < b.x) or ((a.x == b.x) and (a.y <= b.y))

## Constructor. Override of [method Object._init]. Creates a resolution list
## based on the provided [param resolutions]. The [param resolutions] argument
## does not currently use spread syntax because, at the time of writing, spread
## syntax does not support type safety in GDScript.
func _init(resolutions: Array[Vector2i] = []) -> void:
	_resolutions.append_array(resolutions)
	_resolutions.sort_custom(_sort_resolutions)
	
	# This would be easier with sets (we could then just cast to a set)
	for i in range(_resolutions.size() - 2, -1, -1):
		if _resolutions[i] == _resolutions[i + 1]:
			_resolutions.remove_at(i)

## Get all the resolutions in this list as an array of vectors.
func get_resolutions() -> Array[Vector2i]:
	return _resolutions.duplicate_deep()


## Returns true if the given resolution is in this list.
func has_resolution(resolution: Vector2i) -> bool:
	return _resolutions.has(resolution)


## Returns the number of resolutions in the list.
func size() -> int:
	return _resolutions.size()


## Combines this list with the given list, returning a new resolution list
## containing all resolutions from both in order and without duplicates.
func combine_with(other: ResolutionList) -> ResolutionList:
	return ResolutionList.combine([self, other])


## Combines the given resolution lists, returning a new resolution lists
## containing all resolutions in order without duplicates. The
## [parameter resolution_lists] argument does not use spread syntax because
## spread syntax in GDScript does not, at the time of writing, support type
## safety.
static func combine(resolution_lists: Array[ResolutionList]) -> ResolutionList:
	assert(resolution_lists.all(func (x): return x is ResolutionList), "ResolutionList.combine() args are wrong type. They must be ResolutionList")
	
	var acc := ResolutionList.new()
	
	for resolution_list in resolution_lists:
		acc = _combine_two(acc, resolution_list)
	
	return acc


static func _combine_two(resolution_list_a: ResolutionList, resolution_list_b: ResolutionList) -> ResolutionList:
	var a = resolution_list_a.get_resolutions()
	var b = resolution_list_b.get_resolutions()
	var i := 0
	var j := 0
	var acc: Array[Vector2i] = []
	
	while (i < a.size()) or (j < b.size()):
		var pick_a: bool
		if j >= b.size():
			pick_a = true
		elif i >= a.size():
			pick_a = false
		else:
			pick_a = _sort_resolutions.call(a[i], b[j])
		
		if pick_a:
			if acc.is_empty() or (a[i] != acc.back()):
				acc.push_back(a[i])
			i += 1
			continue
		else:
			if acc.is_empty() or (b[j] != acc.back()):
				acc.push_back(b[j])
			j += 1
			continue
	
	return ResolutionList.new(acc)
