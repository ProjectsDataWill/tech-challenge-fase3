
-- Distribuição absoluta por gênero e ano
SELECT * FROM diversidade_genero
ORDER BY ano_pesquisa, total DESC;

-- Evolução percentual de gênero por ano
SELECT
  ano_pesquisa,
  p1_b__genero                                                    AS genero,
  total,
  ROUND(total * 100.0 / SUM(total) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM diversidade_genero
WHERE p1_b__genero IS NOT NULL
  AND p1_b__genero != ''
ORDER BY ano_pesquisa, total DESC;


-- Top 10 estados com mais profissionais em 2023
SELECT
  p1_e_a__uf_onde_mora AS estado,
  total
FROM distribuicao_uf
WHERE ano_pesquisa = '2023'
ORDER BY total DESC
LIMIT 10;

-- Distribuição por região e ano
SELECT
  ano_pesquisa,
  p1_e_b__regiao_onde_mora AS regiao,
  total,
  ROUND(total * 100.0 / SUM(total) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM distribuicao_regional
WHERE p1_e_b__regiao_onde_mora IS NOT NULL
  AND p1_e_b__regiao_onde_mora != ''
ORDER BY ano_pesquisa, total DESC;


-- Distribuição por cor/raça e ano
SELECT
  ano_pesquisa,
  p1_c__cor_raca_etnia                                            AS cor_raca,
  total,
  ROUND(total * 100.0 / SUM(total) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM cor_raca
WHERE p1_c__cor_raca_etnia IS NOT NULL
  AND p1_c__cor_raca_etnia != ''
ORDER BY ano_pesquisa, total DESC;


-- Top cargos por ano
SELECT
  ano_pesquisa,
  p2_f_cargo_atual                                                AS cargo,
  COUNT(*)                                                        AS total
FROM perfil_profissional
WHERE p2_f_cargo_atual IS NOT NULL
  AND p2_f_cargo_atual != ''
GROUP BY ano_pesquisa, p2_f_cargo_atual
ORDER BY ano_pesquisa, total DESC
LIMIT 30;


-- Distribuição por senioridade e ano
SELECT
  ano_pesquisa,
  p2_g_nivel                                                      AS senioridade,
  COUNT(*)                                                        AS total
FROM perfil_profissional
WHERE p2_g_nivel IS NOT NULL
  AND p2_g_nivel != ''
GROUP BY ano_pesquisa, p2_g_nivel
ORDER BY ano_pesquisa, total DESC;

-- Percentual de senioridade por ano
SELECT
  ano_pesquisa,
  p2_g_nivel                                                      AS senioridade,
  COUNT(*)                                                        AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM perfil_profissional
WHERE p2_g_nivel IS NOT NULL
  AND p2_g_nivel != ''
GROUP BY ano_pesquisa, p2_g_nivel
ORDER BY ano_pesquisa, total DESC;


-- Faixa salarial por senioridade em 2023
SELECT
  p2_g_nivel        AS senioridade,
  p2_h_faixa_salarial AS faixa_salarial,
  COUNT(*)          AS total
FROM perfil_profissional
WHERE ano_pesquisa = '2023'
  AND p2_g_nivel IS NOT NULL          AND p2_g_nivel != ''
  AND p2_h_faixa_salarial IS NOT NULL AND p2_h_faixa_salarial != ''
GROUP BY p2_g_nivel, p2_h_faixa_salarial
ORDER BY p2_g_nivel, total DESC;

-- Faixa salarial por cargo em 2023 (top cargos)
SELECT
  p2_f_cargo_atual    AS cargo,
  p2_h_faixa_salarial AS faixa_salarial,
  COUNT(*)            AS total
FROM perfil_profissional
WHERE ano_pesquisa = '2023'
  AND p2_f_cargo_atual IS NOT NULL    AND p2_f_cargo_atual != ''
  AND p2_h_faixa_salarial IS NOT NULL AND p2_h_faixa_salarial != ''
GROUP BY p2_f_cargo_atual, p2_h_faixa_salarial
ORDER BY cargo, total DESC;


-- Distribuição por modelo de trabalho e ano
SELECT
  ano_pesquisa,
  p2_q_atualmente_qual_a_sua_forma_de_trabalho AS modelo_trabalho,
  COUNT(*)                                      AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM perfil_profissional
WHERE p2_q_atualmente_qual_a_sua_forma_de_trabalho IS NOT NULL
  AND p2_q_atualmente_qual_a_sua_forma_de_trabalho != ''
GROUP BY ano_pesquisa, p2_q_atualmente_qual_a_sua_forma_de_trabalho
ORDER BY ano_pesquisa, total DESC;

-- Modelo ideal de trabalho (preferência) em 2023
SELECT
  p2_r_qual_a_forma_de_trabalho_ideal_para_voc AS modelo_ideal,
  COUNT(*)                                     AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM perfil_profissional
WHERE ano_pesquisa = '2023'
  AND p2_r_qual_a_forma_de_trabalho_ideal_para_voc IS NOT NULL
  AND p2_r_qual_a_forma_de_trabalho_ideal_para_voc != ''
GROUP BY p2_r_qual_a_forma_de_trabalho_ideal_para_voc
ORDER BY total DESC;


-- Satisfação na empresa atual por ano
SELECT
  ano_pesquisa,
  p2_k_voc_est_satisfeito_na_sua_empresa_atual AS satisfeito,
  COUNT(*)                                     AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY ano_pesquisa), 1) AS pct
FROM perfil_profissional
WHERE p2_k_voc_est_satisfeito_na_sua_empresa_atual IS NOT NULL
  AND p2_k_voc_est_satisfeito_na_sua_empresa_atual != ''
GROUP BY ano_pesquisa, p2_k_voc_est_satisfeito_na_sua_empresa_atual
ORDER BY ano_pesquisa, total DESC;

-- Intenção de mudança de emprego em 2023
SELECT
  p2_n_voc_pretende_mudar_de_emprego_nos_pr_ximos_6_meses AS pretende_mudar,
  COUNT(*)                                                 AS total,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1)      AS pct
FROM perfil_profissional
WHERE ano_pesquisa = '2023'
  AND p2_n_voc_pretende_mudar_de_emprego_nos_pr_ximos_6_meses IS NOT NULL
  AND p2_n_voc_pretende_mudar_de_emprego_nos_pr_ximos_6_meses != ''
GROUP BY p2_n_voc_pretende_mudar_de_emprego_nos_pr_ximos_6_meses
ORDER BY total DESC;


-- Top setores por ano
SELECT
  ano_pesquisa,
  p2_b_setor        AS setor,
  COUNT(*)          AS total
FROM perfil_profissional
WHERE p2_b_setor IS NOT NULL
  AND p2_b_setor != ''
GROUP BY ano_pesquisa, p2_b_setor
ORDER BY ano_pesquisa, total DESC
LIMIT 30;


-- Resumo geral por ano: total de respondentes, % mulheres, % sênior
SELECT
  p.ano_pesquisa,
  COUNT(*)                                                              AS total_respondentes,
  ROUND(SUM(CASE WHEN p.p2_g_nivel = 'Sênior' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1)                                         AS pct_senior,
  ROUND(SUM(CASE WHEN p.p2_g_nivel = 'Júnior' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 1)                                         AS pct_junior
FROM perfil_profissional p
WHERE p.p2_g_nivel IS NOT NULL
GROUP BY p.ano_pesquisa
ORDER BY p.ano_pesquisa;