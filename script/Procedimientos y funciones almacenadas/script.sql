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