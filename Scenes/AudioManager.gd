extends Node

func playSFX(sfx_name):
	if sfx_name == SFX.Hit:
		$HitSFX.play()
	if sfx_name == SFX.Growl:
		if(not $GrowlSFX.playing):
			$GrowlSFX.play()
