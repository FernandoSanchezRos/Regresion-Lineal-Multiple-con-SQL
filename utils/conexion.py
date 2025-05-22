import psycopg2
from utils.logger import get_logger

logger = get_logger()

def get_connection(
    dbname: str = "regression",
    user: str = "admin",
    password: str = "admin",
    host: str = "db",
    port: str = "5432"
):
    try:
        conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )
        logger.info(f"Conectado correctamente a PostgreSQL: db={dbname}, host={host}:{port}")
        return conn
    except Exception as e:
        logger.error(f"Error al conectar a PostgreSQL: {e}")
        raise
