# FITree - Exemplos de Uso das Novas Funcionalidades

## Visão Geral das Melhorias

O aplicativo FITree foi atualizado com as seguintes funcionalidades:

### 1. Banco de Dados SQLite
- Armazenamento local de dados de alimentos e exercícios
- Cache inteligente para reduzir chamadas de API
- Persistência de refeições e treinos do usuário

### 2. Integração com APIs Externas
- **Nutrição**: USDA FoodData Central API (gratuita)
- **Exercícios**: API-Ninjas (gratuita)
- Fallback para dados mockados em caso de falha da API

### 3. Novas Telas de Busca
- Tela de busca de alimentos com informações nutricionais
- Tela de busca de exercícios por grupo muscular ou nome

## Como Usar as Novas Funcionalidades

### Busca de Alimentos

1. **Navegue para a tela de refeições**
2. **Clique em "Adicionar Alimento"** (botão que deve ser adicionado às telas existentes)
3. **Digite o nome do alimento** (ex: "banana", "chicken", "rice")
4. **Visualize as informações nutricionais**:
   - Calorias por 100g
   - Carboidratos, proteínas e gorduras
   - Fonte dos dados (USDA)
5. **Selecione os alimentos desejados**
6. **Salve a refeição**

**Exemplo de busca**:
```
Busca: "banana"
Resultado: 
- Banana: 89 kcal | C: 23g | P: 1.1g | G: 0.3g
```

### Busca de Exercícios

1. **Navegue para a tela de treinos**
2. **Clique em "Criar Novo Treino"** (botão que deve ser adicionado às telas existentes)
3. **Selecione um grupo muscular** ou **digite o nome do exercício**
4. **Visualize as informações do exercício**:
   - Tipo (força, cardio, alongamento)
   - Grupo muscular alvo
   - Nível de dificuldade
   - Instruções detalhadas
5. **Adicione exercícios ao treino**
6. **Salve o treino**

**Grupos musculares disponíveis**:
- Peito (chest)
- Bíceps (biceps)
- Tríceps (triceps)
- Quadríceps (quadriceps)
- Abdominais (abdominals)
- E muitos outros...

## Estrutura do Banco de Dados

### Tabelas Principais

1. **alimentos**: Armazena informações nutricionais
2. **exercicios**: Armazena informações de exercícios
3. **refeicoes_usuario**: Refeições criadas pelo usuário
4. **treinos_usuario**: Treinos criados pelo usuário
5. **alimentos_refeicao**: Relação entre alimentos e refeições
6. **exercicios_treino**: Relação entre exercícios e treinos

### Cache Inteligente

- Os dados das APIs são armazenados localmente
- Reduz o número de chamadas para as APIs externas
- Melhora a performance do aplicativo
- Cache é limpo automaticamente após 7 dias

## APIs Utilizadas

### USDA FoodData Central
- **URL**: https://api.nal.usda.gov/fdc/v1
- **Tipo**: Gratuita (com limitações)
- **Dados**: Informações nutricionais de alimentos
- **Limitação**: 1000 requisições/hora

### API-Ninjas Exercises
- **URL**: https://api.api-ninjas.com/v1/exercises
- **Tipo**: Gratuita (com chave de API)
- **Dados**: Exercícios por grupo muscular
- **Funcionalidades**: Busca por nome, músculo, tipo, dificuldade

## Fallback e Tratamento de Erros

### Dados Mockados
Quando as APIs não estão disponíveis, o aplicativo utiliza dados mockados:

**Alimentos mockados**:
- Arroz branco cozido
- Feijão preto cozido
- Peito de frango grelhado
- Banana
- Aveia

**Exercícios mockados**:
- Flexão de braço
- Agachamento
- Prancha
- Burpee
- Rosca direta

### Tratamento de Erros
- Mensagens de erro amigáveis ao usuário
- Fallback automático para dados mockados
- Logs de erro para debugging

## Testes Implementados

### Testes de Modelos
- Criação correta de AlimentoModel
- Criação correta de ExercicioModel
- Criação correta de TreinoModel

### Testes de Serviços
- Cálculo de nutrição de refeições
- Tradução de grupos musculares
- Tradução de tipos de exercício
- Tradução de níveis de dificuldade

### Execução dos Testes
```bash
flutter test test/simple_test.dart
```

## Próximos Passos

### Melhorias Sugeridas

1. **Interface do Usuário**:
   - Adicionar botões para acessar as telas de busca
   - Melhorar a visualização de dados nutricionais
   - Adicionar gráficos de progresso

2. **Funcionalidades**:
   - Histórico de refeições e treinos
   - Metas de calorias e macronutrientes
   - Sincronização com dispositivos fitness

3. **Performance**:
   - Implementar paginação nas buscas
   - Otimizar consultas ao banco de dados
   - Adicionar indicadores de carregamento

4. **APIs**:
   - Considerar APIs pagas para mais dados
   - Implementar rate limiting
   - Adicionar retry automático

## Conclusão

O aplicativo FITree agora possui:
- ✅ Armazenamento SQLite funcional
- ✅ Integração com APIs externas
- ✅ Cache inteligente
- ✅ Telas de busca implementadas
- ✅ Testes básicos funcionando
- ✅ Tratamento de erros robusto

O aplicativo está pronto para uso e pode ser expandido com as melhorias sugeridas acima.

