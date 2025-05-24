-- 04_predicciones.sql

-- Eliminamos la tabla anterior si existe
DROP TABLE IF EXISTS predicciones;

-- Creamos una nueva tabla SOLO con los datos de test y la predicción
CREATE TABLE predicciones AS
SELECT 
    d.*,
    m.beta_0 + 
    m.beta_edad * d.edad + 
    m.beta_estudios * d.nivel_estudios + 
    m.beta_exp * d.anos_experiencia AS y_pred
FROM datos_split d
CROSS JOIN (
    SELECT beta_0, beta_edad, beta_estudios, beta_exp
    FROM modelo_coeficientes
    ORDER BY fecha DESC
    LIMIT 1
) m
WHERE d.conjunto = 'test';

-- Mostramos algunas filas para inspección
SELECT id, edad, nivel_estudios, anos_experiencia, salario, y_pred
FROM predicciones
ORDER BY id
LIMIT 10;
