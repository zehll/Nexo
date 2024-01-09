extends Node2D
class_name CBotoes

# ELEMENTOS DA CENA
@onready var Novo: ColorRect = $Novo
@onready var IconeNovo: TextureRect = $Novo/Icone
@onready var Abrir: ColorRect = $Abrir
@onready var IconeAbrir: TextureRect = $Abrir/Icone
@onready var Salvar: ColorRect = $Salvar
@onready var IconeSalvar: TextureRect = $Salvar/Icone
@onready var Modo: ColorRect = $Modo
@onready var IconeModo: TextureRect = $Modo/Icone
@onready var Voltar: ColorRect = $Voltar
@onready var IconeVoltar: TextureRect = $Voltar/Icone
@onready var Esquerda: ColorRect = $Esquerda
@onready var IconeEsquerda: TextureRect = $Esquerda/Icone
@onready var Direita: ColorRect = $Direita
@onready var IconeDireita: TextureRect = $Direita/Icone
@onready var Sorteio: ColorRect = $Sorteio
@onready var IconeSorteio: TextureRect = $Sorteio/Icone
@onready var Adicionar: ColorRect = $Adicionar
@onready var IconeAdicionar: TextureRect = $Adicionar/Icone
@onready var VerAmbos: TextureRect = $Visualizacao/Ambos
@onready var VerMarcados: TextureRect = $Visualizacao/Marcados
@onready var VerDesmarcados: TextureRect = $Visualizacao/Desmarcados
@onready var Zoom: Label = $Zoom/Texto
@onready var Digitacao: LineEdit = $Busca/Digitacao
@onready var IconeBuscar: TextureRect = $Busca/Icone
@onready var Titulo: ColorRect = $Titulo
@onready var TextoTitulo: Label = $Titulo/Texto
@onready var TelaCheia: ColorRect = $TelaCheia
@onready var IconeTelaCheia: TextureRect = $TelaCheia/Icone
@onready var Minimizar: ColorRect = $Minimizar
@onready var IconeMinimizar: TextureRect = $Minimizar/Icone
@onready var Maximizar: ColorRect = $Maximizar
@onready var IconeMaximizar: TextureRect = $Maximizar/Icone
@onready var Sair: ColorRect = $Sair
@onready var IconeSair: TextureRect = $Sair/Icone
@onready var Pergunta: PackedScene = preload("res://Pergunta/Pergunta.tscn")

# INICIAR
func _ready() -> void:
	for item in [Novo,Abrir,Salvar,Modo,Voltar,Esquerda,Direita,Sorteio,Adicionar,TelaCheia,Minimizar,Maximizar,Sair,VerAmbos,VerMarcados,VerDesmarcados,Digitacao,IconeBuscar]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)
	get_viewport().size_changed.connect(_atualizar_tamanho)
	_atualizar_tamanho()

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	var tamanho_da_janela: Vector2 = Vector2(float(get_window().size.x),float(get_window().size.y))
	Sair.position.x = tamanho_da_janela.x - 27.0
	Maximizar.position.x = Sair.position.x - 27.0
	Minimizar.position.x = Maximizar.position.x - 27.0
	TelaCheia.position.x = Minimizar.position.x - 27.0
	Titulo.size.x = tamanho_da_janela.x - 672.0
	TextoTitulo.size.x = Titulo.size.x

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if [Novo,Abrir,Salvar,Modo,Voltar,Esquerda,Direita,Sorteio,Adicionar,TelaCheia,Minimizar,Maximizar,Sair].has(botao):
		if estado == 0:
			botao.color = Color(0.0,0.0,0.0,1.0)
			botao.get_children()[0].self_modulate = Color(0.2,0.2,0.2,1.0)
		elif estado == 1:
			botao.color = Color(0.07,0.07,0.07,1.0)
			botao.get_children()[0].self_modulate = Color(0.27,0.27,0.27,1.0)
		elif estado == 2:
			botao.color = Color(0.15,0.15,0.15,1.0)
			botao.get_children()[0].self_modulate = Color(0.36,0.35,0.35,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	if botao == Novo: pass
	elif botao == Abrir: pass
	elif botao == Salvar: pass
	elif botao == Modo: pass
	elif botao == Voltar: pass
	elif botao == Esquerda: pass
	elif botao == Direita: pass
	elif botao == Sorteio: pass
	elif botao == Adicionar: pass
	elif botao == VerAmbos: pass
	elif botao == VerMarcados: pass
	elif botao == VerDesmarcados: pass
	elif botao == IconeBuscar: pass
	elif botao == TelaCheia: _alterar_janela(2)
	elif botao == Minimizar: _alterar_janela(0)
	elif botao == Maximizar: _alterar_janela(1)
	elif botao == Sair: _sair(0,0)

# ALTERAR TAMANHO DA JANELA
func _alterar_janela(modo: int) -> void:
	if modo == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	else:
		var tamanho_da_tela: Vector2i = DisplayServer.screen_get_size()
		if modo == 1:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			if get_window().size.x == tamanho_da_tela.x:
				get_window().size = Vector2i(1152,648)
				get_window().position = Vector2i(tamanho_da_tela / 2) - Vector2i(576,324)
			else:
				get_window().size = Vector2i(tamanho_da_tela.x,roundi(0.94 * tamanho_da_tela.y))
				get_window().position = Vector2i(0,0)
		elif modo == 2:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				get_window().size = Vector2i(1152,648)
				get_window().position = Vector2i(tamanho_da_tela / 2) - Vector2i(576,324)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

# SAIR
func _sair(resposta: int, etapa: int) -> void:
	if etapa == 0:
		if self.get_parent().Janelas.get_child_count() > 0:
			self.get_parent().Janelas.get_children()[0].fechar()
		if self.get_parent().Arquivo == "":
			get_tree().quit()
		else:
			pass
	else:
		pass
