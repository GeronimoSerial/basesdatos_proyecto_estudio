/*
===================================================================================
TAREA 1: SCRIPT DE CARGA AUTOMATIZADA (1 MILLÓN DE FILAS) EN LA TABLA rrhh.persona
===================================================================================
*/

-- Tabla temporal de Nombres
DECLARE @Nombres TABLE (id INT IDENTITY(1,1) PRIMARY KEY, nombre VARCHAR(50));
INSERT INTO @Nombres (nombre) VALUES
('Juan'), ('María'), ('Carlos'), ('Ana'), ('Luis'), ('Elena'), ('José'), ('Laura'),
('Miguel'), ('Sofía'), ('Diego'), ('Lucía'), ('Pedro'), ('Marta'), ('Javier'), ('Paula'),
('David'), ('Sara'), ('Fernando'), ('Carmen'), ('Alejandro'), ('Isabel'), ('Daniel'), ('Patricia'),
('Manuel'), ('Clara'), ('Sergio'), ('Cristina'), ('Pablo'), ('Raquel'); -- 30 nombres

-- Tabla temporal de Apellidos
DECLARE @Apellidos TABLE (id INT IDENTITY(1,1) PRIMARY KEY, apellido VARCHAR(50));
INSERT INTO @Apellidos (apellido) VALUES
('García'), ('Rodríguez'), ('González'), ('Fernández'), ('López'), ('Martínez'), ('Sánchez'), ('Pérez'),
('Gómez'), ('Martín'), ('Jiménez'), ('Ruiz'), ('Hernández'), ('Díaz'), ('Moreno'), ('Álvarez'),
('Muñoz'), ('Romero'), ('Alonso'), ('Gutiérrez'), ('Navarro'), ('Torres'), ('Domínguez'), ('Vázquez'),
('Ramos'), ('Gil'), ('Ramírez'), ('Serrano'), ('Blanco'), ('Suárez'); -- 30 apellidos


-- Iniciamos la carga de datos
DECLARE @i INT = 1;
DECLARE @total_nombres INT = (SELECT COUNT(*) FROM @Nombres);
DECLARE @total_apellidos INT = (SELECT COUNT(*) FROM @Apellidos);

-- Iniciamos una transacción única para máxima velocidad
BEGIN TRANSACTION;
            
-- Bucle para insertar 1 millón de filas
WHILE @i <= 1000000
BEGIN
    
    -- Seleccionamos un nombre y apellido al azar
    DECLARE @nombre_aleatorio VARCHAR(50) = (SELECT TOP 1 nombre FROM @Nombres ORDER BY NEWID());
    DECLARE @apellido_aleatorio VARCHAR(50) = (SELECT TOP 1 apellido FROM @Apellidos ORDER BY NEWID());

    INSERT INTO rrhh.persona (
        dni,
        nombre,
        apellido,
        telefono,
        mail,
        created_at
    )
    VALUES (
        -- DNI ÚNICO
        10000000 + @i, 
        
        -- DATOS REALISTAS
        @nombre_aleatorio,
        @apellido_aleatorio,
        
        -- Teléfono ÚNICO
        -- (Lo basamos en el DNI para asegurar unicidad)
        3410000000 + (10000000 + @i), 
        
        -- MAIL ÚNICO Y REALISTA
        LOWER(REPLACE(@nombre_aleatorio, ' ', '')) + '.' + 
        LOWER(REPLACE(@apellido_aleatorio, ' ', '')) + 
        CAST(@i AS VARCHAR(7)) + '@mail-proyecto.com',
        
        -- FECHA ALEATORIA (Últimos 20 años)
        DATEADD(second, CAST(RAND() * -630720000 AS INT), SYSDATETIMEOFFSET())
    );
            
    SET @i = @i + 1;
END
            
-- Confirmamos la transacción
COMMIT TRANSACTION;

-- Verificamos el conteo final
SELECT COUNT(*) AS TotalFilas_En_rrhh_persona FROM rrhh.persona;

-- Mostramos todos los registros de la tabla rrhh.persona
SELECT * FROM rrhh.persona;




/*
===========================================
TAREA 2: BUSQUEDA POR PERIODO (SIN INDICE)
===========================================
*/
SELECT 
    dni, 
    nombre, 
    apellido, 
    mail 
FROM 
    rrhh.persona
WHERE 
    created_at >= '2020-05-01 00:00:00' 
    AND created_at < '2020-05-31 00:00:00';




/*
==========================================================================================
TAREA 3: DEFINIR UN INDICE AGRUPADO SOBRE LA COLUMNA FECHA Y REPETIR LA CONSULTA ANTERIOR.
==========================================================================================
*/

-- Primero borramos la clave primaria de la tabla rrhh.persona
ALTER TABLE rrhh.persona DROP CONSTRAINT pk_persona;

CREATE CLUSTERED INDEX IX_persona_created_at_CLUSTEREADO
ON rrhh.persona (created_at);

SELECT 
    dni, 
    nombre, 
    apellido, 
    mail 
FROM 
    rrhh.persona
WHERE 
    created_at >= '2020-05-01 00:00:00' 
    AND created_at < '2020-05-31 00:00:00';




/*
===================================
TAREA 4: BORRAR EL INDICE ANTERIOR.
===================================
*/

DROP INDEX IX_persona_created_at_CLUSTEREADO ON rrhh.persona;




/*
===============================================================================================================================================
TAREA 5: DEFINIR OTRO INDICE AGRUPADO SOBRE LA COLUMNA FECHA PERO QUE ADEMAS INCLUYA LAS COLUMNAS SELECCIONADAS Y REPETIR LA CONSULTA ANTERIOR.
===============================================================================================================================================
*/

CREATE NONCLUSTERED INDEX IX_persona_created_at_COBERTURA 
ON rrhh.persona (created_at) 
INCLUDE (dni, nombre, apellido, mail);

SELECT 
    dni, 
    nombre, 
    apellido, 
    mail 
FROM 
    rrhh.persona
WHERE 
    created_at >= '2020-05-01 00:00:00' 
    AND created_at < '2020-05-31 00:00:00';

DROP INDEX IX_persona_created_at_COBERTURA ON rrhh.persona;

-- Limpiar la cache
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;



ALTER TABLE rrhh.persona 
ADD CONSTRAINT pk_persona PRIMARY KEY (id_persona);
