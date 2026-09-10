extends Node

#----------------------------

signal begin_combat
signal end_combat


#------------ UI -----------------

signal show_text_tooltip(global_p : Vector2, text : String, anchor_bottom : bool)
signal hide_all_tooltips
