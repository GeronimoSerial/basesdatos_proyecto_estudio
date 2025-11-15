# Tema: Optimización de Consultas a Través de Índices

El objetivo de este proyecto fue analizar y cuantificar el impacto en el rendimiento de diferentes estrategias de indexación en SQL Server. Para ello, se realizaron pruebas de consulta sobre una tabla poblada con un gran volumen de datos (1 millón de registros), simulando un escenario realista donde la optimización de consultas es fundamental.

## 1. Configuración del Entorno de Pruebas

### 1.1. Definición de la Tabla

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

