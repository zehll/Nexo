extends ColorRect
class_name CPergunta
signal Resposta(resposta: int)

# ELEMENTOS DA CENA
@onready var Borda: ColorRect = $Borda
@onready var Janela: ColorRect = $Borda/Janela
@onready var Pergunta: Label = $Borda/Janela/Pergunta
@onready var Botao1: ColorRect = $Borda/Janela/Botao1
@onready var InteriorBotao1: ColorRect = $Borda/Janela/Botao1/InteriorBotao1
@onready var TextoBotao1: Label = $Borda/Janela/Botao1/InteriorBotao1/Texto1
@onready var FonteRespostas: LabelSettings = preload("res://Recursos/FonteResposta.tres")

# VARIÁVEIS
@onready var Botoes: Array = [Botao1]

# INICIAR
func iniciar(pergunta: String, respostas: Array = []) -> void:
	for item in [self,Botao1]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Pergunta.text = pergunta
	var largura_da_pergunta: float = Pergunta.label_settings.font.get_string_size(pergunta,HORIZONTAL_ALIGNMENT_CENTER,-1,Pergunta.label_settings.font_size).x
	TextoBotao1.text = respostas[0]
	var largura_da_resposta: float = FonteRespostas.font.get_string_size(respostas[0],HORIZONTAL_ALIGNMENT_CENTER,-1,FonteRespostas.font_size).x
	var largura_do_botao: float = largura_da_resposta + 20.0
	InteriorBotao1.size.x = largura_do_botao
	TextoBotao1.size.x = InteriorBotao1.size.x
	Botao1.size.x = largura_do_botao + 6.0
	var largura_dos_botoes: float = Botao1.size.x
	var contagem: int = 1
	while contagem < respostas.size():
		var novo_botao: ColorRect = ColorRect.new()
		var novo_interior_do_botao: ColorRect = ColorRect.new()
		var novo_texto_do_botao: Label = Label.new()
		Janela.add_child(novo_botao)
		novo_botao.add_child(novo_interior_do_botao)
		novo_interior_do_botao.add_child(novo_texto_do_botao)
		novo_botao.color = Color(0.2,0.2,0.2,1.0)
		novo_botao.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		novo_botao.mouse_entered.connect(Mouse.localizar.bind(novo_botao))
		novo_botao.mouse_exited.connect(Mouse.localizar.bind(Mouse))
		novo_interior_do_botao.color = Color(0.0,0.0,0.0,1.0)
		novo_interior_do_botao.mouse_filter = Control.MOUSE_FILTER_IGNORE
		novo_texto_do_botao.text = respostas[contagem]
		novo_texto_do_botao.label_settings = FonteRespostas
		novo_texto_do_botao.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		novo_texto_do_botao.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		novo_texto_do_botao.self_modulate = Color(0.4,0.4,0.4,1.0)
		largura_da_resposta = FonteRespostas.font.get_string_size(respostas[contagem],HORIZONTAL_ALIGNMENT_CENTER,-1,FonteRespostas.font_size).x
		largura_do_botao = largura_da_resposta + 20.0
		novo_botao.size = Vector2(largura_do_botao + 6.0,42.0)
		novo_botao.position = Vector2(Botoes[contagem - 1].position.x + Botoes[contagem - 1].size.x + 20.0,51.0)
		novo_interior_do_botao.size = Vector2(largura_do_botao,36.0)
		novo_interior_do_botao.position = Vector2(3.0,3.0)
		novo_texto_do_botao.size = novo_interior_do_botao.size
		largura_dos_botoes += largura_do_botao + 20.0
		Botoes.append(novo_botao)
		contagem += 1
	if largura_dos_botoes >= largura_da_pergunta:
		Pergunta.size.x = largura_dos_botoes + 40.0
		Janela.size.x = Pergunta.size.x
		Borda.size.x = Janela.size.x + 6.0
	else:
		while largura_dos_botoes < largura_da_pergunta:
			largura_dos_botoes = 0.0
			contagem = 0
			while contagem < Botoes.size():
				Botoes[contagem].size.x += 1
				Botoes[contagem].get_children()[0].size.x += 1
				Botoes[contagem].get_children()[0].get_children()[0].size.x += 1
				if contagem != 0:
					Botoes[contagem].position.x = Botoes[contagem - 1].position.x + Botoes[contagem - 1].size.x + 20.0
					largura_dos_botoes += 20.0
				largura_dos_botoes += Botoes[contagem].size.x
				contagem += 1
		Janela.size.x = largura_dos_botoes + 20.0
		Pergunta.size.x = Janela.size.x
		Borda.size.x = Janela.size.x + 6.0
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)
	get_viewport().size_changed.connect(_atualizar_tamanho)
	_atualizar_tamanho()

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if Botoes.has(botao):
		if estado == 0:
			botao.get_children()[0].color = Color(0.0,0.0,0.0,1.0)
			botao.get_children()[0].get_children()[0].self_modulate = Color(0.4,0.4,0.4,1.0)
		elif estado == 1:
			botao.get_children()[0].color = Color(0.05,0.05,0.05,1.0)
			botao.get_children()[0].get_children()[0].self_modulate = Color(0.45,0.45,0.45,1.0)
		elif estado == 2:
			botao.get_children()[0].color = Color(0.1,0.1,0.1,1.0)
			botao.get_children()[0].get_children()[0].self_modulate = Color(0.5,0.5,0.5,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	if botao == self:
		emit_signal("Resposta",-1)
	elif Botoes.has(botao):
		var contagem: int = 0
		while Botoes[contagem] != botao: contagem += 1
		emit_signal("Resposta",contagem)

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	self.size = Vector2(float(get_window().size.x),float(get_window().size.y)) - Vector2(6.0,6.0)
	Borda.position = (self.size / 2.0) - (Borda.size / 2.0)

# FECHAR
func fechar() -> void:
	Mouse.disconnect("Saiu",_atualizar_cor)
	Mouse.disconnect("Entrou",_atualizar_cor)
	Mouse.disconnect("IniciouClique",_atualizar_cor)
	Mouse.disconnect("CliqueValido",_clique)
	Mouse.localizar(Mouse)
	get_viewport().disconnect("size_changed",_atualizar_tamanho)
	Janela.remove_child(Pergunta)
	Pergunta.queue_free()
	for botao in Janela.get_children():
		var interior_do_botao: ColorRect = botao.get_children()[0]
		var texto_do_botao: Label = interior_do_botao.get_children()[0]
		interior_do_botao.remove_child(texto_do_botao)
		texto_do_botao.queue_free()
		botao.remove_child(interior_do_botao)
		interior_do_botao.queue_free()
		Janela.remove_child(botao)
		botao.queue_free()
	Borda.remove_child(Janela)
	Janela.queue_free()
	self.remove_child(Borda)
	Borda.queue_free()
	self.get_parent().remove_child(self)
	self.queue_free()
