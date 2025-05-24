-- 01_verificar_datos.sql

-- Verificar número total de registros
SELECT COUNT(*) FROM DATOS;

-- Verificar valores nulos en cada columna
SELECT
    COUNT(*) FILTER (WHERE edad IS NULL) as nulos_edad,
    COUNT(*) FILTER (WHERE nivel_estudios IS NULL) AS nulos_nivel_estudios,
    COUNT(*) FILTER (WHERE anos_experiencia IS NULL) AS nulos_anos_experiencia,
    COUNT(*) FILTER (WHERE salario IS NULL) AS nulos_salario
FROM datos;

-- Verificar duplicados sin contar id
SELECT COUNT(*) AS registros_duplicados
FROM(
    SELECT edad, nivel_estudios, anos_experiencia, salario, COUNT(*)
    FROM datos
    GROUP BY edad, nivel_estudios, anos_experiencia, salario
    HAVING COUNT(*) > 1
) sub;

-- Estadísticas descriptivas
SELECT
    AVG(edad) AS media_edad,
    STDDEV_POP(edad) AS std_edad,
    AVG(nivel_estudios) AS media_nivel_estudios,
    STDDEV_POP(nivel_estudios) AS std_nivel_estudios,
    AVG(anos_experiencia) as media_anos_experiencia,
    STDDEV_POP(anos_experiencia) AS std_anos_experiencia,
    AVG(salario) AS media_salarioM,
    STDDEV_POP(salario) AS std_salario
FROM datos;

-- Correlaciones
SELECT
    CORR(edad, nivel_estudios) AS corr_edad_estudios,
    CORR(edad, anos_experiencia) AS corr_edad_experiencia,
    CORR(edad, salario) AS corr_edad_salario,
    CORR(nivel_estudios, anos_experiencia) AS corr_estudios_experiencia,
    CORR(nivel_estudios, salario) AS corr_estudios_salario,
    CORR(anos_experiencia, salario) AS corr_experiencia_salario
FROM datos;