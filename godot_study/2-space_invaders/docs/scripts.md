# Scripts

- $".":
  - Seletor de nós. Ex:
    - $"." -> Seleciona o nó atual
    - $game/player -> Seleciona o player dentro do nó "game"

- func _ready():
  - Chamado no primeiro render do node.

- func _process(delta):
  - Chamado a cada frame.

- queue_free():
  - Coloca o objeto na fila para ser destruído.

- free():
  - Destrói imediatamente. Causa erros.

- add_group("group_name"):
  - Array com elementos add no grupo.

- get_node():
  - Pede por um nó da árvore.

- setget get_func, set_func:
  - Criar getters e setters para a varíavel com o 'getset'
  - Toda chamade de atribuição do valor da varíavel passará pelas funções definidas. Mesmo que a mudança seja chamada de fora.

- _draw():
  - Função da godot que desenha o elemento na tela.

- update():
  - Chama a função _draw().

- Engine.is_editor_hint():
  - Verifica se está em modo de edição.
  - Para isso funcionar é necessário add na primeira linha a palavra reservada 'tool'.

- signal signal_name:
  - Registra um sinal.

- emit_signal("signal_name"):
  - Emite o sinal informado.

- connect("signal_name", script_que_ira_executar_o_metodo, "método_que_será_executado"):
  - Conecta o script ao sinal e executa um método quando ouve o sinal.

- preload var var_name ...:
  - Faz o pré carregamento de algo ao ser iniciado.

- onready var var_name = ...:
  - Atribui a variável o valor no momento que o jogo é iniciado.

- randomize():
  - Altera a 'semente' da geração dos números aleatórios baseando-se na hora do computador.
  - Torna mais eficiente a geração de números aleatórios.

- yield(node, "signal")
  - Aguarda o elemento emitir o sinal específicado para continar a execução do script

- 
