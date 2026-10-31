extends Node
@warning_ignore_start("unused_signal")
#----------------------------

signal begin_combat
signal end_combat


#------------ UI -----------------
signal item_slot_hovered(slot : ItemSlot, on : bool)
signal item_slot_gui_input(slot : ItemSlot, event : InputEvent)
