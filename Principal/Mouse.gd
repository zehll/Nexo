extends Node

# SINAIS
signal Entrou(local: Node)
signal Saiu(local: Node)
signal IniciouClique(local: Node)
signal CliqueValido(local: Node)

# INFORMAÇÕES
var Clicando: bool = false
var LocalValido: Node = self
var LocalAtual: Node = self
var LocalUltimoClique: Vector2 = Vector2(0.0,0.0)
var MomentoUltimoClique: int = 0

# DETECTAR CLIQUES
func _input(acao: InputEvent) -> void:
	if acao is InputEventMouseButton:
		if acao.button_index == 1:
			Clicando = acao.pressed
			if Clicando:
				emit_signal("IniciouClique",LocalValido)
				LocalUltimoClique = get_viewport().get_mouse_position()
				MomentoUltimoClique = Time.get_ticks_msec()
			else:
				if LocalAtual == LocalValido:
					emit_signal("CliqueValido",LocalValido)
					emit_signal("Entrou",LocalValido)
				else:
					emit_signal("Saiu",LocalValido)
					LocalValido = LocalAtual
					emit_signal("Entrou",LocalValido)

# DETECTAR LOCALIZAÇÃO
func localizar(local: Node) -> void:
	LocalAtual = local
	if not Clicando:
		if local != LocalValido:
			emit_signal("Saiu",LocalValido)
		LocalValido = local
		emit_signal("Entrou",LocalValido)
