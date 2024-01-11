extends ColorRect
class_name CPastas
signal Cancelar(nada: String)
signal Abrir(arquivo: String)
signal Salvar(arquivo: String)
signal NovaImagem(arquivo: String)

# LISTAS
enum Atividades {Abrir,Salvar,NovaImagem}

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
@onready var Bordas: ColorRect = $Bordas
@onready var Voltar: ColorRect = $Bordas/Voltar
@onready var IconeVoltar: TextureRect = $Bordas/Voltar/Icone
@onready var FaixaSuperior: ColorRect = $Bordas/FaixaSuperior
@onready var TextoFaixaSuperior: Label = $Bordas/FaixaSuperior/Texto
@onready var Janela: ColorRect = $Bordas/Janela
@onready var BarraDeRolagem: ScrollContainer = $Bordas/Janela/BarraDeRolagem
@onready var Grade: GridContainer = $Bordas/Janela/BarraDeRolagem/Grade
@onready var FaixaInferior: ColorRect = $Bordas/FaixaInferior
@onready var Digitacao: LineEdit = $Bordas/FaixaInferior/Digitacao
@onready var Botao1: ColorRect = $Bordas/Botao1
@onready var TextoBotao1: Label = $Bordas/Botao1/Texto
@onready var Botao2: ColorRect = $Bordas/Botao2
@onready var TextoBotao2: Label = $Bordas/Botao2/Texto
@onready var ItemPasta: PackedScene = preload("res://Pastas/ItemPasta/ItemPasta.tscn")

# VARIÁVEIS
@onready var Atividade: int
@onready var Botao2Ativo: bool
@onready var PastaAtual: String = "C:/"

# INICIAR
func iniciar(atividade: int) -> void:
	Principal = Mouse.Principal[0]
	Atividade = atividade
	Digitacao.text_changed.connect(_detectar_digitacao)
	var pasta_inicial: String = "C:/"
	if Atividade == Atividades.Abrir:
		TextoFaixaSuperior.text = "Abrir Projeto"
		TextoBotao1.text = "Cancelar"
		TextoBotao2.text = "Abrir"
	elif Atividade == Atividades.Salvar:
		TextoFaixaSuperior.text = "Salvar Projeto"
		TextoBotao1.text = "Cancelar"
		TextoBotao2.text = "Salvar"
	elif Atividade == Atividades.NovaImagem:
		TextoFaixaSuperior.text = "Adicionar Imagem/Pasta"
		TextoBotao1.text = "Cancelar"
		TextoBotao2.text = "Adicionar"
	if Principal.Arquivo != "":
		var pasta_decomposta: PackedStringArray = Principal.Arquivo.split("/")
		var arquivo: String = pasta_decomposta[-1]
		pasta_decomposta.remove_at(pasta_decomposta.size() - 1)
		pasta_inicial = "/".join(pasta_decomposta) + "/"
		if Atividade != Atividades.NovaImagem:
			Digitacao.text = arquivo
			_botao_dois(true)
	PastaAtual = pasta_inicial
	_atualizar_tamanho()
	_carregar(pasta_inicial)
	for item in [self,Voltar,Botao1,Botao2]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)
	get_viewport().size_changed.connect(_atualizar_tamanho)

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	var tamanho_da_janela: Vector2 = Vector2(float(get_window().size.x),float(get_window().size.y))
	self.size = tamanho_da_janela - Vector2(6.0,6.0)
	Bordas.size = Vector2(0.6 * tamanho_da_janela.x,0.9 * tamanho_da_janela.y)
	Bordas.position = Vector2(0.2 * tamanho_da_janela.x,0.05 * tamanho_da_janela.y)
	FaixaSuperior.size.x = Bordas.size.x - 34.0
	TextoFaixaSuperior.size.x = FaixaSuperior.size.x
	Janela.size = Vector2(Bordas.size.x - 6.0,Bordas.size.y - 95.0)
	BarraDeRolagem.size = Janela.size
	Grade.columns = floori((Janela.size.x - 8.0) / 80.0)
	Grade.size = Vector2(Janela.size.x - 8.0,Janela.size.y)
	FaixaInferior.size.x = Bordas.size.x - 6.0
	FaixaInferior.position.y = Bordas.size.y - 61.0
	Digitacao.size.x = FaixaInferior.size.x - 8.0
	var largura_dos_botoes: float = (Bordas.size.x - 9.0) / 2.0
	Botao1.size.x = largura_dos_botoes
	Botao1.position.y = Bordas.size.y - 33.0
	TextoBotao1.size.x = largura_dos_botoes
	Botao2.size.x = largura_dos_botoes
	Botao2.position = Vector2(largura_dos_botoes + 6.0,Bordas.size.y - 33.0)
	TextoBotao2.size.x = largura_dos_botoes

# ALTERAR ESTADO DO BOTÃO
func _botao_dois(ativo: bool) -> void:
	Botao2Ativo = ativo
	if ativo:
		Botao2.mouse_filter = Control.MOUSE_FILTER_STOP
		Botao2.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		TextoBotao2.self_modulate = Color(0.4,0.4,0.4,1.0)
	else:
		Botao2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		Botao2.mouse_default_cursor_shape = Control.CURSOR_ARROW
		TextoBotao2.self_modulate = Color(0.2,0.2,0.2,1.0)

# CARREGAR PASTA
func _carregar(pasta: String) -> void:
	Digitacao.text = ""
	PastaAtual = pasta
	for item in Grade.get_children():
		item.disconnect("Marcado",_detectar_selecao)
		item.disconnect("Confirmado",_detectar_escolha)
		item.fechar()
	var leitor: DirAccess = DirAccess.open(pasta)
	leitor.list_dir_begin()
	var proximo_item: String = leitor.get_next()
	while proximo_item != "":
		if leitor.current_is_dir():
			var novo_item: CItemPasta = ItemPasta.instantiate()
			Grade.add_child(novo_item)
			novo_item.iniciar(proximo_item, CItemPasta.Tipos.Pasta)
			novo_item.Marcado.connect(_detectar_selecao)
			novo_item.Confirmado.connect(_detectar_escolha)
		else:
			if [Atividades.Abrir,Atividades.Salvar].has(Atividade) and proximo_item.right(5) == ".tres":
				var novo_item: CItemPasta = ItemPasta.instantiate()
				Grade.add_child(novo_item)
				novo_item.iniciar(proximo_item, CItemPasta.Tipos.Arquivo)
				novo_item.Marcado.connect(_detectar_selecao)
				novo_item.Confirmado.connect(_detectar_escolha)
			elif Atividade == Atividades.NovaImagem and [".jpg",".png"].has(proximo_item.right(4)) or proximo_item.right(5) == ".jpeg":
				var novo_item: CItemPasta = ItemPasta.instantiate()
				Grade.add_child(novo_item)
				novo_item.iniciar(proximo_item, CItemPasta.Tipos.Arquivo)
				novo_item.Marcado.connect(_detectar_selecao)
				novo_item.Confirmado.connect(_detectar_escolha)
		proximo_item = leitor.get_next()

# DETECTAR SELEÇÃO
func _detectar_selecao(nome: String) -> void:
	Digitacao.text = nome
	_detectar_digitacao(nome)

# DETECTAR ESCOLHA
func _detectar_escolha(botao: CItemPasta, nome: String) -> void:
	if botao.Tipo == CItemPasta.Tipos.Pasta:
		_carregar(PastaAtual + nome + "/")
	elif botao.Tipo == CItemPasta.Tipos.Arquivo:
		if Atividade == Atividades.Abrir:
			emit_signal("Abrir",PastaAtual + nome)
		elif Atividade == Atividades.Salvar:
			emit_signal("Salvar",PastaAtual + nome)
	elif botao.Tipo == CItemPasta.Tipos.Imagem:
		emit_signal("NovaImagem",false,PastaAtual + nome)

# DETECTAR DIGITAÇÃO
func _detectar_digitacao(texto: String) -> void:
	if texto == "":
		_botao_dois(false)
	else:
		for item in Grade.get_children():
			if item.Nome.text != texto:
				item.Selecionado = false
				item.atualizar_cor(item,0)
		var eh_pasta_com_imagens: bool = false
		var eh_arquivo: bool = false
		var eh_imagem: bool = false
		var leitor: DirAccess = DirAccess.open(PastaAtual)
		leitor.list_dir_begin()
		var proximo_item: String = leitor.get_next()
		while proximo_item != "":
			if proximo_item == texto:
				if leitor.current_is_dir():
					var segundo_leitor: DirAccess = DirAccess.open(PastaAtual + "/" + proximo_item)
					segundo_leitor.list_dir_begin()
					var proximo_item_do_segundo_leitor: String = segundo_leitor.get_next()
					while proximo_item_do_segundo_leitor != "":
						if [".jpg",".png"].has(proximo_item_do_segundo_leitor.right(4)) or proximo_item_do_segundo_leitor.right(5) == ".jpeg":
							eh_pasta_com_imagens = true
						proximo_item_do_segundo_leitor = segundo_leitor.get_next()
				else:
					if proximo_item.right(5) == ".tres":
						eh_arquivo = true
					elif [".jpg",".png"].has(proximo_item.right(4)) or proximo_item.right(5) == ".jpeg":
						eh_imagem = true
			proximo_item = leitor.get_next()
		if Atividade == Atividades.Abrir:
			_botao_dois(eh_arquivo)
		elif Atividade == Atividades.Salvar:
			_botao_dois(texto.count(".") == 0 or eh_arquivo or texto.right(5) == ".tres")
		else:
			_botao_dois(eh_imagem or eh_pasta_com_imagens)

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if botao == Voltar:
		if estado == 0:
			Voltar.color = Color(0.0,0.0,0.0,1.0)
			IconeVoltar.self_modulate = Color(0.2,0.2,0.2,1.0)
		elif estado == 1:
			Voltar.color = Color(0.05,0.05,0.05,1.0)
			IconeVoltar.self_modulate = Color(0.25,0.25,0.25,1.0)
		elif estado == 2:
			Voltar.color = Color(0.1,0.1,0.1,1.0)
			IconeVoltar.self_modulate = Color(0.3,0.3,0.3,1.0)
	elif botao == Botao1:
		if estado == 0:
			Botao1.color = Color(0.0,0.0,0.0,1.0)
			TextoBotao1.self_modulate = Color(0.4,0.4,0.4,1.0)
		elif estado == 1:
			Botao1.color = Color(0.05,0.05,0.05,1.0)
			TextoBotao1.self_modulate = Color(0.45,0.45,0.45,1.0)
		elif estado == 2:
			Botao1.color = Color(0.1,0.1,0.1,1.0)
			TextoBotao1.self_modulate = Color(0.5,0.5,0.5,1.0)
	elif botao == Botao2:
		if estado == 0:
			Botao2.color = Color(0.0,0.0,0.0,1.0)
			TextoBotao2.self_modulate = Color(0.4,0.4,0.4,1.0)
		elif estado == 1:
			Botao2.color = Color(0.05,0.05,0.05,1.0)
			TextoBotao2.self_modulate = Color(0.45,0.45,0.45,1.0)
		elif estado == 2:
			Botao2.color = Color(0.1,0.1,0.1,1.0)
			TextoBotao2.self_modulate = Color(0.5,0.5,0.5,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	if [self,Botao1].has(botao): emit_signal("Cancelar","")
	elif botao == Voltar: _voltar()
	elif botao == Botao2: _confirmar()

# VOLTAR
func _voltar() -> void:
	if PastaAtual.count("/") != 1:
		var pasta_desmembrada: PackedStringArray = PastaAtual.left(-1).split("/")
		pasta_desmembrada.remove_at(pasta_desmembrada.size() - 1)
		_carregar("/".join(pasta_desmembrada) + "/")

# CONFIRMAR
func _confirmar() -> void:
	var texto: String = Digitacao.text
	if Atividade == Atividades.Abrir: emit_signal("Abrir",PastaAtual + texto)
	elif Atividade == Atividades.Salvar: emit_signal("Salvar",PastaAtual + texto)
	elif Atividade == Atividades.NovaImagem:
		if texto.right(5) == ".jpeg" or [".png",".jpg"].has(texto.right(4)): emit_signal("NovaImagem",PastaAtual + "/" + texto)
		else: emit_signal("NovaImagem",PastaAtual + texto + "/")

# FECHAR
func fechar() -> void:
	for item in Grade.get_children():
		item.disconnect("Marcado",_detectar_selecao)
		item.disconnect("Confirmado",_detectar_escolha)
		item.fechar()
	for item in [self,Voltar,Botao1,Botao2]:
		item.disconnect("mouse_entered",Mouse.localizar)
		item.disconnect("mouse_exited",Mouse.localizar)
	Mouse.localizar(Mouse)
	Mouse.disconnect("Saiu",_atualizar_cor)
	Mouse.disconnect("Entrou",_atualizar_cor)
	Mouse.disconnect("IniciouClique",_atualizar_cor)
	Mouse.disconnect("CliqueValido",_clique)
	get_viewport().disconnect("size_changed",_atualizar_tamanho)
	Digitacao.disconnect("text_changed",_detectar_digitacao)
	for item in [TextoBotao2,TextoBotao1,Digitacao,Grade,TextoFaixaSuperior,IconeVoltar]:
		item.get_parent().remove_child(item)
		item.queue_free()
	Janela.remove_child(BarraDeRolagem)
	BarraDeRolagem.queue_free()
	for item in [Voltar,FaixaSuperior,Janela,FaixaInferior,Botao1,Botao2]:
		Bordas.remove_child(item)
		item.queue_free()
	self.remove_child(Bordas)
	Bordas.queue_free()
	self.get_parent().remove_child(self)
	self.queue_free()
