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

def limpar(nome):
    nome = re.sub(r'[^a-zA-Z0-9_]', '_', nome)
    nome = re.sub(r'_+', '_', nome)
    return nome.strip('_')

# Leitura sem inferSchema para evitar conflito de tipos
df_2021 = spark.read.option("header","true").option("inferSchema","false").csv(f"{BUCKET}/bronze/State_of_data_2021.csv")
df_2022 = spark.read.option("header","true").option("inferSchema","false").csv(f"{BUCKET}/bronze/State_of_data_2022.csv")
df_2023 = spark.read.option("header","true").option("inferSchema","false").csv(f"{BUCKET}/bronze/State_of_data_2023.csv")

# Adiciona ano
df_2021 = df_2021.withColumn("ano_pesquisa", F.lit("2021"))
df_2022 = df_2022.withColumn("ano_pesquisa", F.lit("2022"))
df_2023 = df_2023.withColumn("ano_pesquisa", F.lit("2023"))

# Renomeia todas as colunas de uma vez com toDF — evita StackOverflow
novos_2021 = [limpar(c) for c in df_2021.columns]
novos_2022 = [limpar(c) for c in df_2022.columns]
novos_2023 = [limpar(c) for c in df_2023.columns]

df_2021 = df_2021.toDF(*novos_2021)
df_2022 = df_2022.toDF(*novos_2022)
df_2023 = df_2023.toDF(*novos_2023)

# União preservando todas as colunas
df_silver = df_2021.unionByName(df_2022, allowMissingColumns=True) \
                   .unionByName(df_2023, allowMissingColumns=True) \
                   .dropDuplicates()

# Checkpoint para quebrar o lineage do Spark
spark.sparkContext.setCheckpointDir(f"{BUCKET}/checkpoints/")
df_silver = df_silver.checkpoint()

print(f"Total de registros Silver: {df_silver.count()}")

# Grava Silver como Parquet
df_silver.write.mode("overwrite").parquet(f"{BUCKET}/silver/state_of_data_consolidado/")

print("Silver gravado com sucesso!")
job.commit()