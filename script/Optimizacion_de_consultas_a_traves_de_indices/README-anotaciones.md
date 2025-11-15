## Tarea 1: Carga de Datos

El objetivo de esta primer tarea fue realizar una carga de datos con un gran volumen. Se buscaba poblar una tabla con al menos 1 millón de registros, esta tabla debía incluir un campo de fecha, el cual no tendría ningún indice.

Se eligió la tabla rrhh.persona debido a que es una tabla padre, lo cual facilita el proceso de almacenar estos datos, y por contar con el campo ‘created_at’ de tipo (DATETIMEOFFSET), ideal para las pruebas de rangos de fecha.

(imagenes)

Como la tarea requería un script para automatizar la carga, se utilizo un script T-SQL. Este script consiste en un bucle WHILE que se ejecuta 1 millón de veces.

(imagen)

Al finalizar la ejecución del script, la tabla rrhh.persona quedo poblada con 1 millón de filas únicas, con datos aleatorios y una amplia variedad de fechas en la columna ‘created_at’.



## Tarea 2: Prueba 1 (Sin Índice)

Resultados de la prueba 1 (Sin indice)
Se ejecuto una consulta de búsqueda por periodo (mes de mayo del año 2020) sobre la tabla rrhh.persona, que contiene 1 millón de registros.
- Tiempo transcurrido: 61ms.
- Filas encontradas: 4077.

(imagen)

El tiempo transcurrido fue bastante rápido para un escaneo de 1 millón de registros, debido a que los datos estaban en la cache de memoria, de igual manera el plan de ejecución revelo que el motor realizo un Clustered Index Scan, forzándolo a leer la tabla completa. Esto es ineficiente y no es escalable.

(imagen)

El plan de ejecución muestra que la operación mas costosa (98% del costo total) fue un ‘Clustered Index Scan’. Un método muy ineficiente, debido a que el motor tuvo que leer el millón de filas.



## Tarea 3: Prueba 2 (Con Índice Agrupado)

Se repitió la consulta de búsqueda por periodo (mes de mayo del año 2020) después de haber creado un indice agrupado (Clustered Index) en la columna ‘created_at’.

(imagen)

Si comparamos con el tiempo de la consulta anterior (sin indice): 61ms, y la nueva consulta con tiempo: 26ms, notamos que ahora la consulta es mucho mas rápida, una mejora de rendimiento bastante significativa a pesar de que la consulta original también fue rápida.

(imagen)

Gracias a que el indice reordeno físicamente toda la tabla por fecha, el motor de SQL Server supo exactamente por donde ir, logrando una gran eficiencia.

*(Nota: En la Tarea 4 se borró este índice para la siguiente prueba).*



## Tarea 5: Prueba 3 (Con Índice de Cobertura)

Se creo un indice no agrupado (Non-Clustered) en created_at con una clausula INCLUDE para las columnas dni, nombre, apellido y mail.

(imagen)

El tiempo transcurrido fue de: 22ms.

(imagen)

Este plan representa una optimización de ‘cobertura’ (Covering Index), y es, en teoría, el método mas eficiente para esta consulta especifica. Gracias a la clausula INCLUDE, el propio indice ya contenía una copia de las columnas dni, nombre, apellido y mail. Y al igual que en la tarea 3, el motor utilizo para buscar (seek) y saltar directamente a los registros del año 2020, ignorando el resto de la tabla.



## Tarea 6: Conclusiones

Luego de haber puesto a prueba los tres métodos de consulta, se demuestra una diferencia clave en la eficiencia y el tiempo de respuesta. Los resultados de las pruebas (para un periodo de 1 mes) nos dejan un claro aprendizaje sobre como la estrategia de acceso a los datos impacta en el rendimiento:

Para la prueba 1: Sin indice, se utilizo el método Clustered Index Scan, con un tiempo de 61ms. En esta prueba, el motor de SQL Server se vio forzado a realizar un escaneo completo de la tabla, lo que implica leer el millón de registros, uno por uno, para comparar cuales cumplían con el filtro de fecha.

Para la prueba 2: Con indice agrupado, se utilizo el método Clustered Index Seek, con un tiempo de 26ms. Al crear el indice agrupado en la fecha, la tabla se reordeno físicamente por esa columna, por lo tanto el motor ya no tuvo que escanear, sino que pudo realizar una búsqueda directa, saltando inmediatamente al periodo de mayo de 2020 y leer solo las filas necesarias.

Para la prueba 3: Con indice de cobertura, se utilizo el método Index Seek, con un tiempo de 22ms, el mas rápido registrado. Este método fue mas eficiente, se creo un indice no agrupado en la fecha, pero se incluyeron (INCLUDE) las columnas del SELECT (dni, nombre, apellido, etc.). El motor no solo realizo una búsqueda directa como en la prueba 2, sino que ademas obtuvo todos los datos que necesitaba del propio indice, sin siquiera tener que tocar la tabla principal, representando la optimización ideal para esta consulta especifica.

Este proyecto nos enseña que la optimización de bases de datos es una parte clave del diseño. No alcanza con solo ‘crear un indice’. La lección mas importante es que debemos pensar en como vamos a buscar los datos para poder elegir el tipo de indice correcto. También nos enseña que la diferencia entre una consulta lenta y una rápida esta en lograr que el motor de la base de datos pase de un Scan (leer la tabla entera) a un Seek (una búsqueda directa y precisa).
