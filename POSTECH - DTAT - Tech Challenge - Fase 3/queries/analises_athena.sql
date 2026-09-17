
-- Distribuição absoluta por gênero e ano
SELECT * FROM diversidade_genero
ORDER BY ano_pesquisa, total DESC;

-- Evolução percentual de gênero por ano
SELECT
  ano_pesquisa,
  p1_b__genero                                                          AS genero,
  total,
  ROUND(total * 100.0 / SUM(total) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM diversidade_genero
WHERE p1_b__genero IS NOT NULL AND p1_b__genero != ''
ORDER BY ano_pesquisa, total DESC;


-- Top 10 estados com mais profissionais em 2023
SELECT p1_e_a__uf_onde_mora AS estado, total
FROM distribuicao_uf
WHERE ano_pesquisa = '2023'
ORDER BY total DESC
LIMIT 10;

-- Distribuição por região e ano
SELECT
  ano_pesquisa,
  p1_e_b__regiao_onde_mora                                              AS regiao,
  total,
  ROUND(total * 100.0 / SUM(total) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM distribuicao_regional
WHERE p1_e_b__regiao_onde_mora IS NOT NULL AND p1_e_b__regiao_onde_mora != ''
ORDER BY ano_pesquisa, total DESC;


SELECT
  ano_pesquisa,
  p1_c__cor_raca_etnia                                                  AS cor_raca,
  total,
  ROUND(total * 100.0 / SUM(total) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM cor_raca
WHERE p1_c__cor_raca_etnia IS NOT NULL AND p1_c__cor_raca_etnia != ''
ORDER BY ano_pesquisa, total DESC;


SELECT
  ano_pesquisa,
  p2_f_cargo_atual                                                      AS cargo,
  COUNT(*)                                                              AS total
FROM perfil_profissional
WHERE p2_f_cargo_atual IS NOT NULL AND p2_f_cargo_atual != ''
GROUP BY ano_pesquisa, p2_f_cargo_atual
ORDER BY ano_pesquisa, total DESC
LIMIT 30;

SELECT
  ano_pesquisa,
  p2_g_nivel                                                            AS senioridade,
  COUNT(*)                                                              AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM perfil_profissional
WHERE p2_g_nivel IS NOT NULL AND p2_g_nivel != ''
GROUP BY ano_pesquisa, p2_g_nivel
ORDER BY ano_pesquisa, total DESC;


-- Faixa salarial por senioridade em 2023
SELECT
  p2_g_nivel          AS senioridade,
  p2_h_faixa_salarial AS faixa_salarial,
  COUNT(*)            AS total
FROM perfil_profissional
WHERE ano_pesquisa = '2023'
  AND p2_g_nivel IS NOT NULL          AND p2_g_nivel != ''
  AND p2_h_faixa_salarial IS NOT NULL AND p2_h_faixa_salarial != ''
GROUP BY p2_g_nivel, p2_h_faixa_salarial
ORDER BY p2_g_nivel, total DESC;


SELECT
  ano_pesquisa,
  p2_q_atualmente_qual_a_sua_forma_de_trabalho                         AS modelo_trabalho,
  COUNT(*)                                                              AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM perfil_profissional
WHERE p2_q_atualmente_qual_a_sua_forma_de_trabalho IS NOT NULL
  AND p2_q_atualmente_qual_a_sua_forma_de_trabalho != ''
GROUP BY ano_pesquisa, p2_q_atualmente_qual_a_sua_forma_de_trabalho
ORDER BY ano_pesquisa, total DESC;


-- Adoção de linguagens por ano (colunas binárias 0/1)
SELECT
  ano_pesquisa,
  SUM(CASE WHEN p4_d_a_sql    = '1' OR p4_d_1_sql    = '1' THEN 1 ELSE 0 END) AS sql,
  SUM(CASE WHEN p4_d_c_python = '1' OR p4_d_3_python = '1' THEN 1 ELSE 0 END) AS python,
  SUM(CASE WHEN p4_d_b_r      = '1' OR p4_d_2_r      = '1' THEN 1 ELSE 0 END) AS r,
  SUM(CASE WHEN p4_d_f_java   = '1' OR p4_d_6_java   = '1' THEN 1 ELSE 0 END) AS java,
  SUM(CASE WHEN p4_d_m_javascript = '1' OR p4_d_14_javascript = '1' THEN 1 ELSE 0 END) AS javascript,
  SUM(CASE WHEN p4_d_j_scala  = '1' OR p4_d_10_scala = '1' THEN 1 ELSE 0 END) AS scala,
  COUNT(*) AS total_respondentes
FROM tecnologias
GROUP BY ano_pesquisa
ORDER BY ano_pesquisa;


SELECT
  ano_pesquisa,
  SUM(CASE WHEN p4_g_a_amazon_web_services_aws = '1' OR p4_h_2_amazon_web_services_aws = '1' THEN 1 ELSE 0 END) AS aws,
  SUM(CASE WHEN p4_g_b_google_cloud_gcp        = '1' OR p4_h_3_google_cloud_gcp        = '1' THEN 1 ELSE 0 END) AS gcp,
  SUM(CASE WHEN p4_g_c_azure_microsoft         = '1' OR p4_h_1_azure_microsoft         = '1' THEN 1 ELSE 0 END) AS azure,
  COUNT(*) AS total
FROM tecnologias
GROUP BY ano_pesquisa
ORDER BY ano_pesquisa;


SELECT
  ano_pesquisa,
  SUM(CASE WHEN p4_h_a_microsoft_powerbi  = '1' OR p4_i_1_microsoft_powerbi  = '1' OR p4_j_1_microsoft_powerbi  = '1' THEN 1 ELSE 0 END) AS powerbi,
  SUM(CASE WHEN p4_h_c_tableau            = '1' OR p4_i_3_tableau            = '1' OR p4_j_3_tableau            = '1' THEN 1 ELSE 0 END) AS tableau,
  SUM(CASE WHEN p4_h_d_metabase           = '1' OR p4_i_4_metabase           = '1' OR p4_j_4_metabase           = '1' THEN 1 ELSE 0 END) AS metabase,
  SUM(CASE WHEN p4_h_q_google_data_studio = '1' OR p4_i_17_google_data_studio = '1' OR p4_j_8_looker_studiogoogle_data_studio = '1' THEN 1 ELSE 0 END) AS google_data_studio,
  COUNT(*) AS total
FROM tecnologias
GROUP BY ano_pesquisa
ORDER BY ano_pesquisa;


SELECT
  ano_pesquisa,
  SUM(CASE WHEN p4_m_1_n_o_uso_solu_es_de_ai_generativa_com_foco_em_produtividade                            = '1' THEN 1 ELSE 0 END) AS nao_usa_ia,
  SUM(CASE WHEN p4_m_2_uso_solu_es_gratuitas_de_ai_generativa_com_foco_em_produtividade                      = '1' THEN 1 ELSE 0 END) AS usa_ia_gratis,
  SUM(CASE WHEN p4_m_3_uso_e_pago_pelas_solu_es_de_ai_generativa_com_foco_em_produtividade                   = '1' THEN 1 ELSE 0 END) AS usa_ia_pago,
  SUM(CASE WHEN p4_m_4_a_empresa_que_trabalho_paga_pelas_solu_es_de_ai_generativa_com_foco_em_produtividade  = '1' THEN 1 ELSE 0 END) AS empresa_paga_ia,
  COUNT(*) AS total
FROM tecnologias
WHERE ano_pesquisa = '2023'
GROUP BY ano_pesquisa;


SELECT
  ano_pesquisa,
  COUNT(*)                                                                          AS total_respondentes,
  ROUND(SUM(CASE WHEN p2_g_nivel = 'Sênior' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_senior,
  ROUND(SUM(CASE WHEN p2_g_nivel = 'Júnior' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_junior,
  ROUND(SUM(CASE WHEN p2_g_nivel = 'Pleno'  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS pct_pleno
FROM perfil_profissional
WHERE p2_g_nivel IS NOT NULL
GROUP BY ano_pesquisa
ORDER BY ano_pesquisa;