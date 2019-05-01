extends Label

func _notification(what: int) -> void:
	if what > MessageBus.INDEX_OFFSET:
		printt(OS.get_ticks_msec() / 1000.0, "Label #" + name + " получение сообщения ...")
		var message = MessageBus.receive(what)
		printt(OS.get_ticks_msec() / 1000.0, "Label #" + name + " сообщение получено")
#		if message.Content[0] == int(name):
		visible = (message.Content[0] == int(name))