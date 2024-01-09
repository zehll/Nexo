extends ColorRect
class_name CItemRotulo

# ELEMENTOS DA CENA
@onready var Nome: Label = $Nome
@onready var Subtitulo: Label = $Subtitulo
@onready var Apagar: TextureRect = $Apagar
@onready var Editar: TextureRect = $Editar
@onready var Adicionar: TextureRect = $Adicionar

# VARIÁVEIS
@onready var ModoImagem: bool
@onready var Marcado: bool

# INICIAR
func iniciar(rotulo: String, superiores: Array, modo_imagem: bool, marcado: bool = true) -> void:
	Nome.text = rotulo
	if superiores == []:
		Subtitulo.text = "Rótulo Original"
	else:
		Subtitulo.text = superiores[0]
		var contagem: int = 1
		while contagem < superiores.size():
			Subtitulo.text = Subtitulo.text + " > " + superiores[contagem]
			contagem += 1
	ModoImagem = modo_imagem
	Marcado = marcado
	if modo_imagem:
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
			if not ModoImagem:
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
			if not ModoImagem:
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
			if not ModoImagem:
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
			if not ModoImagem:
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
			if not ModoImagem:
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
			if not ModoImagem:
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
	if botao == self: pass
	elif botao == Apagar: pass
	elif botao == Editar: pass
	elif botao == Adicionar: pass

# FECHAR
func fechar() -> void:
	get_viewport().disconnect("size_changed",atualizar_tamanho)
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
