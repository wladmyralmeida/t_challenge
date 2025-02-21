# Desafio Flutter: Árvore de Ativos

Este aplicativo exibe a hierarquia de Locais, Sublocais, Ativos e Componentes de uma empresa, consumindo a API de demonstração do [fake-api.tractian.com](https://fake-api.tractian.com).

## Funcionalidades

1. **Tela Inicial**: Lista de Empresas.
2. **Tela de Ativos**:
   - Exibe a árvore de ativos (Locais, Ativos, Componentes).
   - Filtro por texto (busca).
   - Filtro de sensores de energia (`sensorType == 'energy'`).
   - Filtro de status crítico (`status == 'critical'`).
   - Quando filtra, mantém o caminho (pais) até o item filtrado.

## Demonstração

[Insira aqui um vídeo ou GIF da usabilidade do app, mostrando a escolha de uma empresa, abertura da árvore e aplicação de filtros.]

## Melhorias Futuras

- **Performance**: Implementar caching local, paginação (se houvesse muitos ativos), e otimizações na montagem da árvore e busca.
- **UI/UX**: Melhorar design com animações suaves de expansão e collapse, ícones personalizados e feedback de carregamento (Skeleton).
- **Testes**: Criar testes unitários para provedores e testes de widget para a árvore.
- **Melhor tratamento de erros**: Retentativas automáticas em caso de falha de rede, e mensagens mais claras.
- **Acesso offline**: Cache e sincronização posterior.
# t_challenge
