-- SCRIPT "Sistema de Gestión Escolar"
-- INSERCIÓN DEL LOTE DE DATOS
-- Fecha: 27/11/2025

-- =========================
-- GEOGRAFÍA
-- =========================

-- Provincias
INSERT INTO geografia.provincia
    (nombre)
VALUES
    ('Corrientes');
GO

-- Departamentos
INSERT INTO geografia.departamento
    (nombre, id_provincia)
VALUES
    ('Capital', 1),
    ('Goya', 1),
    ('Mercedes', 1),
    ('Curuzú Cuatiá', 1),
    ('Bella Vista', 1),
    ('Saladas', 1),
    ('Mburucuyá', 1),
    ('Paso de los Libres', 1),
    ('Esquina', 1);
GO

-- Localidades
INSERT INTO geografia.localidad
    (nombre, id_departamento)
VALUES
    ('Riachuelo', 1),
    ('Álamos', 2),
    ('Felipe Yofre', 3),
    ('Basualdo', 4),
    ('Colonia 3 de Abril', 5),
    ('Angua', 6),
    ('Chacras', 7),
    ('Bonpland', 8),
    ('Buena Vista', 9),
    ('Paso Pesoa', 1),
    ('Laguna Soto', 1),
    ('Colonia Elenita', 2);
GO

-- Domicilios
INSERT INTO geografia.domicilio
    (calle, altura, id_localidad)
VALUES
    ('Av. 3 de Abril', 1250, 1),
    ('Junín', 845, 1),
    ('San Martín', 320, 2),
    ('Belgrano', 150, 3),
    ('Rivadavia', 500, 4),
    ('Av. Costanera', 1800, 5),
    ('Bolívar', 230, 6),
    ('Sarmiento', 450, 7),
    ('Urquiza', 780, 8),
    ('Córdoba', 1100, 9),
    ('Pellegrini', 600, 10),
    ('Mendoza', 350, 11),
    ('La Rioja', 420, 12),
    ('Catamarca', 890, 1),
    ('Tucumán', 1230, 1);
GO

-- =========================
-- INFRAESTRUCTURA
-- =========================

-- Edificios
INSERT INTO infraestructura.edificio
    (id_domicilio)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15);
GO

-- Proveedores
INSERT INTO infraestructura.proveedor
    (nombre)
VALUES
    ('Telecom'),
    ('Movistar'),
    ('Claro'),
    ('Gigared'),
    ('Personal');
GO

-- Tecnologías
INSERT INTO infraestructura.tecnologia
    (descripcion)
VALUES
    ('Fibra Óptica'),
    ('ADSL'),
    ('Cable Coaxial'),
    ('Satelital'),
    ('Wireless');
GO

-- Calidad de Servicio
INSERT INTO infraestructura.calidad_servicio
    (descripcion)
VALUES
    ('Excelente'),
    ('Muy Bueno'),
    ('Bueno'),
    ('Regular'),
    ('Deficiente');
GO

-- Edificio Conexión
INSERT INTO infraestructura.edificio_conexion
    (id_edificio, id_proveedor, id_tecnologia, id_calidad_servicio, fecha_relevamiento, observaciones)
VALUES
    (1, 1, 1, 1, '2024-03-15', 'Conexión estable'),
    (2, 2, 2, 2, '2024-03-20', 'Velocidad adecuada'),
    (3, 3, 3, 3, '2024-04-01', 'Requiere mejora'),
    (4, 4, 4, 4, '2024-04-10', 'Conexión intermitente'),
    (5, 5, 1, 1, '2024-04-15', 'Sin inconvenientes'),
    (6, 3, 2, 2, '2024-05-01', NULL),
    (7, 4, 3, 5, '2024-05-10', 'Antena nueva instalada'),
    (8, 5, 1, 1, '2024-05-15', 'Buen rendimiento'),
    (9, 2, 5, 5, '2024-06-01', 'Pendiente actualización'),
    (10, 1, 1, 1, '2024-06-10', 'Funcionamiento óptimo');
GO

-- =========================
-- RRHH
-- =========================

-- Roles
INSERT INTO rrhh.rol
    (codigo)
VALUES
    ('DIRECTOR'),
    ('VICEDIRECTOR'),
    ('DOCENTE'),
    ('ADMINISTRATIVO'),
    ('SUPERVISOR')
GO

-- Personas
INSERT INTO rrhh.persona
    (dni, nombre, apellido, telefono, mail)
VALUES
    (28456123, 'María', 'González', 3794512345, 'maria.gonzalez@edu.corrientes.gob.ar'),
    (30125478, 'Juan', 'Pérez', 3794523456, 'juan.perez@edu.corrientes.gob.ar'),
    (25789456, 'Ana', 'Rodríguez', 3794534567, 'ana.rodriguez@edu.corrientes.gob.ar'),
    (32456789, 'Carlos', 'López', 3794545678, 'carlos.lopez@edu.corrientes.gob.ar'),
    (27891234, 'Laura', 'Martínez', 3794556789, 'laura.martinez@edu.corrientes.gob.ar'),
    (29345678, 'Pedro', 'Sánchez', 3794567890, 'pedro.sanchez@edu.corrientes.gob.ar'),
    (31567890, 'Lucía', 'Fernández', 3794578901, 'lucia.fernandez@edu.corrientes.gob.ar'),
    (26234567, 'Roberto', 'García', 3794589012, 'roberto.garcia@edu.corrientes.gob.ar'),
    (33789012, 'Silvia', 'Díaz', 3794590123, 'silvia.diaz@edu.corrientes.gob.ar'),
    (24567891, 'Miguel', 'Torres', 3794501234, 'miguel.torres@edu.corrientes.gob.ar'),
    (35123456, 'Patricia', 'Romero', 3794512346, 'patricia.romero@edu.corrientes.gob.ar'),
    (28901234, 'Diego', 'Acosta', 3794523457, 'diego.acosta@edu.corrientes.gob.ar'),
    (30567891, 'Claudia', 'Benítez', 3794534568, 'claudia.benitez@edu.corrientes.gob.ar'),
    (27234567, 'Fernando', 'Castro', 3794545679, 'fernando.castro@edu.corrientes.gob.ar'),
    (32891234, 'Gabriela', 'Mendoza', 3794556780, 'gabriela.mendoza@edu.corrientes.gob.ar');
GO

-- =========================
-- INSTITUCIONAL
-- =========================

-- Servicio Comida
INSERT INTO institucional.servicio_comida
    (nombre)
VALUES
    ('Desayuno'),
    ('Almuerzo'),
    ('Merienda'),
    ('Desayuno y Almuerzo'),
    ('Completo');
GO

-- Categorías 
INSERT INTO institucional.categoria
    (id_categoria, codigo, descripcion)
VALUES
    (1, 1, 'Primera Categoría'),
    (2, 2, 'Segunda Categoría'),
    (3, 3, 'Tercera Categoría'),
    (4, 4, 'Cuarta Categoría')
GO

-- Zonas (no tiene identity)
INSERT INTO institucional.zona
    (id_zona, codigo, descripcion)
VALUES
    (1, 'A', 'Zona A - Urbana Central'),
    (2, 'B', 'Zona B - Urbana Periférica'),
    (3, 'C', 'Zona C - Rural Cercana'),
    (4, 'D', 'Zona D - Rural Lejana'),
    (5, 'E', 'Zona E - Inhóspita');
GO

-- Turnos
INSERT INTO institucional.turno
    (descripcion)
VALUES
    ('Mañana'),
    ('Tarde'),
    ('Noche'),
    ('Jornada Completa');
GO

-- Modalidades
INSERT INTO institucional.modalidad
    (descripcion)
VALUES
    ('Nivel Inicial'),
    ('Nivel Primario'),
    ('Educación para Jovenes y Adultos'),
    ('Educación Especial');
GO

-- Escuelas 
INSERT INTO institucional.escuela
    (cue, nombre, fecha_fundacion, telefono, mail, cabecera_id, id_serv_comida, id_categoria, id_zona, id_modalidad, id_turno, id_ambito)
VALUES
    (180001234567, 'Escuela N° 1 Juan Bautista Alberdi', '1950-03-15', 3794400001, 'escuela1@edu.corrientes.gob.ar', NULL, 4, 1, 1, 1, 1, 1),
    (180001234568, 'Escuela N° 2 Manuel Belgrano', '1955-08-20', 3794400002, 'escuela2@edu.corrientes.gob.ar', NULL, 4, 1, 1, 1, 2, 1),
    (180001234569, 'Escuela N° 3 José de San Martín', '1960-04-10', 3794400003, 'escuela3@edu.corrientes.gob.ar', NULL, 5, 2, 2, 1, 1, 1),
    (180001234570, 'Escuela N° 4 Bernardino Rivadavia', '1965-07-09', 3794400004, 'escuela4@edu.corrientes.gob.ar', NULL, 2, 2, 2, 1, 2, 1),
    (180001234571, 'Escuela Rural N° 5 Martín Fierro', '1970-05-25', 3794400005, 'escuela5@edu.corrientes.gob.ar', NULL, 5, 3, 3, 4, 1, 2),
    (180001234572, 'Escuela Técnica N° 1', '1975-09-17', 3794400006, 'tecnica1@edu.corrientes.gob.ar', NULL, 4, 1, 1, 2, 3, 1),
    (180001234573, 'Escuela Rural N° 6 Juana Azurduy', '1980-06-20', 3794400007, 'escuela6@edu.corrientes.gob.ar', NULL, 5, 4, 4, 3, 1, 2),
    (180001234574, 'Escuela N° 7 Domingo F. Sarmiento', '1985-11-11', 3794400008, 'escuela7@edu.corrientes.gob.ar', NULL, 4, 2, 1, 1, 1, 1),
    (180001234575, 'Escuela Especial N° 1', '1990-04-02', 3794400009, 'especial1@edu.corrientes.gob.ar', NULL, 5, 1, 1, 3, 1, 1),
    (180001234576, 'Centro Educativo de Adultos N° 1', '1995-03-08', 3794400010, 'adultos1@edu.corrientes.gob.ar', NULL, 1, 3, 2, 4, 3, 1);
GO




-- =========================
-- VACANTES
-- =========================

-- Cargos
INSERT INTO vacantes.cargo
    (prefijo, sufijo, descripcion, id_rol)
VALUES
    (1, 1, 'Director de Primera', 1),
    (1, 2, 'Director de Segunda', 1),
    (2, 1, 'Vicedirector de Primera', 2),
    (2, 2, 'Vicedirector de Segunda', 2),
    (5, 328, 'Maestro de Grado', 3),
    (5, 329, 'Maestro Especial', 3),
    (7, 50, 'Auxiliar Administrativo', 5)
GO

-- Plazas
INSERT INTO vacantes.plaza
    (id_escuela, prefijo, sufijo, descripcion, id_turno, id_cargo)
VALUES
    (33, 05, 321, 'Dirección Escuela 1', 1, 1),
    (32, 05, 322, 'Vicedirección Escuela 1', 1, 3),
    (33, 05, 328, 'Maestro 1ro A', 1, 5),
    (33, 05, 329, 'Maestro Música', 1, 6),
    (32, 05, 330, 'Dirección Escuela 2', 2, 2),
    (32, 05, 331, 'Maestro 1ro A', 2, 5),
    (33, 05, 332, 'Dirección Escuela 3', 1, 1),
    (33, 05, 333, 'Maestro 2do A', 1, 5),
    (32, 05, 334, 'Dirección Escuela 4', 2, 2),
    (32, 05, 335, 'Dirección Escuela Rural 5', 1, 1),
    (32, 05, 336, 'Dirección Técnica', 3, 1),
    (32, 05, 337, 'Vicedirección Técnica', 2, 3),
    (33, 05, 338, 'Secretaría Administrativa', 4, 7),
    (33, 05, 339, 'Dirección Escuela Rural 6', 1, 2),
    (32, 05, 340, 'Dirección Escuela 7', 1, 1);
GO

-- =========================
-- SUPERVISIÓN
-- =========================

-- Supervisor Escuela
INSERT INTO supervision.supervisor_escuela
    (id_persona, id_cargo, id_escuela)
VALUES
    (10, 5, 32),
    (10, 5, 41),
    (10, 5, 33),
    (14, 5, 34),
    (14, 5, 35),
    (14, 5, 36),
    (15, 5, 37),
    (15, 5, 38),
    (15, 5, 39),
    (10, 5, 40);
GO

-- =========================
-- RELEVAMIENTO
-- =========================

-- Problemáticas
INSERT INTO relevamiento.problematica
    (dimension, descripcion)
VALUES
    ('Infraestructura', 'Falta de mantenimiento edilicio'),
    ('Infraestructura', 'Problemas de conectividad'),
    ('Pedagógica', 'Ausentismo estudiantil'),
    ('Pedagógica', 'Bajo rendimiento académico'),
    ('Social', 'Situaciones de vulnerabilidad'),
    ('Recursos', 'Falta de material didáctico'),
    ('Recursos', 'Equipamiento obsoleto'),
    ('Personal', 'Falta de personal docente'),
    ('Personal', 'Alta rotación de personal'),
    ('Ambiental', 'Problemas de accesibilidad');
GO

-- Escuela Problemática
INSERT INTO relevamiento.escuela_problematica
    (id_problematica, id_escuela)
VALUES
    (1, 33),
    (2, 35),
    (2, 37),
    (3, 34),
    (4, 32),
    (5, 39),
    (5, 41),
    (6, 36),
    (7, 38),
    (8, 40);
GO


-- Personal Tipo
INSERT INTO relevamiento.personal_tipo
    (codigo, nombre, id_rol, activo)
VALUES
    ('DIR', 'Director', 1, 1),
    ('VICEDIR', 'Vicedirector', 2, 1),
    ('DOC', 'Docente', 3, 1),
    ('PREC', 'Preceptor', 4, 1),
    ('ADM', 'Administrativo', 5, 1),
    ('AUX', 'Auxiliar', 7, 1),
    ('PSICO', 'Psicólogo', NULL, 1),
    ('BIBLIO', 'Bibliotecario', NULL, 1);
GO

-- Personal 
INSERT INTO relevamiento.personal
    (id_escuela, anio, id_personal_tipo, cantidad, observaciones)
VALUES
    (34, 2024, 1, 1, NULL),
    (34, 2024, 2, 1, NULL),
    (34, 2024, 3, 12, 'Planta completa'),
    (34, 2024, 6, 3, NULL),
    (32, 2024, 1, 1, NULL),
    (32, 2024, 3, 10, 'Falta 1 docente'),
    (32, 2024, 6, 2, NULL),
    (33, 2024, 1, 1, NULL),
    (33, 2024, 3, 8, NULL),
    (35, 2024, 1, 1, NULL),
    (35, 2024, 3, 4, 'Escuela rural pequeña'),
    (36, 2024, 1, 1, NULL),
    (36, 2024, 2, 1, NULL),
    (36, 2024, 3, 25, 'Escuela técnica'),
    (36, 2024, 4, 5, NULL),
    (36, 2024, 5, 2, NULL),
    (36, 2024, 6, 4, NULL),
    (39, 2024, 1, 1, NULL),
    (39, 2024, 3, 6, 'Personal especializado'),
    (39, 2024, 7, 2, 'Equipo de apoyo');
GO

-- =========================
-- PROGRAMAS
-- =========================

-- Programa Acompañamiento
INSERT INTO programas.programa_acompanamiento
    (descripcion)
VALUES
    ('Programa Nacional de Alfabetización'),
    ('Conectar Igualdad'),
    ('Plan de Lectura'),
    ('Programa de Apoyo Socioeducativo'),
    ('Educación Sexual Integral'),
    ('Programa de Inclusión Digital'),
    ('Plan de Mejora Institucional');
GO

-- Escuela Programa
INSERT INTO programas.escuela_programa
    (id_programa, id_escuela)
VALUES
    (1, 41),
    (1, 32),
    (1, 33),
    (2, 41),
    (2, 36),
    (2, 38),
    (3, 41),
    (3, 32),
    (3, 34),
    (4, 35),
    (4, 37),
    (5, 32),
    (5, 36),
    (6, 36),
    (6, 39),
    (7, 33),
    (7, 34),
    (7, 40);
GO

-- =========================
-- DIRECTOR ESCUELA
-- =========================

INSERT INTO institucional.director_escuela
    (id_plaza, id_escuela, id_persona, fecha_inicio, fecha_fin)
VALUES
    (31, 33, 1, '2020-03-01', NULL),
    (35, 33, 2, '2019-03-01', NULL),
    (37, 32, 3, '2021-03-01', NULL),
    (39, 32, 4, '2022-03-01', NULL),
    (40, 32, 5, '2018-03-01', NULL),
    (41, 33, 6, '2017-03-01', NULL),
    (42, 33, 7, '2023-03-01', NULL),
    (43, 32, 8, '2020-03-01', NULL);
GO

PRINT 'Carga de datos completada exitosamente.';

