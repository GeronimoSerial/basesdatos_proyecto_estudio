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

