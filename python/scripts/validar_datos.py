from utils.conexion import get_connection
from utils.logger import get_logger

logger = get_logger()

def validar_datos(df):
    logger.info("Iniciando validación de los datos generados.")

    try:
        assert not df.isnull().values.any(), "Hay valores nulos"
        assert (df["edad"] >= 18).all(), "Edad menor a 18"
        assert (df["nivel_estudios"].between(1, 10)).all(), "Nivel de estudios fuera de rango"
        assert (df["anos_experiencia"] >= 0).all(), "Experiencia negativa"
        assert df.corr()["salario"].drop("salario").abs().max() > 0.2, "Correlación muy débil"

        logger.info("Validación de datos superada.")

    except AssertionError as e:
        logger.error(f"Validación fallida: {e}")
        raise

def verificar_tabla_creada(nombre_tabla="datos"):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT EXISTS (
            SELECT FROM information_schema.tables
            WHERE table_name = %s
        )
    """, (nombre_tabla,))
    existe = cur.fetchone()[0]
    conn.close()

    if existe:
        logger.info(f"La tabla '{nombre_tabla}' existe en la base de datos.")
    else:
        logger.error(f"La tabla '{nombre_tabla}' no existe en la base de datos.")
        raise ValueError(f"La tabla '{nombre_tabla}' no fue creada.")

def validar_correcta_inserccion_sql():
    logger.info("Comprobando si los datos se han insertado correctamente en la base de datos.")
    
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM datos")
        count = cur.fetchone()[0]
        conn.close()

        if count == 0:
            logger.error("No se han insertado registros en la tabla 'datos'.")
            raise ValueError("No se han insertado registros en la tabla 'datos'.")
        else:
            logger.info(f"Se han insertado {count} registros en la tabla 'datos'.")

    except Exception as e:
        logger.error(f"Error al validar la inserción en SQL: {e}")
        raise