class_name OptionOptionButton
extends OptionButton
## [OptionButton] linked to an option in SV Options.
##
## This `OptionButton` will update itself to reflect a configured option, and
## modify that option when changed by the user.
##
## Note that changing the selection only modifies the option if it is done in
## a way that emits the [signal item_selected] signal.

## Possible parts of an item to use as the option value.
enum ValueStore {
	## Use the item ID as the value
	ID,
	## Use the item index as the value
	INDEX,
	## Use the item metadata as the value
	METADATA,
	## Use the item text as the value
	TEXT
}

## Path of option to link to. See [GameOptions].
@export var option_path := "":
	set(value):
		option_path = value
		if _accessor != null:
			_accessor.option_path = value
	get:
		return option_path

## Set to `true` if the option specified by [member option_path] is found on
## cloud options instead of local options.
@export var cloud := false:
	set(value):
		cloud = value
		if _accessor != null:
			_accessor.cloud = value
	get:
		return cloud

## Determines which part of an item is considered to store its value. The option
## will be synced with this value. Usually you want either id or metadata.
##
## Do not modify this after ready as it will cause undefined behaviour.
@export var value_store: ValueStore = ValueStore.ID

var _accessor: OptionAccessor


# Override
func _ready() -> void:
	_accessor = OptionAccessor.new()
	add_child(_accessor)
	
	_accessor.option_path = option_path
	_accessor.cloud = cloud
	
	_accessor.option_modified.connect(_on_accessor_option_modified)
	item_selected.connect(_on_item_selected)
	
	var starting_value := _accessor.get_option()
	_select_item_by_value(starting_value)


# Override
func _exit_tree() -> void:
	if _accessor.option_modified.is_connected(_on_accessor_option_modified):
		_accessor.option_modified.disconnect(_on_accessor_option_modified)
	
	if item_selected.is_connected(_on_item_selected):
		item_selected.disconnect(_on_item_selected)


func _select_item_by_value(value: Variant):
	match value_store:
		ValueStore.ID:
			if (value is int) or (value is float):
				select(get_item_index(value))
			else:
				push_error("Cannot set OptionOptionButton selection because linked option was not a float or int.")
				select(-1)
		ValueStore.INDEX:
			if (value is int) or (value is float):
				select(value)
			else:
				push_error("Cannot set OptionOptionButton selection because linked option was not a float or int.")
				select(-1)
		ValueStore.METADATA:
			var found := false
			for i in range(item_count):
				var metadata := get_item_metadata(i)
				if metadata == value:
					select(i)
					found = true
					break
			if not found:
				push_error("Cannot set OptionOptionButton selection because linked option's value was not found among item metadata.")
				select(-1)
		ValueStore.TEXT:
			var found := false
			for i in range(item_count):
				var text := get_item_text(i)
				if text == value:
					select(i)
					found = true
					break
			if not found:
				push_error("Cannot set OptionOptionButton selection because linked option's value was not found among item text.")
				select(-1)
		_:
			push_error("Invalid value_store value")


# Signal connection
func _on_accessor_option_modified(new_value: Variant) -> void:
	if new_value is bool:
		_select_item_by_value(new_value)
	else:
		push_error("Cannot set OptionOptionButton selection because linked option was wrong type.")


# Signal connection
func _on_item_selected(index: int) -> void:
	match value_store:
		ValueStore.ID:
			_accessor.set_option(get_item_id(index))
		ValueStore.INDEX:
			_accessor.set_option(index)
		ValueStore.METADATA:
			_accessor.set_option(get_item_metadata(index))
		ValueStore.TEXT:
			_accessor.set_option(get_item_text(index))
		_:
			push_error("Invalid value_store value. Cannot set option value.")
