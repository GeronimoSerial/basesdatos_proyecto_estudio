## Tema: Optimización de consultas a través de índices

### Objetivos de Aprendizaje:

- Conocer los tipos de índices y sus aplicaciones.
- Evaluar el impacto de los índices en el rendimiento de las consultas.

### Criterios de Evaluación:

- Medición correcta de los tiempos de respuesta antes y después de aplicar índices.
- Documentación detallada de los planes de ejecución de las consultas.
- Evaluación de la mejora en el rendimiento.

### Tareas:

- Realizar una carga masiva de por lo menos un millón de registro sobre alguna tabla que contenga un campo fecha (sin índice). Hacerlo con un script para poder automatizarlo.
- Realizar una búsqueda por periodo y registrar el plan de ejecución utilizado por el motor y los tiempos de respuesta.
- Definir un índice agrupado sobre la columna fecha y repetir la consulta anterior. Registrar el plan de ejecución utilizado por el motor y los tiempos de respuesta.
- Borrar el índice creado
- Definir otro índice agrupado sobre la columna fecha pero que además incluya las columnas seleccionadas y repetir la consulta anterior. Registrar el plan de ejecución utilizado por el motor y los tiempos de respuesta.
- Expresar las conclusiones en base a las pruebas realizadas.
