extends Control

const PLAYER_COLLISION_LAYER = 1
const COLLECTIBLE_COLLISION_LAYER = 2
#Boat layer is 4 not 3 because: https://www.reddit.com/r/godot/comments/18n88zn/raycast3dget_colliderget_collision_layer/
const BOAT_COLLISION_LAYER = 4

func update_inventory(amount):
	$Inventory.text = str(amount)

func toggle_interactable_UI(interactable):
	if not interactable:
		$BoatUI.hide()
		$CollectibleUI.hide()
		$MoreWoodUI.hide()
		return
		
	var collision_layer = interactable.get_collision_layer()
	if (collision_layer == COLLECTIBLE_COLLISION_LAYER):
		$CollectibleUI.show()
	elif (collision_layer == BOAT_COLLISION_LAYER):
		$BoatUI.show()
		
func show_morewood_UI():
	$BoatUI.hide()
	$CollectibleUI.hide()
	$MoreWoodUI.show()


