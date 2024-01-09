extends Node2D
class_name CListaDeRotulos

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
@onready var Margem: ColorRect = $Margem
@onready var Fundo: ColorRect = $Fundo
@onready var Lista: VBoxContainer = $Fundo/Lista
@onready var EsquerdaTres: ColorRect = $EsquerdaTres
@onready var IconeEsquerdaTres: TextureRect = $EsquerdaTres/Icone
@onready var EsquerdaDois: ColorRect = $EsquerdaDois
@onready var IconeEsquerdaDois: TextureRect = $EsquerdaDois/Icone
@onready var EsquerdaUm: ColorRect = $EsquerdaUm
@onready var IconeEsquerdaUm: TextureRect = $EsquerdaUm/Icone
@onready var DireitaUm: ColorRect = $DireitaUm
@onready var IconeDireitaUm: TextureRect = $DireitaUm/Icone
@onready var DireitaDois: ColorRect = $DireitaDois
@onready var IconeDireitaDois: TextureRect = $DireitaDois/Icone
@onready var DireitaTres: ColorRect = $DireitaTres
@onready var IconeDireitaTres: TextureRect = $DireitaTres/Icone
@onready var ItemRotulo: PackedScene = preload("res://ListaDeRotulos/ItemRotulo/ItemRotulo.tscn")

# VARIÁVEIS
@onready var PosicaoNaJanela: float = 0.7
@onready var RotulosValidos: Array = []
@onready var Paginas: int = 0

# INICIAR
func _ready() -> void:
	Principal = self.get_parent()
	for item in [Margem,EsquerdaTres,EsquerdaDois,EsquerdaUm,DireitaUm,DireitaDois,DireitaTres]:
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
	Margem.size.y = tamanho_da_janela.y - 33.0
	Margem.position.x = min(tamanho_da_janela.x - 135.0,PosicaoNaJanela * tamanho_da_janela.x)
	Fundo.size = Vector2(tamanho_da_janela.x - Margem.position.x - 6.0,tamanho_da_janela.y - 33.0)
	Fundo.position.x = Margem.position.x + 3.0
	Lista.size = Vector2(Fundo.size.x,Fundo.size.y - 33.0)
	var largura_dos_botoes: float = (Fundo.size.x - 15.0) / 6.0
	var posicao_x_dos_botoes: int = roundi(Fundo.position.x)
	for item in [EsquerdaTres,EsquerdaDois,EsquerdaUm,DireitaUm,DireitaDois,DireitaTres]:
		item.size.x = largura_dos_botoes
		item.position = Vector2(float(posicao_x_dos_botoes),tamanho_da_janela.y - 33.0)
		posicao_x_dos_botoes += roundi(largura_dos_botoes) + 3
	for item in [IconeEsquerdaTres,IconeEsquerdaDois,IconeEsquerdaUm,IconeDireitaUm,IconeDireitaDois,IconeDireitaTres]:
		item.position.x = (largura_dos_botoes / 2.0) - 10.0
	for item in Lista.get_children():
		item.atualizar_tamanho()

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if [EsquerdaTres,EsquerdaDois,EsquerdaUm,DireitaUm,DireitaDois,DireitaTres].has(botao):
		if estado == 0:
			botao.color = Color(0.0,0.0,0.0,1.0)
			botao.get_children()[0].self_modulate = Color(0.2,0.2,0.2,1.0)
		elif estado == 1:
			botao.color = Color(0.05,0.05,0.05,1.0)
			botao.get_children()[0].self_modulate = Color(0.25,0.25,0.25,1.0)
		elif estado == 2:
			botao.color = Color(0.1,0.1,0.1,1.0)
			botao.get_children()[0].self_modulate = Color(0.3,0.3,0.3,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	if botao == EsquerdaTres: pass
	elif botao == EsquerdaDois: pass
	elif botao == EsquerdaUm: pass
	elif botao == DireitaUm: pass
	elif botao == DireitaDois: pass
	elif botao == DireitaTres: pass

# PROCESSO CONTÍNUO
func _physics_process(_delta: float) -> void:
	if Mouse.Clicando and Mouse.LocalValido == Margem:
		var largura_da_janela: float = float(get_window().size.x)
		var posicao_do_mouse: float = get_viewport().get_mouse_position().x
		var porcentagem: float = posicao_do_mouse / largura_da_janela
		if posicao_do_mouse < largura_da_janela - 135.0 and porcentagem > 0.55:
			PosicaoNaJanela = porcentagem
			_atualizar_tamanho()

# ATUALIZAR
func atualizar(busca: String) -> void:
	var rotulos_validos: Array = []
	for rotulo in Principal.Rotulos:
		if busca != "":
			if rotulo[0].left(busca.length()) == busca:
				rotulos_validos.append(rotulo)
		else:
			rotulos_validos.append(rotulo)
	if Principal.ModoImagem:
		if Principal.Visualizacao == 1:
			for rotulo in rotulos_validos:
				if not Principal.ItemAtual[1].has(rotulo[0]):
					rotulos_validos.erase(rotulo)
		elif Principal.Visualizacao == 2:
			for rotulo in rotulos_validos:
				if Principal.ItemAtual[1].has(rotulo[0]):
					rotulos_validos.erase(rotulo)
	RotulosValidos = rotulos_validos
	_preencher_pagina(0)

# PREENCHER PÁGINA
func _preencher_pagina(pagina: int) -> void:
	for item in Lista.get_children():
		item.fechar()
	var itens_cabiveis: int = floori(Lista.size.y / 45.0)
	Paginas = ceili(float(RotulosValidos.size()) / float(itens_cabiveis))
	var contagem: int = 0
	var indice_atual: int = pagina * itens_cabiveis
	while contagem < min(itens_cabiveis,RotulosValidos.size()):
		var rotulo_atual: Array = RotulosValidos[indice_atual]
		var todos_os_superiores: Array = []
		var superior_atual: String = RotulosValidos[indice_atual][1]
		while superior_atual != "Origem":
			todos_os_superiores.append(superior_atual)
			for item in Principal.Rotulos:
				if item[0] == superior_atual:
					superior_atual = item[1]
		var novo_rotulo: CItemRotulo = ItemRotulo.instantiate()
		Lista.add_child(novo_rotulo)
		if Principal.ModoImagem:
			novo_rotulo.iniciar(rotulo_atual[0],todos_os_superiores,Principal.ModoImagem,Principal.ItemAtual[1].has(rotulo_atual[0]))
		else:
			novo_rotulo.iniciar(rotulo_atual[0],todos_os_superiores,Principal.ModoImagem)
		contagem += 1
