import pandas as pd
from utils.conexion import get_connection
from utils.logger import get_logger

logger = get_logger()

def insertar_datos(df=None):
    if df is None:
        df = pd.read_csv("data/raw/dataset.csv")

    logger.info(f"Iniciando inserción de {len(df)} registros en la tabla 'datos'.")

    try:
        conn = get_connection()
        cur = conn.cursor()

        for _, row in df.iterrows():
            cur.execute("""
                INSERT INTO datos (edad, nivel_estudios, anos_experiencia, salario)
                VALUES (%s, %s, %s, %s)
            """, tuple(row))

        conn.commit()
        cur.close()
        conn.close()

        logger.info("Inserción completada correctamente en la tabla 'datos'.")

    except Exception as e:
        logger.error(f"Error durante la inserción de datos: {e}")
        raise


if __name__ == "__main__":
    insertar_datos()
