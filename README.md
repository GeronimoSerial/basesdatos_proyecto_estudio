# PRESENTACIÓN - RELEVAMIENTO ANUAL

### Facultad: Facultad de Ciencias Exactas y Naturales y Agrimensura.

### Carrera: Licenciatura en Sistemas de Información.

### Asignatura: Bases de Datos I.

### Docente: Villegas Darío

### Integrantes:

- Serial Geronimo
- Escalante Marcelo
- Lago Matias
- Mancuello Lucas

### Fecha: 16/11/2025

## CAPÍTULO I: INTRODUCCIÓN

### Tema.

El trabajo de relevamiento consiste en la recopilación y sistematización de información de todas las instituciones educativas de la provincia correspondientes a los niveles Inicial, Primario y de Adultos, bajo la jurisdicción del Consejo General de Educación. La carga se realizará mediante un formulario digital único y obligatorio, donde cada escuela deberá completar datos institucionales y de funcionamiento definidos previamente. Se excluye la información de matrícula.

### Definición o planteamiento del problema.

Actualmente, la carga de datos se realiza a través de formularios de Google Forms. Este método presenta limitaciones: cada año las escuelas deben volver a cargar la totalidad de la información desde cero, lo que genera redundancia, mayores posibilidades de error y un uso ineficiente del tiempo de los responsables. Con la nueva implementación, el sistema permitirá mantener un registro histórico único y persistente por institución, donde solo deberán actualizarse los datos que hayan cambiado en el transcurso del año, reduciendo significativamente la carga administrativa y mejorando la consistencia de la información.

### Objetivo del trabajo práctico.

El presente Trabajo Práctico se realiza para diseñar e implementar una solución tecnológica superadora al proceso actual de "Relevamiento Anual" de instituciones educativas. La problemática central identificada es la ineficiencia y redundancia del sistema actual (basado en Google Forms), que obliga a las instituciones a cargar la totalidad de sus datos desde cero cada año, incrementando la carga administrativa y el riesgo de inconsistencias.

El lector puede esperar de este trabajo el diseño y la descripción de un nuevo sistema de información. Este sistema estará centrado en la creación de un registro histórico, único y persistente por institución, optimizando el proceso de carga para que el personal solo deba actualizar la información que ha cambiado, mejorando así la eficiencia y la calidad de los datos recopilados por el Consejo General de Educación.

### i. Objetivo general.

Desarrollar e implementar un sistema de gestión de información centralizado para el Relevamiento Anual, que garantice la persistencia de los datos históricos de las instituciones educativas (Nivel Inicial, Primario y de Adultos) y elimine la carga redundante de información, optimizando la eficiencia del proceso y la fiabilidad de los datos recolectados.

### ii. Objetivos específicos.

Para alcanzar el objetivo general, se plantean los siguientes resultados particulares:

- Diseñar un modelo de base de datos capaz de almacenar de forma estructurada y persistente la información institucional y de funcionamiento de cada escuela.
- Implementar un formulario digital que se precargue automáticamente con los datos registrados por la institución en el período anterior al inicio de un nuevo ciclo de relevamiento.
- Desarrollar la funcionalidad que permita al personal de la escuela revisar, validar y únicamente modificar los campos que hayan sufrido cambios respecto al año anterior, en lugar de completar el formulario en su totalidad.
- Reducir significativamente el tiempo administrativo dedicado por el personal de las instituciones a la carga del relevamiento anual.
- Mejorar la consistencia e integridad de la información recopilada, minimizando los errores de carga manual derivados de la reinserción de datos ya existentes.
- Establecer un registro histórico único por institución que facilite la consulta y el análisis de la evolución de los datos a lo largo del tiempo (excluyendo matrícula).

## CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL

En la actualidad, resulta impensable para una administración pública moderna gestionar sus políticas educativas sin el uso de tecnologías de la información. Estas han permitido a los ministerios y consejos de educación automatizar procesos clave como la recolección de datos censales, el seguimiento de indicadores y la gestión de recursos institucionales, lo que mejora significativamente la eficiencia operativa, reduce la carga administrativa sobre las escuelas y aumenta la calidad y fiabilidad de la información para la toma de decisiones.

Aunque el factor humano (directivos y secretarios) sigue siendo esencial para validar la veracidad de la información, la tendencia hacia la automatización de la persistencia de datos es cada vez más fuerte. En el pasado, herramientas como formularios digitales simples (Google Forms) obligaban a reiniciar la carga de datos cada año. En el futuro, la estructura de la recolección de datos cambia drásticamente, adoptando sistemas que "recuerdan" la información y solo solicitan las actualizaciones.

En este contexto, el uso de SQL Server, un motor de bases de datos relacionales, juega un papel fundamental. Este Sistema de Gestión de Información (SGI) permite almacenar y procesar grandes volúmenes de datos relacionados con la operación de las escuelas (información institucional, de funcionamiento, infraestructura, etc.) de manera eficiente, organizada y persistente.

Nuestro caso de estudio utiliza SQL Server como el motor de este SGI, estructurando la información en tablas interrelacionadas. Entre las principales tablas que forman parte del sistema se encuentran las de Instituciones (datos únicos y permanentes como CUE, nombre, domicilio), Datos de Funcionamiento (información que se actualiza anualmente, como oferta pedagógica o servicios) y un Registro Histórico. Cada tabla está diseñada para almacenar datos de manera eficiente, lo que facilita la gestión del relevamiento anual y la consulta histórica.

Este sistema, al integrarse en la administración del Consejo General de Educación, no solo permite una gestión más eficiente del proceso de carga, sino que también agiliza la toma de decisiones estratégicas. En nuestro caso, SQL Server provee una infraestructura robusta que permite acceder y gestionar la información de forma ágil, segura y escalable, lo cual es crucial en la operación anual de relevamiento.

El uso de tecnologías como SQL Server no solo optimiza la gestión interna, sino que también facilita la creación de políticas públicas basadas en evidencia. Un sistema bien estructurado, con una base de datos relacional e histórica, permite al Consejo analizar la evolución del sistema educativo, identificar tendencias y asignar recursos de manera eficiente. Además, la capacidad de acceder a datos fiables en tiempo real facilita la toma de decisiones informadas, lo que impulsa el desarrollo regional y la mejora continua del servicio educativo.

# CAPÍTULO III: METODOLOGÍA SEGUIDA

## Fases del Desarrollo

### Fase de elección de caso de estudio
 El caso de estudio elegido fue el **Sistema de Relevamiento Anual de Instituciones Educativas**, propuesto por un integrante que trabaja en el Consejo General de Educación. 
 Este tema fue seleccionado porque:
- Es un problema real con aplicación práctica inmediata
- Permite aplicar todos los conceptos de la materia
- Tiene complejidad suficiente para demostrar lo aprendido
- Acceso directo a información del dominio del problema

### Fase de desarrollo
En esta fase nos coordinamos de manera que cada integrante del grupo realice un tema determinado

1. **Manejo de permisos a nivel de usuarios de base de datos** - Gerónimo Serial
2. **Procedimientos y funciones almacenadas** - Matías Lago
3. **Optimización de consultas a través de índices** - Marcelo Escalante
4. **Manejo de tipos de datos JSON** - Lucas Mancuello

### Fase de explicación de temas
Una vez terminados los scripts, tuvimos una reunión en la cual cada integrante del grupo explicó cómo trabajó su tema, cómo realizó su script y cualquier aspecto relevante que quisiera aportar al respecto.

### Fase de pruebas
Cuando ya se encontraba todo finalizado, realizamos un conjunto de pruebas a todo el sistema completo para corroborar que no hubiera ninguna falla o error. Testeamos todas las operaciones para contemplar todos los posibles resultados.

### Fase final
Para esta fase nos reunimos todos los integrantes y verificamos los scripts y los readme.
Para corregir cualquier falla o error que surgiera.

---

## Herramientas (Instrumentos y procedimientos)

En la elaboración de nuestro caso de estudio, utilizamos las siguientes herramientas:

1. **ERD Plus**: Una sencilla pero potente herramienta para modelado de bases de datos, teniendo herramientas para crear diagramas relacionales, conceptuales, y código SQL. ERD Plus nos permitió modelar el esquema conceptual.

3. **SQL Server Management**: Una herramienta de gestión y administración de bases de datos desarrollada por Microsoft, específicamente diseñada para trabajar con SQL Server, entre otros lenguajes.

6. **WhatsApp**: Herramienta de mensajería 

7. **Discord**: Plataforma de comunicación para realizar reuniones virtuales

8. **Documentación oficial de Microsoft SQL Server**: Consulta constante de la documentación de SQL Server para implementar correctamente procedimientos, funciones, índices, permisos y JSON.

---

## Metodología de Trabajo

### División de Responsabilidades
Cada integrante asumió la responsabilidad completa de un tema específico:
- Investigación individual del tema asignado
- Desarrollo del script SQL correspondiente
- Creación de documentación (README)
- Pruebas del módulo desarrollado

### Coordinación del Equipo
- **Comunicación asíncrona**: Grupo de WhatsApp para consultas rápidas y coordinación de horarios
- **Comunicación sincrónica**: Reuniones por Discord para revisión conjunta y resolucion de problemas
- **Revisión cruzada**: Cada integrante revisó el trabajo de otros para asegurar calidad y consistencia

### Integración de Módulos
Una vez completados los desarrollos individuales, realizamos sesiones de integración donde:
- Se verificó la compatibilidad entre módulos
- Se realizaron pruebas del sistema completo

---

## Dificultades Encontradas

Durante el desarrollo del proyecto enfrentamos algunos desafíos:

1. **Coordinación de horarios**: Al tener disponibilidad limitada, adoptamos un modelo de trabajo híbrido (asíncrono + sincrónico) que funcionó bien.

3. **Performance de funciones**: Las funciones de tabla tenían rendimiento inferior. Se solucionó implementando índices estratégicos y usando funciones inline cuando era posible.

---
