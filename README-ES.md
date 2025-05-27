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

**Código del Trigger:**

```sql
DELIMITER $$

CREATE TRIGGER after_concert_insert
AFTER INSERT ON concert
FOR EACH ROW
BEGIN
    CALL assign_specialty_to_concert(NEW.ID, 1); -- Paramedic
    CALL assign_specialty_to_concert(NEW.ID, 2); -- Firefighter
    CALL assign_specialty_to_concert(NEW.ID, 3); -- Rescuer
    CALL assign_specialty_to_concert(NEW.ID, 4); -- Police/Security
END$$

DELIMITER ;
```

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

**Fórmula utilizada:**

```sql
CEIL(get_specialty_multiplier(p_specialty) * p_tickets / 200)
```

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

### 📌 `asign_staff_to_all_concerts()`

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

### 📄 `asignation_details`

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
