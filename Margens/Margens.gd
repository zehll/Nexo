extends Node2D
class_name CMargens

# ELEMENTOS DA CENA
@onready var CantoSuperiorEsquerdo: ColorRect = $CantoSuperiorEsquerdo
@onready var FaixaSuperior: ColorRect = $FaixaSuperior
@onready var CantoSuperiorDireito: ColorRect = $CantoSuperiorDireito
@onready var FaixaEsquerda: ColorRect = $FaixaEsquerda
@onready var FaixaDireita: ColorRect = $FaixaDireita
@onready var CantoInferiorEsquerdo: ColorRect = $CantoInferiorEsquerdo
@onready var FaixaInferior: ColorRect = $FaixaInferior
@onready var CantoInferiorDireito: ColorRect = $CantoInferiorDireito
@onready var Barra: ColorRect = $Barra

# CONSTANTES
const TamanhoMinimo: Vector2i = Vector2i(300,300)

# VARIÁVEIS
@onready var Movimentacao: Vector2i = Vector2i(0,0)
@onready var PosicaoDoClique: Vector2i = Vector2i(0,0)

# INICIAR
func _ready() -> void:
	for item in self.get_children():
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Mouse.IniciouClique.connect(_detectar.bind(true))
	Mouse.CliqueValido.connect(_detectar.bind(false))
	get_viewport().size_changed.connect(_atualizar_tamanho)

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	var tamanho_da_janela: Vector2 = Vector2(float(get_window().size.x),float(get_window().size.y))
	FaixaSuperior.size.x = tamanho_da_janela.x - 6.0
	CantoSuperiorDireito.position.x = tamanho_da_janela.x - 3.0
	FaixaEsquerda.size.y = tamanho_da_janela.y - 6.0
	FaixaDireita.size.y = tamanho_da_janela.y - 6.0
	FaixaDireita.position.x = tamanho_da_janela.x - 3.0
	CantoInferiorEsquerdo.position.y = tamanho_da_janela.y - 3.0
	FaixaInferior.size.x = tamanho_da_janela.x - 6.0
	FaixaInferior.position.y = tamanho_da_janela.y - 3.0
	CantoInferiorDireito.position = Vector2(tamanho_da_janela.x - 3.0,tamanho_da_janela.y - 3.0)
	Barra.size.x = tamanho_da_janela.x - 6.0

# DETECTAR MOUSE SOBRE AS MARGENS
func _detectar(local: Node, pressionado: bool) -> void:
	if pressionado:
		if local == CantoSuperiorEsquerdo: Movimentacao = Vector2i(-1,-1)
		elif local == FaixaSuperior: Movimentacao = Vector2i(0,-1)
		elif local == CantoSuperiorDireito: Movimentacao = Vector2i(1,-1)
		elif local == FaixaEsquerda: Movimentacao = Vector2i(-1,0)
		elif local == FaixaDireita: Movimentacao = Vector2i(1,0)
		elif local == CantoInferiorEsquerdo: Movimentacao = Vector2i(-1,1)
		elif local == FaixaInferior: Movimentacao = Vector2i(0,1)
		elif local == CantoInferiorDireito: Movimentacao = Vector2i(1,1)
		elif local == Barra: Movimentacao = Vector2i(2,2)
		if Movimentacao != Vector2i(0,0): PosicaoDoClique = DisplayServer.mouse_get_position()
	else:
		Movimentacao = Vector2i(0,0)

# PROCESSO CONTÍNUO
func _physics_process(_delta: float) -> void:
	if Movimentacao != Vector2i(0,0):
		var tamanho_da_janela: Vector2i = get_window().size
		var posicao_da_janela: Vector2i = get_window().position
		var posicao_do_mouse: Vector2i = DisplayServer.mouse_get_position()
		var movimento: Vector2i = posicao_do_mouse - PosicaoDoClique
		if Movimentacao.x == -1:
			tamanho_da_janela.x -= movimento.x
			posicao_da_janela.x += movimento.x
		elif Movimentacao.x == 1:
			tamanho_da_janela.x += movimento.x
		if Movimentacao.y == -1:
			tamanho_da_janela.y -= movimento.y
			posicao_da_janela.y += movimento.y
		elif Movimentacao.y == 1:
			tamanho_da_janela.y += movimento.y
		elif Movimentacao.y == 2:
			posicao_da_janela += movimento
		if tamanho_da_janela.x >= TamanhoMinimo.x:
			get_window().size.x = tamanho_da_janela.x
			get_window().position.x = posicao_da_janela.x
			PosicaoDoClique.x = posicao_do_mouse.x
		if tamanho_da_janela.y >= TamanhoMinimo.y:
			get_window().size.y = tamanho_da_janela.y
			get_window().position.y = posicao_da_janela.y
			PosicaoDoClique.y = posicao_do_mouse.y
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Movimentacao = Vector2i(0,0)

# ALTERAR STATUS
func alterar_status(habilitar: bool) -> void:
	var status: Control.MouseFilter
	if habilitar: status = Control.MOUSE_FILTER_STOP
	else: status = Control.MOUSE_FILTER_IGNORE
	for item in self.get_children():
		item.mouse_filter = status
