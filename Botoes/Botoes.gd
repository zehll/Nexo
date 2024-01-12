extends Node2D
class_name CBotoes

# ELEMENTOS DA CENA
@onready var Principal: CPrincipal
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
@onready var Pergunta: PackedScene = preload("res://Pergunta/Pergunta.tscn")
@onready var Pastas: PackedScene = preload("res://Pastas/Pastas.tscn")
@onready var NovoRotulo: PackedScene = preload("res://ListaDeRotulos/NovoRotulo/NovoRotulo.tscn")
@onready var TexturaImagem: Texture2D = preload("res://Icones/Imagem.png")
@onready var TexturaRotulo: Texture2D = preload("res://Icones/Rotulo.png")

# VARIÁVEIS
@onready var SalvarPreNovo: bool = false
@onready var SalvarPreSair: bool = false
@onready var UltimosIndices: Array = []

# INICIAR
func _ready() -> void:
	for item in [Novo,Abrir,Salvar,Modo,Voltar,Esquerda,Direita,Sorteio,Adicionar,TelaCheia,Minimizar,Maximizar,Sair,VerAmbos,VerMarcados,VerDesmarcados,Digitacao,IconeBuscar]:
		item.mouse_entered.connect(Mouse.localizar.bind(item))
		item.mouse_exited.connect(Mouse.localizar.bind(Mouse))
	Mouse.Saiu.connect(_atualizar_cor.bind(0))
	Mouse.Entrou.connect(_atualizar_cor.bind(1))
	Mouse.IniciouClique.connect(_atualizar_cor.bind(2))
	Mouse.CliqueValido.connect(_clique)
	get_viewport().size_changed.connect(_atualizar_tamanho)
	_atualizar_tamanho()
func iniciar() -> void:
	Principal = Mouse.Principal[0]

# ATUALIZAR TAMANHO
func _atualizar_tamanho() -> void:
	var tamanho_da_janela: Vector2 = Vector2(float(get_window().size.x),float(get_window().size.y))
	Sair.position.x = tamanho_da_janela.x - 27.0
	Maximizar.position.x = Sair.position.x - 27.0
	Minimizar.position.x = Maximizar.position.x - 27.0
	TelaCheia.position.x = Minimizar.position.x - 27.0
	Titulo.size.x = tamanho_da_janela.x - 672.0
	TextoTitulo.size.x = Titulo.size.x

# ATUALIZAR COR
func _atualizar_cor(botao: Node, estado: int) -> void:
	if [Novo,Abrir,Salvar,Modo,Voltar,Esquerda,Direita,Sorteio,Adicionar,TelaCheia,Minimizar,Maximizar,Sair].has(botao):
		if estado == 0:
			botao.color = Color(0.0,0.0,0.0,1.0)
			botao.get_children()[0].self_modulate = Color(0.2,0.2,0.2,1.0)
		elif estado == 1:
			botao.color = Color(0.07,0.07,0.07,1.0)
			botao.get_children()[0].self_modulate = Color(0.27,0.27,0.27,1.0)
		elif estado == 2:
			botao.color = Color(0.15,0.15,0.15,1.0)
			botao.get_children()[0].self_modulate = Color(0.36,0.35,0.35,1.0)
	elif [VerAmbos,VerMarcados,VerDesmarcados].has(botao):
		if Principal.Visualizacao == 0:
			if estado == 0:
				if botao == VerAmbos: botao.self_modulate = Color(0.2,0.2,0.2,1.0)
				else: botao.self_modulate = Color(0.1,0.1,0.1,1.0)
			elif estado == 1:
				if botao == VerAmbos: botao.self_modulate = Color(0.25,0.25,0.25,1.0)
				else: botao.self_modulate = Color(0.15,0.15,0.15,1.0)
			elif estado == 2:
				if botao == VerAmbos: botao.self_modulate = Color(0.3,0.3,0.3,1.0)
				else: botao.self_modulate = Color(0.2,0.2,0.2,1.0)
		elif Principal.Visualizacao == 1:
			if estado == 0:
				if botao == VerMarcados: botao.self_modulate = Color(0.2,0.2,0.2,1.0)
				else: botao.self_modulate = Color(0.1,0.1,0.1,1.0)
			elif estado == 1:
				if botao == VerMarcados: botao.self_modulate = Color(0.25,0.25,0.25,1.0)
				else: botao.self_modulate = Color(0.15,0.15,0.15,1.0)
			elif estado == 2:
				if botao == VerMarcados: botao.self_modulate = Color(0.3,0.3,0.3,1.0)
				else: botao.self_modulate = Color(0.2,0.2,0.2,1.0)
		elif Principal.Visualizacao == 2:
			if estado == 0:
				if botao == VerDesmarcados: botao.self_modulate = Color(0.2,0.2,0.2,1.0)
				else: botao.self_modulate = Color(0.1,0.1,0.1,1.0)
			elif estado == 1:
				if botao == VerDesmarcados: botao.self_modulate = Color(0.25,0.25,0.25,1.0)
				else: botao.self_modulate = Color(0.15,0.15,0.15,1.0)
			elif estado == 2:
				if botao == VerDesmarcados: botao.self_modulate = Color(0.3,0.3,0.3,1.0)
				else: botao.self_modulate = Color(0.2,0.2,0.2,1.0)

# COMPUTAR CLIQUE
func _clique(botao: Node) -> void:
	SalvarPreNovo = false
	SalvarPreSair = false
	if botao == Novo: _novo(0,0)
	elif botao == Abrir: _abrir("",0)
	elif botao == Salvar: _salvar("",0)
	elif botao == Modo: _modo()
	elif botao == Voltar: _mover(-1)
	elif botao == Esquerda: _mover(0)
	elif botao == Direita: _mover(1)
	elif botao == Sorteio: _mover(2)
	elif botao == Adicionar: _adicionar("",0)
	elif botao == VerAmbos: _visualizacao(0)
	elif botao == VerMarcados: _visualizacao(1)
	elif botao == VerDesmarcados: _visualizacao(2)
	elif botao == TelaCheia: _alterar_janela(2)
	elif botao == Minimizar: _alterar_janela(0)
	elif botao == Maximizar: _alterar_janela(1)
	elif botao == Sair: _sair(0,0)

# ALTERAR TAMANHO DA JANELA
func _alterar_janela(modo: int) -> void:
	if modo == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	else:
		var tamanho_da_tela: Vector2i = DisplayServer.screen_get_size()
		if modo == 1:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			if get_window().size.x == tamanho_da_tela.x:
				get_window().size = Vector2i(1152,648)
				get_window().position = Vector2i(tamanho_da_tela / 2) - Vector2i(576,324)
			else:
				get_window().size = Vector2i(tamanho_da_tela.x,roundi(0.94 * tamanho_da_tela.y))
				get_window().position = Vector2i(0,0)
		elif modo == 2:
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				get_window().size = Vector2i(1152,648)
				get_window().position = Vector2i(tamanho_da_tela / 2) - Vector2i(576,324)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

# NOVO
func _novo(resposta: int, etapa: int) -> void:
	if etapa == 0:
		if Principal.Janelas.get_child_count() > 0:
			Principal.Janelas.get_children()[0].fechar()
		if Principal.Arquivo != ""  or Principal.Imagens != [] or Principal.Rotulos != []:
			var questionar_novo: CPergunta = Pergunta.instantiate()
			Principal.Janelas.add_child(questionar_novo)
			questionar_novo.iniciar("Você deseja salvar o projeto atual?",["Cancelar","Sim","Não"])
			questionar_novo.Resposta.connect(_novo.bind(1))
	else:
		if resposta == 0:
			Principal.Janelas.get_children()[0].fechar()
		elif resposta == 1:
			SalvarPreNovo = true
			_salvar("",0)
		else:
			Principal.Arquivo = ""
			Principal.Imagens = []
			Principal.Rotulos = []
			Principal.ItemAtual = []
			Digitacao.text = ""
			Principal.ListaDeImagens.atualizar("")
			Principal.ListaDeRotulos.atualizar("")
			Principal.Exibidor.zerar()
			Principal.Janelas.get_children()[0].fechar()

# ABRIR
func _abrir(resposta: String, etapa: int) -> void:
	if etapa == 0:
		if Principal.Janelas.get_child_count() != 0:
			Principal.Janelas.get_children()[0].fechar()
		var questionar_abrir: CPastas = Pastas.instantiate()
		Principal.Janelas.add_child(questionar_abrir)
		questionar_abrir.iniciar(CPastas.Atividades.Abrir)
		questionar_abrir.Abrir.connect(_abrir.bind(1))
		questionar_abrir.Cancelar.connect(_abrir.bind(2))
	elif etapa == 1:
		var arquivo: Resource = ResourceLoader.load(resposta)
		if arquivo is CDados:
			Principal.Arquivo = resposta
			Principal.Imagens = arquivo.Imagens
			Principal.Rotulos = arquivo.Rotulos
			Principal.Exibidor.zerar()
			if Principal.ModoImagem:
				Principal.ItemAtual = arquivo.Imagens[0]
				Principal.Exibidor.adicionar(arquivo.Imagens[0][0])
			else:
				Principal.ItemAtual = arquivo.Rotulos[0]
				for imagem in Principal.Imagens:
					if imagem[1].has(Principal.ItemAtual[0]):
						Principal.Exibidor.adicionar(imagem[0])
			Digitacao.text = ""
			Principal.ListaDeImagens.atualizar("")
			Principal.ListaDeRotulos.atualizar("")
		Principal.Janelas.get_children()[0].fechar()
	elif etapa == 2:
		Principal.Janelas.get_children()[0].fechar()

# SALVAR
func _salvar(resposta: String, etapa: int) -> void:
	if etapa == 0:
		if (Principal.Arquivo == "" and (Principal.Imagens != [] or Principal.Rotulos != [])) or Principal.Arquivo != "":
			if Principal.Janelas.get_child_count() != 0:
				Principal.Janelas.get_children()[0].fechar()
			var questionar_salvar: CPastas = Pastas.instantiate()
			Principal.Janelas.add_child(questionar_salvar)
			questionar_salvar.iniciar(CPastas.Atividades.Salvar)
			questionar_salvar.Salvar.connect(_salvar.bind(1))
			questionar_salvar.Cancelar.connect(_salvar.bind(2))
	elif etapa == 1:
		if resposta.right(5) != ".tres": resposta = resposta + ".tres"
		var novo_arquivo: CDados = CDados.new()
		novo_arquivo.Imagens = Principal.Imagens
		novo_arquivo.Rotulos = Principal.Rotulos
		ResourceSaver.save(novo_arquivo,resposta)
		Principal.Janelas.get_children()[0].fechar()
		Principal.Arquivo = resposta
		if SalvarPreNovo:
			Principal.Arquivo = ""
			Principal.Imagens = []
			Principal.Rotulos = []
			Principal.ItemAtual = []
			Digitacao.text = ""
			Principal.ListaDeImagens.atualizar("")
			Principal.ListaDeRotulos.atualizar("")
			Principal.Exibidor.zerar()
			SalvarPreNovo = false
		if SalvarPreSair:
			get_tree().quit()
	elif etapa == 2:
		SalvarPreNovo = false
		SalvarPreSair = false
		Principal.Janelas.get_children()[0].fechar()

# ALTERAR MODO
func _modo() -> void:
	Principal.ModoImagem = not Principal.ModoImagem
	UltimosIndices = [0]
	Principal.Exibidor.zerar()
	if Principal.ModoImagem:
		IconeModo.texture = TexturaImagem
		if Principal.Imagens.size() > 0:
			Principal.ItemAtual = Principal.Imagens[0]
			Principal.Exibidor.adicionar(Principal.ItemAtual[0])
			TextoTitulo.text = Principal.ItemAtual[0].split("/")[-1].split(".")[0]
	else:
		IconeModo.texture = TexturaRotulo
		if Principal.Rotulos.size() > 0:
			Principal.ItemAtual = Principal.Rotulos[0]
			for imagem in Principal.Imagens:
				if imagem[1].has(Principal.ItemAtual[0]):
					Principal.Exibidor.adicionar(imagem[0])
			TextoTitulo.text = Principal.ItemAtual[0]
	Digitacao.text = ""
	Principal.ListaDeImagens.atualizar("")
	Principal.ListaDeRotulos.atualizar("")

# MOVER
func _mover(direcao: int) -> void:
	if direcao == -1:
		if UltimosIndices.size() > 1:
			var indice_atual: int = UltimosIndices.pop_back()
			Principal.Exibidor.zerar()
			if Principal.ModoImagem:
				Principal.ItemAtual = Principal.Imagens[indice_atual]
				Principal.Exibidor.adicionar(Principal.ItemAtual[0])
				Principal.Botoes.TextoTitulo.text = Principal.ItemAtual[0].split("/")[-1].split(".")[0]
			else:
				Principal.ItemAtual = Principal.Rotulos[indice_atual]
				for imagem in Principal.Imagens:
					if imagem[1].has(Principal.ItemAtual[0]):
						Principal.Exibidor.adicionar(imagem[0])
				Principal.Botoes.TextoTitulo.text = Principal.ItemAtual[0]
	else:
		var modo_imagem: bool = Principal.ModoImagem
		var mais_de_um: bool = false
		if modo_imagem and Principal.Imagens.size() > 1: mais_de_um = true
		elif not modo_imagem and Principal.Rotulos.size() > 2: mais_de_um = true
		if mais_de_um:
			var indice_atual: int = 0
			if modo_imagem:
				while Principal.Imagens[indice_atual] != Principal.ItemAtual: indice_atual += 1
			else:
				while Principal.Rotulos[indice_atual] != Principal.ItemAtual: indice_atual += 1
			if direcao == 0:
				indice_atual -= 1
				if indice_atual < 0:
					if modo_imagem: indice_atual = Principal.Imagens.size() - 1
					else: indice_atual = Principal.Rotulos.size() - 1
			elif direcao == 1:
				indice_atual += 1
				if modo_imagem and indice_atual >= Principal.Imagens.size(): indice_atual = 0
				elif not modo_imagem and indice_atual >= Principal.Rotulos.size(): indice_atual = 0
			elif direcao == 2:
				var sorteio: RandomNumberGenerator = RandomNumberGenerator.new()
				var novo_indice: int
				if modo_imagem: novo_indice = sorteio.randi_range(0,Principal.Imagens.size() - 1)
				else: novo_indice = sorteio.randi_range(0,Principal.Rotulos.size() - 1)
				while novo_indice == indice_atual:
					sorteio.randomize()
					if modo_imagem: novo_indice = sorteio.randi_range(0,Principal.Imagens.size() - 1)
					else: novo_indice = sorteio.randi_range(0,Principal.Rotulos.size() - 1)
				indice_atual = novo_indice
			UltimosIndices.push_back(indice_atual)
			Principal.Exibidor.zerar()
			if modo_imagem:
				Principal.ItemAtual = Principal.Imagens[indice_atual]
				Principal.Exibidor.adicionar(Principal.ItemAtual[0])
				Principal.Botoes.TextoTitulo.text = Principal.ItemAtual[0].split("/")[-1].split(".")[0]
			else:
				Principal.ItemAtual = Principal.Rotulos[indice_atual]
				for imagem in Principal.Imagens:
					if imagem[1].has(Principal.ItemAtual[0]):
						Principal.Exibidor.adicionar(imagem[0])
				Principal.Botoes.TextoTitulo.text = Principal.ItemAtual[0]

# ADICIONAR
func _adicionar(resposta: String, etapa: int) -> void:
	if etapa == 0:
		if Principal.ModoImagem:
			if Principal.Janelas.get_child_count() != 0:
				Principal.Janelas.get_children()[0].fechar()
			var questionar_novo_rotulo: CNovoRotulo = NovoRotulo.instantiate()
			Principal.Janelas.add_child(questionar_novo_rotulo)
			questionar_novo_rotulo.iniciar("",false)
			questionar_novo_rotulo.Cancelamento.connect(_concluir_adicionar_rotulo.bind(0))
			questionar_novo_rotulo.NovoRotulo.connect(_concluir_adicionar_rotulo.bind(1))
		else:
			if Principal.Janelas.get_child_count() != 0:
				Principal.Janelas.get_children()[0].fechar()
			var questionar_nova_imagem: CPastas = Pastas.instantiate()
			Principal.Janelas.add_child(questionar_nova_imagem)
			questionar_nova_imagem.iniciar(CPastas.Atividades.NovaImagem)
			questionar_nova_imagem.NovaImagem.connect(_adicionar.bind(1))
			questionar_nova_imagem.Cancelar.connect(_adicionar.bind(2))
	elif etapa == 1:
		if resposta.right(1) == "/":
			var leitor: DirAccess = DirAccess.open(resposta)
			leitor.list_dir_begin()
			var proximo_item: String = leitor.get_next()
			while proximo_item != "":
				if proximo_item.right(5) == ".jpeg" or [".jpg",".png"].has(proximo_item.right(4)):
					Principal.Imagens.append([resposta + "/" + proximo_item,[]])
				proximo_item = leitor.get_next()
		else:
			Principal.Imagens.append([resposta,[]])
		Principal.ListaDeImagens.atualizar(Digitacao.text)
		Principal.ListaDeRotulos.atualizar(Digitacao.text)
		if Principal.ModoImagem and Principal.ItemAtual == []:
			Principal.ItemAtual = Principal.Imagens[0]
			Principal.Exibidor.adicionar(Principal.ItemAtual[0])
		Principal.Janelas.get_children()[0].fechar()
	elif etapa == 2:
		Principal.Janelas.get_children()[0].fechar()

# CONCLUIR ADICIONAR RÓTULO
func _concluir_adicionar_rotulo(resposta: Array, erro: int) -> void:
	if erro != 0:
		Principal.Rotulos.append(resposta)
		Principal.ListaDeImagens.atualizar(Principal.Botoes.Digitacao.text)
		Principal.ListaDeRotulos.atualizar(Principal.Botoes.Digitacao.text)
	Principal.Janelas.get_children()[0].fechar()

# ALTERAR VISUALIZAÇÃO
func _visualizacao(modo: int) -> void:
	var modo_anterior: int = Principal.Visualizacao
	Principal.Visualizacao = modo
	if modo_anterior == 0: _atualizar_cor(VerAmbos,0)
	elif modo_anterior == 1: _atualizar_cor(VerMarcados,0)
	elif modo_anterior == 2: _atualizar_cor(VerDesmarcados,0)
	if modo == 0: _atualizar_cor(VerAmbos,0)
	elif modo == 1: _atualizar_cor(VerMarcados,0)
	elif modo == 2: _atualizar_cor(VerDesmarcados,0)
	Principal.ListaDeImagens.atualizar(Digitacao.text)
	Principal.ListaDeRotulos.atualizar(Digitacao.text)

# SAIR
func _sair(resposta: int, etapa: int) -> void:
	if etapa == 0:
		if Principal.Janelas.get_child_count() > 0:
			Principal.Janelas.get_children()[0].fechar()
		if Principal.Arquivo == "":
			get_tree().quit()
		else:
			var arquivo: CDados = ResourceLoader.load(Principal.Arquivo)
			if arquivo.Imagens == Principal.Imagens and arquivo.Rotulos == Principal.Rotulos:
				get_tree().quit()
			else:
				var questionar_saida: CPergunta = Pergunta.instantiate()
				Principal.Janelas.add_child(questionar_saida)
				questionar_saida.iniciar("Tem certeza de que deseja sair?",["Salvar e Sair","Cancelar","Sair Sem Salvar"])
				questionar_saida.Resposta.connect(_sair.bind(1))
	else:
		if Principal.Janelas.get_child_count() > 0:
			Principal.Janelas.get_children()[0].fechar()
		if resposta == 0:
			var novo_arquivo: CDados = CDados.new()
			novo_arquivo.Imagens = Principal.Imagens
			novo_arquivo.Rotulos = Principal.Rotulos
			if Principal.Arquivo != "":
				ResourceSaver.save(novo_arquivo,Principal.Arquivo)
				get_tree().quit()
			else:
				SalvarPreSair = true
				_salvar("",0)
		elif resposta == 2:
			get_tree().quit()
		else:
			Principal.Janelas.get_children()[0].fechar()
