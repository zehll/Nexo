extends ColorRect
class_name CItemPasta
signal Marcado(nome: String)
signal Confirmado(a_si: Node, nome: String)

# LISTAS
enum Tipos {Pasta,Arquivo,Imagem}

# ELEMENTOS DA CENA
@onready var Icone: TextureRect = $Icone
@onready var Nome: Label = $Nome

# VARIÁVEIS
@onready var Tipo: int
@onready var Selecionado: bool = false
@onready var UltimoClique: int = 0

# INICIAR
func iniciar(nome: String, tipo: int) -> void:
	Nome.text = nome
	Tipo = tipo
	if Tipo == Tipos.Arquivo:
		Icone.texture = load("res://Icones/Novo.png")
	elif Tipo == Tipos.Imagem:
		Icone.texture = load("res://Icones/Imagem.png")
	self.mouse_entered.connect(Mouse.localizar.bind(self))
	self.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if botao == self:
		if Selecionado:
			if estado == 0:
				self.color = Color(0.15,0.15,0.15,1.0)
				Icone.self_modulate = Color(0.35,0.35,0.35,1.0)
				Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
			elif estado == 1:
				self.color = Color(0.2,0.2,0.2,1.0)
				Icone.self_modulate = Color(0.4,0.4,0.4,1.0)
				Nome.self_modulate = Color(0.6,0.6,0.6,1.0)
			elif estado == 2:
				self.color = Color(0.25,0.25,0.25,1.0)
				Icone.self_modulate = Color(0.45,0.45,0.45,1.0)
				Nome.self_modulate = Color(0.65,0.65,0.65,1.0)
		else:
			if estado == 0:
				self.color = Color(0.0,0.0,0.0,1.0)
				Icone.self_modulate = Color(0.2,0.2,0.2,1.0)
				Nome.self_modulate = Color(0.4,0.4,0.4,1.0)
			elif estado == 1:
				self.color = Color(0.05,0.05,0.05,1.0)
				Icone.self_modulate = Color(0.25,0.25,0.25,1.0)
				Nome.self_modulate = Color(0.45,0.45,0.45,1.0)
			elif estado == 2:
				self.color = Color(0.1,0.1,0.1,1.0)
				Icone.self_modulate = Color(0.3,0.3,0.3,1.0)
				Nome.self_modulate = Color(0.5,0.5,0.5,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	if not Selecionado:
		Selecionado = true
		self.color = Color(0.15,0.15,0.15,1.0)
		Icone.self_modulate = Color(0.35,0.35,0.35,1.0)
		Nome.self_modulate = Color(0.55,0.55,0.55,1.0)
		UltimoClique = Time.get_ticks_msec()
		emit_signal("Marcado",self)
	else:
		var momento_atual: int = Time.get_ticks_msec()
		if momento_atual - UltimoClique < 400:
			emit_signal("Confirmado",self,Nome.text)
		UltimoClique = momento_atual

# FECHAR
func fechar() -> void:
	for item in self.get_children():
		self.remove_child(item)
		item.queue_free()
	Mouse.localizar(Mouse)
	self.disconnect("mouse_entered",Mouse.localizar)
	self.disconnect("mouse_exited",Mouse.localizar)
	Mouse.disconnect("Saiu",_atualizar_cor)
	Mouse.disconnect("Entrou",_atualizar_cor)
	Mouse.disconnect("IniciouClique",_atualizar_cor)
	Mouse.disconnect("CliqueValido",_clique)
	self.get_parent().remove_child(self)
	self.queue_free()
