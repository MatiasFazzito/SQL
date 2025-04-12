# 🎶 Logistics Control Database for Concerts and Events

This database is designed for a **logistics control software** for concerts and events. It allows tracking of:

- The **bands/artists** performing at each event
- The **stadium** where the event takes place
- The **medical and security staff** assigned based on ticket sales

The system dynamically assigns staff based on ticket sales, ensuring a **minimum required presence** during the event and providing **recommendations** based on the **maximum stadium capacity**. The calculation follows **safety standards** required by each country.

> 🛠️ **Note:** For presentation and testing purposes, the initial model is based on the **Republic of Argentina**, but it can be adapted to other industries or countries by changing the setup parameters.

---

## 📊 Base Safety Requirements (Argentina Example)

For **music events**, the following minimum staffing requirements are established:

- 👩‍⚕️ 1 Paramedic and 👨‍🚒 1 Firefighter per **200 attendees**
- 🧗‍♂️ 3 Rescue Workers and 👮‍♂️ 3 Police/Security Personnel per **200 attendees**

---

## 🧩 Tables Overview

### 1. `Bands`

Stores relevant data about the bands or artists.

| Field       | Type            | Description                     |
|-------------|------------------|---------------------------------|
| ID          | `INT` (PK)       | Unique band/artist identifier   |
| Name        | `VARCHAR`        | Name of the band/artist         |
| Members     | `INT`            | Number of members               |
| Nationality | `VARCHAR`        | Country of origin               |
| Language    | `VARCHAR`        | Primary language                |
| Genre       | `VARCHAR`        | Music genre                     |

---

### 2. `Stadium`

Stores information about event venues.

| Field    | Type            | Description                       |
|----------|------------------|-----------------------------------|
| ID       | `INT` (PK)       | Unique stadium identifier         |
| Name     | `VARCHAR`        | Stadium name                      |
| Country  | `VARCHAR`        | Location country                  |
| Capacity | `INT`            | Maximum audience capacity         |

---

### 3. `Staff`

Stores information about personnel available for event assignments.

| Field     | Type            | Description                       |
|-----------|------------------|-----------------------------------|
| ID        | `INT` (PK)       | Unique staff identifier           |
| Name      | `VARCHAR`        | Staff member name                 |
| Gender    | `VARCHAR`        | Gender                            |
| Age       | `INT`            | Age                               |
| Specialty | `INT` (FK)       | Reference to `Specialty` table    |

---

### 4. `Specialty`

Reference table for staff specializations.

| Field | Type            | Description             |
|--------|------------------|-------------------------|
| ID     | `INT` (PK)       | Unique specialty ID     |
| Name   | `VARCHAR`        | Name of the specialty   |

---

### 5. `Concert`

Associates bands with stadiums and includes ticket sales data.

| Field        | Type            | Description                     |
|--------------|------------------|---------------------------------|
| ID           | `INT` (PK)       | Unique concert identifier       |
| Tickets_Sold | `INT`            | Number of tickets sold          |
| Band         | `INT` (FK)       | Reference to `Bands` table      |
| Stadium      | `INT` (FK)       | Reference to `Stadium` table    |

---

### 6. `Asignation`

Assigns staff members to specific concerts.

| Field   | Type            | Description                     |
|----------|------------------|---------------------------------|
| ID       | `INT` (PK)       | Unique assignment ID           |
| Concert  | `INT` (FK)       | Reference to `Concert` table   |
| Staff    | `INT` (FK)       | Reference to `Staff` table     |

---

## 🧩 Future Adaptability

This model is scalable and adaptable for:

- Different **types of events** (sports, conferences, etc.)
- Other **countries and regulations**
- Alternative **staffing rules and parameters**

All of this can be configured during the installation phase.

---

## 📁 Use Cases

- 🎤 Concert safety planning  
- 🏟️ Stadium event logistics  
- 🧑‍⚕️ Automated staff assignment based on crowd size  
- 📊 Simulation and testing for different event types

---

> 🚀 Built with flexibility and real-world scenarios in mind.
