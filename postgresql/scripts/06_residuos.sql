-- 06_residuos.sql

-- Eliminamos la tabla temporal si ya existía
DROP TABLE IF EXISTS residuos;

-- Creamos la tabla temporal con los residuos del conjunto de test
CREATE TEMP TABLE residuos AS
SELECT 
    id,
    salario,
    y_pred,
    salario - y_pred AS residuo
FROM predicciones;

-- Estadísticas básicas de los residuos
SELECT
    COUNT(*) AS n_registros,
    ROUND(AVG(residuo), 4) AS media_residuo,
    ROUND(STDDEV_POP(residuo), 4) AS std_residuo,
    ROUND(MIN(residuo), 2) AS min_residuo,
    ROUND(MAX(residuo), 2) AS max_residuo
FROM residuos;

-- Muestra de residuos para revisión manual
SELECT 
    id, 
    salario, 
    y_pred, 
    ROUND(residuo, 2) AS residuo
FROM residuos
ORDER BY id
LIMIT 10;

-- Análisis de residuos 
-- La media debería ser cercana a 0
-- Desviación estándar. Cuanto más pequeña más preciso es el modelo en sus predicciones
--   1. Media y desviación estándar de los residuos
--   ESPERADO:
--     - Media ≈ 0 → indica que el modelo no tiene sesgo sistemático
--     - STDDEV baja → errores poco dispersos = buen ajuste
SELECT
    ROUND(AVG(residuo), 4) AS media_residuo,
    ROUND(STDDEV_POP(residuo), 4) AS std_residuo
FROM residuos;

--   2. Outliers (residuos con valor absoluto > 3 * std)
--   ESPERADO:
--     - Proporción < 0.3% → si los residuos siguen una distribución normal
--     - Muchos outliers indican errores graves o mala especificación del modelo
SELECT 
    COUNT(*) AS n_outliers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM residuos), 2) AS porcentaje_outliers
FROM residuos
WHERE ABS(residuo) > 3 * (SELECT STDDEV_POP(residuo) FROM residuos);

--   3. Percentil 95 del error absoluto
--   ESPERADO:
--     - Este valor representa el error que no se supera en el 95% de los casos
--     - Debe ser lo más bajo posible en relación con el rango del target (`salario`)
SELECT 
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ABS(residuo))::numeric, 2) AS error_95
FROM residuos;

--   4. Rango intercuartílico (IQR)
--   ESPERADO:
--     - Evalúa la dispersión del 50% central de los residuos
--     - Bajo IQR = errores consistentes, estables, poco ruidosos
--     - Alto IQR = modelo con errores muy variables incluso en la parte "normal"
WITH percentiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY residuo)::numeric AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY residuo)::numeric AS q3
    FROM residuos
)
SELECT 
    ROUND(q3 - q1, 4) AS iqr,
    ROUND(q1, 4) AS q1,
    ROUND(q3, 4) AS q3
FROM percentiles;
