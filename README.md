![Icone](./images/logo/logo256x256.png "Icone")

# MLP - Implementação de Rede Neural Multicamadas (MLP) em Lua

Este repositório contém uma implementação independente de uma Rede Neural Multicamadas (MLP) em Lua, gerada com a ajuda de Inteligência Artificial. A rede foi implementada sem o uso de bibliotecas de aprendizado de máquina ou notação matricial. Ela pode ser configurada para suportar múltiplas camadas e unidades, sendo aplicada ao problema clássico do XOR.

## Visão Geral

O MLP é uma rede neural feedforward totalmente conectada com uma ou mais camadas ocultas. Este código usa a função de ativação sigmoide e implementa o algoritmo de retropropagação (backpropagation) para ajustar os pesos da rede durante o treinamento.

Esta implementação foi desenvolvida de forma independente para ser simples e didática, realizando os cálculos elemento a elemento (em vez de usar operações matriciais).

## Características

- Suporte para múltiplas camadas ocultas.
- Função de ativação sigmoide e sua derivada.
- Retropropagação (backpropagation) implementada para ajuste de pesos e vieses.
- Treinamento e teste para resolver o problema lógico do XOR.
- Não usa bibliotecas externas, tornando-o fácil de entender e modificar.
- Código gerado com a assistência de IA, mantendo total independência da implementação.

## Como Funciona


## Como Funciona

A estrutura da rede é definida por um array onde cada elemento indica o número de unidades em cada camada. Por exemplo, a rede para o problema XOR possui 2 unidades na camada de entrada, 2 na camada oculta e 1 unidade na camada de saída:

```lua
local mlp = MLP:new({
    layers: [
        { type: LayerType.Input,  inputs: 2, units: 2 }, 
        { type: LayerType.Hidden, inputs: 2, units: 2 }, 
        { type: LayerType.Final,  inputs: 2, units: 1 }
    ],
    initialization: Initialization.Random
})
;
```

A função `train` é usada para treinar a rede, e `estimate` é usada para realizar estimativas após o treinamento.

## Exemplo: Problema XOR

O problema XOR é um problema lógico clássico que não pode ser resolvido com um único perceptron, mas pode ser resolvido com uma rede neural com uma camada oculta.

### Entradas e Saídas Esperadas

| Entrada | Saída Esperada |
|---------|----------------|
| [0, 0]  | [0]            |
| [0, 1]  | [1]            |
| [1, 0]  | [1]            |
| [1, 1]  | [0]            |

### Uso

1. Clone o repositório:
    ```bash
    git clone https://github.com/WilliamJardim/Lua-MLP-Mini
    ```

2. Execute o arquivo Lua com `lua`:
    ```bash
    lua xor-test.lua
    ```

3. Veja as estimativas da rede para o problema XOR:

    ```bash
    estimativas:
    Entrada: 0,0, Previsão: 0
    Entrada: 0,1, Previsão: 1
    Entrada: 1,0, Previsão: 1
    Entrada: 1,1, Previsão: 0
    ```

## Estrutura do Código

- **MLP**: Classe que representa a Rede Neural Multicamadas.
  - `constructor(layers)`: Inicializa os pesos e vieses da rede.
  - `forward(input)`: Realiza a passagem direta através da rede.
  - `train(inputs, targets, learningRate, epochs)`: Treina a rede usando backpropagation.
  - `estimate(input)`: Retorna estimativas (estimativas) para um dado conjunto de entradas.

## Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

# Esse projeto foi uma reescrita em Lua de meu outro projeto em TypeScript:

- [WilliamJardim/MLP-Mini](https://github.com/WilliamJardim/MLP-mini) 
 A implantação da Rede Neural MLP em TypeScript.