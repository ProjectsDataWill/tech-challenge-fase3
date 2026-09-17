import sys
import re
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql import functions as F

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

BUCKET = "s3://tc-fase3-state-of-data-wl"
SILVER = f"{BUCKET}/silver/state_of_data_consolidado/"
GOLD   = f"{BUCKET}/gold"

df = spark.read.parquet(SILVER)

def limpar(nome):
    nome = re.sub(r'[^a-zA-Z0-9_]', '_', nome)
    nome = re.sub(r'_+', '_', nome)
    return nome.strip('_')

# Renomeia todas as colunas de uma vez com toDF
novos_nomes = [limpar(c) for c in df.columns]
df = df.toDF(*novos_nomes)

# Checkpoint para quebrar o lineage do Spark
spark.sparkContext.setCheckpointDir(f"{BUCKET}/checkpoints/")
df = df.checkpoint()

print("=== COLUNAS DISPONÍVEIS ===")
for i, c in enumerate(df.columns):
    print(f"{i}|{c}")

# === 1. Diversidade de gênero por ano ===
df.groupBy("ano_pesquisa", "P1_b__Genero") \
  .agg(F.count("*").alias("total")) \
  .write.mode("overwrite") \
  .parquet(f"{GOLD}/diversidade_genero/")
print("Gold OK: diversidade_genero")

# === 2. Distribuição por região ===
df.groupBy("ano_pesquisa", "P1_e_b__Regiao_onde_mora") \
  .agg(F.count("*").alias("total")) \
  .write.mode("overwrite") \
  .parquet(f"{GOLD}/distribuicao_regional/")
print("Gold OK: distribuicao_regional")

# === 3. Distribuição por UF ===
df.groupBy("ano_pesquisa", "P1_e_a__uf_onde_mora") \
  .agg(F.count("*").alias("total")) \
  .write.mode("overwrite") \
  .parquet(f"{GOLD}/distribuicao_uf/")
print("Gold OK: distribuicao_uf")

# === 4. Cor/raça por ano ===
col_raca = [c for c in df.columns if "raca" in c.lower() or "etnia" in c.lower()]
print(f"Coluna raça encontrada: {col_raca}")
if col_raca:
    df.groupBy("ano_pesquisa", col_raca[0]) \
      .agg(F.count("*").alias("total")) \
      .write.mode("overwrite") \
      .parquet(f"{GOLD}/cor_raca/")
    print("Gold OK: cor_raca")

# === 5. Perfil profissional (todas colunas P2) ===
colunas_p2 = [c for c in df.columns if c.startswith("P2")]
print(f"Colunas P2: {colunas_p2}")
df.select(["ano_pesquisa"] + colunas_p2) \
  .write.mode("overwrite") \
  .parquet(f"{GOLD}/perfil_profissional/")
print("Gold OK: perfil_profissional")

# === 6. Tecnologias (todas colunas P4) ===
colunas_p4 = [c for c in df.columns if c.startswith("P4")]
print(f"Colunas P4: {colunas_p4}")
if colunas_p4:
    df.select(["ano_pesquisa"] + colunas_p4) \
      .write.mode("overwrite") \
      .parquet(f"{GOLD}/tecnologias/")
    print("Gold OK: tecnologias")

print("=== Todas as Gold layers concluídas! ===")
job.commit()