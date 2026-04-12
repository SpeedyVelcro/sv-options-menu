class_name InputEventTextBuilder
extends Object
## Class for building human-readable strings from [InputEvent]s.
##
## This class has the [method build_text] method allowing you to convert
## [InputEvent]s to human-readable strings. In future may handle translations.
# TODO: BiDi handling for modifiers (e.g. CTRL + Z would translate to Z + CTRL) if this isn't already done by as_text()

## Translation context. See Godot docs on translations.
const TR_CONTEXT = "SVOptionsInputEvent"


## Build a human-readable string from the given [InputEvent]. In future,
## may handle translations using [TranslationServer].
static func build_text(input_event: InputEvent) -> String:
	return input_event.as_text() # TODO: does this need to be translated? Not sure if Godot already localises this
	# TODO: There may also be bindings we want to represent more concisely
