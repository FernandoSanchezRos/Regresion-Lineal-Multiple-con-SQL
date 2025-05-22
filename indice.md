### Índice

1. [🔍 Introducción](#1-%F0%9F%94%8D-introducci%C3%B3n)
2. [🎯 Objetivos del proyecto](#2-%F0%9F%8E%AF-objetivos-del-proyecto)
3. [⚙️ Tecnologías utilizadas](#3-%E2%9A%99%EF%B8%8F-tecnolog%C3%ADas-utilizadas)
4. [📦 Estructura del repositorio](#4-%F0%9F%93%A6-estructura-del-repositorio)
5. [🚀 Instalación y ejecución con Docker](#5-%F0%9F%9A%80-instalaci%C3%B3n-y-ejecuci%C3%B3n-con-docker)

   * Requisitos previos
   * Comando de ejecución
   * Verificación de carga de datos
6. [🧪 Generación de datos sintéticos con Faker](#6-%F0%9F%A7%AA-generaci%C3%B3n-de-datos-sint%C3%A9ticos-con-faker)

   * Script `generate_dataset.py`
   * Diseño del dataset (campos, distribución, lógica lineal)
7. [🧠 Implementación de regresión lineal múltiple en SQL](#7-%F0%9F%A7%A0-implementaci%C3%B3n-de-regresi%C3%B3n-lineal-m%C3%BAltiple-en-sql)

   7.1 Cálculo de estadísticas necesarias (AVG, VAR, COV)

   7.2 Ecuaciones normales (X'X · β = X'Y)

   7.3 Obtención de coeficientes

   7.4 Predicciones `y_hat`
8. [📈 Evaluación del modelo](#8-%F0%9F%93%88-evaluaci%C3%B3n-del-modelo)

   8.1 Error cuadrático medio (MSE, RMSE)

   8.2 Coeficiente de determinación R²

   8.3 Análisis de residuos

   8.4 (Opcional) Test F de significación global
9. [🔧 Funcionalización en SQL](#9-%F0%9F%94%A7-funcionalizaci%C3%B3n-en-sql)

   * Función `regresion_lineal_multiple(tabla TEXT, columnas TEXT[], target TEXT)`
   * Ejemplo de uso con otra tabla
10. [📊 Comparación con scikit-learn (opcional)](#10-%F0%9F%93%8A-comparaci%C3%B3n-con-scikit-learn-opcional)

    * Validación cruzada
    * Comparación de métricas
11. [📌 Conclusiones y aprendizajes](#11-%F0%9F%93%8C-conclusiones-y-aprendizajes)
12. [📁 Anexos](#12-%F0%9F%93%81-anexos)

    * Scripts SQL paso a paso
    * Código completo de la función
    * Capturas o visualizaciones (Power BI, Dash, etc.)
