import logging
from datetime import datetime
import os

logger = None

def get_logger(nombre_log="carga_datos", nivel=logging.INFO):
    global logger
    if logger:
        return logger
    
    # Crear carpeta de logs si no existe
    os.makedirs("../../logs", exist_ok=True)
    fecha=datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
    ruta_log=f"../../logs/{nombre_log}_{fecha}.log"

    # Instanciar logger
    logger = logging.getLogger(nombre_log)
    logger.setLevel(nivel)

    # FileHandler para archivo
    fh=logging.FileHandler(ruta_log)
    fh.setLevel(nivel)

    # StreamHandler (para consola)
    ch=logging.StreamHandler()
    ch.setLevel(nivel)

    # Formato de logs
    formato=logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    fh.setFormatter(formato)
    ch.setFormatter(formato)

    logger.addHandler(fh)
    logger.addHandler(ch)

    return logger