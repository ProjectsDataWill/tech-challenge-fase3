# Tech Challenge — Fase 3: Big Data to Analytics
**POSTECH — Pós-graduação em Data Analytics**

## Descrição do Projeto

Projeto desenvolvido como entrega obrigatória da Fase 3 da pós-graduação em Data Analytics da POSTECH. O desafio simula um cenário real de Engenharia de Dados e Analytics, aplicando conceitos de Big Data em ambiente Cloud (AWS), com foco na pesquisa **State of Data Brasil** (Data Hackers + Bain).

## Objetivo

Construir uma solução completa de Data Engineering e Analytics para apoiar uma Instituição Financeira na compreensão do mercado brasileiro de Dados, Analytics e Inteligência Artificial, subsidiando decisões estratégicas de contratação, capacitação e investimentos em tecnologia.

## Fonte de Dados

- **State of Data Brasil 2021** — Data Hackers / Kaggle
- **State of Data Brasil 2022** — Data Hackers / Kaggle
- **State of Data Brasil 2023** — Data Hackers / Kaggle

Link: https://www.kaggle.com/datahackers/datasets

## Arquitetura da Solução (AWS)

```
Kaggle CSV → Upload S3 → S3 Bronze (Raw CSV)
                              ↓
                       AWS Glue Crawler → Glue Data Catalog
                              ↓
                      Glue Job PySpark → S3 Silver (Parquet)
                              ↓
                      Glue Job PySpark → S3 Gold (Parquet)
                              ↓
                       Amazon Athena (SQL) → Gráficos / Insights
```

### Camadas do Data Lake

| Camada | Descrição | Formato |
|--------|-----------|---------|
| **Bronze** | Dados brutos originais do Kaggle | CSV |
| **Silver** | Dados limpos, padronizados e consolidados (2021-2023) | Parquet |
| **Gold** | Agregações analíticas para consumo | Parquet |

## Serviços AWS Utilizados

- **Amazon S3** — Armazenamento das camadas Bronze, Silver e Gold
- **AWS Glue Crawler** — Descoberta e catalogação automática dos dados
- **AWS Glue Data Catalog** — Metadados e schemas das tabelas
- **AWS Glue Jobs (PySpark)** — ETL e transformação dos dados
- **Amazon Athena** — Consultas SQL analíticas sobre os dados

## Estrutura do Repositório

```
tech-challenge-fase3/
├── README.md
├── arquitetura/
│   └── diagrama_arquitetura.png
├── notebooks/
│   ├── job_bronze_silver.py
│   └── job_silver_gold.py
├── queries/
│   └── analises_athena.sql
└── apresentacao/
    └── apresentacao_executiva.pdf
```

## Questões Respondidas

1. Como está estruturado o mercado brasileiro de Dados?
2. Quais perfis profissionais são mais valorizados pelo mercado?
3. Qual é o cenário de diversidade de gênero nas carreiras de dados?
4. Quais tecnologias apresentam maior adoção entre os profissionais?
5. Qual é o índice de adoção de Inteligência Artificial e seu impacto?
6. Existem diferenças relevantes entre regiões, senioridades ou modelos de trabalho?
7. Quais oportunidades e desafios podem ser identificados para empresas que desejam investir em Dados e IA?

## Repositório

🔗 https://github.com/ProjectsDataWill/tech-challenge-fase3

---
*Tech Challenge Fase 3 — POSTECH Data Analytics — 2026*
