extends Control
class_name CExibidor

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
@onready var Origem: Marker2D = $Origem
@onready var Tabela: GridContainer = $Origem/Tabela
@onready var ItemEmExibicao: PackedScene = preload("res://Exibidor/ItemEmExibicao/ItemEmExibicao.tscn")

# INFORMAÇÕES
const Velocidade: float = 400.0
const Aceleracao: float = 0.01
const Desaceleracao: float = 0.03
const VelocidadeDoZoom: float = 3.0
const AceleracaoDoZoom: float = 0.01
const DesaceleracaoDoZoom: float = 0.04

# VARIÁVEIS
@onready var MovimentoNormalizado: Vector2 = Vector2(0.0,0.0)
@onready var ZoomNormalizado: float = 0.0
@onready var Tamanho: Vector2 = Vector2(128.0,128.0)

# INICIAR
func _ready() -> void:
	self.mouse_entered.connect(Mouse.localizar.bind(self))
	self.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	get_viewport().size_changed.connect(_atualizar_tamanho)
func iniciar() -> void:
	Principal = Mouse.Principal[0]

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	self.size = Vector2(float(get_window().size.x),float(get_window().size.y))

# PROCESSO CONTÍNUO
func _physics_process(delta: float) -> void:
	var direcao: Vector3i = Vector3i(0,0,0)
	if Mouse.LocalValido == self:
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): direcao.x -= 1
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): direcao.y -= 1
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): direcao.x += 1
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): direcao.y += 1
		if Input.is_key_pressed(KEY_Q): direcao.z -= 1
		if Input.is_key_pressed(KEY_E): direcao.z += 1
	_mover(direcao, delta)
	_zoom(direcao.z, delta)

# MOVIMENTAR ELEMENTO EM EXIBIÇÃO
func _mover(direcao: Vector3i, delta: float) -> void:
	if direcao.x == -1:
		if MovimentoNormalizado.x <= 0: MovimentoNormalizado.x = max(-1.0,MovimentoNormalizado.x - Aceleracao)
		else: MovimentoNormalizado.x = max(-1.0,MovimentoNormalizado.x - (8.0 * Aceleracao))
	elif direcao.x == 1:
		if MovimentoNormalizado.x >= 0: MovimentoNormalizado.x = min(1.0,MovimentoNormalizado.x + Aceleracao)
		else: MovimentoNormalizado.x = min(1.0,MovimentoNormalizado.x + (8.0 * Aceleracao))
	elif MovimentoNormalizado.x > 0.0: MovimentoNormalizado.x = max(0.0,MovimentoNormalizado.x - Desaceleracao)
	elif MovimentoNormalizado.x < 0.0: MovimentoNormalizado.x = min(0.0,MovimentoNormalizado.x + Desaceleracao)
	if direcao.y == -1:
		if MovimentoNormalizado.y <= 0: MovimentoNormalizado.y = max(-1.0,MovimentoNormalizado.y - Aceleracao)
		else: MovimentoNormalizado.y = max(-1.0,MovimentoNormalizado.y - (8.0 * Aceleracao))
	elif direcao.y == 1:
		if MovimentoNormalizado.y >= 0: MovimentoNormalizado.y = min(1.0,MovimentoNormalizado.y + Aceleracao)
		else: MovimentoNormalizado.y = min(1.0,MovimentoNormalizado.y + (8.0 * Aceleracao))
	elif MovimentoNormalizado.y > 0.0: MovimentoNormalizado.y = max(0.0,MovimentoNormalizado.y - Desaceleracao)
	elif MovimentoNormalizado.y < 0.0: MovimentoNormalizado.y = min(0.0,MovimentoNormalizado.y + Aceleracao)
	if MovimentoNormalizado != Vector2(0.0,0.0):
		var posicao_pretendida: Vector2 = Origem.global_position + (MovimentoNormalizado * Velocidade * delta)
		var limite_superior: bool = posicao_pretendida.y - ((Tamanho.y * Origem.scale.y) / 2.0) < self.size.y - 30.0
		var limite_inferior: bool = posicao_pretendida.y + ((Tamanho.y * Origem.scale.y) / 2.0) > 30.0
		var limite_esquerdo: bool = posicao_pretendida.x - ((Tamanho.x * Origem.scale.x) / 2.0) < self.size.x - 30.0
		var limite_direito: bool = posicao_pretendida.x + ((Tamanho.x * Origem.scale.x) / 2.0) > 30.0
		if limite_esquerdo and limite_direito: Origem.global_position.x = posicao_pretendida.x
		else: MovimentoNormalizado.x = 0.0
		if limite_superior and limite_inferior: Origem.global_position.y = posicao_pretendida.y
		else: MovimentoNormalizado.y = 0.0

# APROXIMAR E AFASTAR ELEMENTO EM EXIBIÇÃO
func _zoom(intensidade: float, delta: float) -> void:
	if intensidade == -1:
		if ZoomNormalizado <= 0.0: ZoomNormalizado = max(-1.0,ZoomNormalizado - AceleracaoDoZoom)
		else: ZoomNormalizado = max(-1.0,ZoomNormalizado - (4.0 * AceleracaoDoZoom))
	elif intensidade == 1:
		if ZoomNormalizado >= 0.0: ZoomNormalizado = min(1.0,ZoomNormalizado + AceleracaoDoZoom)
		else: ZoomNormalizado = min(1.0,ZoomNormalizado + (4.0 * AceleracaoDoZoom))
	elif ZoomNormalizado > 0.0: ZoomNormalizado = max(0.0,ZoomNormalizado - DesaceleracaoDoZoom)
	elif ZoomNormalizado < 0.0: ZoomNormalizado = min(0.0,ZoomNormalizado + DesaceleracaoDoZoom)
	if ZoomNormalizado != 0.0:
		var movimentacao: float = ZoomNormalizado * VelocidadeDoZoom * delta
		if movimentacao >= 0.0:
			Origem.scale += Vector2(movimentacao, movimentacao)
			Principal.Botoes.Zoom.text = str(roundi(Origem.scale.x * 100.0)) + "%"
		else:
			var escala_pretendida: Vector2 = Origem.scale + Vector2(movimentacao, movimentacao)
			var limite_superior: bool = Origem.global_position.y - ((Tamanho.y * escala_pretendida.y) / 2.0) < self.size.y - 30.0
			var limite_inferior: bool = Origem.global_position.y + ((Tamanho.y * escala_pretendida.y) / 2.0) > 30.0
			var limite_esquerdo: bool = Origem.global_position.x - ((Tamanho.x * escala_pretendida.x) / 2.0) < self.size.x - 30.0
			var limite_direito: bool = Origem.global_position.x + ((Tamanho.x * escala_pretendida.x) / 2.0) > 30.0
			if limite_superior and limite_inferior and limite_esquerdo and limite_direito:
				Origem.scale = Vector2(max(0.05,escala_pretendida.x),max(0.05,escala_pretendida.y))
				Principal.Botoes.Zoom.text = str(roundi(Origem.scale.x * 100.0)) + "%"
			else: ZoomNormalizado = 0.0

# ADICIONAR
func adicionar(arquivo: String, resetar: bool = false) -> void:
	if resetar:
		for item in Tabela.get_children():
			Tabela.remove_child(item)
			item.queue_free()
		Tabela.columns = 1
	else:
		for item in Tabela.get_children():
			if item.Arquivo == arquivo:
				return
	var base: Image = Image.load_from_file(arquivo)
	var textura: ImageTexture = ImageTexture.create_from_image(base)
	var tamanho_da_imagem: Vector2 = Vector2(float(base.get_size().x),float(base.get_size().y))
	var tamanho_medio: Vector2 = tamanho_da_imagem
	var quantidade_de_imagens: float = 1.0
	for item in Tabela.get_children():
		tamanho_medio += item.TamanhoOriginalDaImagem
		quantidade_de_imagens += 1.0
	tamanho_medio = tamanho_medio / quantidade_de_imagens
	var novo_item: CItemEmExibicao = ItemEmExibicao.instantiate()
	Tabela.add_child(novo_item)
	novo_item.preencher(arquivo, textura, tamanho_da_imagem)
	_reposicionar(tamanho_medio)

# REMOVER
func remover(arquivo: String) -> void:
	var tamanho_medio: Vector2 = Vector2(0.0,0.0)
	var quantidade_de_imagens: float = 0.0
	var contagem: int = 0
	var item_eliminado: Array = []
	while contagem < Tabela.get_child_count():
		var item: CItemEmExibicao = Tabela.get_children()[contagem]
		if item.Arquivo == arquivo:
			item_eliminado = [item]
		else:
			quantidade_de_imagens += 1.0
			tamanho_medio += item.TamanhoOriginalDaImagem
		contagem += 1
	tamanho_medio = tamanho_medio / quantidade_de_imagens
	if item_eliminado != []:
		Tabela.remove_child(item_eliminado[0])
		item_eliminado[0].queue_free()
		_reposicionar(tamanho_medio)

# REPOSICIONAR TABELA
func _reposicionar(tamanho_medio: Vector2) -> void:
	var numero_de_linhas: float = float(Tabela.get_child_count()) / float(Tabela.columns)
	if numero_de_linhas > float(Tabela.columns):
		Tabela.columns += 1
	for item in Tabela.get_children():
		item.reajustar(tamanho_medio)
	Tamanho.x = float(Tabela.columns) * tamanho_medio.x
	Tamanho.y = ceilf(float(Tabela.get_child_count()) / float(Tabela.columns)) * tamanho_medio.y
	Tabela.position = Vector2(0.0,0.0) - (Tamanho / 2.0)
	var escala_vertical: float = 1.0
	while Tamanho.y * escala_vertical >= 0.95 * self.size.y:
		escala_vertical -= 0.005
	var escala_horizontal: float = 1.0
	while Tamanho.x * escala_horizontal >= 0.95 * self.size.x:
		escala_horizontal -= 0.005
	var escala_final: float = min(escala_vertical,escala_horizontal)
	Origem.position = self.size / 2.0
	Origem.scale = Vector2(escala_final, escala_final)

# ZERAR
func zerar() -> void:
	for item in Tabela.get_children():
		Tabela.remove_child(item)
		item.queue_free()
	Tamanho = Vector2(100.0,100.0)
	Origem.scale = Vector2(1.0,1.0)
	Origem.position = self.size / 2.0
	Tabela.position = Vector2(-50.0,-50.0)
