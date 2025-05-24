-- 07_importancia.sql
-- Estimación de la importancia relativa de las variables predictoras

-- Paso 1: obtenemos el último modelo entrenado
WITH coefs AS (
    SELECT *
    FROM modelo_coeficientes
    ORDER BY fecha DESC
    LIMIT 1
),

-- Paso 2: desviaciones estándar de las variables en conjunto train
std_train AS (
    SELECT 
        STDDEV_POP(edad) AS std_edad,
        STDDEV_POP(nivel_estudios) AS std_estudios,
        STDDEV_POP(anos_experiencia) AS std_exp
    FROM datos_split
    WHERE conjunto = 'train'
),

-- Paso 3: calculamos importancia como |β| · σ
importancia AS (
    SELECT 
        'edad' AS variable,
        ABS(c.beta_edad) * s.std_edad AS impacto
    FROM coefs c, std_train s
    UNION ALL
    SELECT 
        'nivel_estudios',
        ABS(c.beta_estudios) * s.std_estudios
    FROM coefs c, std_train s
    UNION ALL
    SELECT 
        'anos_experiencia',
        ABS(c.beta_exp) * s.std_exp
    FROM coefs c, std_train s
)

-- Resultado final: importancia relativa ordenada
SELECT *
FROM importancia
ORDER BY impacto DESC;
