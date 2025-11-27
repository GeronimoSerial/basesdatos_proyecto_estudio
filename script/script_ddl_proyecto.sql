-- =========================
-- GEOGRAFÍA
-- =========================
IF SCHEMA_ID('geografia') IS NULL
BEGIN
    EXEC('CREATE SCHEMA geografia');
END
GO

CREATE TABLE geografia.provincia (
    id_provincia INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_provincia PRIMARY KEY (id_provincia)
);
GO

CREATE TABLE geografia.departamento (
    id_departamento INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_provincia INT NOT NULL,
    CONSTRAINT pk_departamento PRIMARY KEY (id_departamento),
    CONSTRAINT fk_departamento_provincia FOREIGN KEY (id_provincia) REFERENCES geografia.provincia (id_provincia)
);
GO

CREATE TABLE geografia.localidad (
    id_localidad INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT pk_localidad PRIMARY KEY (id_localidad),
    CONSTRAINT fk_localidad_departamento FOREIGN KEY (id_departamento) REFERENCES geografia.departamento (id_departamento)
);
GO

CREATE TABLE geografia.domicilio (
    id_domicilio INT IDENTITY(1,1) NOT NULL,
    calle VARCHAR(50) NOT NULL,
    altura INT NOT NULL,
    id_localidad INT NOT NULL,
    CONSTRAINT pk_domicilio PRIMARY KEY (id_domicilio),
    CONSTRAINT fk_domicilio_localidad FOREIGN KEY (id_localidad) REFERENCES geografia.localidad (id_localidad)
);
GO

-- =========================
-- INFRAESTRUCTURA
-- =========================
IF SCHEMA_ID('infraestructura') IS NULL
BEGIN
    EXEC('CREATE SCHEMA infraestructura');
END
GO

CREATE TABLE infraestructura.edificio (
    id_edificio INT IDENTITY(1,1) NOT NULL,
    id_domicilio INT NOT NULL,
    CONSTRAINT pk_edificio PRIMARY KEY (id_edificio),
    CONSTRAINT fk_edificio_domicilio FOREIGN KEY (id_domicilio) REFERENCES geografia.domicilio (id_domicilio)
);
GO

CREATE TABLE infraestructura.proveedor (
    id_proveedor INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor),
    CONSTRAINT uq_proveedor UNIQUE (nombre)
);
GO

CREATE TABLE infraestructura.tecnologia (
    id_tecnologia INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tecnologia PRIMARY KEY (id_tecnologia)
);
GO

CREATE TABLE infraestructura.calidad_servicio (
    id_calidad_servicio INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_calidad_servicio PRIMARY KEY (id_calidad_servicio)
);
GO

CREATE TABLE infraestructura.edificio_conexion (
    id_edificio_conexion INT IDENTITY(1,1) NOT NULL,
    id_edificio INT NOT NULL,
    id_proveedor INT NOT NULL,
    id_tecnologia INT NOT NULL,
    id_calidad_servicio INT NOT NULL,
    fecha_relevamiento DATE DEFAULT GETDATE(),
    observaciones VARCHAR(200) NULL,
    CONSTRAINT pk_edificio_conexion PRIMARY KEY (id_edificio_conexion),
    CONSTRAINT fk_ec_edificio FOREIGN KEY (id_edificio) REFERENCES infraestructura.edificio (id_edificio),
    CONSTRAINT fk_ec_proveedor FOREIGN KEY (id_proveedor) REFERENCES infraestructura.proveedor (id_proveedor),
    CONSTRAINT fk_ec_tecnologia FOREIGN KEY (id_tecnologia) REFERENCES infraestructura.tecnologia (id_tecnologia),
    CONSTRAINT fk_ec_calidad_servicio FOREIGN KEY (id_calidad_servicio) REFERENCES infraestructura.calidad_servicio (id_calidad_servicio)
);
GO

-- =========================
-- RRHH
-- =========================
IF SCHEMA_ID('rrhh') IS NULL
BEGIN
    EXEC('CREATE SCHEMA rrhh');
END
GO

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

CREATE TABLE rrhh.rol (
    id_rol INT IDENTITY(1,1) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    CONSTRAINT uq_rol_codigo UNIQUE (codigo),
    CONSTRAINT pk_rol PRIMARY KEY (id_rol)
);
GO

-- =========================
-- INSTITUCIONAL
-- =========================
IF SCHEMA_ID('institucional') IS NULL
BEGIN
    EXEC('CREATE SCHEMA institucional');
END
GO

CREATE TABLE institucional.servicio_comida (
    id_serv_comida INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_servicio_comida PRIMARY KEY (id_serv_comida)
);
GO

CREATE TABLE institucional.categoria (
    id_categoria INT NOT NULL,
    codigo INT NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categoria_codigo UNIQUE (codigo)
);
GO

CREATE TABLE institucional.zona (
    id_zona INT NOT NULL,
    codigo CHAR(1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_zona PRIMARY KEY (id_zona),
    CONSTRAINT uq_zona_codigo UNIQUE (codigo)
);
GO

CREATE TABLE institucional.turno (
    id_turno INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50),
    CONSTRAINT pk_turno PRIMARY KEY (id_turno)
);
GO

CREATE TABLE institucional.modalidad (
    id_modalidad INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_modalidad PRIMARY KEY (id_modalidad)
);
GO

CREATE TABLE institucional.escuela (
    cue BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_fundacion DATE NULL,
    telefono NUMERIC(20) NOT NULL,
    mail VARCHAR(100) NOT NULL,
    id_escuela INT IDENTITY(1,1) NOT NULL,
    cabecera_id INT NULL,
    id_serv_comida INT NOT NULL,
    id_categoria INT NOT NULL,
    id_zona INT NOT NULL,
    id_modalidad INT NOT NULL,
    id_turno INT NOT NULL,
    CONSTRAINT pk_escuela PRIMARY KEY (id_escuela),
    CONSTRAINT fk_escuela_cabecera FOREIGN KEY (cabecera_id) REFERENCES institucional.escuela (id_escuela),
    CONSTRAINT fk_escuela_servicio_comida FOREIGN KEY (id_serv_comida) REFERENCES institucional.servicio_comida (id_serv_comida),
    CONSTRAINT fk_escuela_categoria FOREIGN KEY (id_categoria) REFERENCES institucional.categoria (id_categoria),
    CONSTRAINT fk_escuela_zona FOREIGN KEY (id_zona) REFERENCES institucional.zona (id_zona),
    CONSTRAINT fk_escuela_modalidad FOREIGN KEY (id_modalidad) REFERENCES institucional.modalidad (id_modalidad),
    CONSTRAINT fk_escuela_turno FOREIGN KEY (id_turno) REFERENCES institucional.turno (id_turno),
    CONSTRAINT uq_escuela_cue UNIQUE (cue),
    CONSTRAINT uq_escuela_mail UNIQUE (mail)
);
GO



-- =========================
-- Cargos
-- =========================
IF SCHEMA_ID('vacantes') IS NULL
BEGIN
    EXEC('CREATE SCHEMA vacantes');
END
GO

CREATE TABLE vacantes.cargo (
    id_cargo INT IDENTITY(1,1) NOT NULL,
    prefijo INT NOT NULL, -- p.ej., 05
    sufijo INT NOT NULL, -- p.ej., 328
    descripcion VARCHAR(100),
    id_rol INT NOT NULL,
    codigo_display AS (
        RIGHT('00' + CONVERT(VARCHAR(2), prefijo), 2) + '-' + 
        RIGHT('000' + CONVERT(VARCHAR(3), sufijo), 3)
    ) PERSISTED,
    CONSTRAINT uq_cargo_prefijo_sufijo UNIQUE (prefijo, sufijo),
    CONSTRAINT pk_cargo PRIMARY KEY (id_cargo),
    CONSTRAINT fk_cargo_rol FOREIGN KEY (id_rol) REFERENCES rrhh.rol (id_rol)
);
GO

CREATE TABLE vacantes.plaza (
    id_plaza INT IDENTITY(1,1) NOT NULL,
    id_escuela INT NOT NULL,
    prefijo INT NOT NULL,
    sufijo INT NOT NULL,
    codigo_display AS (
        RIGHT('00' + CONVERT(VARCHAR(2), prefijo), 2) + '-' + 
        RIGHT('000' + CONVERT(VARCHAR(3), sufijo), 3)
    ) PERSISTED,
    descripcion VARCHAR(150),
    id_turno INT NOT NULL,
    id_cargo INT NOT NULL,
    CONSTRAINT fk_plaza_escuela FOREIGN KEY (id_escuela) REFERENCES institucional.escuela (id_escuela),
    CONSTRAINT pk_plaza PRIMARY KEY (id_plaza), -- Ver NOTA IMPORTANTE abajo
    CONSTRAINT fk_plaza_turno FOREIGN KEY (id_turno) REFERENCES institucional.turno (id_turno),
    CONSTRAINT fk_plaza_cargo FOREIGN KEY (id_cargo) REFERENCES vacantes.cargo (id_cargo),
    -- dentro de la escuela, un único código plaza (prefijo-sufijo)
    CONSTRAINT uq_plaza_codigo_por_escuela UNIQUE (id_escuela, prefijo, sufijo)
    -- validaciones básicas
    -- CONSTRAINT chk_plaza_prefijo_pos CHECK (prefijo > 0),
    -- CONSTRAINT chk_plaza_sufijo_pos CHECK (sufijo > 0)
);
GO

-- Índices útiles para consultas
CREATE INDEX ix_plaza_escuela_cargo ON vacantes.plaza (id_escuela, id_cargo);
GO


IF SCHEMA_ID('supervision') IS NULL
BEGIN
    EXEC('CREATE SCHEMA supervision');
END
GO -- HASTA ACA EJECUTE

CREATE TABLE supervision.supervisor_escuela (
    id_persona INT NOT NULL,
    id_cargo INT NOT NULL,
    id_escuela INT NOT NULL,
    id_autoridad INT NULL, -- CAMBIO: NULL porque la tabla normativa.autoridad no existe aún
    CONSTRAINT pk_supervisor_escuela PRIMARY KEY (id_escuela),
    CONSTRAINT fk_se_escuela FOREIGN KEY (id_escuela) REFERENCES institucional.escuela (id_escuela),
    CONSTRAINT fk_se_persona FOREIGN KEY (id_persona) REFERENCES rrhh.persona (id_persona),
    CONSTRAINT fk_se_cargo FOREIGN KEY (id_cargo) REFERENCES vacantes.cargo (id_cargo)
    -- CONSTRAINT fk_se_autoridad FOREIGN KEY (id_autoridad) REFERENCES normativa.autoridad (id_autoridad) -- COMENTADO: tabla no existe
);
GO

CREATE INDEX idx_se_por_persona ON supervision.supervisor_escuela (id_persona);
GO


IF SCHEMA_ID('relevamiento') IS NULL
BEGIN
    EXEC('CREATE SCHEMA relevamiento');
END
GO

CREATE TABLE relevamiento.problematica (
    id_problematica INT IDENTITY(1,1) NOT NULL,
    dimension VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50),
    CONSTRAINT pk_problematica PRIMARY KEY (id_problematica)
);
GO

CREATE TABLE relevamiento.escuela_problematica (
    id_problematica INT NOT NULL,
    id_escuela INT NOT NULL,
    CONSTRAINT pk_escuela_problematica PRIMARY KEY (id_problematica, id_escuela),
    CONSTRAINT fk_ep_problematica FOREIGN KEY (id_problematica) REFERENCES relevamiento.problematica (id_problematica),
    CONSTRAINT fk_ep_escuela FOREIGN KEY (id_escuela) REFERENCES institucional.escuela (id_escuela)
);
GO


IF SCHEMA_ID('programas') IS NULL
BEGIN
    EXEC('CREATE SCHEMA programas');
END
GO

CREATE TABLE programas.programa_acompanamiento (
    id_programa INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_programa_acompanamiento PRIMARY KEY (id_programa)
);
GO

CREATE TABLE programas.escuela_programa (
    id_programa INT NOT NULL,
    id_escuela INT NOT NULL,
    CONSTRAINT pk_escuela_programa PRIMARY KEY (id_programa, id_escuela),
    CONSTRAINT fk_ep_programa FOREIGN KEY (id_programa) REFERENCES programas.programa_acompanamiento (id_programa),
    CONSTRAINT fk_ep_escuela FOREIGN KEY (id_escuela) REFERENCES institucional.escuela (id_escuela)
);
GO

CREATE TABLE relevamiento.personal_tipo (
    id_personal_tipo INT IDENTITY(1,1) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    id_rol INT NULL,
    activo BIT NOT NULL DEFAULT 1, -- CAMBIO: BOOLEAN -> BIT; true -> 1
    CONSTRAINT uq_personal_tipo_codigo UNIQUE (codigo),
    CONSTRAINT pk_personal_tipo PRIMARY KEY (id_personal_tipo),
    CONSTRAINT fk_personal_tipo_rol FOREIGN KEY (id_rol) REFERENCES rrhh.rol (id_rol)
);
GO

CREATE TABLE relevamiento.personal (
    id_escuela INT NOT NULL,
    anio INT NOT NULL,
    id_personal_tipo INT NOT NULL,
    cantidad INT NOT NULL,
    observaciones VARCHAR(200),
    CONSTRAINT pk_personal PRIMARY KEY (
        id_escuela,
        anio,
        id_personal_tipo
    ),
    CONSTRAINT fk_personal_tipo FOREIGN KEY (id_personal_tipo) REFERENCES relevamiento.personal_tipo (id_personal_tipo),
    CONSTRAINT fk_personal_escuela FOREIGN KEY (id_escuela) REFERENCES institucional.escuela (id_escuela),
    CONSTRAINT ck_personal_cantidad CHECK (cantidad >= 0),
    CONSTRAINT ck_personal_anio CHECK (anio >= 2000)
);
GO

CREATE INDEX ix_personal_escuela_anio ON relevamiento.personal (id_escuela, anio);
GO

CREATE INDEX ix_personal_tipo ON relevamiento.personal (id_personal_tipo);
GO


CREATE TABLE institucional.ambito_escuela (
    id_ambito INT IDENTITY(1,1) NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT uq_ambito_codigo UNIQUE (codigo),
    CONSTRAINT pk_ambito PRIMARY KEY (id_ambito)
);
GO

INSERT INTO
    institucional.ambito_escuela (codigo)
VALUES
    ('URBANA'),
    ('RURAL');
GO

ALTER TABLE institucional.escuela
ADD id_ambito INT NULL;
GO

ALTER TABLE institucional.escuela
ADD CONSTRAINT fk_escuela_ambito FOREIGN KEY (id_ambito) REFERENCES institucional.ambito_escuela (id_ambito);
GO

ALTER TABLE vacantes.plaza
ADD CONSTRAINT uq_plaza_id_escuela UNIQUE (id_plaza, id_escuela);
GO

CREATE TABLE institucional.director_escuela (
    id_director_escuela INT IDENTITY(1,1) NOT NULL,
    id_plaza INT NOT NULL,
    id_escuela INT NOT NULL,
    id_persona INT NOT NULL,
    fecha_inicio DATE NOT NULL DEFAULT GETDATE(),
    fecha_fin DATE NULL,
    CONSTRAINT pk_director_escuela PRIMARY KEY (id_director_escuela),
    CONSTRAINT fk_director_persona FOREIGN KEY (id_persona) REFERENCES rrhh.persona (id_persona),
    CONSTRAINT fk_director_plaza_escuela FOREIGN KEY (id_plaza, id_escuela) REFERENCES vacantes.plaza (id_plaza, id_escuela)
);
GO


-- =========================
-- TIMESTAMPS
-- =========================

ALTER TABLE rrhh.persona
ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO
ALTER TABLE rrhh.persona
ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO


ALTER TABLE institucional.escuela
ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO
ALTER TABLE institucional.escuela
ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO


ALTER TABLE infraestructura.edificio_conexion
ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO
ALTER TABLE infraestructura.edificio_conexion
ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
GO

-- Las siguientes tablas no existen en este script, por lo tanto se comentan los ALTER TABLE:

-- ALTER TABLE normativa.disposicion
-- ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
-- GO
-- ALTER TABLE normativa.disposicion
-- ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
-- GO


-- ALTER TABLE vacantes.vacante
-- ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
-- GO
-- ALTER TABLE vacantes.vacante
-- ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
-- GO


-- ALTER TABLE vacantes.asignacion
-- ADD created_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
-- GO
-- ALTER TABLE vacantes.asignacion
-- ADD updated_at DATETIMEOFFSET NOT NULL DEFAULT SYSDATETIMEOFFSET();
-- GO
