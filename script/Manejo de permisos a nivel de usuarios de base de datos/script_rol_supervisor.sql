-- =========================
-- ROL DE SUPERVISOR
-- =========================

-- 1. Crear el rol de base de datos
IF DATABASE_PRINCIPAL_ID('rol_supervisor') IS NULL
BEGIN
    CREATE ROLE rol_supervisor;
END
ELSE
BEGIN
    PRINT 'El rol rol_supervisor ya existe.';
END
GO

-- 2. Otorgar permisos de SELECT en el esquema institucional
GRANT SELECT ON SCHEMA::institucional TO rol_supervisor;
GO

-- 3. Otorgar permisos de SELECT en supervision.supervisor_escuela 
GRANT SELECT ON supervision.supervisor_escuela TO rol_supervisor;
GO

-- 4. Crear una vista que filtra las escuelas según el supervisor
IF OBJECT_ID('institucional.v_escuelas_supervisor', 'V') IS NOT NULL
    DROP VIEW institucional.v_escuelas_supervisor;
GO

CREATE VIEW institucional.v_escuelas_supervisor
AS
    SELECT
        e.id_escuela,
        e.cue,
        e.nombre,
        e.fecha_fundacion,
        e.telefono,
        e.mail,
        e.cabecera_id,
        e.id_serv_comida,
        e.id_categoria,
        e.id_zona,
        e.id_modalidad,
        e.id_turno,
        e.id_ambito,
        e.created_at,
        e.updated_at
    FROM institucional.escuela e
        INNER JOIN supervision.supervisor_escuela se
        ON e.id_escuela = se.id_escuela
        INNER JOIN rrhh.persona p
        ON se.id_persona = p.id_persona
    WHERE p.mail = CAST(SESSION_CONTEXT(N'email_usuario') AS VARCHAR(100));
GO

-- 5. Otorgar permisos SELECT en la vista
GRANT SELECT ON institucional.v_escuelas_supervisor TO rol_supervisor;
GO

-- 6. Denegar acceso directo a la tabla escuela (forzar uso de la vista)


DENY SELECT ON institucional.escuela TO rol_supervisor;

EXECUTE AS USER = 'supervisor_prueba';
GO

select * from institucional.escuela


IF NOT EXISTS (SELECT *
FROM sys.server_principals
WHERE name = 'supervisor_prueba')
BEGIN
    CREATE LOGIN supervisor_prueba WITH PASSWORD = 'Password123!';
END
GO

IF NOT EXISTS (SELECT *
FROM sys.database_principals
WHERE name = 'supervisor_prueba')
BEGIN
    CREATE USER supervisor_prueba FOR LOGIN supervisor_prueba;
END
GO 

ALTER ROLE rol_supervisor ADD MEMBER supervisor_prueba;
GO

-- usuarios de prueba:  fernando.castro@edu.corrientes.gob.ar miguel.torres@edu.corrientes.gob.ar


EXEC sp_set_session_context @key = N'email_usuario', @value = 'fernando.castro@edu.corrientes.gob.ar', @read_only = 0;
SELECT nombre
FROM institucional.v_escuelas_supervisor;


EXEC sp_set_session_context @key = N'email_usuario', @value = 'miguel.torres@edu.corrientes.gob.ar', @read_only = 0;
SELECT nombre
FROM institucional.v_escuelas_supervisor;
