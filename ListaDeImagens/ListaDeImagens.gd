extends Node2D
class_name CListaDeImagens

# ELEMENTOS DA CENA
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

# VARIÁVEIS
@onready var PosicaoNaJanela: float = 0.3
@onready var ModoImagem: bool = true

# INICIAR
func _ready() -> void:
	for item in [Margem,EsquerdaTres,EsquerdaDois,EsquerdaUm,DireitaUm,DireitaDois,DireitaTres]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	get_viewport().size_changed.connect(_atualizar_tamanho)
	_atualizar_tamanho()

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	var tamanho_da_janela: Vector2 = Vector2(float(get_window().size.x),float(get_window().size.y))
	Margem.size.y = tamanho_da_janela.y - 33.0
	Margem.position.x = max(135.0,PosicaoNaJanela * tamanho_da_janela.x)
	Fundo.size = Vector2(Margem.position.x - 3.0,tamanho_da_janela.y - 33.0)
	Lista.size = Vector2(Fundo.size.x,Fundo.size.y - 33.0)
	var largura_dos_botoes: float = (Fundo.size.x - 15.0) / 6.0
	var posicao_x_dos_botoes: int = 0
	for item in [EsquerdaTres,EsquerdaDois,EsquerdaUm,DireitaUm,DireitaDois,DireitaTres]:
		item.size.x = largura_dos_botoes
		item.position = Vector2(float(posicao_x_dos_botoes),tamanho_da_janela.y - 33.0)
		posicao_x_dos_botoes += roundi(largura_dos_botoes) + 3
	for item in [IconeEsquerdaTres,IconeEsquerdaDois,IconeEsquerdaUm,IconeDireitaUm,IconeDireitaDois,IconeDireitaTres]:
		item.position.x = (largura_dos_botoes / 2.0) - 10.0

# PROCESSO CONTÍNUO
func _physics_process(_delta: float) -> void:
	if Mouse.Clicando and Mouse.LocalValido == Margem:
		var posicao_do_mouse: float = get_viewport().get_mouse_position().x
		var porcentagem: float = posicao_do_mouse / float(get_window().size.x)
		if posicao_do_mouse > 135.0 and porcentagem < 0.45:
			PosicaoNaJanela = porcentagem
			_atualizar_tamanho()

# ATUALIZAR
func atualizar(busca: String) -> void:
	pass

# ALTERAR STATUS
func alterar_status(modo_imagem: bool) -> void:
	pass
