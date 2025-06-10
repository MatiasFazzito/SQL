# 🎶 ConcertIO

## 📚 Table of Contents

- [🎶 Introduction](#-logistics-control-database-for-concerts-and-events)
- [📊 Base Safety Requirements (Argentina Example)](#-base-safety-requirements-argentina-example)
- [🧪 Steps to Run the Database](#-steps-to-run-the-database)
- [🧩 Tables Overview](#-tables-overview)
  - [1. `Bands`](#1-bands)
  - [2. `Stadium`](#2-stadium)
  - [3. `Staff`](#3-staff)
  - [4. `Specialty`](#4-specialty)
  - [5. `Concert`](#5-concert)
  - [6. `Asignation`](#6-asignation)
  - [7. `Audit_Log`](#7-audit_log)
- [⚡ Defined Triggers](#-defined-triggers)
  - [`after_concert_insert`](#-after_concert_insert)
  - [Audit Triggers for `bands` Table](#-audit-triggers-for-bands-table)
  - [Audit Triggers for `stadium` Table](#-audit-triggers-for-the-stadium-table)
  - [Audit Triggers for `concert` Table](#-audit-triggers-for-the-concert-table)
  - [Audit Triggers for `staff` Table](#-audit-triggers-for-the-staff-table)
- [🧠 Defined Functions in the Database](#-defined-functions-in-the-database)
  - [`get_specialty_multiplier`](#-get_specialty_multiplierpspecialty-int)
  - [`get_required_staff`](#-get_required_staffptickets-int-pspecialty-int)
- [⚙️ List of Stored Procedures](#️-list-of-stored-procedures)
  - [`assign_specialty_to_concert`](#-assign_specialty_to_concertp_concert_id-int-p_specialty-int)
  - [`asign_staff_to_all_concerts`](#-asign_staff_to_all_concerts)
- [🔍 List of Views](#-list-of-views)
  - [`asignation_details`](#-asignation_details)
  - [`concert_details`](#-concert_details)
  - [`staff_details`](#-staff_details)
- [🧩 Future Adaptability](#-future-adaptability)
- [📁 Use Cases](#-use-cases)



---

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

## 🧪 Steps to Run the Database

Below are the necessary steps to properly set up and run this database in a local or development environment:

1. **Create the database**  
   - Run the database creation script. [This file](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql) contains the creation of the tables with their corresponding relational keys and triggers.

2. **Select the database to use**  
   - Within the same [file](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql), execute the `USE concertio;` command.

3. **Create all tables**  
   - In the same [file](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql), run the script that defines all the tables (`bands`, `stadium`, `staff`, etc.).

4. **Create the triggers**  
   - In the same [file](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Schema%20y%20Tables/ConcertIO_DB_Creation.sql), run the portion of the script that creates the necessary triggers (`after_concert_insert`, and audit triggers for `bands`, `stadium`, `concert`, `staff`).

> 💡 **Pro Tip:** These first steps can be executed all at once by running the entire initial script file, which will leave the database mostly ready.

5. **Create views**  
   - From this [folder](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Views), run each script individually to generate the views by right-clicking on the `Views` section of the schema (`asignation_details`, `concert_details`, `staff_details`).

6. **Create functions**  
   - From this [folder](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Functions), run each script individually to define the functions (`get_required_staff`, `get_specialty_multiplier`).

7. **Create stored procedures**  
   - From this [folder](https://github.com/MatiasFazzito/SQL/tree/main/SQL%20Files/Procedures), run each script individually to define the procedures (`assign_specialty_to_concert`, `asign_staff_to_all_concerts`).

8. **Insert initial data**  
   - Load test data using this [script](https://github.com/MatiasFazzito/SQL/blob/main/SQL%20Files/Data%20insertion/Mock_Data_Stress_Insertion.sql), or insert real data into the main tables (`bands`, `stadium`, `specialty`, `staff`, etc.).

> 💡 **Tip:** Make sure to run the scripts in the correct order during this step to avoid foreign key or cross-reference errors. It is recommended to follow the order specified in the provided test data file.

9. **Verify functionality**  
   - Insert a new concert and check whether the staff is assigned automatically.  
   - Verify that the audit triggers are recording the changes.

10. **Adjust parameters if necessary**  
   - Modify multipliers or assignment rules depending on the country or type of event.

11. **(Optional) Load more data or run additional tests**  
   - Use the procedures and views to perform functional tests.

---

> 💡 **Tip:** Make sure to execute the scripts in the correct order to avoid foreign key or cross-reference errors.

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

### 7. `Audit_Log`

Stores a history of actions performed on other tables for auditing purposes.

| Field        | Type                                 | Description                                                                 |
|--------------|--------------------------------------|-----------------------------------------------------------------------------|
| ID           | `INT` (PK, AUTO_INCREMENT)           | Unique identifier for the log entry                                        |
| Table_Name   | `VARCHAR(64)`                        | Name of the table where the action took place                              |
| Action_Type  | `ENUM('INSERT', 'UPDATE', 'DELETE')` | Type of action recorded (INSERT, UPDATE, or DELETE)                        |
| Action_Time  | `TIMESTAMP` (DEFAULT CURRENT_TIMESTAMP) | Date and time when the action occurred                                 |
| Old_Data     | `JSON`                               | Data before the change (only for UPDATE and DELETE actions)                |
| New_Data     | `JSON`                               | Data after the change (only for INSERT and UPDATE actions)                 |

📌 *This table is designed to automatically log changes made to other tables via custom triggers, enabling full system auditability.*

---

## ⚡ Defined Triggers

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

---

### 🔔 Audit Triggers for `bands` Table

**Description:**  
These three triggers are automatically executed after insert, update, and delete operations on the `bands` table. They record the changes made to the band records in the `audit_log` table, capturing the relevant data before and/or after the changes to maintain an audit trail.

**Purpose:**  
To ensure traceability and auditing of all modifications to the `bands` table by logging inserts, updates, and deletions. This helps monitor data integrity and provides historical records of band information changes.

---

### 🔔 Audit Triggers for the `stadium` Table

**Description:**  
These three triggers are automatically executed after insert, update, and delete operations on the `stadium` table. They record the changes made to the stadium records in the `audit_log` table, capturing the relevant data before and/or after the changes to maintain an audit trail.

**Purpose:**  
To ensure traceability and auditing of all modifications to the `stadium` table by logging inserts, updates, and deletions. This helps monitor data integrity and provides historical records of stadium information changes.

---

### 🔔 Audit Triggers for the `concert` Table

**Description:**  
These three triggers are automatically executed after insert, update, and delete operations on the `concert` table. They record the changes made to the concert records in the `audit_log` table, capturing the relevant data before and/or after the changes to maintain an audit trail.

**Purpose:**  
To ensure traceability and auditing of all modifications to the `concert` table by logging inserts, updates, and deletions. This helps monitor data integrity and provides historical records of concert information changes.

---

### 🔔 Audit Triggers for the `staff` Table

**Description:**  
These three triggers are automatically executed after insert, update, and delete operations on the `staff` table. They log changes made to staff records into the `audit_log` table, capturing relevant data before and/or after the changes to maintain a comprehensive audit trail.

**Purpose:**  
To ensure traceability and auditing of all modifications to the `staff` table by logging insertions, updates, and deletions. This facilitates monitoring data integrity and provides a historical record of changes in staff information.

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
Performs staff assignment for **all specialties** across **all concerts** registered in the database.

**Purpose and benefits:**  
- Executes the full staff assignment process for all events in a single step.  
- Useful for simulations, testing, or initial data loads.  
- Ensures every concert has at least the minimum required staff per specialty.  
- **Alternative to the `after_concert_insert` trigger**: this procedure can be used manually if the user prefers not to rely on the automatic trigger when inserting new concerts.

**How it works:**  
1. Iterates through all registered concerts using a cursor.  
2. For each concert, calls the `assign_specialty_to_concert` procedure for each specialty type (1 to 4).

**Involved tables:**  
- `concert`: to iterate through all events.  
- `asignation`: to insert the resulting staff assignments.  
- `staff`: accessed indirectly via the internal procedure.

**Procedures used:**  
- `assign_specialty_to_concert()`

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
