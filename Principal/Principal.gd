extends Node2D
class_name CPrincipal

# ELEMENTOS DA CENA
@onready var Exibidor: CExibidor = $Exibidor
@onready var ListaDeImagens: CListaDeImagens = $ListaDeImagens
@onready var ListaDeRotulos: CListaDeRotulos = $ListaDeRotulos
@onready var Margens: CMargens = $Margens
@onready var Botoes: CBotoes = $Botoes

# LISTAS
@onready var Arquivo: String = ""
@onready var ModoImagem: bool = true
@onready var Visualizacao: int = 0
@onready var ItemAtual: Array = []
@onready var Imagens: Array = []
@onready var Rotulos: Array = []

# IMAGENS = [IMAGEM1, IMAGEM2, IMAGEM3]
# ...IMAGEM = [ARQUIVO, RÓTULOS]
# ......ARQUIVO = "C:/Imagem.jpg"
# ......RÓTULOS = ["Paisagens","Florestas"]

# RÓTULOS = [RÓTULO1, RÓTULO2, RÓTULO3]
# ...RÓTULO = [NOME, SUPERIOR]
# ......NOME = "Florestas"
# ......SUPERIOR = "Paisagens"

# INICIAR
func _ready() -> void:
	Mouse.Principal = self
