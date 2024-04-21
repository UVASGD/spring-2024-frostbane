extends Control

const PLAYER_COLLISION_LAYER = 1
const COLLECTIBLE_COLLISION_LAYER = 2
#Boat layer is 4 not 3 because: https://www.reddit.com/r/godot/comments/18n88zn/raycast3dget_colliderget_collision_layer/
const BOAT_COLLISION_LAYER = 4
const CAMPFIRE_COLLISION_LAYER = 8

func update_inventory(amount):
	$Inventory.text = str(amount)

func hide_all():
	$BoatUI.hide()
	$CollectibleUI.hide()
	$MoreWoodUI.hide()
	$CampfireUI.hide()

func toggle_interactable_UI(interactable):
	if not interactable:
		hide_all()
		return
		
	var collision_layer = interactable.get_collision_layer()
	if (collision_layer == COLLECTIBLE_COLLISION_LAYER):
		$CollectibleUI.show()
	elif (collision_layer == BOAT_COLLISION_LAYER):
		$BoatUI.show()
	elif (collision_layer == CAMPFIRE_COLLISION_LAYER):
		$CampfireUI.show()
		
func show_morewood_UI():
	hide_all()
	$MoreWoodUI.show()


