extends ColorRect
class_name CItemRotulo

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
@onready var Nome: Label = $Nome
@onready var Subtitulo: Label = $Subtitulo
@onready var Apagar: TextureRect = $Apagar
@onready var Editar: TextureRect = $Editar
@onready var Adicionar: TextureRect = $Adicionar
@onready var Pergunta: PackedScene = preload("res://Pergunta/Pergunta.tscn")
@onready var NovoRotulo: PackedScene = preload("res://ListaDeRotulos/NovoRotulo/NovoRotulo.tscn")

# VARIÁVEIS
@onready var Superior: String
@onready var Superiores: Array
@onready var Marcado: bool
@onready var Editando: bool = false

# INICIAR
func iniciar(rotulo: String, superiores: Array, marcado: bool = true) -> void:
	Principal = Mouse.Principal[0]
	Nome.text = rotulo
	Superiores = superiores
	if superiores == []:
		Superior = "Origem"
		Subtitulo.text = "Rótulo Original"
	else:
		Superior = superiores[0]
		Subtitulo.text = superiores[0]
		var contagem: int = 1
		while contagem < superiores.size():
			Subtitulo.text = Subtitulo.text + " > " + superiores[contagem]
			contagem += 1
	Marcado = marcado
	if Principal.ModoImagem:
		if marcado:
			Nome.self_modulate = Color(0.0,0.5,0.0,1.0)
			Subtitulo.self_modulate = Color(0.0,0.4,0.0,1.0)
			Apagar.self_modulate = Color(0.0,0.2,0.0,1.0)
			Editar.self_modulate = Color(0.0,0.2,0.0,1.0)
			Adicionar.self_modulate = Color(0.0,0.2,0.0,1.0)
		else:
			Nome.self_modulate = Color(0.5,0.0,0.0,1.0)
			Subtitulo.self_modulate = Color(0.4,0.0,0.0,1.0)
			Apagar.self_modulate = Color(0.2,0.0,0.0,1.0)
			Editar.self_modulate = Color(0.2,0.0,0.0,1.0)
			Adicionar.self_modulate = Color(0.2,0.0,0.0,1.0)
	for item in [self,Apagar,Editar,Adicionar]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)
	atualizar_tamanho()

# ATUALIZAR TAMANHO
func atualizar_tamanho() -> void:
	var largura_da_lista: float = self.get_parent().size.x
	Nome.size.x = largura_da_lista - 55.0
	Subtitulo.size.x = largura_da_lista - 27.0

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if botao == self:
		if estado == 0:
			self.color = Color(0.0,0.0,0.0,1.0)
			if not Principal.ModoImagem:
				Nome.self_modulate = Color(0.5,0.5,0.5,1.0)
				Subtitulo.self_modulate = Color(0.4,0.4,0.4,1.0)
			else:
				if Marcado:
					Nome.self_modulate = Color(0.0,0.5,0.0,1.0)
					Subtitulo.self_modulate = Color(0.0,0.4,0.0,1.0)
				else:
					Nome.self_modulate = Color(0.5,0.0,0.0,1.0)
					Subtitulo.self_modulate = Color(0.4,0.0,0.0,1.0)
		elif estado == 1:
			if not Principal.ModoImagem:
				self.color = Color(0.05,0.05,0.05,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
				Subtitulo.self_modulate = Color(0.45,0.45,0.45,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.05,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.55,0.0,1.0)
					Subtitulo.self_modulate = Color(0.0,0.45,0.0,1.0)
				else:
					self.color = Color(0.05,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.55,0.0,0.0,1.0)
					Subtitulo.self_modulate = Color(0.45,0.0,0.0,1.0)
		elif estado == 2:
			if not Principal.ModoImagem:
				self.color = Color(0.1,0.1,0.1,1.0)
				Nome.self_modulate = Color(0.6,0.6,0.6,1.0)
				Subtitulo.self_modulate = Color(0.5,0.5,0.5,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.1,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.6,0.0,1.0)
					Subtitulo.self_modulate = Color(0.0,0.5,0.0,1.0)
				else:
					self.color = Color(0.1,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.6,0.0,0.0,1.0)
					Subtitulo.self_modulate = Color(0.5,0.0,0.0,1.0)
	elif [Apagar,Editar,Adicionar].has(botao):
		if estado == 0:
			self.color = Color(0.0,0.0,0.0,1.0)
			if not Principal.ModoImagem:
				Nome.self_modulate = Color(0.5,0.5,0.5,1.0)
				Subtitulo.self_modulate = Color(0.4,0.4,0.4,1.0)
				botao.self_modulate = Color(0.2,0.2,0.2,1.0)
			else:
				if Marcado:
					Nome.self_modulate = Color(0.0,0.5,0.0,1.0)
					Subtitulo.self_modulate = Color(0.0,0.4,0.0,1.0)
					botao.self_modulate = Color(0.0,0.2,0.0,1.0)
				else:
					Nome.self_modulate = Color(0.5,0.0,0.0,1.0)
					Subtitulo.self_modulate = Color(0.4,0.0,0.0,1.0)
					botao.self_modulate = Color(0.2,0.0,0.0,1.0)
		elif estado == 1:
			if not Principal.ModoImagem:
				self.color = Color(0.05,0.05,0.05,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
				Subtitulo.self_modulate = Color(0.45,0.45,0.45,1.0)
				botao.self_modulate = Color(0.25,0.25,0.25,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.05,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.55,0.0,1.0)
					Subtitulo.self_modulate = Color(0.0,0.45,0.0,1.0)
					botao.self_modulate = Color(0.0,0.25,0.0,1.0)
				else:
					self.color = Color(0.5,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.55,0.0,0.0,1.0)
					Subtitulo.self_modulate = Color(0.45,0.0,0.0,1.0)
					botao.self_modulate = Color(0.25,0.0,0.0,1.0)
		elif estado == 2:
			if not Principal.ModoImagem:
				self.color = Color(0.05,0.05,0.05,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
				Subtitulo.self_modulate = Color(0.45,0.45,0.45,1.0)
				botao.self_modulate = Color(0.3,0.3,0.3,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.05,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.55,0.0,1.0)
					Subtitulo.self_modulate = Color(0.0,0.45,0.0,1.0)
					botao.self_modulate = Color(0.0,0.3,0.0,1.0)
				else:
					self.color = Color(0.5,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.55,0.0,0.0,1.0)
					Subtitulo.self_modulate = Color(0.45,0.0,0.0,1.0)
					botao.self_modulate = Color(0.3,0.0,0.0,1.0)

# DETECTAR CLIQUE
func _clique(botao: Node) -> void:
	if botao == self: _selecionar()
	elif botao == Apagar: _apagar(0,0)
	elif botao == Editar: _adicionar_ou_editar([],0,true)
	elif botao == Adicionar: _adicionar_ou_editar([],0)

# SELECIONAR
func _selecionar() -> void:
	if Principal.ModoImagem and Principal.ItemAtual != []:
		if Marcado:
			Principal.ItemAtual[1].erase(Nome.text)
			Marcado = false
			if Principal.ItemAtual[1] != []:
				for item in Principal.ItemAtual[1]:
					if _inferiores().has(item):
						Principal.ItemAtual[1].erase(item)
		else:
			Principal.ItemAtual[1].append(Nome.text)
			Marcado = true
			for item in Superiores:
				if not Principal.ItemAtual[1].has(item):
					Principal.ItemAtual[1].append(item)
		_atualizar_cor(self,0)
		_atualizar_cor(Apagar,0)
		_atualizar_cor(Editar,0)
		_atualizar_cor(Adicionar,0)
	else:
		Principal.ItemAtual = [Nome.text,Superior]
		Principal.Exibidor.zerar()
		for imagem in Principal.Imagens:
			if imagem[1].has(Nome.text):
				Principal.Exibidor.adicionar(imagem[0])
		Principal.Botoes.Digitacao.text = ""
		Principal.ListaDeImagens.atualizar("")
		Principal.ListaDeRotulos.atualizar("")
		Principal.Botoes.TextoTitulo.text = Principal.ItemAtual[0]

# APAGAR
func _apagar(resposta: int, etapa: int) -> void:
	if etapa == 0:
		var questionar_apagar: CPergunta = Pergunta.instantiate()
		if Principal.Janelas.get_child_count() > 0:
			Principal.Janelas.get_children()[0].fechar()
		Principal.Janelas.add_child(questionar_apagar)
		questionar_apagar.iniciar("Você tem certeza de que deseja apagar o rótulo?",["Sim","Não"])
		questionar_apagar.Resposta.connect(_apagar.bind(1))
	elif etapa == 1:
		if resposta == 0:
			var deletaveis: Array = [Nome.text]
			if not Principal.ModoImagem and (deletaveis.has(Principal.ItemAtual[0]) or deletaveis.has(Principal.ItemAtual[1])):
				Principal.ItemAtual = []
				Principal.Exibidor.zerar()
			for item in _inferiores():
				deletaveis.append(item)
			for imagem in Principal.Imagens:
				for rotulo in imagem[1]:
					if deletaveis.has(rotulo):
						imagem[1].erase(rotulo)
			for rotulo in Principal.Rotulos:
				if deletaveis.has(rotulo[0]):
					Principal.Rotulos.erase(rotulo)
			Principal.ListaDeImagens.atualizar(Principal.Botoes.Digitacao.text)
			Principal.ListaDeRotulos.atualizar(Principal.Botoes.Digitacao.text)
		Principal.Janelas.get_children()[0].fechar()

# ADICIONAR
func _adicionar_ou_editar(resposta: Array, etapa: int, editar: bool = false) -> void:
	if etapa == 0:
		if Principal.Janelas.get_child_count() > 0:
			Principal.Janelas.get_children()[0].fechar()
		var questionar_adicionar: CNovoRotulo = NovoRotulo.instantiate()
		Principal.Janelas.add_child(questionar_adicionar)
		if not editar:
			questionar_adicionar.iniciar(Nome.text)
		else:
			questionar_adicionar.iniciar(Superior,Nome.text)
			Editando = true
		questionar_adicionar.NovoRotulo.connect(_adicionar_ou_editar.bind(1))
		questionar_adicionar.Cancelamento.connect(_adicionar_ou_editar.bind(2))
	elif etapa == 1:
		if not Editando:
			Principal.Rotulos.append(resposta)
		else:
			var indice_do_rotulo: int = 0
			while Principal.Rotulos[indice_do_rotulo][0] != Nome.text: indice_do_rotulo += 1
			Principal.Rotulos[indice_do_rotulo] = resposta
		Principal.ListaDeRotulos.atualizar(Principal.Botoes.Digitacao.text)
		Principal.Janelas.get_children()[0].fechar()
		Editando = false
	elif etapa == 2:
		Principal.Janelas.get_children()[0].fechar()
		Editando = false

# REUNIR TODOS OS INFERIORES
func _inferiores():
	var todos_os_inferiores: Array = [Nome.text]
	var inferiores_imediatos: Array = [Nome.text]
	while _inferiores_imediatos(inferiores_imediatos) != null:
		for item in _inferiores_imediatos(inferiores_imediatos):
			if not todos_os_inferiores.has(item):
				todos_os_inferiores.append(item)
		inferiores_imediatos = _inferiores_imediatos(inferiores_imediatos)
	todos_os_inferiores.pop_front()
	if todos_os_inferiores == []: return null
	else: return todos_os_inferiores

# OBTER TODOS OS INFERIORES IMEDIATOS DE UM CONJUNTO DE RÓTULOS
func _inferiores_imediatos(grupo: Array):
	var resposta: Array = []
	for item in grupo:
		for rotulo in Principal.Rotulos:
			if rotulo[1] == item:
				resposta.append(rotulo[0])
	if resposta == []: return null
	else: return resposta

# FECHAR
func fechar() -> void:
	Mouse.disconnect("Saiu",_atualizar_cor)
	Mouse.disconnect("Entrou",_atualizar_cor)
	Mouse.disconnect("IniciouClique",_atualizar_cor)
	Mouse.disconnect("CliqueValido",_clique)
	for item in [Apagar,Editar,Adicionar]:
		item.disconnect("mouse_entered",Mouse.localizar)
		item.disconnect("mouse_exited",Mouse.localizar)
	Mouse.localizar(Mouse)
	for item in [Apagar,Editar,Adicionar,Nome,Subtitulo]:
		self.remove_child(item)
		item.queue_free()
	self.get_parent().remove_child(self)
	self.queue_free()
