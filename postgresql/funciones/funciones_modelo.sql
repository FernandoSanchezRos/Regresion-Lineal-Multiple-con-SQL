-- funciones_modelo.sql
-- Encapsulamiento en PL/pgSQL de la lógica de regresión lineal múltiple
-- Proyecto: Regresión Lineal en PostgreSQL para Ingeniería de Datos
-- Autor: Fernando Sánchez Ros
-- Fecha: 2025-05-24

-- ========================================
-- 1. Verificación de Datos
-- ========================================
CREATE OR REPLACE FUNCTION verificar_datos(tabla TEXT)
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