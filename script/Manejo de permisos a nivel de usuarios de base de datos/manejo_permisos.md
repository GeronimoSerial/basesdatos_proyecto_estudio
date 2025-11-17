# Tema: Manejo de permisos a nivel de usuarios de base de datos.

## Introducción

El presente informe documenta el proceso de implementación, configuración y verificación del esquema de seguridad aplicado sobre una base de datos institucional desarrollada en SQL Server.

## Configuración del entorno

El servidor SQL Server se encuentra configurado en modo mixto (Windows Authentication + SQL Server Authentication)

Esta configuración es requisito indispensable para permitir la autenticación con usuarios SQL definidos manualmente mediante CREATE LOGIN

## Permiso a nivel de usuarios

Este bloque implementa un caso práctico donde se definen dos usuarios con niveles de acceso claramente diferenciados:

**admin_user →** Usuario administrador con control total sobre la base.

**lector_user →** Usuario con permisos únicamente de lectura, pero autorizado a ejecutar procedimientos almacenados.

Este enfoque permite validar el concepto de seguridad encapsulada mediante procedimientos almacenados.

### Creación de logins a nivel servidor

Los logins son las credenciales que permiten autenticar a un usuario en la instancia SQL Server.

Se crean con el siguiente comando

```jsx
CREATE LOGIN admin_user WITH PASSWORD = 'contrasena_admin';
CREATE LOGIN lector_user WITH PASSWORD = 'contrasena_lector';

```

### Creación de usuarios en la base de datos

Una vez creados los logins, deben asociarse a la base mediante usuarios locales:

```jsx
USE consejo;
GO
CREATE USER admin_user FOR LOGIN admin_user;
CREATE USER lector_user FOR LOGIN lector_user;
```

**Finalidad:**

Representa al login dentro de la base de datos y permite aplicar permisos sobre tablas, procedimientos o roles.

### Asignación de permisos

**Usuario administrador:**

```jsx
ALTER ROLE db_owner ADD MEMBER admin_user;
```

Este rol otorga control total sobre la base, equivalente a un administrador. Puede realizar operaciones DDL y DML.

**Usuario de solo lectura**

```jsx
GRANT SELECT TO lector_user;
```

Restringe al usuario únicamente a la lectura de datos. No puede insertar, modificar ni eliminar registros.

**Permisos de ejecución sobre procedimientos almacenados.**

El usuario con solo lectura debería poder ejecutar un procedimiento almacenado previamente creado.

Ejemplo con **insertarPersona**

```jsx
GRANT EXECUTE ON dbo.insertarPersona TO lector_user;
```

Permite que el usuario ejecute lógica encapsulada, sin necesidad de tener permisos directos de escritura sobre la tabla

Este comportamiento se sustenta en el mecanismo de **ownership chaining**, mediante el cual SQL Server autoriza la ejecución del SP siempre que:

- El usuario tenga permiso de `EXECUTE`.
- El propietario del SP y de las tablas involucradas sea el mismo (dbo)

### Pruebas funcionales

1. **Prueba de INSERT directo (usuario admin)**

```jsx
INSERT INTO rrhh.persona (dni, nombre, apellido, telefono, mail)
VALUES (12345678, 'Juan', 'Perez', 3794000000, 'juan@mail.com');
```

**Resultado esperado:**

Inserción exitosa.

![admin_user.png](https://github.com/GeronimoSerial/basesdatos_proyecto_estudio/blob/main/doc/admin_user.png)

1. **Prueba de INSERT directo (usuario lector)**

```jsx
INSERT INTO rrhh.persona (dni, nombre, apellido, telefono, mail)
VALUES (11111111, 'Luis', 'Gomez', 3794111111, 'luis@mail.com');
```

**Resultado esperado:**

Error de permisos.

![lector_sin_permisos.png](https://github.com/GeronimoSerial/basesdatos_proyecto_estudio/blob/main/doc/lector_sin_permisos.png)

1. **Prueba de INSERT a través del procedimiento almacenado**

```jsx
EXEC dbo.insertarPersona
  @DNI = 22222222,
  @Nombre = 'Mario',
  @Apellido = 'Lopez',
  @Telefono = 3794222222,
  @Mail = 'mario@mail.com';

```

**Resultado esperado:**

Inserción exitosa, aún cuando el usuario no posee permisos directos de INSERT.

![lector_procedimiento.png](https://github.com/GeronimoSerial/basesdatos_proyecto_estudio/blob/main/doc/lector_procedimiento.png)

## Permiso a nivel de roles del DBMS

Este bloque desarrolla un modelo de seguridad escalable mediante roles, donde los permisos se asignan al rol y luego éste se asigna a los usuarios.

Se busca demostrar:

- Diferencias entre permisos directos y delegados
- Comportamiento al intentar leer una tabla con y sin permisos heredados

**Creación de nuevos logins y usuarios**

```jsx
CREATE LOGIN user_a WITH PASSWORD = 'user_a_pass';

CREATE LOGIN user_b WITH PASSWORD = 'user_b_pass';

-- Creación de usuarios nuevos para permisos a nivel de roles.
CREATE USER user_a FOR LOGIN user_a;

CREATE USER user_b FOR LOGIN user_b;
```

**Creación del rol con permiso de lectura**

El rol se limita a leer la tabla institucional.escuela:

```jsx
CREATE ROLE rol_lectura_escuela;
GRANT SELECT ON institucional.escuela TO rol_lectura_escuela;
```

**Finalidad:**

Centralizar permisos en un rol, evitando asignarlos directamente a cada usuario

**Asignación del rol a un usuario**

```jsx
ALTER ROLE rol_lectura_escuela ADD MEMBER user_a;
```

### Pruebas funcionales

**Lectura con usuario que tiene el rol**

```jsx
SELECT TOP 10 nombre, cue FROM institucional.escuela;
```

**Resultado esperado:**

Consulta exitosa.

**Lectura con usuario sin rol**

```jsx
SELECT TOP 10 nombre, cue FROM institucional.escuela;

```

**Resultado esperado:**

Error → (user_b no pertenece al rol y no tiene permisos directos)

![user_sin_permisos_rol.png](https://github.com/GeronimoSerial/basesdatos_proyecto_estudio/blob/main/doc/user_sin_permisos_rol.png)

## Conclusiones

1. **Seguridad por usuarios:**

   El usuario administrador posee control total sobre la base, mientras que el usuario lector queda limitado estrictamente a la lectura.

   Se verificó que este último no puede realizar inserciones directas, pero sí ejecutar procedimientos almacenados gracias a la seguridad basada en ejecución (ownership chaining).

2. **Seguridad por roles:**

   La creación del rol `rol_lectura_escuela` permitió centralizar permisos y delegar lectura a `user_a` de forma ordenada y escalable.

   Se comprobó que los usuarios sin pertenencia al rol no pueden acceder a la información.

3. **Encapsulamiento mediante procedimientos almacenados:**

   El uso de procedimientos permitió otorgar permisos de ejecución sin exponer permisos directos sobre las tablas, garantizando mayor control y coherencia en la manipulación de datos.

4. **Buenas prácticas institucionales:**

   La implementación de este esquema asegura:

   - Control granular del acceso.
   - Trazabilidad y coherencia.
   - Administración simplificada de permisos.
   - Mayor seguridad frente a errores operativos o usos indebidos.
