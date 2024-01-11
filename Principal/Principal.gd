extends Node2D
class_name CPrincipal

# ELEMENTOS DA CENA
@onready var Exibidor: CExibidor = $Exibidor
@onready var ListaDeImagens: CListaDeImagens = $ListaDeImagens
@onready var ListaDeRotulos: CListaDeRotulos = $ListaDeRotulos
@onready var Janelas: Node2D = $Janelas
@onready var Margens: CMargens = $Margens
@onready var Botoes: CBotoes = $Botoes

# LISTAS
@onready var Arquivo: String = ""
@onready var ModoImagem: bool = true
@onready var Visualizacao: int = 0
@onready var ItemAtual: Array = []
@onready var Imagens: Array = []
@onready var Rotulos: Array = []

# INICIAR
func _ready() -> void:
	Mouse.Principal = [self]
	Botoes.iniciar()
