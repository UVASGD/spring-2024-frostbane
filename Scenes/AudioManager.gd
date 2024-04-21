extends Node

func playSFX(sfx_name):
	if sfx_name == SFX.Hit:
		$HitSFX.play()
