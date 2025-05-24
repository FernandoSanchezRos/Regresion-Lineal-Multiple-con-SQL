-- 08_resumen_modelo.sql
-- Guarda un resumen completo de la versión del modelo entrenado

-- Paso 0: crear tabla de registro si no existe
CREATE TABLE IF NOT EXISTS registro_modelo (
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mae NUMERIC,
    rmse NUMERIC,
    r2 NUMERIC,
    std_residuo NUMERIC,
    error_95 NUMERIC,
    variable_mas_importante TEXT
);

-- Paso 1: cálculo de métricas (mae, rmse, r²)
WITH errores AS (
    SELECT 
        salario,
        y_pred,
        salario - y_pred AS residuo,
        ABS(salario - y_pred) AS abs_error,
        POWER(salario - y_pred, 2) AS sq_error
    FROM predicciones
),
metricas AS (
    SELECT 
        AVG(abs_error) AS mae,
        SQRT(AVG(sq_error)) AS rmse,
        SUM(sq_error) AS ssres
    FROM errores
),
media_salario AS (
    SELECT AVG(salario) AS media FROM predicciones
),
sstotal AS (
    SELECT SUM(POWER(salario - m.media, 2)) AS sstot
    FROM predicciones, media_salario m
),
r2calc AS (
    SELECT 1 - ssres/sstot AS r2
    FROM metricas, sstotal
),

-- Paso 2: desviación estándar de residuos
std_res AS (
    SELECT STDDEV_POP(salario - y_pred) AS std_residuo
    FROM predicciones
),

-- Paso 3: percentil 95 del error absoluto
error_95 AS (
    SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ABS(salario - y_pred))::numeric AS e95
    FROM predicciones
),

-- Paso 4: variable más importante
top_variable AS (
    WITH coef AS (
        SELECT *
        FROM modelo_coeficientes
        ORDER BY fecha DESC
        LIMIT 1
    ),
    desviaciones AS (
        SELECT 
            STDDEV_POP(edad) AS std_edad,
            STDDEV_POP(nivel_estudios) AS std_estudios,
            STDDEV_POP(anos_experiencia) AS std_exp
        FROM datos_split
        WHERE conjunto = 'train'
    )
    SELECT variable
    FROM (
        SELECT 'edad' AS variable, ABS(c.beta_edad * d.std_edad) AS impacto
        FROM coef c CROSS JOIN desviaciones d
        UNION ALL
        SELECT 'nivel_estudios', ABS(c.beta_estudios * d.std_estudios)
        FROM coef c CROSS JOIN desviaciones d
        UNION ALL
        SELECT 'anos_experiencia', ABS(c.beta_exp * d.std_exp)
        FROM coef c CROSS JOIN desviaciones d
    ) impactos
    ORDER BY impacto DESC
    LIMIT 1
)

-- Paso final: insertar el registro en la tabla resumen
INSERT INTO registro_modelo (mae, rmse, r2, std_residuo, error_95, variable_mas_importante)
SELECT 
    m.mae,
    m.rmse,
    ROUND(r.r2, 4),
    ROUND(s.std_residuo, 4),
    ROUND(e.e95, 2),
    v.variable
FROM metricas m, r2calc r, std_res s, error_95 e, top_variable v;

-- Verificación del último registro
SELECT * FROM registro_modelo
ORDER BY fecha DESC
LIMIT 1;
