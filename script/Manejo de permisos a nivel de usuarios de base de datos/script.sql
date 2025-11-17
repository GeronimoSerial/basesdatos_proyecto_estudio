USE consejo;
GO

--Creación de usuarios a nivel Base de datos
--Creación de usuarios a nivel Base de datos
´--Creación de usuarios a nivel Base de datos

CREATE LOGIN admin_user WITH PASSWORD = 'admin_pass';

CREATE LOGIN lector_user WITH PASSWORD = 'lector_pass';

CREATE USER admin_user FOR LOGIN admin_user;

CREATE USER lector_user FOR LOGIN lector_user;

--consultar usuarios

SELECT name, type_desc
FROM sys.database_principals
WHERE
    name IN ('admin_user', 'lector_user');

ALTER ROLE db_owner ADD MEMBER admin_user;

--Permiso solo lectura para el usuario lector

GRANT SELECT TO lector_user;
-- Permiso de un procedimiento almacenado para el usuario lector.

GRANT EXECUTE ON dbo.insertarPersona TO lector_user;

-- Corroborar qué usuarios fueron creados

SELECT name FROM sys.server_principals WHERE type = 'S';

-- Permisos a nivel de roles del DBMS

CREATE LOGIN user_a WITH PASSWORD = 'user_a_pass';

CREATE LOGIN user_b WITH PASSWORD = 'user_b_pass';

-- Creación de usuarios nuevos para permisos a nivel de roles.
CREATE USER user_a FOR LOGIN user_a;

CREATE USER user_b FOR LOGIN user_b;

-- Rol solo lectura en una tabla específica
CREATE ROLE rol_lectura_escuela;

GRANT SELECT ON institucional.escuela TO rol_lectura_escuela;

-- Permiso rol_solo_lectura para el usuario a
ALTER ROLE rol_lectura_escuela ADD MEMBER user_a;