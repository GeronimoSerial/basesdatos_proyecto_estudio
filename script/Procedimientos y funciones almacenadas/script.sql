--Procedimientos almacenados
--INSERT
--UPDATE
--DELETE

--insertar una persona
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

--modificar una persona
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

--borrar una persona
CREATE PROCEDURE borrarPersona
  @DNI INT
AS
BEGIN
  DELETE FROM rrhh.persona
  WHERE dni = @DNI;
END;
GO