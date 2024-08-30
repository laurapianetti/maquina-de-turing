from graphviz import Digraph
import json

def gerar_diagrama_mt(mt_json, nome_arquivo="maquina_turing"):
    """
    Gera um diagrama da máquina de Turing a partir de um JSON.

    Args:
        mt_json: Dicionário JSON representando a máquina de Turing.
        nome_arquivo: Nome do arquivo de saída (sem extensão).
    """

    # Extrair informações do JSON
    estados = mt_json["mt"][0]
    transicoes = mt_json["mt"][5]
    estado_inicial = mt_json["mt"][6]
    estados_finais = mt_json["mt"][7]

    # Criar o grafo direcionado
    dot = Digraph(comment='Máquina de Turing', format='png', graph_attr={'rankdir' : 'LR'})

    # Adicionar nós (estados)
    for estado in estados:
        if estado in estados_finais:
            dot.node(estado, shape='doublecircle', fontname='Verdana')  # Estados finais com dois círculos
        else:
            dot.node(estado, shape='circle', fontname='Verdana')

    # Adicionar arestas (transições)
    arestas = {}  # Dicionário para armazenar as arestas e seus rótulos

    for transicao in transicoes:
        # Formatar o estilo do label
        if transicao[4] == '>':
            transicao[4] = 'D'
        else:
            transicao[4] = 'E'
        if transicao[1] == '_':
            transicao[1] = 'U'
        if transicao[3] == '_':
            transicao[3] = 'U'
        if transicao[1] == '[':
            transicao[1] = '<'
        if transicao[3] == '[':
            transicao[3] = '<'
        
        origem = transicao[0]
        destino = transicao[2]
        rotulo_transicao = f"{transicao[1]}/{transicao[3]}{transicao[4]}"

        if (origem, destino) in arestas:
            arestas[(origem, destino)] += f"\n{rotulo_transicao}"  # Adiciona o rótulo à aresta existente
        else:
            arestas[(origem, destino)] = rotulo_transicao  # Cria uma nova aresta

    for (origem, destino), rotulo in arestas.items():
        dot.edge(origem, destino, label=rotulo, fontname='Verdana')

    # Marcar o estado inicial (opcional)
    inicial = ''
    dot.node(inicial, style='invis')
    dot.edge(inicial, estado_inicial)
    dot.node(estado_inicial, shape='circle')

    # Salvar o diagrama em um arquivo
    dot.render(nome_arquivo, view=False)

# Carregar o JSON da máquina de Turing (substitua pelo seu arquivo JSON)
with open("mt.json", "r") as f:
    mt_json = json.load(f)

# Gerar o diagrama
gerar_diagrama_mt(mt_json) 