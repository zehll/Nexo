extends ColorRect
class_name CItemImagem

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
@onready var Nome: Label = $Nome
@onready var Apagar: TextureRect = $Apagar

# VARIÁVEIS
@onready var Arquivo: String
@onready var ModoImagem: bool
@onready var Marcado: bool

# INICIAR
func iniciar(arquivo: String, modo_imagem: bool, marcado: bool = true) -> void:
	Principal = Mouse.Principal[0]
	Arquivo = arquivo
	ModoImagem = modo_imagem
	Marcado = marcado
	Nome.text = arquivo.split("/")[-1]
	if not modo_imagem:
		if marcado:
			Apagar.self_modulate = Color(0.0,0.2,0.0,1.0)
			Nome.self_modulate = Color(0.0,0.5,0.0,1.0)
		else:
			Apagar.self_modulate = Color(0.2,0.0,0.0,1.0)
			Nome.self_modulate = Color(0.5,0.0,0.0,1.0)
	for item in [self,Apagar]:
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
	Apagar.position.x = largura_da_lista - 25.0
	Nome.size.x = largura_da_lista - 35.0

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if botao == self:
		if estado == 0:
			if ModoImagem:
				self.color = Color(0.0,0.0,0.0,1.0)
				Nome.self_modulate = Color(0.5,0.5,0.5,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.5,0.0,1.0)
				else:
					self.color = Color(0.0,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.5,0.0,0.0,1.0)
		elif estado == 1:
			if ModoImagem:
				self.color = Color(0.05,0.05,0.05,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.05,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.55,0.0,1.0)
				else:
					self.color = Color(0.05,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.55,0.0,0.0,1.0)
		elif estado == 2:
			if ModoImagem:
				self.color = Color(0.1,0.1,0.1,1.0)
				Nome.self_modulate = Color(0.6,0.6,0.6,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.1,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.6,0.0,1.0)
				else:
					self.color = Color(0.1,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.6,0.0,0.0,1.0)
	elif botao == Apagar:
		if estado == 0:
			if ModoImagem:
				self.color = Color(0.0,0.0,0.0,1.0)
				Nome.self_modulate = Color(0.5,0.5,0.5,1.0)
				Apagar.self_modulate = Color(0.2,0.2,0.2,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.5,0.0,1.0)
					Apagar.self_modulate = Color(0.0,0.2,0.0,1.0)
				else:
					self.color = Color(0.0,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.5,0.0,0.0,1.0)
					Apagar.self_modulate = Color(0.2,0.0,0.0,1.0)
		elif estado == 1:
			if ModoImagem:
				self.color = Color(0.05,0.05,0.05,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
				Apagar.self_modulate = Color(0.25,0.25,0.25,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.05,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.55,0.0,1.0)
					Apagar.self_modulate = Color(0.0,0.25,0.0,1.0)
				else:
					self.color = Color(0.05,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.55,0.0,0.0,1.0)
					Apagar.self_modulate = Color(0.25,0.0,0.0,1.0)
		elif estado == 2:
			if ModoImagem:
				self.color = Color(0.05,0.05,0.05,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
				Apagar.self_modulate = Color(0.3,0.3,0.3,1.0)
			else:
				if Marcado:
					self.color = Color(0.0,0.05,0.0,1.0)
					Nome.self_modulate = Color(0.0,0.55,0.0,1.0)
					Apagar.self_modulate = Color(0.0,0.3,0.0,1.0)
				else:
					self.color = Color(0.05,0.0,0.0,1.0)
					Nome.self_modulate = Color(0.55,0.0,0.0,1.0)
					Apagar.self_modulate = Color(0.3,0.0,0.0,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	if botao == self: _selecionar()
	elif botao == Apagar: _apagar(0,0)

# SELECIONAR
func _selecionar() -> void:
	var contagem: int = 0
	var resolvido: bool = false
	while contagem < Principal.Imagens.size() and not resolvido:
		if Principal.Imagens[contagem][0] == Arquivo:
			resolvido = true
		else:
			contagem += 1
	if Principal.ModoImagem:
		Principal.Botoes.UltimosIndices.push_back(contagem)
		Principal.Exibidor.zerar()
		Principal.ItemAtual = Principal.Imagens[contagem]
		Principal.Exibidor.adicionar(Arquivo)
		Principal.Botoes.Digitacao.text = ""
		Principal.ListaDeImagens.atualizar("")
		Principal.ListaDeRotulos.atualizar("")
	else:
		if Principal.Imagens[contagem][1].has(Principal.ItemAtual[0]):
			var deletaveis: Array = [Principal.ItemAtual[0]]
			for item in _inferiores(Principal.ItemAtual[0]):
				if Principal.Imagens[contagem][1].has(item):
					Principal.Imagens[contagem][1].erase(item)
			Principal.ListaDeImagens.atualizar(Principal.Botoes.Digitacao.text)
			Principal.ListaDeRotulos.atualizar(Principal.Botoes.Digitacao.text)
		else:
			Principal.Imagens[contagem][1].append(Principal.ItemAtual[0])
			var superiores: Array = [Principal.ItemAtual[1]]
			var item_em_analise: Array = Principal.ItemAtual
			var superior_imediato: String = item_em_analise[1]
			while superior_imediato != "Origem":
				var contagem2: int = -1
				while item_em_analise[0] != superior_imediato:
					contagem2 += 1
					item_em_analise = Principal.Rotulos[contagem2]
				superior_imediato = item_em_analise[1]
				superiores.append(superior_imediato)
			superiores.pop_back()
			for item in superiores:
				Principal.Imagens[contagem][1].append(item)
			Principal.ListaDeImagens.atualizar(Principal.Botoes.Digitacao.text)
			Principal.ListaDeRotulos.atualizar(Principal.Botoes.Digitacao.text)

# REUNIR TODOS OS INFERIORES
func _inferiores(rotulo: String):
	var todos_os_inferiores: Array = [rotulo]
	var inferiores_imediatos: Array = [rotulo]
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

# APAGAR
func _apagar(resposta: int, etapa: int) -> void:
	var indice: int = 0
	while Principal.Imagens[indice][0] != Arquivo: indice += 1
	if Principal.ModoImagem and Principal.ItemAtual == Principal.Imagens[indice]:
		if Principal.Imagens.size() > 1: Principal.Botoes._mover(1)
		else:
			Principal.Exibidor.zerar()
			Principal.ItemAtual = []
	Principal.Imagens.erase(Principal.Imagens[indice])
	Principal.Botoes.Digitacao.text = ""
	Principal.ListaDeImagens.atualizar("")
	Principal.ListaDeRotulos.atualizar("")

# FECHAR
func fechar() -> void:
	Mouse.disconnect("Saiu",_atualizar_cor)
	Mouse.disconnect("Entrou",_atualizar_cor)
	Mouse.disconnect("IniciouClique",_atualizar_cor)
	Mouse.disconnect("CliqueValido",_clique)
	Apagar.disconnect("mouse_entered",Mouse.localizar)
	Apagar.disconnect("mouse_exited",Mouse.localizar)
	Mouse.localizar(Mouse)
	for item in [Nome,Apagar]:
		self.remove_child(item)
		item.queue_free()
	self.get_parent().remove_child(self)
	self.queue_free()
