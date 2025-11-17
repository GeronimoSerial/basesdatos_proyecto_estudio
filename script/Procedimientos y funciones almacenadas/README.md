# Procedimientos y Funciones Almacenadas

---

##  Introduccion

Los **procedimientos almacenados** y las **funciones** son herramientas de SQL Server que permiten encapsular lógica de negocio en la base de datos, reduciendo código duplicado y mejorando el mantenimiento.

| Característica | Procedimiento | Función |
|----------------|---------------|---------|
| **Propósito** | Ejecutar acciones (INSERT, UPDATE, DELETE) | Calcular y retornar valores |
| **Retorna** | Opcional (OUTPUT) | Obligatorio (RETURNS) |
| **Uso en SELECT** |  No |  Sí |
| **Modifica datos** |  Sí |  No |

---

##  Procedimientos Almacenados

Bloques de código que **ejecutan operaciones** en la base de datos.

### Tipos de Procedimientos

#### 1. Definidos por el Usuario
Creados para tareas específicas del proyecto.

```sql
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

-- Uso:
EXEC insertarPersona 
    @DNI = 12345678, 
    @Nombre = 'Juan', 
    @Apellido = 'Pérez',
    @Telefono = 3794123456, 
    @Mail = 'juan@mail.com';
```

#### 2. Temporales
Para uso temporal en la sesión actual.

```sql
-- Local
CREATE PROCEDURE #VerificarDatos
    @IdEscuela INT
AS
BEGIN
    SELECT COUNT(*) AS total
    FROM relevamiento.personal
    WHERE id_escuela = @IdEscuela;
END;
GO
```

#### 3. Sistema
Procedimientos predefinidos de SQL Server.

```sql
-- Ver estructura de tabla
EXEC sp_help 'rrhh.persona';

-- Listar procedimientos
EXEC sp_stored_procedures;
```

### Procedimientos del Proyecto

```sql
-- INSERT
EXEC insertarEscuela @CUE, @Nombre, @Telefono, ...;
EXEC insertarPersona @DNI, @Nombre, @Apellido, ...;

-- UPDATE
EXEC modificarEscuela @CUE, @NuevoTelefono, @NuevoMail;
EXEC modificarPersona @DNI, @NuevoTelefono, @NuevoMail;

-- DELETE
EXEC borrarEscuela @CUE;
EXEC borrarPersona @DNI;

-- Lógica con validación
EXEC asignarProblematicaEscuela @IdProblematica, @IdEscuela;
EXEC quitarProgramaEscuela @IdPrograma, @IdEscuela;
```

---

## Funciones Almacenadas

Objetos que **calculan y retornan valores**, usables en consultas SQL.

### Tipos de Funciones

#### 1. Escalares
Retornan un único valor.

```sql
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

-- Uso en SELECT:
SELECT 
    nombre,
    dbo.contarProblematicasEscuela(id_escuela) AS problematicas
FROM institucional.escuela;

-- Uso en WHERE:
SELECT nombre
FROM institucional.escuela
WHERE dbo.contarProblematicasEscuela(id_escuela) > 2;
```

#### 2. Tabla en Línea
Retornan una tabla (un solo SELECT).

```sql
CREATE FUNCTION listarEscuelasPorProblematica(@IdProblematica INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        e.id_escuela,
        e.cue,
        e.nombre,
        e.telefono,
        z.descripcion AS zona
    FROM relevamiento.escuela_problematica ep
    JOIN institucional.escuela e ON ep.id_escuela = e.id_escuela
    JOIN institucional.zona z ON e.id_zona = z.id_zona
    WHERE ep.id_problematica = @IdProblematica
);
GO

-- Uso como tabla:
SELECT * FROM dbo.listarEscuelasPorProblematica(1);

-- Uso con JOIN:
SELECT e.nombre, ep.*
FROM institucional.escuela e
CROSS APPLY dbo.listarEscuelasPorProblematica(1) ep;
```

#### 3. Tabla Multidefinidas
Retornan tabla con lógica compleja.

```sql
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
           AND anio = YEAR(GETDATE())) AS total_personal
    FROM institucional.escuela e
    WHERE e.id_escuela = @IdEscuela
);
GO

-- Uso:
SELECT * FROM dbo.estadisticasEscuela(1);
```

#### 4. Agregación (predefinidas)
```sql
SELECT 
    SUM(cantidad) AS total,
    AVG(cantidad) AS promedio,
    COUNT(*) AS registros
FROM relevamiento.personal;
```

#### 5. Sistema (predefinidas)
```sql
SELECT 
    GETDATE() AS fecha_actual,
    NEWID() AS nuevo_guid,
    SUSER_NAME() AS usuario;
```

---

## Comparación

| Aspecto | Procedimiento | Función |
|---------|---------------|---------|
| Propósito | Ejecutar acciones | Calcular/consultar |
| Modifica datos |  Sí |  No |
| Retorna valor | Opcional | Obligatorio |
| Uso en SELECT |  No |  Sí |
| Transacciones |  Sí |  No |
| Llamada | `EXEC proc` | `SELECT func()` |

### Cuándo Usar Cada Uno

 **Usar Procedimientos para:**
- Operaciones INSERT, UPDATE, DELETE
- Lógica de negocio con validaciones
- Procesos con múltiples pasos
- Transacciones

 **Usar Funciones para:**
- Cálculos en consultas
- Transformaciones de datos
- Filtros complejos
- Datos parametrizados en SELECT

---

## Formas de uso

### Ejecutar Procedimientos
```sql
-- Con parámetros nombrados
EXEC insertarPersona 
    @DNI = 12345678,
    @Nombre = 'Juan',
    @Apellido = 'Pérez',
    @Telefono = 3794123456,
    @Mail = 'juan@mail.com';
```

### Usar Funciones
```sql
-- En SELECT
SELECT nombre, dbo.contarProblematicasEscuela(id_escuela)
FROM escuela;

-- En WHERE
SELECT * FROM escuela
WHERE dbo.contarProblematicasEscuela(id_escuela) > 2;

-- Como tabla
SELECT * FROM dbo.listarEscuelasPorProblematica(1);
```

### Ver Definiciones
```sql
-- Ver procedimientos existentes
SELECT name, type_desc FROM sys.objects WHERE type = 'P';

-- Ver funciones existentes
SELECT name, type_desc FROM sys.objects WHERE type IN ('FN', 'TF');

-- Ver código
EXEC sp_helptext 'insertarPersona';
EXEC sp_helptext 'contarProblematicasEscuela';
```

---

## Procedimientos Implementados

| Procedimiento | Descripción |
|---------------|-------------|
| `insertarPersona` | Insertar nueva persona |
| `modificarPersona` | Actualizar teléfono y mail |
| `borrarPersona` | Eliminar persona por DNI |
| `insertarEscuela` | Insertar nueva escuela |
| `modificarEscuela` | Actualizar datos de escuela |
| `borrarEscuela` | Eliminar escuela por CUE |
| `insertarProblematica` | Insertar nueva problemática |
| `asignarProblematicaEscuela` | Asignar problemática (con validación) |
| `quitarProblematicaEscuela` | Quitar problemática de escuela |
| `insertarProgramaAcompanamiento` | Insertar nuevo programa |
| `asignarProgramaEscuela` | Asignar programa (con validación) |
| `quitarProgramaEscuela` | Quitar programa de escuela |

---

## Funciones Implementadas

| Función | Tipo | Descripción |
|---------|------|-------------|
| `contarProblematicasEscuela` | Escalar | Cuenta problemáticas de una escuela |
| `listarEscuelasPorProblematica` | Tabla inline | Lista escuelas con una problemática |
| `estadisticasEscuela` | Tabla inline | Dashboard completo de escuela |

---

## Ventajas

### Procedimientos
-  Reducen código duplicado
-  Mayor seguridad (control de acceso)
-  Mejor mantenimiento
-  Reducción de tráfico de red
-  Performance optimizado

### Funciones
-  Reutilización en consultas
-  Abstracción de complejidad
-  Código más legible
-  Mantenimiento centralizado
-  Integración natural con SQL

---
