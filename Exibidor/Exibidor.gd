extends Control

# ELEMENTOS DA CENA
@onready var Origem: Marker2D = $Origem

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
		else:
			var escala_pretendida: Vector2 = Origem.scale + Vector2(movimentacao, movimentacao)
			var limite_superior: bool = Origem.global_position.y - ((Tamanho.y * escala_pretendida.y) / 2.0) < self.size.y - 30.0
			var limite_inferior: bool = Origem.global_position.y + ((Tamanho.y * escala_pretendida.y) / 2.0) > 30.0
			var limite_esquerdo: bool = Origem.global_position.x - ((Tamanho.x * escala_pretendida.x) / 2.0) < self.size.x - 30.0
			var limite_direito: bool = Origem.global_position.x + ((Tamanho.x * escala_pretendida.x) / 2.0) > 30.0
			if limite_superior and limite_inferior and limite_esquerdo and limite_direito: Origem.scale = escala_pretendida
			else: ZoomNormalizado = 0.0
