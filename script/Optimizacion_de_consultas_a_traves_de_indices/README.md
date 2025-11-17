# Tema: Optimización de Consultas a Través de Índices

## 1. Introducción

El objetivo de este tema fue analizar y medir el impacto en el rendimiento de diferentes estrategias de indexación en SQL Server. Para ello, se realizaron pruebas de consulta sobre una tabla poblada con un gran volumen de datos (1 millón de registros), simulando un escenario realista donde la optimización de consultas es fundamental.

## 2. Configuración del Entorno de Pruebas

### 2.1. Definición de la Tabla

Se utilizó la tabla `rrhh.persona`. La estructura inicial se creó con el siguiente script:

```sql
CREATE TABLE rrhh.persona (
    id_persona INT IDENTITY(1,1) NOT NULL,
    dni INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    telefono NUMERIC(20) NOT NULL,
    mail VARCHAR(100) NOT NULL,
    CONSTRAINT pk_persona PRIMARY KEY (id_persona),
    CONSTRAINT uq_persona_dni UNIQUE (dni),
    CONSTRAINT uq_persona_mail UNIQUE (mail),
    CONSTRAINT ck_persona_dni CHECK (
        dni BETWEEN 1000000 AND 99999999
    )
);
GO

ALTER TABLE rrhh.persona
ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO
ALTER TABLE rrhh.persona
ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO
```

### 2.2. Carga de Datos

Para poblar la tabla, se ejecutó un script T-SQL con un bucle WHILE para insertar 1 millón de filas únicas. Esto aseguró un volumen de datos suficiente y una distribución aleatoria de fechas en la columna created_at.

```sql
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
```

## 3. Pruebas Realizadas y Análisis

### 3.1. Prueba 1: (Sin Índice)
```sql
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
```

- Descripción: Consulta ejecutada sobre la tabla original, que solo tiene el índice Clustered por defecto (la PRIMARY KEY id_persona).
- Resultados:
```text
(4077 rows affected)
Total execution time: 00:00:00.061
```

- Análisis del Plan de Ejecución: El motor de SQL Server realizó un Clustered Index Scan. Esto significa que tuvo que leer la tabla entera (el millón de filas) para encontrar las 4,077 que cumplían la condición. Fue la operación más costosa (98% del costo) y es altamente ineficiente.

### 3.2. Prueba 2: Con Índice Agrupado (Clustered Index)

```sql
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
```

- Descripción: Se eliminó la PRIMARY KEY original y se creó un nuevo Índice Agrupado directamente en la columna created_at.
- Resultados:

```text
(4077 rows affected)
Total execution time: 00:00:00.026
```

- Análisis del Plan de Ejecución: El plan cambió a un Clustered Index Seek. Gracias a que la tabla se reordenó físicamente por fecha, el motor pudo "saltar" directamente al inicio del rango de mayo 2020 y leer solo las filas necesarias. El tiempo de respuesta mejoró en más de un 50% (de 61ms a 26ms).

### 3.3. Prueba 3: Con Índice de Cobertura (Non-Clustered + INCLUDE)

```sql
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
```

- Descripción: Se volvió a la PRIMARY KEY original (en id_persona) y se creó un Índice No Agrupado en created_at. Crucialmente, se usó la cláusula INCLUDE para añadir las columnas dni, nombre, apellido y mail al índice.
- Resultados:

```text
(4077 rows affected)
Total execution time: 00:00:00.022
```

- Análisis del Plan de Ejecución: Este fue el escenario más rápido. El plan utilizó un Index Seek (similar a la Prueba 2) pero con una ventaja clave: el índice ya contenía todas las columnas solicitadas por el SELECT (gracias al INCLUDE). El motor ni siquiera tuvo que tocar la tabla principal (rrhh.persona); obtuvo todos los datos directamente de la estructura del índice, logrando la optimización ideal.

## 4. Conclusiones

Luego de haber puesto a prueba los tres métodos de consulta, se demuestra una diferencia clave en la eficiencia y el tiempo de respuesta. Los resultados de las pruebas (para un periodo de 1 mes) nos dejan un claro aprendizaje sobre como la estrategia de acceso a los datos impacta en el rendimiento.

La lección principal es que no basta con "crear un índice". Debemos diseñar los índices basándonos en cómo se consultarán los datos. La diferencia entre un Scan (leer todo) y un Seek (búsqueda directa) es la clave para que una consulta pase de ser lenta e ineficiente a ser rápida y escalable. El índice de cobertura (Prueba 3) resultó ser teórica y prácticamente el más eficiente para esta consulta específica.


