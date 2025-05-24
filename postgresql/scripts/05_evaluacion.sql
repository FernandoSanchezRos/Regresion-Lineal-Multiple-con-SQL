-- 05_evaluacion.sql

-- Evaluación del modelo sobre conjunto de test

WITH errores AS (
    SELECT
        salario,
        y_pred,
        salario - y_pred AS residuo,
        ABS(salario - y_pred) AS abs_error,
        POWER(salario - y_pred, 2) AS sq_error
    FROM predicciones
),

estadisticas AS (
    SELECT 
        AVG(abs_error) AS MAE,
        SQRT(AVG(sq_error)) AS RMSE,
        SUM(sq_error) AS SSres
    FROM errores
),

media_total AS (
    SELECT AVG(salario) AS media_salario
    FROM predicciones
),

suma_total AS (
    SELECT SUM(POWER(salario - m.media_salario, 2)) AS SStot
    FROM predicciones, media_total m
)

-- Resultado final: métricas de evaluación
SELECT
    e.MAE,
    e.RMSE,
    ROUND(1 - e.SSres / t.SStot, 4) AS R2
FROM estadisticas e, suma_total t;
