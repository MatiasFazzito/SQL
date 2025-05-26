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

## ⚡ Defined Trigger

This section documents the trigger created in the database, explaining its purpose, functionality, and which procedures it automatically invokes.

---

### 🧩 `after_concert_insert`

**Description:**  
Trigger that is automatically executed after a new record is inserted into the `concert` table.

**Purpose:**  
Immediately assigns the required staff to a newly created concert based on the number of tickets sold and the required specialties. This automation eliminates the need to manually assign personnel after each new concert is added.

**How it works:**  
When a new concert is inserted, this trigger automatically calls the `assign_specialty_to_concert` procedure for each required staff specialty:

- `1`: Paramedic  
- `2`: Firefighter  
- `3`: Rescuer  
- `4`: Police/Security  

**Trigger code:**

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

## 🧠 Defined Functions in the Database

This section details the functions created in the database, their purpose, and how they interact with existing data. These functions are designed to automate the calculation of the required staff based on specialty and the number of tickets sold.

---

### 🔧 `get_specialty_multiplier(p_specialty INT)`

**Description:**  
Returns the multiplier associated with each staff specialty according to the minimum personnel requirements per type for events.

**Purpose:**  
Establishes the required staff proportion for each type of specialty according to defined safety standards. This function is internally used to calculate the amount of staff required for a specific specialty.

**Returned values based on `p_specialty`:**

| Specialty (`p_specialty`)   | Multiplier | Description         |
|-----------------------------|------------|---------------------|
| 1                           | 1          | Paramedic           |
| 2                           | 1          | Firefighter         |
| 3                           | 3          | Rescuer             |
| 4                           | 3          | Police/Security     |
| Other                       | 0          | Not assigned        |

**Related tables:**  
- `Specialty`: Based on specialty IDs, although the function does not directly query this table.

---

### 🔧 `get_required_staff(p_tickets INT, p_specialty INT)`

**Description:**  
Calculates the total number of staff required for a given specialty, based on the number of tickets sold.

**Purpose:**  
Determines how many staff members are needed for a specific specialty in a given event, applying proportional rules (1 paramedic and 1 firefighter, and 3 rescuers and 3 security per 200 tickets).

**Formula used:**

```sql
CEIL(get_specialty_multiplier(p_specialty) * p_tickets / 200)
```

---

## 🔍 List of Views

This section documents the views created in the database to simplify complex queries by joining multiple tables. These views allow users to access meaningful insights without having to manually join tables each time.

---

### 📄 `asignation_details`

**Description:**  
Displays a relationship between each staff assignment, the assigned staff member's name, and the stadium where they will work.

**Purpose:**  
Facilitates tracking of which staff members are assigned to which concert and stadium.

**Tables involved:**
- `asignation`: Assignments between concerts and staff.
- `staff`: Contains staff details.
- `concert`: Links the staff assignment to a concert.
- `stadium`: Provides venue details.

**Returned columns:**
- `Asignation_ID`
- `Staff_Name`
- `Stadium_Name`

---

### 📄 `concert_details`

**Description:**  
Provides summarized information about each concert, including the band performing and the stadium where the event takes place.

**Purpose:**  
Offers a quick overview of scheduled events and their corresponding bands and locations.

**Tables involved:**
- `concert`: Registered concerts.
- `bands`: Band or artist details.
- `stadium`: Venue information.

**Returned columns:**
- `Concert_ID`
- `Band_Name`
- `Stadium_Name`

---

### 📄 `staff_details`

**Description:**  
Displays a detailed list of staff members along with their assigned specialty.

**Purpose:**  
Simplifies filtering and identification of staff based on their specialty.

**Tables involved:**
- `staff`: Personal data of each staff member.
- `specialty`: Description of each specialty.

**Returned columns:**
- `Staff_ID`
- `Staff_Name`
- `Specialty_Name`

---

## ⚙️ List of Stored Procedures

This section documents the stored procedures defined in the database. These procedures automate key tasks, such as assigning staff to concerts based on their specialty and the number of tickets sold, reducing errors and improving operational efficiency.

---

### 📌 `assign_specialty_to_concert(p_concert_id INT, p_specialty INT)`

**Description:**  
Automatically assigns available staff members of a specific specialty to a specific concert, proportionally to the number of tickets sold.

**Purpose and Benefits:**  
- Automates the assignment of specific staff types (paramedics, firefighters, rescuers, police/security).
- Prevents duplicate assignments (ensures staff is not already assigned to the same concert).
- Dynamically adjusts the number of assigned staff according to demand (based on tickets sold).

**How it works:**  
1. Retrieves the number of tickets sold from the `concert` table.
2. Calculates the required number of staff using the `get_required_staff()` function.
3. Uses a cursor to iterate through the available staff members of the given specialty.
4. Inserts the required number of assignments into the `asignation` table.

**Tables involved:**
- `concert`: to get the number of tickets sold.
- `staff`: to select available staff by specialty.
- `asignation`: to store staff-to-concert assignments.

**Functions used:**
- `get_required_staff()`

---

### 📌 `asign_staff_to_all_concerts()`

**Description:**  
Performs the full assignment of staff for **all specialties** to **all registered concerts** in the database.

**Purpose and Benefits:**  
- Executes a complete staff assignment for all events in a single operation.
- Useful for simulations, testing, or initial data loads.
- Ensures every concert has the minimum required staff by specialty.

**How it works:**  
1. Iterates through all concerts using a cursor.
2. For each concert, calls `assign_specialty_to_concert()` for each specialty (1 through 4).

**Tables involved:**
- `concert`: to fetch all event IDs.
- `asignation`: to insert the resulting staff assignments.
- `staff`: indirectly accessed by the internal procedure.

**Procedures used:**
- `assign_specialty_to_concert()`

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
