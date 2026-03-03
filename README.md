# 📦 Estoque PDV - Ordem Suplementos

O **Estoque PDV** é um sistema de gestão de vendas e inventário desenvolvido especificamente para lojas de suplementos. Ele permite o controle total de produtos, clientes, vendas com desconto e um dashboard financeiro em tempo real.



## 🚀 Funcionalidades

- **PDV (Ponto de Venda):** Interface rápida para realização de vendas com suporte a leitor de código de barras.
- **Gestão de Estoque:** Controle automático de entrada e saída, com alertas de estoque crítico.
- **Dashboard Administrativo:** Gráficos de faturamento, lucro real (considerando descontos) e ranking de vendedores.
- **Sistema de Usuários:** Níveis de acesso para `Admin` e `Vendedor`.
- **Relatórios:** Fechamento de caixa diário e histórico de vendas filtrado por data.
- **Impressão de Cupom:** Layout otimizado para impressoras térmicas de 80mm.

## 🛠️ Tecnologias Utilizadas

* **Linguagem:** Ruby 3.4.7
* **Framework:** [Ruby on Rails 8.1](https://rubyonrails.org/)
* **Banco de Dados:** SQLite3 (Desenvolvimento/Local) / PostgreSQL (Produção)
* **Estilização:** Tailwind CSS
* **Autenticação:** Devise (Customizado para login via Username)

## 📦 Como Instalar e Rodar Localmente

### Pré-requisitos
* Ruby instalado (versão 3.3+)
* Bundler instalado
* Node.js e Yarn/NPM (para o Tailwind)

### Instalação

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/estoque_PDV.git](https://github.com/seu-usuario/estoque_PDV.git)
    cd estoque_PDV
    ```

2.  **Instale as dependências:**
    ```bash
    bundle install
    ```

3.  **Prepare o Banco de Dados:**
    ```bash
    rails db:setup
    ```
    *(Isso criará o banco, as tabelas e carregará o usuário admin padrão do arquivo `db/seeds.rb`)*

4.  **Inicie o sistema:**
    ```bash
    ./bin/dev
    ```
    Acesse em seu navegador: `http://localhost:3000`

## 📊 Estrutura Financeira (Lógica do Lucro)

O sistema utiliza uma fórmula de cálculo de lucro real para evitar divergências causadas por descontos:
$$Lucro = (\text{Preço de Venda} - \text{Preço de Custo}) - \text{Descontos Concedidos}$$

## 💻 IMAGENS DO PROJETO

<img width="432" height="532" alt="Captura de tela 2026-02-12 214459" src="https://github.com/user-attachments/assets/2ea25ba0-c65e-46e2-80b1-297cc3a5a0f3" />


<img width="999" height="864" alt="Captura de tela 2026-02-12 214224" src="https://github.com/user-attachments/assets/06c8779f-cf46-4b63-a76a-aaa1f9876093" />

<img width="1003" height="462" alt="Captura de tela 2026-02-12 214304" src="https://github.com/user-attachments/assets/e54bcde7-f05b-42ca-83f2-1b9689d9d729" />

<img width="984" height="684" alt="Captura de tela 2026-02-12 214250" src="https://github.com/user-attachments/assets/e3fd5dc3-0244-46b7-b01d-189cbf3471e5" />



## 📄 Licença

Este projeto foi desenvolvido para fins de estudo e aplicação comercial na loja **Ordem Suplementos**.

---
Desenvolvido com ❤️ por **Vitor** - *Estudante de Sistemas de Informação na UniRios*.
