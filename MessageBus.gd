"""
 Сервер приема/передачи сообщений для узлов, состоящих в определенных группах или всем узлам сцены
 (C) BRaven 2019, Godot Engine 3.1

 данный скрипт нужно прописать в автозагрузку проекта и для корректной работы сделать первым в списке
 для отправки сообщения нужно вызвать функцию send с обязательным первым параметром self, чтобы указать отправителя сообщения
 получатель - имя группы. Если получатель не указан, сообщение считается широковещательным
 содержание сообщения является массивом, что позволяет передавать различное количество аргументов
 по-умолчанию все сообщения передаются незамедлительно, т.е. на момент окончания функции send все получатели уже обработают сообщение
 флаги описаны в SceneTree, перечисление GroupCallFlags
 потенциальные получатели сообщения информируются через втроенную в движок систему оповещения и должны самостоятельно
 получить сообщение вызвав функцию receive с кодом сообщения в течении одного фрейма, после чего все сообщения удаляются
 полученное сообщение является словарем с ключами: отправитель, получатель, содержание и время (прошедшее с момента запуска приложения)
"""

extends Node

const INDEX_OFFSET: = 100	# берем больше 100 с запасом чтобы не перекрывать системные сообщения
var messages = []	# список сообщений

func _process(delta: float) -> void:
	messages.clear()	# в конце каждого фрейма очищаем список сообщений

# функция для отправки сообщения
func send(sender: Object, recipient: = "", content: = [], flags: int = 2) -> void:
	var data = {}
	data["Sender"] = sender
	data["Recipient"] = recipient
	data["Content"] = content
	data["Time"] = OS.get_ticks_msec()
	
	messages.append(data)
	
	var index: int = INDEX_OFFSET + messages.size()
	if recipient:
		get_tree().notify_group_flags(flags, recipient, index)
	else:
		get_tree().current_scene.propagate_notification(index)

# получение сообщения по индексу
func receive(index: int) -> Dictionary:
	return messages[index - INDEX_OFFSET - 1]

# этот код нужно поместить в принимающих узлах
# func _notification(what: int) -> void:
#	if what > MessageBus.INDEX_OFFSET:
#		var message = MessageBus.receive(what)
