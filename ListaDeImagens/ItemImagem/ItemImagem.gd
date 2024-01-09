extends ColorRect
class_name CItemImagem

# ELEMENTOS DA CENA
@onready var Nome: Label = $Nome
@onready var Apagar: TextureRect = $Apagar

# VARIÁVEIS
@onready var Arquivo: String
@onready var ModoImagem: bool
@onready var Marcado: bool

# INICIAR
func iniciar(arquivo: String, modo_imagem: bool, marcado: bool = true) -> void:
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
	if botao == self:
		pass
	elif botao == Apagar:
		pass

# FECHAR
func fechar() -> void:
	get_viewport().disconnect("size_changed",atualizar_tamanho)
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
