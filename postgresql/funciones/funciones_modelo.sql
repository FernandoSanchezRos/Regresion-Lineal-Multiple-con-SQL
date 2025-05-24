-- funciones_modelo.sql
-- Encapsulamiento en PL/pgSQL de la lógica de regresión lineal múltiple
-- Proyecto: Regresión Lineal en PostgreSQL para Ingeniería de Datos
-- Autor: Fernando Sánchez Ros
-- Fecha: 2025-05-24

-- ========================================
-- 1. Verificación de Datos
-- ========================================
CREATE OR REPLACE FUNCTION verificar_datos(tabla TEXT, idx TEXT)
RETURNS VOID AS $$
DECLARE
    total_registros INT;
BEGIN
    -- Contar registros
    EXECUTE 
        format('SELECT COUNT(*) FROM %I', tabla) INTO total_registros;
    RAISE NOTICE 'Total de registros de la tabla %: %', tabla, total_registros;
    -- Contar nulos por columna
    PERFORM contar_nulos(tabla);
    -- Contar duplicados excluyendo ids
    PERFORM contar_duplicados(tabla, idx);

END;
$$ LANGUAGE plpgsql;

-- Función auxiliar. Contar nulos
CREATE OR REPLACE FUNCTION contar_nulos(tabla TEXT)
RETURNS VOID AS $$
DECLARE
    colname TEXT;
    sql TEXT;
    resultado INT;
BEGIN
    FOR colname IN
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = tabla AND table_schema = 'public'
    LOOP
        sql := format('SELECT COUNT(*) FROM %I WHERE %I IS NULL', tabla, colname);
        EXECUTE sql INTO resultado;
        RAISE NOTICE 'Columna %: % valores nulos', colname, resultado;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
-- Función auxiliar. Contar duplicados sin contar el índice
CREATE OR REPLACE FUNCTION contar_duplicados(tabla TEXT, idx TEXT)
RETURNS VOID AS $$
DECLARE
    cols TEXT;
    sql TEXT;
    resultado INT;
BEGIN
    SELECT string_agg(column_name, ', ')
    INTO cols
    FROM information_schema.columns
    WHERE table_name = tabla AND table_schema = 'public' AND column_name <> idx;

    sql := format('SELECT COUNT(*) FROM (SELECT %s FROM %I GROUP BY %s HAVING COUNT(*) > 1) AS sub',cols, tabla, cols);
    EXECUTE sql INTO resultado;
    RAISE NOTICE 'La tabla % tiene % duplicados', tabla, resultado;
END;
$$ LANGUAGE plpgsql;
