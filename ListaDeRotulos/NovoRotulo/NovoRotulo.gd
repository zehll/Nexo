extends ColorRect
class_name CNovoRotulo
signal NovoRotulo(informacoes: Array)
signal Cancelamento(nada: Array)

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
@onready var Bordas: ColorRect = $Bordas
@onready var Janela: ColorRect = $Bordas/Janela
@onready var TextoSuperior: Label = $Bordas/Janela/TextoSuperior
@onready var FundoDigitacao: ColorRect = $Bordas/Janela/FundoDigitacao
@onready var Digitacao: LineEdit = $Bordas/Janela/FundoDigitacao/Digitacao
@onready var FundoLista: ColorRect = $Bordas/Janela/FundoLista
@onready var BarraDeRolagem: ScrollContainer = $Bordas/Janela/FundoLista/BarraDeRolagem
@onready var Lista: VBoxContainer = $Bordas/Janela/FundoLista/BarraDeRolagem/Lista
@onready var Cancelar: ColorRect = $Bordas/Cancelar
@onready var TextoCancelar: Label = $Bordas/Cancelar/Texto
@onready var Confirmar: ColorRect = $Bordas/Confirmar
@onready var TextoConfirmar: Label = $Bordas/Confirmar/Texto
@onready var FonteLista: LabelSettings = preload("res://Recursos/FonteResposta.tres")

# VARIÁVEIS
@onready var Editar: bool = false
@onready var Grupo: String = "Sem Grupo"

# INICIAR
func iniciar(grupo: String = "", editar: bool = false) -> void:
	Principal = Mouse.Principal[0]
	if grupo != "":
		Grupo = grupo
		_criar_item(grupo,true)
		_criar_item("Sem Grupo",false)
	else:
		_criar_item("Sem Grupo",true)
	for rotulo in Principal.Rotulos:
		if rotulo[0] != grupo:
			_criar_item(rotulo[0])
	for item in [self,Cancelar,Confirmar]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Editar = editar
	Digitacao.text_changed.connect(_digitacao)
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)
	get_viewport().size_changed.connect(_atualizar_tamanho)
	_atualizar_tamanho()

# CRIAR ITEM
func _criar_item(nome: String, marcado: bool = false) -> void:
	var novo_item: ColorRect = ColorRect.new()
	var texto_do_novo_item: Label = Label.new()
	Lista.add_child(novo_item)
	novo_item.add_child(texto_do_novo_item)
	novo_item.custom_minimum_size.y = 28.0
	novo_item.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	novo_item.mouse_entered.connect(Mouse.localizar.bind(novo_item))
	novo_item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	texto_do_novo_item.text = nome
	texto_do_novo_item.label_settings = FonteLista
	texto_do_novo_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_do_novo_item.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texto_do_novo_item.clip_text = true
	texto_do_novo_item.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	if marcado:
		novo_item.color = Color(0.3,0.3,0.3,1.0)
		texto_do_novo_item.self_modulate = Color(0.55,0.55,0.55,1.0)
	else:
		novo_item.color = Color(0.15,0.15,0.15,1.0)
		texto_do_novo_item.self_modulate = Color(0.4,0.4,0.4,1.0)

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	var tamanho_da_janela: Vector2 = Vector2(float(get_window().size.x),float(get_window().size.y))
	self.size = tamanho_da_janela - Vector2(6.0,6.0)
	Bordas.size = Vector2(0.55 * tamanho_da_janela.x, 0.9 * tamanho_da_janela.y)
	Janela.size = Bordas.size - Vector2(6.0,42.0)
	TextoSuperior.size.x = Janela.size.x
	FundoDigitacao.size.x = Janela.size.x - 20.0
	Digitacao.size.x = FundoDigitacao.size.x - 18.0
	FundoLista.size = Vector2(Janela.size.x - 20.0,Janela.size.y - 99.0)
	BarraDeRolagem.size = FundoLista.size
	Lista.size = BarraDeRolagem.size - Vector2(8.0,0.0)
	for item in Lista.get_children():
		item.custom_minimum_size.x = Lista.size.x
		item.size.x = Lista.size.x
		item.get_children()[0].size = item.size
	var largura_dos_botoes: float = (Bordas.size.x - 9.0) / 2.0
	Cancelar.size.x = largura_dos_botoes
	Cancelar.position.y = Bordas.size.y - 36.0
	TextoCancelar.size.x = largura_dos_botoes
	Confirmar.size.x = largura_dos_botoes
	Confirmar.position = Vector2(largura_dos_botoes + 6.0,Bordas.size.y - 36.0)
	TextoConfirmar.size.x = largura_dos_botoes

# DETECTAR DIGITAÇÃO
func _digitacao(texto: String) -> void:
	if texto != "":
		var liberado: bool = true
		for rotulo in Principal.Rotulos:
			if texto == rotulo[0] and Grupo == rotulo[1]:
				liberado = false
		if liberado:
			Confirmar.mouse_filter = Control.MOUSE_FILTER_STOP
			Confirmar.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		Confirmar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		Confirmar.mouse_default_cursor_shape = Control.CURSOR_ARROW

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if [Cancelar,Confirmar].has(botao):
		if estado == 0:
			botao.color = Color(0.0,0.0,0.0,1.0)
			botao.get_children()[0].self_modulate = Color(0.4,0.4,0.4,1.0)
		elif estado == 1:
			botao.color = Color(0.05,0.05,0.05,1.0)
			botao.get_children()[0].self_modulate = Color(0.45,0.45,0.45,1.0)
		elif estado == 2:
			botao.color = Color(0.1,0.1,0.1,1.0)
			botao.get_children()[0].self_modulate = Color(0.5,0.5,0.5,1.0)
	elif Lista.get_children().has(botao):
		if Grupo != botao.get_children()[0].text:
			if estado == 0:
				botao.color = Color(0.15,0.15,0.15,1.0)
				botao.get_children()[0].self_modulate = Color(0.4,0.4,0.4,1.0)
			elif estado == 1:
				botao.color = Color(0.2,0.2,0.2,1.0)
				botao.get_children()[0].self_modulate = Color(0.45,0.45,0.45,1.0)
			elif estado == 2:
				botao.color = Color(0.25,0.25,0.25,1.0)
				botao.get_children()[0].self_modulate = Color(0.5,0.5,0.5,1.0)

# CLIQUE
func _clique(botao: Node) -> void:
	if botao == Confirmar:
		if Grupo == "Sem Grupo":
			Grupo = "Origem"
		if Editar:
			emit_signal("NovoRotulo",[Digitacao.text,Grupo,0])
		else:
			emit_signal("NovoRotulo",[Digitacao.text,Grupo])
	elif [self,Cancelar].has(botao):
		emit_signal("Cancelamento",[])
	elif Lista.get_children().has(botao):
		var texto: String = botao.get_children()[0].text
		if texto != Grupo:
			var antigo_grupo: String = Grupo
			Grupo = texto
			for item in Lista.get_children():
				if item.get_children()[0].text == antigo_grupo:
					_atualizar_cor(item,0)
			_atualizar_cor(botao,0)

# FECHAR
func fechar() -> void:
	get_viewport().disconnect("size_changed",_atualizar_tamanho)
	Mouse.disconnect("Saiu",_atualizar_cor)
	Mouse.disconnect("Entrou",_atualizar_cor)
	Mouse.disconnect("IniciouClique",_atualizar_cor)
	Mouse.disconnect("CliqueValido",_clique)
	Mouse.localizar(Mouse)
	for item in Lista.get_children():
		var texto: Label = item.get_children()[0]
		item.remove_child(texto)
		texto.queue_free()
		item.disconnect("mouse_entered",Mouse.localizar)
		item.disconnect("mouse_exited",Mouse.localizar)
		Lista.remove_child(item)
		item.queue_free()
	Digitacao.disconnect("text_changed",_digitacao)
	for item in [TextoConfirmar,TextoCancelar,Lista,Digitacao,TextoSuperior]:
		item.get_parent().remove_child(item)
		item.queue_free()
	for item in [Cancelar,Confirmar]:
		item.disconnect("mouse_entered",Mouse.localizar)
		item.disconnect("mouse_exited",Mouse.localizar)
		Bordas.remove_child(item)
		item.queue_free()
	for item in [BarraDeRolagem,FundoDigitacao]:
		item.get_parent().remove_child(item)
		item.queue_free()
	Janela.remove_child(FundoLista)
	FundoLista.queue_free()
	Bordas.remove_child(Janela)
	Janela.queue_free()
	self.remove_child(Bordas)
	Bordas.queue_free()
	self.disconnect("mouse_entered",Mouse.localizar)
	self.disconnect("mouse_exited",Mouse.localizar)
	self.get_parent().remove_child(self)
	self.queue_free()
