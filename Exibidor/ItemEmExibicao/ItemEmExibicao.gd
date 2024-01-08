extends Control
class_name CItemEmExibicao

# ELEMENTOS DA CENA
@onready var Imagem: TextureRect = $Imagem

# INFORMAÇÕES
@onready var Arquivo: String = ""
@onready var TamanhoOriginalDaImagem: Vector2 = Vector2(0.0,0.0)

# PREENCHER
func preencher(arquivo: String, textura: Texture2D, tamanho_da_imagem: Vector2) -> void:
	Arquivo = arquivo
	Imagem.texture = textura
	TamanhoOriginalDaImagem = tamanho_da_imagem

# REAJUSTAR
func reajustar(tamanho_medio: Vector2) -> void:
	self.custom_minimum_size = tamanho_medio
	self.size = tamanho_medio
	var proporcao_da_imagem: float = TamanhoOriginalDaImagem.x / TamanhoOriginalDaImagem.y
	var tamanho_da_imagem: Vector2 = TamanhoOriginalDaImagem
	if tamanho_da_imagem.x >= tamanho_medio.x: tamanho_da_imagem = Vector2(tamanho_medio.x,tamanho_medio.x*proporcao_da_imagem)
	if tamanho_da_imagem.y >= tamanho_medio.y: tamanho_da_imagem = Vector2(tamanho_medio.y*proporcao_da_imagem,tamanho_medio.y)
	Imagem.size = tamanho_da_imagem
	Imagem.position = (self.size / 2.0) - (Imagem.size / 2.0)
