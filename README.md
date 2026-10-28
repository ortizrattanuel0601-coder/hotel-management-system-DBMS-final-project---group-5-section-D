
# Hotel Management System

## Project Overview
The Hotel Management System is a web-based application developed for DBMS 1 and Systems Integration and Architecture (SIA). It manages hotel information such as guests, rooms, reservations, employees, services, and service orders.

## Technologies Used
- **Backend:** Node.js and Express.js
- **Database:** MySQL
- **API:** REST API
- **Version Control:** Git and GitHub
- **Frontend:** To be documented as implemented

## Features
- Guest Management
- Room Management
- Reservation Management
- Employee Management
- Hotel Service Management
- Service Order Management
- Reports using SQL JOIN queries

## Installation and Setup

### Requirements
- Node.js and npm
- MySQL Server
- Git

### Steps
1. Clone this repository.
2. Open the project folder in a terminal.
3. Install dependencies:
   ```bash
   npm install
   ```
4. Create a `.env` file using the required environment variable names from the project configuration. Do not commit database passwords or other secrets.
5. Create the project database in MySQL and import the provided database schema.
6. Start the application using the start command configured in `package.json`.
7. Open the API at `http://localhost:1234`.

## API Endpoints

| Resource | Endpoint |
|---|---|
| Guests | `/api/guests` |
| Rooms | `/api/rooms` |
| Reservations | `/api/reservations` |
| Employees | `/api/employees` |
| Services | `/api/services` |
| Service Orders | `/api/service-orders` |

## Team Members and Responsibilities

| Member | GitHub Username | Assigned Tables | Resource / Feature | JOIN Report |
|---|---|---|---|---|
| Member 1 | To be filled | `guests`, `reviews` | Guest Management | Guest Review Report |
| Member 2 | To be filled | `room`, `room_types`, `housekeeping_tasks`, `maintenance_requests` | Room & Housekeeping | Room Operations Report |
| Member 3 | To be filled | `reservations`, `reservation_rooms` | Reservation Management | Reservation Details Report |
| Member 4 | To be filled | `employees`, `position` | Employee Management | Employee Position Report |
| Member 5 | To be filled | `services`, `service_orders`, `inventory_items`, `inventory_transactions` | Services & Inventory | Service Order Report |
| Member 6 | To be filled | `invoices`, `payments` | Billing & Payments | Invoice & Payment Report |

## Git Collaboration Rules
- Work on your assigned feature branch.
- Make meaningful commits using clear commit messages.
- Push your feature branch to GitHub.
- Open a Pull Request to merge your changes into `main`.
- Do not commit `.env`, database passwords, or `node_modules`.

## Project Status
Backend API development and initial GitHub setup are in progress.
