class_name AudioBusId
extends AudioBusReference
## Reference to an audio bus by id
##
## A (reasonably) type-safe reference to an audio bus by ID. Note that this
## provides no guarantees that the audio bus actually exists.


## The ID of the audio bus. See [AudioServer]
@export var bus_id: int


# Constructor
func _init(bus_id: int = 0): # User should always provide an id but resource loading seems to error out if you can't use the empty constructor
	self.bus_id = bus_id


# Override
func get_name() -> String:
	return AudioServer.get_bus_name(bus_id)


# Override
func get_id() -> int:
	return bus_id
