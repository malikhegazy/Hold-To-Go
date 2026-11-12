extends Button

func take_screenshot() -> void:
	# Learned from Mina Pêcheux
	hide()
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_jpg("res://screenshot.jpg")
	show()
