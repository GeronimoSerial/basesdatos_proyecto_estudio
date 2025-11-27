# Tema: Manejo de tipos de datos JSON en SQL Server





## Objetivos de Aprendizaje:



- Conocer el manejo de tipos de datos JSON en bases de datos relacionales.

- Implementar operaciones CRUD sobre datos almacenados en formato JSON.



## Tareas:



- Crear una nueva tabla con una columna JSON.

- Agregar datos no estructurados en formato JSON y realizar operaciones de actualización, agregación y borrado.

- Ejecutar operaciones de consulta sobre datos JSON.

- Optimizar consultas para estas estructuras JSON.



## Teoría

El manejo de JSON (JavaScript Object Notation) es relevante cuando se trabaja con integraciones de sistemas externos, ya que permite el intercambio de datos de manera eficiente y estructurada. JSON es útil para almacenar configuraciones de productos o integrar datos de ventas desde otras plataformas. Otro beneficio es que los datos de tipo JSON es su longitud que puede ser variable. Dentro de un JSON se puede agregar tags nuevos e insertar nuevos datos sin afectar a los demás campos y sin la necesidad de crear nuevas columnas. En SQL Server, en lugar de un tipo de datos JSON explícito, se usa el tipo de datos NVARCHAR (normalmente NVARCHAR(MAX)) para almacenar los datos JSON. Luego, se utilizan funciones JSON nativas para manipular y consultar datos.

- Crear una nueva tabla con una columna JSON.

### 1. Creación de Estructura 

- Creación de Tabla: Se creó la tabla relevamiento.escuela_info_json con una columna (info_relevamiento) de tipo NVARCHAR(MAX) designada para almacenar el contenido JSON.

•	Validación de Formato: Se agregó una restricción (CHECK (ISJSON(info_relevamiento) > 0)) para asegurar que solo se puedan insertar strings que cumplan con el formato JSON válido, manteniendo la integridad del dato.


- Agregar datos no estructurados en formato JSON y realizar operaciones de actualización, agregación y borrado.


### 2. CRUD (Creación, Lectura, Actualización y Borrado) 

| Operación | Funciones | Descripción |
|-----------|-----------|-------------|
| CREATE (Insertar) | JSON_QUERY, CONCAT | Se insertaron registros iniciales con datos JSON complejos, mezclando datos relacionales (id_escuela, anio) con datos no estructurados (infraestructura, conectividad). |
| UPDATE (Actualizar) | JSON_MODIFY | Se realizaron múltiples actualizaciones para: 1. Modificar valores existentes (e.g., aumentar la velocidad de internet). 2. Modificar múltiples campos anidados. 3. Agregar nuevas propiedades al JSON. |
| DELETE (Borrar) | JSON_MODIFY, DELETE | Se demostró cómo eliminar una propiedad del JSON (asignando NULL con JSON_MODIFY) y cómo eliminar un registro completo basándose en un valor dentro del JSON (JSON_VALUE). |


- Ejecutar operaciones de consulta sobre datos JSON.


### 3. Consultas y Extracción de Datos 

Se utilizó la funcionalidad JSON de SQL Server para extraer información del contenido JSON:

- Extracción de Valores Escalados: Uso de la función JSON_VALUE para obtener valores atómicos (strings, números) de rutas específicas.

- Extracción de Sub-Objetos o Arrays: Uso de la función JSON_QUERY para extraer objetos o arrays completos, manteniendo el formato JSON.

- Expansión de Arrays (Rowset): Uso de la función OPENJSON en conjunto con CROSS APPLY para convertir un array JSON anidado (ej. $.Proyectos) en un conjunto de filas (rowset), permitiendo su consulta como datos tabulares relacionales.


- Optimizar consultas para estas estructuras JSON.


### 4. Optimización de Consultas 

Se abordó la mejora del rendimiento de las consultas JSON, que por defecto tienden a realizar Index Scans (lectura de tabla completa):

- Columnas Calculadas PERSISTED: Se crearon columnas calculadas (e.g., Zona, Velocidad_Internet) que materializan (almacenan físicamente) valores extraídos del JSON usando JSON_VALUE o TRY_CAST.

- Indexación: Se creó un índice (IDX_EscuelaJson_Zona_Velocidad) sobre la columna calculada Zona, incluyendo otras columnas de interés.

- Comparativa de Performance: Se demostró cómo la consulta que utiliza las columnas calculadas indexadas cambia el Plan de Ejecución de un ineficiente Index Scan a un eficiente Index Seek, logrando una mejora significativa en el tiempo de respuesta, especialmente en tablas grandes.


--------------------------------------------------------------------------------


## Conclusiones sobre el uso de JSON en SQL Server


### Relevancia del manejo de JSON

El manejo de JSON (JavaScript Object Notation) es especialmente relevante al trabajar con integraciones de sistemas externos. Esta tecnología permite el intercambio de datos de manera eficiente y estructurada, lo cual resulta fundamental en escenarios donde es necesario conectar diferentes plataformas. Por ejemplo, JSON facilita el almacenamiento de configuraciones de productos y la integración de datos de ventas provenientes de otras fuentes.

### Ventajas de la estructura JSON

Una de las principales ventajas de los datos de tipo JSON es la flexibilidad que ofrece en cuanto a su longitud, que puede ser variable. Esto permite agregar nuevos tags e insertar información adicional dentro del mismo objeto JSON sin afectar los demás campos y sin la necesidad de modificar el esquema de la base de datos, como la creación de nuevas columnas.

### Implementación en SQL Server

En SQL Server, no existe un tipo de datos JSON explícito. En su lugar, se utiliza el tipo de datos NVARCHAR (generalmente NVARCHAR(MAX)) para almacenar la información en formato JSON. Posteriormente, se emplean funciones nativas de JSON para manipular y consultar estos datos de manera eficiente.

### Ventajas del uso de datos JSON en SQL Server

#### Versatilidad

El manejo de datos JSON en SQL Server permite trabajar con grandes volúmenes de datos semi-estructurados sin la necesidad de crear múltiples tablas. Esta característica resulta especialmente útil cuando se requiere almacenar información adicional sin comprometer la integridad de la base de datos.

#### Flexibilidad en Actualizaciones

Una de las principales ventajas de JSON es la posibilidad de agregar o modificar propiedades sin necesidad de alterar el esquema de la tabla. Esto facilita la gestión de cambios en columnas JSON bien estructuradas, donde las consultas no suelen ser demasiado complejas.

#### Eficiencia en Almacenamiento

La consolidación de múltiples atributos dentro de un solo campo JSON permite reducir la cantidad de columnas en la tabla y simplificar el diseño de la base de datos. El campo JSON puede crecer y ser editado, siempre respetando el límite de caracteres asignado a la columna. Sin embargo, a medida que aumenta el tamaño del JSON, también crecen las implicancias en el rendimiento de las consultas.

### Desventajas del uso de datos JSON en SQL Server

#### Rendimiento

Las consultas que involucran datos JSON pueden resultar más lentas comparadas con aquellas que utilizan columnas tradicionales. Aunque es posible crear columnas calculadas e índices para mejorar el rendimiento, estas soluciones no siempre son óptimas para consultas complejas. Además, el uso excesivo de índices puede generar problemas de rendimiento debido a la naturaleza de los datos JSON.

#### Mantenimiento

La utilización de datos JSON requiere validaciones adicionales y pruebas de rendimiento, especialmente en sistemas donde los datos semi-estructurados son extensos. El tiempo que demanda resolver consultas complejas de manera eficiente puede afectar el rendimiento y exige mayor atención por parte del equipo de desarrollo.

### Consideraciones finales para el uso de JSON en SQL Server

El uso de JSON en SQL Server resulta muy útil, por ejemplo, para exportar información requerida por otros sistemas. Sus principales desventajas están relacionadas con el tamaño, la complejidad en el diseño de la base de datos y la complejidad de los datos almacenados en formato JSON.
Una forma efectiva de aprovechar el potencial de los datos semi-estructurados en formato JSON es utilizarlos para guardar información que pueda cambiar con el tiempo, pero que no comprometa el diseño estructural de la base de datos. Es decir, aquellos datos que complementan al sistema y son necesarios, pero que, por su naturaleza cambiante, pueden almacenarse en JSON, aprovechando sus ventajas y evitando la necesidad de modificar el modelo de la base SQL.


