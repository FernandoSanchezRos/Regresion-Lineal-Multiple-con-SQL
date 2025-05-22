import sys, os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
from generar_datos import generar_datos, escribir_dataset_csv, escribir_coeficientes_json
from insertar_datos_en_sql import insertar_datos
from validar_datos import validar_datos, verificar_tabla_creada, validar_correcta_inserccion_sql
from utils.logger import get_logger


logger = get_logger()

if __name__ == "__main__":
    logger.info("Iniciando ejecución completa del pipeline de generación e insercción de datos.")

    try:
        # 1. Generar datos y escribirlos en disco
        df, coefs = generar_datos(10_000)
        escribir_dataset_csv(df)
        escribir_coeficientes_json(coefs)

        # 2. Validar datos generados
        validar_datos(df)

        # 3. Verificar que la tabla 'datos' existe
        verificar_tabla_creada("datos")

        # 4. Insertar en SQL
        insertar_datos(df)

        # 5. Validar que la inserción ha sido correcta
        validar_correcta_inserccion_sql()

        logger.info("Pipeline de generación e insercción de datos ejecutado correctamente de principio a fin.")

    except Exception as e:
        logger.error(f"Error en la ejecución del pipeline de generación e insercción de datos: {e}")
        raise
