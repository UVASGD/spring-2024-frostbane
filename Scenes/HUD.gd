extends Control

func update_inventory(amount):
	$Inventory.text = str(amount)

func toggle_collectible_UI(toggle_on):
	if toggle_on:
		$CollectibleUI.show()
	else:
		$CollectibleUI.hide()
