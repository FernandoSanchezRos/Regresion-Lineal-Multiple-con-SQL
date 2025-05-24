# Introducción

En este proyecto se implementa desde cero un modelo de **regresión lineal múltiple utilizando únicamente SQL**. A diferencia de los enfoques tradicionales que utilizan bibliotecas estadísticas o de aprendizaje automático como scikit-learn, aquí se busca demostrar que es posible realizar todo el proceso analítico, desde la generación de datos, el cálculo de coeficientes, hasta la evaluación del modelo, directamente en una base de datos relacional como PostgreSQL.

Este enfoque tiene una doble finalidad:

* **Didáctica**: entender cómo funciona internamente una regresión lineal múltiple, sin abstracciones.
* **Profesional**: construir funciones reutilizables en SQL que puedan aplicarse a diferentes conjuntos de datos dentro de entornos donde SQL es la herramienta principal.

Además, se utilizará Docker para garantizar la reproducibilidad del entorno y se generarán datos sintéticos controlados para poder validar fácilmente el funcionamiento del modelo.

---

# Objetivos del proyecto

Este proyecto tiene como propósito principal  **demostrar la capacidad de implementar y evaluar un modelo de regresión lineal múltiple directamente en SQL** , sin depender de herramientas externas de machine learning.

Los objetivos específicos son:

* **Aplicar conocimientos estadísticos fundamentales** (medias, varianzas, covarianzas, ecuaciones normales) usando únicamente SQL.
* **Ejercitar SQL avanzado** , incluyendo operaciones matriciales, subconsultas correlacionadas, y transformaciones de datos a gran escala.
* **Automatizar procesos mediante funciones** definidas en  **PL/pgSQL** , favoreciendo la reutilización y abstracción lógica.
* **Evaluar modelos estadísticos** dentro del entorno relacional, mediante métricas como MSE, R² y análisis de residuos.
* **Diseñar entornos reproducibles con Docker** , poniendo en práctica buenas prácticas de despliegue y portabilidad.
* **Controlar la estructura de los datos de entrada** , utilizando generadores sintéticos con lógica conocida, lo que permite validar los resultados.

En conjunto, este proyecto permite ejercitar de forma integrada aspectos clave de la ingeniería de datos como la transformación, modelado, automatización y evaluación dentro de un entorno SQL.

---

# Tecnologías utilizadas

Este proyecto ha sido diseñado para ejercitar un conjunto de herramientas y competencias representativas del perfil de  **ingeniero de datos** , estructuradas en torno a un flujo reproducible y técnico. Las tecnologías empleadas se utilizan con los siguientes propósitos:

* **PostgreSQL + SQL + PL/pgSQL**

  Todo el modelo de regresión se implementa sobre una base de datos relacional utilizando SQL estándar para el procesamiento estadístico (medias, covarianzas, matrices, predicciones) y funciones programadas en **PL/pgSQL** para encapsular lógica compleja y automatizar el análisis. Esta integración refleja escenarios reales donde la base de datos actúa como motor de cálculo.
* **Docker**

  Se emplea para crear un entorno portable y reproducible, facilitando la ejecución del proyecto sin necesidad de configurar manualmente dependencias ni versiones.
* **Python + Faker**

  Utilizado exclusivamente para **generar datos sintéticos** de entrenamiento, introduciendo ruido controlado sobre relaciones lineales para simular escenarios realistas y facilitar la validación del modelo.
* **Dash (Plotly)**

  Herramienta ligera de visualización interactiva, usada para representar resultados como predicciones, residuos o métricas del modelo de forma accesible y reproducible desde navegado.

---

# Flujo de trabajo del proyecto

El proyecto se estructura en varias fases encadenadas que reflejan un proceso típico de ingeniería de datos aplicada a análisis estadístico:

1. **Inicialización del entorno**

   Se levanta la infraestructura necesaria mediante Docker, incluyendo una instancia de PostgreSQL lista para ejecutar código SQL y PL/pgSQL.
2. **Generación de datos sintéticos**

   Mediante un script en Python (`generate_dataset.py`), se crean datos artificiales que simulan relaciones lineales entre variables, introduciendo aleatoriedad controlada.
3. **Carga y preparación de la base de datos**

   Se crea la tabla de entrada y se insertan los datos generados. Se realizan comprobaciones para validar la correcta inserción y estructura del dataset.
4. **Cálculo de regresión en SQL**

   Se implementan paso a paso los componentes de una regresión lineal múltiple: medias, varianzas, covarianzas, coeficientes, predicciones y métricas de evaluación.
5. **Encapsulado de lógica en funciones**

   Toda la lógica estadística se abstrae dentro de una función en  **PL/pgSQL** , permitiendo reutilizarla con distintos datasets o esquemas sin repetir el código.
6. **Visualización de resultados**

   Se utiliza **Dash** para mostrar de forma interactiva los resultados: predicciones vs. reales, residuos, métricas o comparativas con otros modelos si se desea.

---

# Inicialización del entorno

---

# Generación de datos sintéticos

La regresión lineal múltiple se apoya en una serie de **supuestos estadísticos** que deben cumplirse para que los resultados del modelo sean válidos. En este proyecto generamos los datos sintéticos  **siguiendo cuidadosamente esos supuestos** , para construir una base sólida sobre la que validar y experimentar con el modelo.

A continuación explicamos cada uno de ellos, junto con lo que hacemos para asegurarnos de cumplirlo (y por qué esa estrategia es adecuada):

## 1. **Linealidad**

La regresión lineal solo captura relaciones  **lineales** . Si la relación real entre las variables no lo es, el modelo no podrá captarla y los coeficientes estimados serán incorrectos.

### ¿Qué hacemos?

Creamos la variable `y` como una combinación **estrictamente lineal** de `x1`, `x2` y `x3`:

<pre class="overflow-visible!" data-start="942" data-end="990"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>y = β₀ + β₁·x₁ + β₂·x₂ + β₃·x₃ + ε
</span></span></code></div></div></pre>

Esto garantiza que el modelo esté correctamente especificado y que los coeficientes que obtengamos en la regresión reflejen una relación real definida.

## 2. **Independencia de los errores**

Si los errores están correlacionados entre sí (por ejemplo, en datos temporales), los estimadores pueden dejar de ser válidos y se infravalora la incertidumbre en los tests estadísticos.

### ¿Qué hacemos?

Generamos ruido aleatorio sin estructura temporal:

<pre class="overflow-visible!" data-start="1452" data-end="1478"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>ε ~ N(</span><span>0</span><span>, σ²)
</span></span></code></div></div></pre>

Esto garantiza que los residuos no sigan un patrón ni dependan de observaciones anteriores. Así evitamos sesgos y errores en los intervalos de confianza.

## 3. **Homoscedasticidad**

Si la varianza del error cambia según el valor de alguna variable (`x`), hablamos de heterocedasticidad. Esto distorsiona los errores estándar y los tests t pierden validez.

### ¿Qué hacemos?

Para asegurar homcedasticidad creamos datos con desviación típica constante

<pre class="overflow-visible!" data-start="2026" data-end="2074"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>ε = np.random.normal(</span><span>0</span><span>, </span><span>3</span><span>)
</span></span></code></div></div></pre>

De este modo creamos datos homocedasticidad

## 4.**Normalidad de los errores**

Este supuesto es necesario para que los intervalos de confianza y los tests t y F sean estadísticamente válidos. Si no se cumple, las inferencias pueden ser incorrectas.

### ¿Qué hacemos?

El error `ε` se genera con distribución normal:

<pre class="overflow-visible!" data-start="2514" data-end="2540"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>ε ~ N(</span><span>0</span><span>, σ²)
</span></span></code></div></div></pre>

Así nos aseguramos de que los residuos del modelo (y no las `x`) tienen una distribución adecuada para aplicar inferencias estadísticas clásicas.

## 5. **Ausencia de multicolinealidad**

Si las variables predictoras están muy correlacionadas entre sí, el modelo no puede distinguir su efecto individual sobre `y`, lo que provoca coeficientes inestables.

### ¿Qué hacemos?

Generamos `x1`, `x2` y `x3` de forma **independiente** entre sí:

<pre class="overflow-visible!" data-start="2991" data-end="3085"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>x1 = np.random.normal(...)
x2 = np.random.normal(...)
x3 = np.random.normal(...)
</span></span></code></div></div></pre>

Esto evita colinealidad y permite que el modelo asigne coeficientes bien definidos y estables a cada predictor.

## 6. **Suficiente variabilidad en las predictoras**

Si una variable tiene un valor casi constante, no aporta nada al modelo. Necesitamos variabilidad para que tenga capacidad explicativa.

### ¿Qué hacemos?

Definimos las variables con distribuciones de varianza adecuada:

<pre class="overflow-visible!" data-start="3484" data-end="3545"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>x1 = np.random.normal(loc=</span><span>50</span><span>, scale=</span><span>10</span><span>, size=n)
</span></span></code></div></div></pre>

Así aseguramos que cada variable tiene valores diversos, lo que permite al modelo aprender relaciones reales y no ruido.

## 7. **Control sobre los coeficientes reales (`β`)**

> En problemas reales, los coeficientes verdaderos son desconocidos. Al definirlos nosotros mismos, podemos evaluar si el modelo los recupera correctamente y si los supuestos están afectando al resultado.

### ¿Qué hacemos?

Definimos explícitamente los coeficientes:

<pre class="overflow-visible!" data-start="3999" data-end="4047"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none rounded-t-[5px]">python</div><div class="sticky top-9"><div class="absolute end-0 bottom-0 flex h-9 items-center pe-2"><div class="bg-token-sidebar-surface-primary text-token-text-secondary dark:bg-token-main-surface-secondary flex items-center rounded-sm px-2 font-sans text-xs"><button class="flex gap-1 items-center select-none px-4 py-1" aria-label="Copiar"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copiar</button><span class="" data-state="closed"><button class="flex items-center gap-1 px-4 py-1 select-none"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-xs"><path d="M2.5 5.5C4.3 5.2 5.2 4 5.5 2.5C5.8 4 6.7 5.2 8.5 5.5C6.7 5.8 5.8 7 5.5 8.5C5.2 7 4.3 5.8 2.5 5.5Z" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round"></path><path d="M5.66282 16.5231L5.18413 19.3952C5.12203 19.7678 5.09098 19.9541 5.14876 20.0888C5.19933 20.2067 5.29328 20.3007 5.41118 20.3512C5.54589 20.409 5.73218 20.378 6.10476 20.3159L8.97693 19.8372C9.72813 19.712 10.1037 19.6494 10.4542 19.521C10.7652 19.407 11.0608 19.2549 11.3343 19.068C11.6425 18.8575 11.9118 18.5882 12.4503 18.0497L20 10.5C21.3807 9.11929 21.3807 6.88071 20 5.5C18.6193 4.11929 16.3807 4.11929 15 5.5L7.45026 13.0497C6.91175 13.5882 6.6425 13.8575 6.43197 14.1657C6.24513 14.4392 6.09299 14.7348 5.97903 15.0458C5.85062 15.3963 5.78802 15.7719 5.66282 16.5231Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path><path d="M14.5 7L18.5 11" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg>Editar</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr"><code class="whitespace-pre! language-python"><span><span>β₀ = </span><span>5</span><span>
β₁ = </span><span>0.8</span><span>
β₂ = -</span><span>1.2</span><span>
β₃ = </span><span>2.5</span><span>
</span></span></code></div></div></pre>

Esto permite comparar los coeficientes estimados con los reales, medir el error de estimación, y comprobar si se ven afectados por la heterocedasticidad o colinealidad. Es una práctica excelente para validar un modelo en condiciones controladas.

---

# Carga y preparación de la base de datos

Una vez generados los datos sintéticos, es necesario cargarlos en la base de datos y preparar el entorno para poder ejecutar sobre él los análisis posteriores. Esta etapa reproduce una parte esencial de la ingeniería de datos: la integración de datos externos en un sistema relacional, asegurando su validez estructural y semántica antes del modelado.

## Creación automática de la estructura

La base de datos se define automáticamente al levantar el contenedor PostgreSQL gracias a la variable `POSTGRES_DB=regression`. La tabla de entrada `datos` se crea mediante un script SQL alojado en `docker-entrypoint-initdb.d`, lo que asegura su ejecución únicamente en la inicialización del entorno.

Además, se implementa un mecanismo de verificación desde Python que comprueba que la tabla ha sido creada correctamente antes de insertar los datos, generando un log estructurado de cada paso.

## Inserción de los datos desde Python

La inserción de los datos se realiza desde un script en Python (`insertar_datos.py`) que utiliza `psycopg2` para iterar sobre cada fila del CSV generado previamente. Antes de realizar esta operación, los datos pasan por una fase de validación (`validar_datos.py`) que garantiza:

* Ausencia de valores nulos o inconsistentes.
* Coherencia estadística (valores dentro de rangos esperados, correlaciones mínimas).
* Cumplimiento de los supuestos necesarios para aplicar regresión lineal.

Este control garantiza que los datos que ingresan en la base son aptos para su análisis posterior.

## Validación estructural de la carga

Tras la inserción, se realiza una segunda validación conectando de nuevo a PostgreSQL para comprobar que la tabla contiene el número esperado de registros. Todo este proceso queda registrado mediante un sistema centralizado de `logging`, que genera un archivo `.log` por ejecución, permitiendo rastrear en detalle cualquier anomalía.

---


# Cálculo de Regresión Lineal Múltiple en SQL

Este proyecto implementa, paso a paso, una regresión lineal múltiple utilizando únicamente SQL sobre una base de datos PostgreSQL. El objetivo es demostrar cómo puede desarrollarse un flujo completo de análisis predictivo sin salir del lenguaje SQL, lo cual es ideal tanto para consolidar fundamentos matemáticos como para mostrar dominio de SQL avanzado en un contexto realista.

Cada etapa se ejecuta mediante scripts independientes, lo que permite verificar manualmente cada componente del modelo antes de encapsularlo en funciones reutilizables o procedimientos almacenados (`PL/pgSQL`).

---

## 1. Verificación previa de los datos

Antes de ajustar el modelo, se comprueban los supuestos fundamentales para evitar errores silenciosos en las predicciones:

- Detección de nulos y duplicados
- Cálculo de estadísticas descriptivas (`AVG`, `STDDEV_POP`, etc.)
- Análisis de correlación entre predictores (`CORR`)
- Revisión manual de escalado, normalidad y dispersión

## 2. División en train/test

Se realiza un particionado aleatorio de los datos mediante `RANDOM()` para evaluar el modelo en observaciones no vistas:

```sql
SELECT *, 
       CASE WHEN RANDOM() < 0.8 THEN 'train' ELSE 'test' END AS conjunto
FROM datos;
```


## 3. Ajuste del modelo (cálculo de coeficientes)

Se implementa el cálculo de los coeficientes `β` a partir de la fórmula matricial de mínimos cuadrados:

$$
\beta = (X^TX)^{-1}X^Ty
$$

En SQL, este cálculo se descompone en:

* Cálculo de medias y varianzas de los predictores
* Cálculo de covarianzas cruzadas (`COVAR_POP`)
* Cálculo manual del intercepto `β₀` y los coeficientes `β₁...βₙ`

Los coeficientes se almacenan en una tabla `modelo_coeficientes` para poder ser reutilizados en predicciones posteriores.

## 4. Predicción

Aplicando la ecuación del modelo, se calcula la variable `y_pred` sobre el conjunto de test:

```sql
SELECT *,
       beta_0 + beta_1 * edad + beta_2 * nivel_estudios + beta_3 * anos_experiencia AS y_pred
FROM datos_split
WHERE conjunto = 'test';
```

Los resultados se almacenan en una nueva tabla `predicciones`.

## 5. Evaluación del modelo

Se calculan métricas de rendimiento sobre el conjunto de test mediante agregaciones:

* **MAE** (Mean Absolute Error)
* **RMSE** (Root Mean Squared Error)
* **R²** (Coeficiente de determinación)

Estas métricas permiten comparar distintos ajustes y detectar posibles sobreajustes.

## 6. Análisis de los residuos

Para validar los supuestos del modelo, se analizan los residuos:

$$
\text{residuo} = y - \hat{y}
$$


Entre los análisis realizados:

* Comprobación de que la **media ≈ 0**
* Cálculo de la **desviación estándar**
* Detección de **outliers residuales** (|residuo| > 3σ)
* Cálculo del **percentil 95** del error absoluto
* Evaluación del **rango intercuartílico (IQR)**

Estos indicadores ayudan a comprobar la calidad del ajuste y la estabilidad del modelo.

## 7. Importancia de variables

Se calcula una medida de importancia relativa de cada predictor como:

$$
\text{impacto}_i = |\beta_i|\cdot std(x_i)
$$

Esto permite comparar el peso efectivo de cada variable incluso si no están estandarizadas. La variable con mayor impacto se almacena en el resumen final del modelo.

## 8. Registro del modelo

Finalmente, se encapsula todo en un resumen almacenado en la tabla `registro_modelo`, que incluye:

* Fecha de entrenamiento
* MAE, RMSE, R²
* Desviación de residuos
* Percentil 95 del error
* Variable más influyente

Este paso permite versionar los modelos y hacer seguimiento de su evolución.

## ¿Por qué hacerlo paso a paso?

Este enfoque modular no solo facilita la validación de cada componente del modelo, sino que también permite:

* Detectar errores de cálculo tempranos
* Justificar cada decisión con evidencia numérica
* Asegurar interpretabilidad antes de encapsular lógica en funciones SQL o procedimientos almacenados

Una vez validado, el flujo puede compactarse en funciones `PL/pgSQL` para producción o automatización.
