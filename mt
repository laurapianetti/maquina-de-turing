#!/usr/bin/env python3

import json
import sys
from collections import deque

def load_turing_machine_from_file(filepath):
    with open(filepath, 'r') as file:
        data = json.load(file)
    
    # Extrai as especificações da máquina de acordo com o JSON
    try:
        states = data['mt'][0]
        input_alphabet = data['mt'][1]
        tape_alphabet = data['mt'][2]
        start_symbol = data['mt'][3]
        blank_symbol = data['mt'][4]
        transitions = data['mt'][5]
        initial_state = data['mt'][6]
        final_states = set(data['mt'][7])
    except IndexError as e:
        print("Erro: o formato do arquivo JSON não é válido.")
        sys.exit(1)

    # Cria a máquina
    machine = {
        "states": states,
        "input_alphabet": input_alphabet,
        "tape_alphabet": tape_alphabet,
        "start_symbol": start_symbol,
        "blank_symbol": blank_symbol,
        "transitions": transitions,
        "initial_state": initial_state,
        "final_states": final_states
    }
    return machine

def turing_machine_simulation(machine, word):
    # Inicializa a máquina 
    transitions = machine['transitions']
    start_symbol = machine['start_symbol']
    initial_state = machine['initial_state']
    final_states = set(machine['final_states'])
    blank_symbol = machine['blank_symbol']


    # Inicializa a fita com a palavra de entrada
    tape = list(start_symbol+word)
    head_position = 1

    # Inicializa a fila de estados a serem explorados
    queue = deque([(initial_state, head_position, tape)])  # (estado atual, posição na fita, fita)
    
    # Simula a máquina
    while queue:
        # print(f"fila -> {queue}")
        current_state, head_position, current_tape = queue.popleft()
        # print(f"Estado atual -> {current_state}")
        # print(f"Cabeçote -> {head_position}")
        # print(f"Fita -> {current_tape}")

        if current_state in final_states:
            return True

        if head_position == len(current_tape):
            current_tape.append(blank_symbol)

        for transition in transitions:
            # print(f"Transição -> {transition}")
            try:
                state, read_symbol, new_state, write_symbol, direction = transition
            except ValueError:
                print("Erro: transição mal formatada no arquivo JSON.")
                sys.exit(1)

            if state == current_state and current_tape[head_position] == read_symbol:
                # print("ENTROU")
                new_tape = current_tape[:]
                new_tape[head_position] = write_symbol

                new_head_position = head_position + (1 if direction == '>' else -1)

                if new_head_position < 0:
                    continue

                queue.append((new_state, new_head_position, new_tape))
    
    # print("SAIU")
    return False

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usar: ./mt [MT] [Palavra]")
        sys.exit(1)

    filepath = sys.argv[1]
    word = sys.argv[2]

    machine = load_turing_machine_from_file(filepath)

    if turing_machine_simulation(machine, word):
        print("Sim")
    else:
        print("Não")
