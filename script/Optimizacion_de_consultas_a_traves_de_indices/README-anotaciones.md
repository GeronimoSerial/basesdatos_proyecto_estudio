## Tarea 1: Carga de Datos

[cite_start]El objetivo fue poblar la tabla `rrhh.persona` con 1 millón de registros[cite: 3]. [cite_start]Esta tabla se eligió por ser una tabla padre y por contener el campo `created_at` (DATETIMEOFFSET) sin índice, ideal para las pruebas[cite: 3, 4].

[cite_start]Se utilizó un script T-SQL con un bucle `WHILE` que se ejecutó 1 millón de veces, insertando datos aleatorios y una amplia variedad de fechas[cite: 5, 6, 7].

---

## 📊 Tarea 2: Prueba 1 (Sin Índice)

[cite_start]Se ejecutó una consulta de búsqueda por rango de fechas (mayo de 2020) sobre la tabla con 1 millón de registros[cite: 10].

* [cite_start]**Filas encontradas:** 4077 [cite: 12]
* [cite_start]**Tiempo transcurrido:** 61ms [cite: 11]

[cite_start]Aunque el tiempo fue rápido (por la caché de memoria), el plan de ejecución mostró un **Clustered Index Scan**[cite: 13]. [cite_start]Esto significa que el motor leyó la tabla completa (1 millón de filas), lo cual es muy ineficiente y no es escalable[cite: 14, 15, 16].

---

## 📈 Tarea 3: Prueba 2 (Con Índice Agrupado)

[cite_start]Se creó un **Índice Agrupado (Clustered Index)** en la columna `created_at` [cite: 18] y se repitió la consulta.

* **Filas encontradas:** 4077
* [cite_start]**Tiempo transcurrido:** 26ms [cite: 19]

[cite_start]La mejora es significativa[cite: 19]. El plan de ejecución cambió a un **Clustered Index Seek**. [cite_start]Gracias a que el índice reordenó físicamente la tabla por fecha, el motor pudo "saltar" directamente a los datos de mayo de 2020 sin leer toda la tabla[cite: 20, 35].

[cite_start]*(Nota: En la Tarea 4 se borró este índice para la siguiente prueba [cite: 22]).*

---

## ⚡ Tarea 5: Prueba 3 (Con Índice de Cobertura)

[cite_start]Se creó un **Índice No Agrupado (Non-Clustered)** en `created_at`, usando la cláusula `INCLUDE` para añadir las columnas `dni`, `nombre`, `apellido` y `mail`[cite: 24].

* **Filas encontradas:** 4077
* [cite_start]**Tiempo transcurrido:** 22ms [cite: 25]

[cite_start]Este fue el método más rápido[cite: 36]. [cite_start]El plan usó un **Index Seek**[cite: 36]. [cite_start]Esta es una optimización de "cobertura" (Covering Index)[cite: 26]. [cite_start]El motor no solo saltó directamente a los datos de 2020, sino que **obtuvo todas las columnas que necesitaba del propio índice**, sin tener que tocar la tabla principal[cite: 27, 28, 38].

---

## 💡 Tarea 6: Conclusiones

[cite_start]Los resultados demuestran el impacto de la estrategia de acceso[cite: 30, 31]:

| Prueba | Método de Acceso | Tiempo | Eficiencia |
| :--- | :--- | :--- | :--- |
| **Prueba 1** | Clustered Index **Scan** | 61ms | [cite_start]Muy baja (leyó 1M de filas) [cite: 32, 33] |
| **Prueba 2** | Clustered Index **Seek** | 26ms | [cite_start]Alta (saltó a los datos) [cite: 34, 35] |
| **Prueba 3** | Index **Seek** (Covering) | 22ms | [cite_start]Óptima (saltó a los datos y los leyó del índice) [cite: 36, 38] |

> **Lección principal:** No basta con "crear un índice". [cite_start]Debemos analizar cómo se buscarán los datos para elegir el tipo de índice correcto[cite: 40].
>
> [cite_start]La diferencia clave está en lograr que el motor pase de un **Scan** (leer todo) a un **Seek** (búsqueda directa)[cite: 41].

---

### Anexos: Scripts y Planes de Ejecución

*(Aquí es donde deberás insertar tus imágenes y bloques de código)*

