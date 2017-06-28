Novas Funcionalidades
=====================

* adição métricas de código fonte simples
  - número de linhas de código
  - número de funções globais
  - número de classes
  - número de métodos
* protótipo do pré-parser (não está 100% funcional)
* adição de testes de aceitação
* melhorias no Rakefile

Refatoração
===========

* bin/kuniri (executável - CLI)
* global_tests
* Redução da complexidade ciclomática de métodos apontados pelo rubocop

Atividades Extras
==================

* correção de diversos bugs
  - remoção de espaços no final de linha
  - remoção de espaços entre o nome da função e seus parâmetros
  - correta identificação de heranças
  - ...
* rubocop compliance
* uso do SafeYAML.load ao invés do YAML.load (vulnerabilidade)
* adição do rubocop na integração contínua
* adição do testes de aceitação na integração contínua

Próximos Passos
===============

* Evolução do pré-parser (integração com o core do kuniri) - Dívida Técnica
* Bug com a detecção de lambdas - Dívida Técnica
* Escrever testes de aceitação com códigos de projetos reais
* Detectar composição e agregação entre classes

Lições Aprendidas
=================

* Ruby
* Git/github
* Testes usando shell script (shunit2)
* Mais fácil gerenciar times menores (4 pessoas)
* Objetivos do cliente (técnico) pode não ser os mesmos que o seu!
* Retrospectiva foi importante para "lavar roupa suja"
