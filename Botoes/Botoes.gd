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

# INICIAR
func _ready() -> void:
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
