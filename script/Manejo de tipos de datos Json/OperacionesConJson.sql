/*
=========================================================================
Tema: Manejo de tipos de datos JSON en SQL Server
=========================================================================

**Objetivos de Aprendizaje:**
1. Conocer el manejo de tipos de datos JSON en bases de datos relacionales.
2. Implementar operaciones CRUD sobre datos almacenados en formato JSON.

**Tareas:**
1. Crear una nueva tabla con una columna JSON.
2. Agregar datos no estructurados en formato JSON y realizar operaciones de 
   actualización, agregación y borrado.
3. Ejecutar operaciones de consulta sobre datos JSON.
4. Optimizar consultas para estas estructuras JSON.

*/

USE RelevamientoEducativo;
GO


--EJEMPLO INICIAL: Convertir datos relacionales a JSON con FOR JSON

-- Ejemplo 1: FOR JSON AUTO - Convierte automaticamente
SELECT TOP 3 
    id_escuela, 
    cue, 
    nombre, 
    telefono
FROM institucional.escuela
FOR JSON AUTO;

-- Ejemplo 2: FOR JSON PATH - Mayor control sobre la estructura
SELECT TOP 3
    cue AS "Escuela.CUE",
    nombre AS "Escuela.Nombre",
    z.descripcion AS "Escuela.Zona"
FROM institucional.escuela e
JOIN institucional.zona z ON e.id_zona = z.id_zona
FOR JSON PATH;

-- Ejemplo 3: FOR JSON PATH, WITHOUT_ARRAY_WRAPPER - Sin corchetes (un solo objeto)
SELECT TOP 1 
    cue, 
    nombre, 
    telefono 
FROM institucional.escuela
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

GO

--TAREA 1: Crear una nueva tabla con una columna JSON

-- Crear tabla para almacenar datos variables de escuelas en formato JSON
CREATE TABLE relevamiento.escuela_info_json (
    id_info INT IDENTITY(1,1) NOT NULL,
    id_escuela INT NOT NULL,
    anio INT NOT NULL,
    info_relevamiento NVARCHAR(MAX) NULL, -- Columna para datos JSON
    fecha_carga DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_escuela_info_json PRIMARY KEY (id_info),
    CONSTRAINT FK_escuela_info_json FOREIGN KEY (id_escuela) 
        REFERENCES institucional.escuela (id_escuela)
);
GO

-- Agregar constraint para verificar que solo se ingresen datos en formato JSON
ALTER TABLE relevamiento.escuela_info_json
ADD CONSTRAINT CK_escuela_info_isjson CHECK (ISJSON(info_relevamiento) > 0);
GO


--TAREA 2: Insertar datos en formato JSON

-- Insertar datos de escuelas con informacion de infraestructura en JSON
INSERT INTO relevamiento.escuela_info_json (id_escuela, anio, info_relevamiento)
SELECT 
    e.id_escuela,
    2024 AS anio,
    JSON_QUERY(
        CONCAT(
            '{"CUE": "', e.cue, '", ',
            '"Nombre": "', e.nombre, '", ',
            '"Zona": "', z.descripcion, '", ',
            '"Categoria": "', c.descripcion, '", ',
            '"Turno": "', t.descripcion, '", ',
            '"Modalidad": "', m.descripcion, '", ',
            '"Servicio_Comida": "', sc.nombre, '", ',
            '"Infraestructura": {',
                '"Total_Aulas": 12, ',
                '"Aulas_Con_Proyector": 8, ',
                '"Laboratorio_Informatica": 1, ',
                '"Biblioteca": 1, ',
                '"Gimnasio": 1',
            '}, ',
            '"Conectividad": {',
                '"Tipo": "Fibra Optica", ',
                '"Velocidad_Mbps": 100, ',
                '"Proveedor": "Telecom"',
            '}, ',
            '"Estado_Edilicio": "Bueno"}'
        )
    ) AS info_relevamiento
FROM institucional.escuela e
JOIN institucional.zona z ON e.id_zona = z.id_zona
JOIN institucional.categoria c ON e.id_categoria = c.id_categoria
JOIN institucional.turno t ON e.id_turno = t.id_turno
JOIN institucional.modalidad m ON e.id_modalidad = m.id_modalidad
JOIN institucional.servicio_comida sc ON e.id_serv_comida = sc.id_serv_comida
WHERE e.id_escuela IN (1, 2, 3); -- Insertar para las primeras 3 escuelas
GO

-- Insertar datos adicionales con estructura diferente (proyectos especiales)
INSERT INTO relevamiento.escuela_info_json (id_escuela, anio, info_relevamiento)
VALUES 
(1, 2024, N'{
    "Proyectos": [
        {"Nombre": "Robotica", "Participantes": 45, "Presupuesto": 50000},
        {"Nombre": "Huerta Escolar", "Participantes": 60, "Presupuesto": 15000}
    ],
    "Equipamiento": {
        "Notebooks": 25,
        "PcEscritorio": 15,
        "Tablets": 30,
        "Proyectores": 8
    }
}');
GO

--Operaciones de actualizacion con JSON_MODIFY

-- Actualizacion 1: Modificar un campo especifico (aumentar velocidad de internet)
UPDATE relevamiento.escuela_info_json
SET info_relevamiento = JSON_MODIFY(
    info_relevamiento, 
    '$.Conectividad.Velocidad_Mbps', 
    200
)
WHERE id_escuela = 1 AND ISJSON(info_relevamiento) > 0;
GO

-- Actualizacion 2: Cambiar estado edificio segun zona
UPDATE relevamiento.escuela_info_json
SET info_relevamiento = JSON_MODIFY(
    info_relevamiento,
    '$.Estado_Edilicio',
    CASE 
        WHEN JSON_VALUE(info_relevamiento, '$.Zona') LIKE '%Rural%' THEN 'Regular - Requiere Mantenimiento'
        WHEN JSON_VALUE(info_relevamiento, '$.Zona') LIKE '%Urbana Central%' THEN 'Muy Bueno'
        ELSE 'Bueno'
    END
)
WHERE ISJSON(info_relevamiento) > 0;
GO

-- Actualizacion 3: Agregar nueva propiedad (WiFi cobertura)
UPDATE relevamiento.escuela_info_json
SET info_relevamiento = JSON_MODIFY(
    info_relevamiento, 
    '$.Conectividad.WiFi_Cobertura_Porcentaje', 
    95
)
WHERE id_escuela = 1;
GO

-- Actualizacion 4: Modificar multiples campos anidados
UPDATE relevamiento.escuela_info_json
SET info_relevamiento = JSON_MODIFY(
    JSON_MODIFY(
        info_relevamiento,
        '$.Infraestructura.Total_Aulas',
        15  -- Aumentar aulas
    ),
    '$.Infraestructura.Aulas_Con_Proyector',
    12  -- Aumentar proyectores
)
WHERE id_escuela = 1;
GO

--Operaciones de BORRADO

-- Borrado 1: Eliminar una propiedad del JSON (establecer en NULL)
UPDATE relevamiento.escuela_info_json
SET info_relevamiento = JSON_MODIFY(
    info_relevamiento, 
    '$.Conectividad.WiFi_Cobertura_Porcentaje', 
    NULL
)
WHERE id_escuela = 1;
GO

-- Borrado 2: Eliminar un registro completo
-- Primero insertar un registro temporal
INSERT INTO relevamiento.escuela_info_json (id_escuela, anio, info_relevamiento)
VALUES (1, 2023, N'{"Temporal": true, "Dato": "Para eliminar"}');
GO

-- Ahora eliminarlo
DELETE FROM relevamiento.escuela_info_json 
WHERE JSON_VALUE(info_relevamiento, '$.Temporal') = 'true';
GO

--TAREA 3: Consultas sobre datos JSON

-- Consulta 1: Extraer un campo especifico con JSON_VALUE
SELECT 
    id_escuela,
    JSON_VALUE(info_relevamiento, '$.Nombre') AS Nombre_Escuela,
    JSON_VALUE(info_relevamiento, '$.Estado_Edilicio') AS Estado
FROM relevamiento.escuela_info_json
WHERE anio = 2024;
GO

-- Consulta 2: Extraer multiples campos del JSON
SELECT	
    JSON_VALUE(info_relevamiento, '$.Nombre') AS Escuela, 
    JSON_VALUE(info_relevamiento, '$.Zona') AS Zona,
    JSON_VALUE(info_relevamiento, '$.Conectividad.Velocidad_Mbps') AS Velocidad_Internet,
    JSON_VALUE(info_relevamiento, '$.Conectividad.Tipo') AS Tipo_Conexion
FROM relevamiento.escuela_info_json
WHERE ISJSON(info_relevamiento) > 0;
GO

-- Consulta 3: Filtrar por valores dentro del JSON
SELECT	
    JSON_VALUE(info_relevamiento, '$.Nombre') AS Escuela,
    JSON_VALUE(info_relevamiento, '$.Infraestructura.Total_Aulas') AS Aulas
FROM relevamiento.escuela_info_json
WHERE TRY_CAST(JSON_VALUE(info_relevamiento, '$.Infraestructura.Total_Aulas') AS INT) >= 12;
GO

-- Observar el plan de ejecucion (Index Scan - no optimizado)
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT	
    JSON_VALUE(info_relevamiento, '$.Nombre') AS Escuela
FROM relevamiento.escuela_info_json
WHERE JSON_VALUE(info_relevamiento, '$.Zona') = 'Zona A - Urbana Central'
  AND TRY_CAST(JSON_VALUE(info_relevamiento, '$.Conectividad.Velocidad_Mbps') AS INT) >= 100;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

--Observamos en el plan de ejecucion que se realiza un Index Scan (tabla completa)

-- Consulta 4: Extraer array completo con JSON_QUERY
SELECT 
    id_escuela,
    JSON_QUERY(info_relevamiento, '$.Infraestructura') AS Info_Infraestructura,
    JSON_QUERY(info_relevamiento, '$.Conectividad') AS Info_Conectividad
FROM relevamiento.escuela_info_json;
GO

-- Consulta 5: Expandir array JSON con OPENJSON
SELECT 
    ej.id_escuela,
    proyecto.Nombre AS Proyecto,
    proyecto.Participantes,
    proyecto.Presupuesto
FROM relevamiento.escuela_info_json ej
CROSS APPLY OPENJSON(info_relevamiento, '$.Proyectos')
    WITH (
        Nombre NVARCHAR(100) '$.Nombre',
        Participantes INT '$.Participantes',
        Presupuesto INT '$.Presupuesto'
    ) AS proyecto
WHERE ISJSON(info_relevamiento) > 0;
GO
