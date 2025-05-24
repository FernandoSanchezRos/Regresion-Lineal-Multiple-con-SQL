-- 03_ajuste_modelo.sql

-- Paso 0: Creamos la tabla de coeficientes (si no existe)
CREATE TABLE IF NOT EXISTS modelo_coeficientes (
    beta_0 NUMERIC,
    beta_edad NUMERIC,
    beta_estudios NUMERIC,
    beta_exp NUMERIC,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Paso 1: calcular medias (sobre el conjunto de entrenamiento)
WITH medias AS (
    SELECT
        AVG(edad) AS media_edad,
        AVG(nivel_estudios) AS media_estudios,
        AVG(anos_experiencia) AS media_exp,
        AVG(salario) AS media_salario
    FROM datos_split
    WHERE conjunto = 'train'
),

-- Paso 2: calcular varianzas de x y covarianzas con y
momentos AS (
    SELECT
        -- Varianzas
        VAR_POP(edad) AS var_edad,
        VAR_POP(nivel_estudios) AS var_estudios,
        VAR_POP(anos_experiencia) AS var_exp,

        -- Covarianzas con salario
        COVAR_POP(edad, salario) AS covar_edad_salario,
        COVAR_POP(nivel_estudios, salario) AS covar_estudios_salario,
        COVAR_POP(anos_experiencia, salario) AS covar_exp_salario
    FROM datos_split
    WHERE conjunto = 'train'
),

-- Paso 3: calcular coeficientes β₁, β₂, β₃
coeficientes_lineales AS (
    SELECT
        covar_edad_salario / var_edad AS beta_edad,
        covar_estudios_salario / var_estudios AS beta_estudios,
        covar_exp_salario / var_exp AS beta_exp
    FROM momentos
),

-- Paso 4: calcular intercepto β₀
coef_finales AS (
    SELECT
        c.beta_edad,
        c.beta_estudios,
        c.beta_exp,
        m.media_salario 
            - (c.beta_edad * m.media_edad 
            +  c.beta_estudios * m.media_estudios 
            +  c.beta_exp * m.media_exp) AS beta_0
    FROM coeficientes_lineales c
    CROSS JOIN medias m
)

-- Paso 5: Insertamos los coeficientes en la tabla
INSERT INTO modelo_coeficientes (beta_0, beta_edad, beta_estudios, beta_exp)
SELECT beta_0, beta_edad, beta_estudios, beta_exp
FROM coef_finales;

-- Mostramos los valores insertados (opcional)
SELECT * 
FROM modelo_coeficientes
ORDER BY fecha DESC
LIMIT 1;
