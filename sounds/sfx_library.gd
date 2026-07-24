extends Node

func play(sfx):
	for child in get_children():
		if (child.name == "Drift1" && sfx == "Drift1") || (child.name == "Drift2" && sfx == "Drift2") || (child.name == "Land" && sfx == "Land"):
			if !child.playing:
				child.play()
		elif child.name == sfx:
			child.play()
