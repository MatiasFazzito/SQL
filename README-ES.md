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

> 🚀 Diseñado con flexibilidad y escenarios reales en mente.
