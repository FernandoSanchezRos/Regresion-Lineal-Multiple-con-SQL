-- 02_split_train_test.sql

-- Eliminamos la tabla si existe
DROP TABLE IF EXISTS datos_split;

-- Creamos la nueva tabla
CREATE TABLE datos_split AS
SELECT *,
    CASE 
        WHEN RANDOM() < 0.8 THEN 'train'
        ELSE 'test'
    END AS conjunto
FROM datos;

-- Verificación, registros x conjunto
SELECT conjunto, COUNT(*) AS total
FROM datos_split
GROUP BY conjunto;