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
	atualizar_tamanho()

# ATUALIZAR TAMANHO
func atualizar_tamanho() -> void:
	var largura_da_lista: float = self.get_parent().size.x
	Apagar.position.x = largura_da_lista - 25.0
	Nome.size.x = largura_da_lista - 35.0
