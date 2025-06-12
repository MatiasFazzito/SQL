# 🎶 ConcertIO

## 📚 Índice

- [🎶 Introducción](#-base-de-datos-para-control-logístico-de-conciertos-y-eventos)
- [📊 Requisitos de Seguridad Base](#-requisitos-de-seguridad-base-ejemplo-argentina)
- [🔗 Diagrama de Entidad-Relacion](http://github.com/MatiasFazzito/SQL/blob/main/Entity%20relation%20diagram.png)
- [🧪 Pasos para la ejecución de la base de datos](#-pasos-para-la-ejecución-de-la-base-de-datos)
- [🧩 Descripción de Tablas](#-descripción-de-tablas)
  - [`Bands`](#1-bands)
  - [`Stadium`](#2-stadium)
  - [`Staff`](#3-staff)
  - [`Specialty`](#4-specialty)
  - [`Concert`](#5-concert)
  - [`Asignation`](#6-asignation)
  - [`Audit_Log`](#7-audit_log)
- [⚡ Trigger Definido](#-trigger-definido)
  - [`after_concert_insert`](#-after_concert_insert)
  - [Triggers de Auditoría `bands`](#-triggers-de-auditoría-para-la-tabla-bands)
  - [Triggers de Auditoría `stadium`](#-triggers-de-auditoría-para-la-tabla-stadium)
  - [Triggers de Auditoría `concert`](#-triggers-de-auditoría-para-la-tabla-concert)
  - [Triggers de Auditoría `staff`](#-triggers-de-auditoría-para-la-tabla-staff)
- [🧠 Funciones Definidas en la Base de Datos](#-funciones-definidas-en-la-base-de-datos)
  - [`get_specialty_multiplier()`](#-get_specialty_multiplierp_specialty-int)
  - [`get_required_staff()`](#-get_required_staffp_tickets-int-p_specialty-int)
- [⚙️ Stored Procedures](#-listado-de-stored-procedures)
  - [`assign_specialty_to_concert()`](#-assign_specialty_to_concertp_concert_id-int-p_specialty-int)
  - [`assign_staff_to_all_concerts()`](#-assign_staff_to_all_concerts)
- [🔍 Vistas Definidas](#-listado-de-vistas-definidas)
  - [`assignment_details`](#-assignment_details)
  - [`concert_details`](#-concert_details)
  - [`staff_details`](#-staff_details)
- [📦 Uso del Data Warehouse como Backup Manual](#-uso-del-data-warehouse-como-backup-manual)
- [🧩 Adaptabilidad Futura](#-adaptabilidad-futura)
- [📁 Casos de Uso](#-casos-de-uso)
- [📄 Informe de Cumplimiento de Normas de Seguridad en Conciertos](#-informe-de-cumplimiento-de-normas-de-seguridad-en-conciertos)

---

# 🎶 Base de Datos para Control Logístico de Conciertos y Eventos

Esta base de datos está diseñada para un **software de control logístico** de conciertos y eventos. Permite el seguimiento de:

- Las **bandas/artistas** que se presentarán en cada evento  
- El **estadio o predio** donde se llevará a cabo  
- El **staff médico y de seguridad** asignado según la cantidad de entradas vendidas

El sistema asigna dinámicamente al personal requerido según la venta de entradas, garantizando una **presencia mínima obligatoria** durante el evento y proporcionando **recomendaciones** basadas en la **capacidad máxima del estadio**. El cálculo se realiza en base a los **estándares de seguridad** requeridos por cada país.

> 🛠️ **Nota:** Para fines de presentación y prueba, el modelo inicial está basado en la **República Argentina**, pero puede adaptarse a otras industrias o países modificando los parámetros en la instalación.

---

## 📊 Requisitos de Seguridad Base (Ejemplo Argentina)

Para eventos **musicales**, se establece el siguiente mínimo obligatorio de personal:

- 👩‍⚕️ 1 Paramédico y 👨‍🚒 1 Bombero cada **200 asistentes**
- 🧗‍♂️ 3 Rescatistas y 👮‍♂️ 3 Policías/Encargados de seguridad cada **200 asistentes**

---

## 🧪 Pasos para la ejecución de la base de datos

A continuación se detallan los pasos necesarios para implementar correctamente esta base de datos en un entorno local o de desarrollo:

1. **Crear la base de datos**  
   - Ejecutar el script de creación de la base de datos [este archivo](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql) contiene la creacion de las tablas con sus respectivas claves relacionales y triggers.

2. **Seleccionar la base de datos a utilizar**  
   - Dentro del [archivo](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql) ejecutar el comando `USE concertio ;`.

3. **Crear todas las tablas**  
   - Dentro del [archivo](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql) ejecutar el script que contiene las definiciones de las tablas (`bands`, `stadium`, `staff`, etc.).

4. **Crear los triggers**  
   - Dentro del [archivo](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql) ejecutar la porcion del script que crea los triggers necesarios (`after_concert_insert`, y los de auditoría para `bands`, `stadium`, `concert`, `staff`).
  
> 💡 **Pro Tip:** Estos primeros pasos pueden hacerse automaticamente si eecutas todo el bloque definido en el archivo inicial dejando la base de datos lista en su mayoria.
  
5. **Crear vistas**  
   - Desde este [fichero](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Views) ejecutar uno por uno los scripts que generan las vistas haciendo click derecho en el apartado `Views` del schema (`asignation_details`, `concert_details`, `staff_details`).

6. **Crear funciones**  
   - Desde este [fichero](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Functions) Ejecutar uno por uno los scripts que definen las funciones (`get_required_staff`, `get_specialty_multiplier`).
  
7. **Crear los procedimientos almacenados**  
   - Desde este [fichero](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Procedures) Ejecutar uno por uno los scripts que definen los procedimientos (`assign_specialty_to_concert`, `asign_staff_to_all_concerts`).

8. **Insertar datos iniciales**  
   - Cargar datos de prueba ejecutando el siguiente [script](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Data%20insertion/Mock_Data_Stress_Insertion.sql) o datos reales en las tablas principales (`bands`, `stadium`, `specialty`, `staff`, etc.).
   - 
> 💡 **Sugerencia:** Asegurate de ejecutar los scripts en el orden correcto en este paso para evitar errores de referencias cruzadas o claves foráneas, se recomienda seguir el orden detallado en el archivo de prueba provisto.

9. **Verificar el funcionamiento**  
   - Insertar un concierto nuevo y comprobar si se asigna el staff automáticamente.  
   - Revisar si los triggers de auditoría están registrando los cambios.

10. **Adaptar parámetros si es necesario**  
   - Cambiar multiplicadores o reglas de asignación según el país o tipo de evento.

11. **(Opcional) Cargar más datos o realizar pruebas**  
   - Utilizar los procedimientos y vistas para ejecutar pruebas funcionales.

12. **Generado de backups**  
   -  Desde este [fichero](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Data%20Warehouse) ejecutar el [script de creacion de Data Warehouse](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Data%20Warehouse/DW_Schema_And_Tables_Creation.sql) para crear el la estructura del backup.

13. **Generado de backups**  
   -  Desde este [fichero](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Data%20Warehouse) ejecutar el [script de insercion de datos](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Data%20Warehouse/DW_Data_Insertion.sql) para realizar el backup.

---

> 💡 **Sugerencia:** Asegurate de ejecutar los scripts en el orden correcto para evitar errores de referencias cruzadas o claves foráneas.

---

## 🧩 Descripción de Tablas

### 1. `Bands`

Almacena datos relevantes de las bandas o artistas.

| Campo       | Tipo             | Descripción                      |
|-------------|------------------|----------------------------------|
| ID          | `INT` (PK)       | Identificador único              |
| Name        | `VARCHAR`        | Nombre de la banda/artista       |
| Members     | `INT`            | Cantidad de integrantes          |
| Nationality | `VARCHAR`        | Nacionalidad                     |
| Language    | `VARCHAR`        | Idioma principal                 |
| Genre       | `VARCHAR`        | Género musical                   |

---

### 2. `Stadium`

Contiene información sobre los estadios o predios.

| Campo    | Tipo             | Descripción                       |
|----------|------------------|-----------------------------------|
| ID       | `INT` (PK)       | Identificador único               |
| Name     | `VARCHAR`        | Nombre del estadio                |
| Country  | `VARCHAR`        | País donde se encuentra           |
| Capacity | `INT`            | Capacidad máxima de público       |

---

### 3. `Staff`

Almacena información sobre el personal disponible para asignar a eventos.

| Campo     | Tipo             | Descripción                       |
|-----------|------------------|-----------------------------------|
| ID        | `INT` (PK)       | Identificador único               |
| Name      | `VARCHAR`        | Nombre del personal               |
| Gender    | `VARCHAR`        | Género                            |
| Age       | `INT`            | Edad                              |
| Specialty | `INT` (FK)       | Referencia a tabla `Specialty`    |

---

### 4. `Specialty`

Tabla de referencia para las especialidades del staff.

| Campo | Tipo             | Descripción             |
|--------|------------------|-------------------------|
| ID     | `INT` (PK)       | ID único de especialidad|
| Name   | `VARCHAR`        | Nombre de la especialidad|

---

### 5. `Concert`

Relaciona bandas con estadios y registra la cantidad de entradas vendidas.

| Campo        | Tipo             | Descripción                      |
|--------------|------------------|----------------------------------|
| ID           | `INT` (PK)       | Identificador del concierto      |
| Tickets_Sold | `INT`            | Entradas vendidas                |
| Band         | `INT` (FK)       | Referencia a la tabla `Bands`    |
| Stadium      | `INT` (FK)       | Referencia a la tabla `Stadium`  |

---

### 6. `Asignation`

Asigna miembros del staff a conciertos específicos.

| Campo   | Tipo             | Descripción                      |
|----------|------------------|----------------------------------|
| ID       | `INT` (PK)       | Identificador de asignación     |
| Concert  | `INT` (FK)       | Referencia a la tabla `Concert` |
| Staff    | `INT` (FK)       | Referencia a la tabla `Staff`   |

---

### 7. `Audit_Log`

Almacena un historial de acciones realizadas sobre otras tablas para fines de auditoría.

| Campo       | Tipo                             | Descripción                                                                 |
|-------------|----------------------------------|-----------------------------------------------------------------------------|
| ID          | `INT` (PK, AUTO_INCREMENT)       | Identificador único de la entrada en el log                                |
| Table_Name  | `VARCHAR(64)`                    | Nombre de la tabla sobre la cual se realizó la acción                      |
| Action_Type | `ENUM('INSERT', 'UPDATE', 'DELETE')` | Tipo de acción registrada (INSERT, UPDATE o DELETE)                    |
| Action_Time | `TIMESTAMP` (DEFAULT CURRENT_TIMESTAMP) | Fecha y hora en que se ejecutó la acción                              |
| Old_Data    | `JSON`                           | Datos previos a la modificación (solo UPDATE y DELETE)                     |
| New_Data    | `JSON`                           | Datos nuevos resultantes de la acción (solo INSERT y UPDATE)              |

📌 *Esta tabla está diseñada para registrar automáticamente los cambios en otras tablas mediante triggers personalizados, permitiendo realizar auditorías completas del sistema.*

---

## ⚡ Trigger Definido

Esta sección documenta el trigger creado en la base de datos, explicando su propósito, cómo funciona y qué procedimientos invoca automáticamente.

---

### 🧩 `after_concert_insert`

**Descripción:**  
Trigger que se ejecuta automáticamente después de insertar un nuevo registro en la tabla `concert`.

**Objetivo:**  
Asignar inmediatamente el personal necesario a un nuevo concierto basado en la cantidad de entradas vendidas y según los requerimientos por especialidad. Automatiza el proceso de asignación sin necesidad de ejecutar procedimientos manualmente luego de cada inserción.

**Funcionamiento:**  
Al agregarse un nuevo concierto, este trigger llama automáticamente al procedimiento `assign_specialty_to_concert` para cada una de las especialidades requeridas:

- `1`: Paramédico
- `2`: Bombero
- `3`: Rescatista
- `4`: Policía/Seguridad

---

### 🔔 Triggers de Auditoría para la Tabla `bands`

**Descripción:**  
Estos tres triggers se ejecutan automáticamente después de operaciones de inserción, actualización y eliminación en la tabla `bands`. Registran los cambios realizados en los registros de bandas en la tabla `audit_log`, capturando los datos relevantes antes y/o después de las modificaciones para mantener un historial de auditoría.

**Objetivo:**  
Garantizar la trazabilidad y auditoría de todas las modificaciones en la tabla `bands` mediante el registro de inserciones, actualizaciones y eliminaciones. Esto ayuda a monitorear la integridad de los datos y proporciona un registro histórico de los cambios en la información de las bandas.

---

### 🔔 Triggers de Auditoría para la Tabla `stadium`

**Descripción:**  
Estos tres triggers se ejecutan automáticamente después de operaciones de inserción, actualización y eliminación en la tabla `stadium`. Registran los cambios realizados en los registros de estadios en la tabla `audit_log`, capturando los datos relevantes antes y/o después de las modificaciones para mantener un historial de auditoría.

**Objetivo:**  
Garantizar la trazabilidad y auditoría de todas las modificaciones en la tabla `stadium` mediante el registro de inserciones, actualizaciones y eliminaciones. Esto ayuda a monitorear la integridad de los datos y proporciona un registro histórico de los cambios en la información de los estadios.

---

### 🔔 Triggers de Auditoría para la tabla `concert`

**Descripción:**  
Estos tres triggers se ejecutan automáticamente después de operaciones de inserción, actualización y eliminación en la tabla `concert`. Registran los cambios realizados en los registros de conciertos en la tabla `audit_log`, capturando los datos relevantes antes y/o después de las modificaciones para mantener un historial de auditoría.

**Objetivo:**  
Garantizar la trazabilidad y auditoría de todas las modificaciones en la tabla `concert` mediante el registro de inserciones, actualizaciones y eliminaciones. Esto ayuda a monitorear la integridad de los datos y proporciona un historial de los cambios en la información de los conciertos.

---

### 🔔 Triggers de Auditoría para la tabla `staff`

**Descripción:**  
Estos tres triggers se ejecutan automáticamente después de operaciones de inserción, actualización y eliminación en la tabla `staff`. Registran los cambios realizados en los registros del personal en la tabla `audit_log`, capturando los datos relevantes antes y/o después de las modificaciones para mantener un historial completo de auditoría.

**Objetivo:**  
Garantizar la trazabilidad y auditoría de todas las modificaciones en la tabla `staff` mediante el registro de inserciones, actualizaciones y eliminaciones. Esto facilita el monitoreo de la integridad de los datos y proporciona un registro histórico de los cambios en la información del personal.

---

## 🧠 Funciones Definidas en la Base de Datos

Esta sección detalla las funciones creadas en la base de datos, su propósito y cómo interactúan con los datos existentes. Estas funciones están diseñadas para automatizar el cálculo del personal requerido según la especialidad y la cantidad de entradas vendidas.

---

### 🔧 `get_specialty_multiplier(p_specialty INT)`

**Descripción:**  
Devuelve el multiplicador asociado a cada especialidad del staff según los requisitos mínimos de personal por tipo para eventos.

**Objetivo:**  
Establecer la proporción de personal requerido por cada tipo de especialidad según los estándares establecidos. Esta función es utilizada internamente para calcular la cantidad de personal necesario de una especialidad específica.

**Valores devueltos según `p_specialty`:**

| Especialidad (`p_specialty`) | Multiplicador | Descripción      |
|-----------------------------|----------------|------------------|
| 1                           | 1              | Paramédico       |
| 2                           | 1              | Bombero          |
| 3                           | 3              | Rescatista       |
| 4                           | 3              | Policía/Seguridad|
| Otro                        | 0              | Sin asignación   |

**Tablas relacionadas:**  
- `Specialty`: Se basa en los IDs de especialidad, aunque no accede directamente a la tabla.

---

### 🔧 `get_required_staff(p_tickets INT, p_specialty INT)`

**Descripción:**  
Calcula la cantidad total de personal requerido para una especialidad dada, basado en la cantidad de entradas vendidas.

**Objetivo:**  
Determinar cuántos miembros del staff se necesitan de una especialidad específica para un evento determinado, aplicando las reglas proporcionales (por cada 200 tickets vendidos).

---

## ⚙️ Listado de Stored Procedures

Esta sección documenta los procedimientos almacenados definidos en la base de datos. Estos procedimientos permiten automatizar tareas críticas como la asignación de personal a los conciertos según su especialidad y la cantidad de entradas vendidas, reduciendo la posibilidad de errores y mejorando la eficiencia operativa.

---

### 📌 `assign_specialty_to_concert(p_concert_id INT, p_specialty INT)`

**Descripción:**  
Asigna automáticamente miembros del staff de una especialidad determinada a un concierto específico, de forma proporcional a la cantidad de entradas vendidas.

**Objetivo y beneficios:**  
- Automatiza la asignación de personal específico (paramédicos, bomberos, rescatistas, policías).
- Evita duplicidad en las asignaciones (verifica que el staff no esté previamente asignado al mismo concierto).
- Se adapta a los requerimientos dinámicos de personal según la demanda (entradas vendidas).

**Funcionamiento:**  
1. Consulta la cantidad de entradas vendidas (`concert`).
2. Calcula el número requerido de personal según especialidad (`get_required_staff`).
3. Utiliza un cursor para recorrer los miembros del staff disponibles de esa especialidad.
4. Inserta las asignaciones hasta completar el número necesario.

**Tablas involucradas:**
- `concert`: para obtener las entradas vendidas.
- `staff`: para seleccionar personal disponible según especialidad.
- `asignation`: para registrar las asignaciones de staff a conciertos.

**Funciones utilizadas:**
- `get_required_staff()`

---

### 📌 `assign_staff_to_all_concerts()`

**Descripción:**  
Realiza la asignación de personal para **todas las especialidades** en **todos los conciertos** registrados en la base de datos.

**Objetivo y beneficios:**  
- Ejecuta en un solo paso la asignación completa del personal a todos los eventos.  
- Útil para simulaciones, pruebas o cargas iniciales de datos.  
- Garantiza que todos los conciertos tengan al menos el personal mínimo requerido por especialidad.  
- **Alternativa al trigger `after_concert_insert`**: este procedimiento puede utilizarse manualmente si el usuario prefiere no activar el trigger automático al insertar conciertos.

**Funcionamiento:**  
1. Recorre todos los conciertos registrados mediante un cursor.  
2. Para cada concierto, llama al procedimiento `assign_specialty_to_concert` para cada tipo de especialidad (1 a 4).

**Tablas involucradas:**  
- `concert`: para recorrer todos los eventos.  
- `asignation`: para insertar las asignaciones resultantes.  
- `staff`: accedida indirectamente por el procedimiento interno.

**Procedimientos utilizados:**  
- `assign_specialty_to_concert()`

---

## 🔍 Listado de Vistas Definidas

Esta sección describe las vistas creadas en la base de datos para facilitar el acceso a información compuesta y mejorar la legibilidad de los datos. Las vistas permiten obtener resultados combinando múltiples tablas sin necesidad de escribir consultas complejas cada vez.

---

### 📄 `assignment_details`

**Descripción:**  
Muestra una relación entre cada asignación de personal, el nombre del miembro del staff asignado y el estadio donde trabajará.

**Objetivo:**  
Facilitar el seguimiento de qué miembro del staff fue asignado a qué evento y en qué estadio prestará servicio.

**Tablas involucradas:**
- `asignation`: Relación entre conciertos y personal.
- `staff`: Contiene los datos del personal.
- `concert`: Conciertos donde se asigna el personal.
- `stadium`: Lugar donde se realiza el evento.

**Columnas devueltas:**
- `Asignation_ID`
- `Staff_Name`
- `Stadium_Name`

---

### 📄 `concert_details`

**Descripción:**  
Proporciona detalles resumidos de cada concierto, especificando qué banda tocará y en qué estadio se realizará.

**Objetivo:**  
Ofrecer una vista rápida de los eventos programados, incluyendo las bandas y los lugares asociados.

**Tablas involucradas:**
- `concert`: Contiene los conciertos registrados.
- `bands`: Datos de las bandas o artistas.
- `stadium`: Información de los estadios.

**Columnas devueltas:**
- `Concert_ID`
- `Band_Name`
- `Stadium_Name`

---

### 📄 `staff_details`

**Descripción:**  
Muestra una lista detallada del personal, con su nombre y la especialidad asignada.

**Objetivo:**  
Simplificar la identificación del staff según su especialidad sin necesidad de hacer múltiples uniones en las consultas.

**Tablas involucradas:**
- `staff`: Información del personal.
- `specialty`: Detalles de cada especialidad.

**Columnas devueltas:**
- `Staff_ID`
- `Staff_Name`
- `Specialty_Name`

---

## 📦 Uso del Data Warehouse como Backup Manual

En el contexto del sistema **ConcertIO**, se implementó un **Data Warehouse (DW)** que, además de permitir el análisis histórico y la generación de reportes, cumple también una función clave como mecanismo de **respaldo manual** de los datos operativos.

### 🧱 Estructura del Data Warehouse

El Data Warehouse se implementó en un esquema independiente llamado `concertio_dw`, con tablas que replican la estructura de las tablas clave del sistema, como conciertos, staff y asignaciones.

---

## 🧩 Adaptabilidad Futura

Este modelo es escalable y adaptable a:

- Distintos **tipos de eventos** (deportivos, conferencias, etc.)  
- Otros **países y normativas locales**  
- Reglas de **asignación de personal** personalizadas  

Todo esto se puede configurar durante la fase de instalación.

---

## 📁 Casos de Uso

- 🎤 Planificación de seguridad para conciertos  
- 🏟️ Logística de eventos en estadios  
- 🧑‍⚕️ Asignación automática de personal según el público estimado  
- 📊 Simulación y pruebas para distintos tipos de eventos

---

## 📄 Informe de Cumplimiento de Normas de Seguridad en Conciertos

### 🎯 Objetivo del informe

El presente [informe]() tiene como finalidad evaluar el **cumplimiento de las normas mínimas de seguridad** establecidas para eventos masivos, específicamente conciertos musicales, utilizando como base la cantidad de entradas vendidas y el personal asignado a cada evento según su especialidad.

---

### 🧾 Descripción de los datos analizados

Este análisis se realizó en base a los datos reales del sistema **ConcertIO**, incluyendo:

- Información detallada de los conciertos (banda, estadio, entradas vendidas).
- Personal asignado por concierto, clasificado por especialidad:
  - Paramédicos  
  - Bomberos  
  - Rescatistas  
  - Personal de seguridad
- Reglas de seguridad aplicadas:
  - 1 paramédico y 1 bombero cada 200 asistentes  
  - 3 rescatistas y 3 agentes de seguridad cada 200 asistentes

Se calculó, para cada concierto, la cantidad mínima de personal requerido por especialidad y se comparó con el personal realmente asignado.

---

### 📊 Contenido del dashboard

El dashboard visual contiene:

- **Indicadores clave (KPI):**
  - Total de conciertos registrados  
  - Porcentaje de eventos que cumplen con la normativa  
  - Total de personal asignado por especialidad

- **Tablas de detalle por concierto:**
  - Comparación entre requerimiento y asignación  
  - Porcentaje de ocupación de cada estadio  
  - Indicadores visuales de cumplimiento (✅ / ❌)

---

### ✅ Conclusiones

El [informe](https://github.com/MatiasFazzito/SQL/tree/main/Audit) permite identificar rápidamente qué conciertos cumplen con los requisitos mínimos de seguridad exigidos por la normativa vigente, y en cuáles es necesario reforzar la asignación de personal. Esta evaluación contribuye a optimizar la planificación operativa y a garantizar condiciones adecuadas para el desarrollo de eventos masivos.

Además, el análisis integrado de la **capacidad del estadio** y la **cantidad de entradas vendidas** permite realizar un seguimiento del **porcentaje de ocupación real** por evento, lo cual resulta útil tanto para fines logísticos como para detectar posibles **situaciones de sobreventa de tickets**, que podrían comprometer la seguridad y la experiencia del público.

---

> 🚀 Diseñado con flexibilidad y escenarios reales en mente.
