import pandas as pd
import numpy as np
import json
from utils.logger import get_logger
import os

logger = get_logger()

def generar_datos(n_registros, seed=131):

    np.random.seed(seed)

    ruido = np.random.normal(loc=0,
                             scale=3,
                             size=n_registros)
    x_1 = np.random.normal(loc=35,
                           scale=10,
                           size=n_registros) # Edad
    x_1 = np.clip(x_1, 18, 65).astype(int)
    x_2 = np.random.normal(loc=5,
                           scale=3,
                           size=n_registros) # Nivel de estudios
    x_2 = np.clip(x_2, 1, 10).astype(int)
    x_3 = np.random.normal(loc=3,
                           scale=2,
                           size=n_registros) # Años de experiencia
    x_3 = np.clip(x_3, 0, x_1 - 18).astype(int)
    b_0, b_1, b_2, b_3 = [14_000, 100, 700, 500] # Valores en euros

    y = b_0 + b_1*x_1 + b_2*x_2 + b_3*x_3 + ruido # y = salario

    data=pd.DataFrame({
        "edad":x_1,
        "nivel_estudios":x_2,
        "anos_experiencia":x_3,
        "salario":y
    })

    logger.info(f"Datos sintéticos generados con {n_registros} registros.")
    return data, {"b_0": b_0, "b_1": b_1, "b_2": b_2, "b_3": b_3}

def escribir_dataset_csv(df, path="../../data/raw"):
    os.makedirs(path, exist_ok=True)
    df.to_csv(f'{path}/dataset.csv', index=False)
    logger.info('Dataset guardado en "data/raw/dataset.csv".')

def escribir_coeficientes_json(coefs, path="../../data/raw"):
    os.makedirs(path, exist_ok=True)
    with open(f"{path}/coefs.json", 'w') as f:
        json.dump(coefs, f, indent=4)
    logger.info(f"Coeficientes guardados en 'data/raw/coefs.json': {coefs}")

    

if __name__=="__main__":
    pass