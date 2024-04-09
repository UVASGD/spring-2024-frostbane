extends Area3D

signal boat_repaired

func repair():
	boat_repaired.emit()
