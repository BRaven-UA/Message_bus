extends Control

var number: int

func _on_Button_pressed() -> void:
	number = int($TextEdit.text)
	printt(OS.get_ticks_msec() / 1000.0, "отправка сообщения ...")
	MessageBus.send(self, "", [number]) # отправка всем
#	MessageBus.send(self, "Labels", [number])	# отправка только определенной группе
	printt(OS.get_ticks_msec() / 1000.0, "сообщение отправлено")