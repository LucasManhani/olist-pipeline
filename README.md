# Olist Pipeline

Pipeline de engenharia de dados end-to-end construída com o dataset público da Olist, aplicando a arquitetura Medallion para transformar dados brutos de e-commerce em métricas de negócio prontas para análise.

## Sobre o projeto

Este é um projeto de estudo em engenharia de dados onde construí uma pipeline ELT completa, desde a ingestão dos CSVs até a criação de tabelas analíticas com métricas de vendas. O foco foi entender o fundamento e fluxo de uma pipeline e arquitetura de dados, deixando muito espaço para novos updates de métricas, ferramentas e schemas para BI. 

## Arquitetura

```
CSVs Olist
    ↓
Python (extract + load)
    ↓
Postgres — schema raw
    ↓
dbt — schema bronze (tipagem correta)
    ↓
dbt — schema silver (limpeza e padronização)
    ↓
dbt — schema gold (métricas de negócio)
```

## Ferramentas

- **Python** — Extração dos dados dos arquivos CSV e carga no Postgres (pandas + SQLAlchemy)
- **Postgres** — Armazenamento dos dados em arquitetura Medallion
- **Docker Compose** — Orquestração do ambiente local em container (Postgres + pgAdmin)
- **dbt Core** — Transformações dos dados e testes de qualidade.
- **Git** — Versionamento

## Estrutura do projeto

```
olist-pipeline/
├── data/                         # CSVs da Olist (não versionados)
├── pipeline/
│   ├── extract.py               # leitura dos CSVs
│   └── load.py                  # carga no Postgres
├── dbt_olist/
│   ├── dbt_project.yml
│   ├── macros/
│   │   └── generate_schema_name.sql
│   └── models/
│       ├── sources.yml          # testes na raw
│       ├── bronze/              # tipagem correta
│       ├── silver/              # limpeza e padronização
│       └── gold/                # métricas de negócio
├── docker-compose.yml
├── .env.example
└── requirements.txt
```

## Camadas

### Raw
Dados brutos dos CSVs carregados pelo Python. Nenhuma transformação — serve como referência de origem dos dados.

### Bronze
Dados com tipos corrigidos. As principais decisões foram:
- CEPs como `text` para preservar zeros à esquerda
- Datas convertidas de `text` para `timestamp`
- Valores monetários convertidos de `double precision` para `numeric` evitando arredondamentos
- IDs como `text` porque são hashes e não números sequenciais

### Silver
Dados limpos e padronizados:
- Colunas de data renomeadas para o padrão `*_at`
- Cidades em lowercase sem acentos (usando `unaccent`)
- Estados em uppercase
- `silver_geolocation` agregada por CEP com média de coordenadas para eliminar duplicatas

### Gold
Cinco tabelas com métricas de vendas agregadas por mês:
- `gold_monthly_revenue` — faturamento e volume de pedidos
- `gold_average_ticket` — ticket médio
- `gold_cancellation_rate` — taxa de cancelamento
- `gold_category_revenue` — faturamento por categoria
- `gold_payment_methods` — faturamento por método de pagamento

## Qualidade de dados

Realizados testes de qualidade com o dbt:
- 21 testes na raw (validação dos dados originais)
- 19 testes no silver (após transformações)
- 16 testes no gold (nas métricas finais)

Os testes validam unicidade de chaves primárias evitando duplicidade e ausência de nulos em colunas críticas.

## Como rodar

**Pré-requisitos:** Docker, Python 3.13 (versões a cima podem ter incompatibilidade com o dbt) e Git.

1. Clonar o repositório:
```bash
git clone https://github.com/SEU_USUARIO/olist-pipeline.git
cd olist-pipeline
```

2. Criar o `.env` com base no `.env.example`:
```bash
cp .env.example .env
```

3. Subir o ambiente:
```bash
docker compose up -d
```

4. Instalar dependências Python:
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

5. Baixar os CSVs da Olist no Kaggle e colocar em `data/raw/`:
[https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

6. Executar a ingestão:
```bash
python pipeline/load.py
```

7. Rodar o dbt:
```bash
cd dbt_olist
dbt run
dbt test
```

## Decisões técnicas

Algumas escolhas que moldaram o projeto:

- **ELT em vez de ETL** — dados brutos carregados primeiro, transformações depois no banco com dbt
- **Macro `generate_schema_name`** — para obter schemas limpos (`bronze`, `silver`, `gold`) em vez da concatenação padrão do dbt
- **Sem constraints físicas** — optei por testes do dbt em vez de PK/FK físicas, seguindo o padrão de Data Warehouses modernos
- **Faturamento via `order_items`** na tabela de categoria — para evitar duplicação causada pela relação 1:N entre pedidos e itens


## Sobre o dataset

Dados públicos da Olist, plataforma brasileira de e-commerce, disponibilizados no Kaggle. Contém aproximadamente 100 mil pedidos realizados entre 2016 e 2018, com informações de clientes, produtos, vendedores, pagamentos, entregas e avaliações.
