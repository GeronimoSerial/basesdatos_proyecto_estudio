--Procedimientos almacenados
--INSERT
--UPDATE
--DELETE

--Procedimiento para insertar una persona
CREATE PROCEDURE insertarPersona
  @DNI INT,
  @Nombre VARCHAR(50),
  @Apellido VARCHAR(50),
  @Telefono NUMERIC(20,0),
  @Mail VARCHAR(100)
AS
BEGIN
  INSERT INTO rrhh.persona (dni, nombre, apellido, telefono, mail)
  VALUES (@DNI, @Nombre, @Apellido, @Telefono, @Mail);
END;
GO

--Procedimiento para modificar una persona
CREATE PROCEDURE modificarPersona
  @DNI INT,
  @NuevoTelefono NUMERIC(20,0),
  @NuevoMail VARCHAR(100)
AS
BEGIN
  UPDATE rrhh.persona
  SET telefono = @NuevoTelefono,
      mail = @NuevoMail,
      updated_at = GETDATE()
  WHERE dni = @DNI;
END;
GO

--Procedimiento para borrar una persona
CREATE PROCEDURE borrarPersona
  @DNI INT
AS
BEGIN
  DELETE FROM rrhh.persona
  WHERE dni = @DNI;
END;
GO

--Procedimiento para insertar una escuela
CREATE PROCEDURE insertarEscuela
  @CUE INT,
  @Nombre VARCHAR(100),
  @Telefono NUMERIC(20,0),
  @Mail VARCHAR(100),
  @IdServComida INT,
  @IdCategoria INT,
  @IdZona INT,
  @IdModalidad INT,
  @IdTurno INT
AS
BEGIN
  INSERT INTO institucional.escuela (cue, nombre, telefono, mail, id_serv_comida, 
  id_categoria, id_zona, id_modalidad, id_turno)
  VALUES (@CUE, @Nombre, @Telefono, @Mail, @IdServComida,
  @IdCategoria, @IdZona, @IdModalidad, @IdTurno);
END;
GO

--Procedimiento para modificar una escuela
CREATE PROCEDURE modificarEscuela
  @CUE INT,
  @NuevoTelefono NUMERIC(20,0),
  @NuevoMail VARCHAR(100)
AS
BEGIN
  UPDATE institucional.escuela
  SET telefono = @NuevoTelefono,
      mail = @NuevoMail,
      updated_at = GETDATE()
  WHERE cue = @CUE;
END;
GO

--Procedimiento para borrar una escuela
CREATE PROCEDURE borrarEscuela
  @CUE INT
AS
BEGIN
  DELETE FROM institucional.escuela
  WHERE cue = @CUE;
END;
GO

-- Procedimiento para insertar una problematica
CREATE PROCEDURE insertarProblematica
  @Dimension VARCHAR(50),
  @Descripcion VARCHAR(50)
AS
BEGIN
  INSERT INTO relevamiento.problematica (dimension, descripcion)
  VALUES (@Dimension, @Descripcion);
END;
GO

-- Procedimiento para asignar problematica a una escuela
CREATE PROCEDURE asignarProblematicaEscuela
  @IdProblematica INT,
  @IdEscuela INT
AS
BEGIN
  -- se verifica que no exista la relacion
  IF NOT EXISTS (SELECT 1 FROM relevamiento.escuela_problematica 
  WHERE id_problematica = @IdProblematica AND id_escuela = @IdEscuela)
  BEGIN
    INSERT INTO relevamiento.escuela_problematica (id_problematica, id_escuela)
    VALUES (@IdProblematica, @IdEscuela);
  END
END;
GO

-- Procedimiento para eliminar problematica de una escuela
CREATE PROCEDURE quitarProblematicaEscuela
  @IdProblematica INT,
  @IdEscuela INT
AS
BEGIN
  DELETE FROM relevamiento.escuela_problematica
  WHERE id_problematica = @IdProblematica AND id_escuela = @IdEscuela;
END;
GO

CREATE PROCEDURE insertarProgramaAcompanamiento
  @Descripcion VARCHAR(100)
AS
BEGIN
  INSERT INTO programas.programa_acompanamiento (descripcion)
  VALUES (@Descripcion);
END;
GO

-- Procedimiento para asignar programa a una escuela
CREATE PROCEDURE asignarProgramaEscuela
  @IdPrograma INT,
  @IdEscuela INT
AS
BEGIN
  -- Verificar que no exista la relacion
  IF NOT EXISTS (SELECT 1 FROM programas.escuela_programa 
                 WHERE id_programa = @IdPrograma 
                   AND id_escuela = @IdEscuela)
  BEGIN
    INSERT INTO programas.escuela_programa (id_programa, id_escuela)
    VALUES (@IdPrograma, @IdEscuela);
  END
END;
GO

-- Procedimiento para eliminar programa de una escuela
CREATE PROCEDURE quitarProgramaEscuela
  @IdPrograma INT,
  @IdEscuela INT
AS
BEGIN
  DELETE FROM programas.escuela_programa
  WHERE id_programa = @IdPrograma 
    AND id_escuela = @IdEscuela;
END;
GO

------------------------------------------------------------------------


-- FUNCIONES ALMACENADAS

-- FUNCION 1: contarProblematicasEscuela
-- Tipo: Escalar (retorna INT)
-- Proposito: Contar cuantas problematicas tiene una escuela

CREATE FUNCTION contarProblematicasEscuela(@IdEscuela INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    
    SELECT @Total = COUNT(*)
    FROM relevamiento.escuela_problematica
    WHERE id_escuela = @IdEscuela;
    
    RETURN ISNULL(@Total, 0);
END;
GO

-- Ejemplo de uso:
 SELECT dbo.contarProblematicasEscuela(1) AS total_problematicas;
-- Resultado esperado: 3 (si la escuela 1 tiene 3 problematicas)


-- FUNCION 2: listarEscuelasPorProblematica
-- Tipo: Table-Valued Function (retorna TABLA)
-- Proposito: Listar todas las escuelas que tienen una problematica específica

CREATE FUNCTION listarEscuelasPorProblematica(@IdProblematica INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.id_escuela,
        e.cue,
        e.nombre,
        e.telefono,
        e.mail,
        z.descripcion AS zona,
        c.descripcion AS categoria
    FROM relevamiento.escuela_problematica ep
    JOIN institucional.escuela e ON ep.id_escuela = e.id_escuela
    JOIN institucional.zona z ON e.id_zona = z.id_zona
    JOIN institucional.categoria c ON e.id_categoria = c.id_categoria
    WHERE ep.id_problematica = @IdProblematica
);
GO

-- Ejemplo de uso:
 SELECT * FROM dbo.listarEscuelasPorProblematica(1);
-- Retorna tabla con todas las escuelas que tienen la problematica con ID 1


-- FUNCION 3: estadisticasEscuela
-- Tipo: Table-Valued Function (retorna TABLA)
-- Proposito: Obtener un resumen completo (dashboard) de una escuela

CREATE FUNCTION estadisticasEscuela(@IdEscuela INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.cue,
        e.nombre,
        (SELECT COUNT(*) 
         FROM relevamiento.escuela_problematica 
         WHERE id_escuela = @IdEscuela) AS total_problematicas,
        (SELECT COUNT(*) 
         FROM programas.escuela_programa 
         WHERE id_escuela = @IdEscuela) AS total_programas,
        (SELECT SUM(cantidad) 
         FROM relevamiento.personal 
         WHERE id_escuela = @IdEscuela 
           AND anio = YEAR(GETDATE())) AS total_personal_actual,
        DATEDIFF(YEAR, e.fecha_fundacion, GETDATE()) AS antiguedad_anios
    FROM institucional.escuela e
    WHERE e.id_escuela = @IdEscuela
);
GO

-- Ejemplo de uso:
 SELECT * FROM dbo.estadisticasEscuela(1);
-- Retorna una fila con: CUE, nombre, total problematicas, total programas, 
-- total personal actual, antigüedad en años


-- VERIFICACION: Ver que las funciones se crearon correctamente

SELECT 
    name AS nombre_funcion,
    type_desc AS tipo,
    create_date AS fecha_creacion
FROM sys.objects
WHERE type IN ('FN', 'TF', 'IF')
  AND name IN ('contarProblematicasEscuela', 'listarEscuelasPorProblematica', 'estadisticasEscuela')
ORDER BY name;
GO


-- PRUEBAS DE LAS FUNCIONES

-- Prueba 1: Verificar que hay problematicas y escuelas
SELECT COUNT(*) AS total_problematicas FROM relevamiento.problematica;
SELECT COUNT(*) AS total_escuelas FROM institucional.escuela;
SELECT COUNT(*) AS total_relaciones FROM relevamiento.escuela_problematica;
GO

-- Prueba 2: Usar contarProblematicasEscuela
SELECT 
    e.nombre AS escuela,
    dbo.contarProblematicasEscuela(e.id_escuela) AS total_problematicas
FROM institucional.escuela e;
GO

-- Prueba 3: Usar listarEscuelasPorProblematica
-- Primero ver que problematicas hay
SELECT * FROM relevamiento.problematica;
-- Luego usar la funcion con una problematica existente
 SELECT * FROM dbo.listarEscuelasPorProblematica(1);
GO

-- Prueba 4: Usar estadisticasEscuela
SELECT * FROM dbo.estadisticasEscuela(1);
GO

-- EJEMPLOS DE USO COMBINADO

-- EJEMPLO 1: Reporte de problematicas por escuela
SELECT 
    e.nombre AS escuela,
    z.descripcion AS zona,
    dbo.contarProblematicasEscuela(e.id_escuela) AS cant_problematicas
FROM institucional.escuela e
JOIN institucional.zona z ON e.id_zona = z.id_zona
ORDER BY cant_problematicas DESC;


-- EJEMPLO 2: Escuelas con mas de 2 problematicas
SELECT 
    e.nombre AS escuela,
    dbo.contarProblematicasEscuela(e.id_escuela) AS problematicas
FROM institucional.escuela e
WHERE dbo.contarProblematicasEscuela(e.id_escuela) > 2
ORDER BY problematicas DESC;


-- EJEMPLO 3: Reporte completo de problematica especifica
SELECT 
    p.dimension,
    p.descripcion AS problematica,
    ep.*
FROM relevamiento.problematica p
CROSS APPLY dbo.listarEscuelasPorProblematica(p.id_problematica) ep
ORDER BY p.dimension, p.descripcion, ep.nombre;


-- EJEMPLO 4: Dashboard de todas las escuelas
SELECT * 
FROM institucional.escuela e
CROSS APPLY dbo.estadisticasEscuela(e.id_escuela) est
ORDER BY est.total_problematicas DESC, est.nombre;


-- EJEMPLO 5: Comparar estadisticas de escuelas en zona rural vs urbana
SELECT 
    CASE WHEN z.codigo = 'C' THEN 'Rural' ELSE 'Urbana' END AS tipo_zona,
    COUNT(*) AS cantidad_escuelas,
    AVG(CAST(est.total_problematicas AS FLOAT)) AS promedio_problematicas,
    AVG(CAST(est.total_personal_actual AS FLOAT)) AS promedio_personal
FROM institucional.escuela e
JOIN institucional.zona z ON e.id_zona = z.id_zona
CROSS APPLY dbo.estadisticasEscuela(e.id_escuela) est
GROUP BY CASE WHEN z.codigo = 'C' THEN 'Rural' ELSE 'Urbana' END;

