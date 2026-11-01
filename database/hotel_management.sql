-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `position_id` int NOT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  KEY `fk_employees_position_idx` (`position_id`),
  CONSTRAINT `fk_employees_position` FOREIGN KEY (`position_id`) REFERENCES `position` (`position_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Rattanuel Joseph','Ortiz','09897656432','ortizrattanuel@gmail.com',1),(2,'Jione','Pontunila','09123456781','pontunilajione@gmail.com',2),(3,'James','Ricaplaza','09123456231','ricaplazajames@gmail.com',3),(4,'Crystal','Palo-palo','09876543216','palopalocrystal@gmail.com',4),(5,'Dwyane Rasheed','Partosa','09875643257','partosadwyane@gmmail.com',6),(6,'Elroy','Vouluntad','0986753532','voluntadelroy@gmail.com',3),(7,'Adrian','Santos','09171230001','adrian.santos@hotel.com',3),(8,'Maria','Reyes','09171230002','maria.reyes@hotel.com',4),(9,'John','Cruz','09171230003','john.cruz@hotel.com',3),(10,'Daniel','Garcia','09171230004','daniel.garcia@hotel.com',4),(11,'Angela','Flores','09171230005','angela.flores@hotel.com',3),(12,'Mark','Dela Cruz','09171230006','mark.delacruz@hotel.com',4);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guests`
--

DROP TABLE IF EXISTS `guests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guests` (
  `guest_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`guest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guests`
--

LOCK TABLES `guests` WRITE;
/*!40000 ALTER TABLE `guests` DISABLE KEYS */;
INSERT INTO `guests` VALUES (1,'Jeramie','09897623456','jeramie@gmail.com'),(2,'Jennifer','09897612346','jennifer@gmail.com'),(3,'Junie','09897677654','junie@gmail.com'),(25,'TestGuestUpdated','09170000000','testguest2026@example.com'),(26,'Rattanuel Joseph Z. Ortiz','(+63) 908 252 6004','ortizrattanuel.0601@gmail.com');
/*!40000 ALTER TABLE `guests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `housekeeping_tasks`
--

DROP TABLE IF EXISTS `housekeeping_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `housekeeping_tasks` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  `task_type` varchar(50) NOT NULL,
  `assigned_date` datetime NOT NULL,
  `completed_date` datetime DEFAULT NULL,
  `task_status` varchar(30) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`task_id`),
  KEY `fk_housekeeping_tasks_room_idx` (`room_id`),
  KEY `fk_housekeeping_tasks_employee_idx` (`employee_id`),
  CONSTRAINT `fk_housekeeping_tasks_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  CONSTRAINT `fk_housekeeping_tasks_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `housekeeping_tasks`
--

LOCK TABLES `housekeeping_tasks` WRITE;
/*!40000 ALTER TABLE `housekeeping_tasks` DISABLE KEYS */;
INSERT INTO `housekeeping_tasks` VALUES (1,1,7,'Room Cleaning','2026-10-19 16:08:54','2026-10-19 16:08:54','Completed','Room cleaned and prepared'),(2,2,9,'Room Cleaning','2026-10-19 16:08:54',NULL,'Pending','Waiting for cleaning'),(3,9,11,'Room Inspection','2026-10-19 16:08:54',NULL,'In Progress','Checking room condition'),(4,17,8,'Maintenance Check','2026-10-19 16:08:54',NULL,'Pending','Check room fixtures'),(5,23,10,'Room Cleaning','2026-10-19 16:08:54','2026-10-19 16:08:54','Completed','Room ready for guests');
/*!40000 ALTER TABLE `housekeeping_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items`
--

DROP TABLE IF EXISTS `inventory_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `quantity_in_stock` int NOT NULL,
  `unit` varchar(20) NOT NULL,
  `reorder_level` int NOT NULL,
  `unit_cost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items`
--

LOCK TABLES `inventory_items` WRITE;
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
INSERT INTO `inventory_items` VALUES (1,'Bath Towels','Linens',100,'pieces',20,150.00),(2,'Bed Sheets','Linens',80,'pieces',15,350.00),(3,'Hotel Soap','Toiletries',200,'bars',50,15.00),(4,'Shampoo Bottles','Toiletries',150,'bottles',30,25.00),(5,'Cleaning Solution','Cleaning Supplies',40,'liters',10,120.00);
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_transactions`
--

DROP TABLE IF EXISTS `inventory_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  `transaction_type` varchar(30) NOT NULL,
  `quantity` int NOT NULL,
  `transaction_date` datetime NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `fk_inventory_transactions_items_idx` (`item_id`),
  KEY `fk_inventory_transactions_employee_idx` (`employee_id`),
  CONSTRAINT `fk_inventory_transactions_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  CONSTRAINT `fk_inventory_transactions_items` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_transactions`
--

LOCK TABLES `inventory_transactions` WRITE;
/*!40000 ALTER TABLE `inventory_transactions` DISABLE KEYS */;
INSERT INTO `inventory_transactions` VALUES (1,1,7,'Stock In',50,'2026-10-19 16:12:23','Received new bath towels'),(2,2,9,'Stock In',30,'2026-10-19 16:12:23','Received new bed sheets'),(3,3,11,'Stock Out',20,'2026-10-19 16:12:23','Soap used for guest rooms'),(4,4,10,'Stock Out',15,'2026-10-19 16:12:23','Shampoo used for guest rooms'),(5,5,8,'Stock In',10,'2026-10-19 16:12:23','Received cleaning solution');
/*!40000 ALTER TABLE `inventory_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `invoices_id` int NOT NULL AUTO_INCREMENT,
  `reservations_id` int NOT NULL,
  `invoice_date` datetime NOT NULL,
  `room_charges` decimal(10,2) NOT NULL,
  `service_charges` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `invoice_status` varchar(30) NOT NULL,
  PRIMARY KEY (`invoices_id`),
  KEY `fk_invoices_reservations_idx` (`reservations_id`),
  CONSTRAINT `fk_invoices_reservations` FOREIGN KEY (`reservations_id`) REFERENCES `reservations` (`reservation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,1,'2026-10-19 16:01:20',2400.00,700.00,3100.00,'Paid'),(2,2,'2026-10-19 16:01:20',5700.00,200.00,5900.00,'Pending'),(3,3,'2026-10-19 16:01:20',3800.00,800.00,4600.00,'Pending'),(4,4,'2026-10-19 16:01:20',7500.00,1000.00,8500.00,'Pending'),(5,5,'2026-10-19 16:01:20',7000.00,500.00,7500.00,'Paid');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_requests`
--

DROP TABLE IF EXISTS `maintenance_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_requests` (
  `maintenance_id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  `issue_description` varchar(255) NOT NULL,
  `priority` varchar(20) NOT NULL,
  `request_date` datetime NOT NULL,
  `completed_date` datetime DEFAULT NULL,
  `maintenance_items` varchar(30) NOT NULL,
  PRIMARY KEY (`maintenance_id`),
  KEY `fk_maintenance_requests_room_idx` (`room_id`),
  KEY `fk_maintenance_request_employee_idx` (`employee_id`),
  CONSTRAINT `fk_maintenance_request_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  CONSTRAINT `fk_maintenance_requests_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_requests`
--

LOCK TABLES `maintenance_requests` WRITE;
/*!40000 ALTER TABLE `maintenance_requests` DISABLE KEYS */;
INSERT INTO `maintenance_requests` VALUES (1,1,8,'Air conditioner not cooling properly','High','2026-10-19 16:15:26',NULL,'Pending'),(2,2,10,'Bathroom faucet leaking','Medium','2026-10-19 16:15:26',NULL,'Pending'),(3,9,8,'Light bulb needs replacement','Low','2026-10-19 16:15:26','2026-10-19 16:15:26','Completed'),(4,17,10,'Door lock needs repair','High','2026-10-19 16:15:26',NULL,'Pending'),(5,23,8,'Shower pressure is low','Medium','2026-10-19 16:15:26',NULL,'Pending');
/*!40000 ALTER TABLE `maintenance_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `payment_date` datetime NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_method` varchar(30) NOT NULL,
  `payment_status` varchar(30) NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `reference_number_UNIQUE` (`reference_number`),
  KEY `fk_payments_invoices_idx` (`invoice_id`),
  CONSTRAINT `fk_payments_invoices` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`invoices_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,'2026-10-19 16:03:37',3100.00,'Cash','Completed','PAY-2026-001'),(2,2,'2026-10-19 16:03:37',2000.00,'GCash','Partial','PAY-2026-002'),(3,3,'2026-10-19 16:03:37',0.00,'Cash','Pending',NULL),(4,4,'2026-10-19 16:03:37',3000.00,'Credit Card','Partial','PAY-2026-004'),(5,5,'2026-10-19 16:03:37',7500.00,'GCash','Completed','PAY-2026-005');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `position`
--

DROP TABLE IF EXISTS `position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `position` (
  `position_id` int NOT NULL AUTO_INCREMENT,
  `position_name` varchar(50) NOT NULL,
  `description` varchar(225) DEFAULT NULL,
  PRIMARY KEY (`position_id`),
  UNIQUE KEY `position_name_UNIQUE` (`position_name`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `position`
--

LOCK TABLES `position` WRITE;
/*!40000 ALTER TABLE `position` DISABLE KEYS */;
INSERT INTO `position` VALUES (1,'Manager','oversees hotel operation and staff'),(2,'Receptionist','Handle guest check-ins, check-outs, and reservations'),(3,'House keeper','Maintains room cleanliness and organization'),(4,'Maintenance staff','repairs and maintains hotel facilities'),(5,'Accountant','Manages Invoices, payments, and financial records. '),(6,'Hotel staff','Assist with general hotel operations');
/*!40000 ALTER TABLE `position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation_rooms`
--

DROP TABLE IF EXISTS `reservation_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation_rooms` (
  `reservation_room_id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `room_id` int NOT NULL,
  `nightly_rate` decimal(10,2) NOT NULL,
  PRIMARY KEY (`reservation_room_id`),
  KEY `fk_reservation_rooms_reservations_idx` (`reservation_id`),
  KEY `fk_room_id_room_idx` (`room_id`),
  CONSTRAINT `fk_reservation_rooms_reservations` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`),
  CONSTRAINT `fk_room_id_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation_rooms`
--

LOCK TABLES `reservation_rooms` WRITE;
/*!40000 ALTER TABLE `reservation_rooms` DISABLE KEYS */;
INSERT INTO `reservation_rooms` VALUES (1,1,1,1200.00),(2,2,2,1200.00),(3,3,9,1900.00),(4,4,17,2500.00),(5,5,23,3500.00),(6,6,1,1200.00);
/*!40000 ALTER TABLE `reservation_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  `reservation_date` datetime NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `reservation_status` varchar(30) NOT NULL,
  `special_requests` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`reservation_id`),
  KEY `fk_reservations_guests

 Copy_idx` (`guest_id`),
  KEY `fk_reservations_employees_idx` (`employee_id`),
  CONSTRAINT `fk_reservations_employees` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  CONSTRAINT `fk_reservations_guests

 Copy` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,1,2,'2026-10-19 15:52:28','2026-10-22','2026-10-24','Confirmed','Non-smoking room'),(2,2,3,'2026-10-19 15:52:28','2026-10-23','2026-10-26','Confirmed','Extra pillows'),(3,3,1,'2026-10-19 15:52:28','2026-10-25','2026-10-27','Pending',NULL),(4,1,4,'2026-10-19 15:52:28','2026-11-01','2026-11-04','Confirmed','Late check-in'),(5,2,5,'2026-10-19 15:52:28','2026-11-05','2026-11-07','Checked-out',NULL),(6,26,NULL,'2026-10-31 11:48:44','2026-12-11','2026-12-13','Pending','give me your best selling desserts');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `guest_id` int NOT NULL,
  `reservation_id` int NOT NULL,
  `rating` int NOT NULL,
  `review_comment` varchar(500) DEFAULT NULL,
  `review_date` datetime NOT NULL,
  PRIMARY KEY (`review_id`),
  KEY `fk_reviews_guest_idx` (`guest_id`),
  KEY `fk_reservation_guest_idx` (`reservation_id`),
  CONSTRAINT `fk_reservation_guest` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`),
  CONSTRAINT `fk_reviews_guest` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`guest_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,5,'Excellent service and clean room.','2026-10-19 16:05:16'),(2,2,2,4,'Comfortable stay and friendly staff.','2026-10-19 16:05:16'),(3,3,3,3,'The room was good, but service was slow.','2026-10-19 16:05:16'),(4,1,4,5,'Very satisfying experience.','2026-10-19 16:05:16'),(5,2,5,4,'Good facilities and comfortable room.','2026-10-19 16:05:16');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `room_number` varchar(10) NOT NULL,
  `floor_number` int DEFAULT NULL,
  `room_status` varchar(30) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `room_type_id` int NOT NULL,
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `room_number_UNIQUE` (`room_number`),
  KEY `fk_room_room_type_idx` (`room_type_id`),
  CONSTRAINT `fk_room_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,'101',NULL,'Available',NULL,1),(2,'102',NULL,'Available',NULL,1),(3,'103',NULL,'Available',NULL,1),(4,'104',NULL,'Available',NULL,1),(5,'105',NULL,'Available',NULL,1),(6,'106',NULL,'Available',NULL,1),(7,'107',NULL,'Available',NULL,1),(8,'108',NULL,'Available',NULL,1),(9,'201',NULL,'Available',NULL,2),(10,'202',NULL,'Available',NULL,2),(11,'203',NULL,'Available',NULL,2),(12,'204',NULL,'Available',NULL,2),(13,'205',NULL,'Available',NULL,2),(14,'206',NULL,'Available',NULL,2),(15,'207',NULL,'Available',NULL,2),(16,'208',NULL,'Available',NULL,2),(17,'301',NULL,'Available',NULL,3),(18,'302',NULL,'Available',NULL,3),(19,'303',NULL,'Available',NULL,3),(20,'304',NULL,'Available',NULL,3),(21,'305',NULL,'Available',NULL,3),(22,'306',NULL,'Available',NULL,3),(23,'401',NULL,'Available',NULL,4),(24,'402',NULL,'Available',NULL,4),(25,'403',NULL,'Available',NULL,4),(26,'404',NULL,'Available',NULL,4),(27,'501',NULL,'Available',NULL,5),(28,'502',NULL,'Available',NULL,5),(29,'503',NULL,'Available',NULL,5),(30,'504',NULL,'Available',NULL,5);
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `room_type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `capacity` int NOT NULL,
  `price_per_night` decimal(10,2) NOT NULL,
  PRIMARY KEY (`room_type_id`),
  UNIQUE KEY `type_name_UNIQUE` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
INSERT INTO `room_types` VALUES (1,'single','room for one guest',1,1200.00),(2,'double','room for two guests',2,1900.00),(3,'deluxe','spacious room with upgraded amenities',2,2500.00),(4,'family','room suitable for families',4,3500.00),(5,'suite','premium room	with seperate living space',4,5000.00);
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_orders`
--

DROP TABLE IF EXISTS `service_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_orders` (
  `service_order_id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `service_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `order_date` datetime NOT NULL,
  `order_status` varchar(30) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`service_order_id`),
  KEY `fk_service_orders_reservations_idx` (`reservation_id`),
  KEY `fk_service_orders_sevice_idx` (`service_id`),
  KEY `fk_service_orders_employee_idx` (`employee_id`),
  CONSTRAINT `fk_service_orders_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
  CONSTRAINT `fk_service_orders_reservations` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`),
  CONSTRAINT `fk_service_orders_sevice` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_orders`
--

LOCK TABLES `service_orders` WRITE;
/*!40000 ALTER TABLE `service_orders` DISABLE KEYS */;
INSERT INTO `service_orders` VALUES (1,1,1,2,2,'2026-10-19 15:57:19','Completed',700.00),(2,2,2,3,1,'2026-10-19 15:57:19','Completed',200.00),(3,3,3,4,1,'2026-10-19 15:57:19','Pending',800.00),(4,4,4,2,1,'2026-10-19 15:57:19','In Progress',1000.00),(5,5,5,6,1,'2026-10-19 15:57:19','Pending',500.00);
/*!40000 ALTER TABLE `service_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `service_price` decimal(10,2) NOT NULL,
  `service_status` varchar(30) NOT NULL,
  PRIMARY KEY (`service_id`),
  UNIQUE KEY `sevice_name_UNIQUE` (`service_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'Room Service','Food and drinks delivered to the room',350.00,'Available'),(2,'Laundry','Washing and ironing of guest clothes',200.00,'Available'),(3,'Airport Transfer','Transportation to and from the airport',800.00,'Available'),(4,'Spa','Relaxation and massage service',1000.00,'Available'),(5,'Extra Bed','Additional bed for a guest room',500.00,'Available');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `unpaid_invoices`
--

DROP TABLE IF EXISTS `unpaid_invoices`;
/*!50001 DROP VIEW IF EXISTS `unpaid_invoices`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `unpaid_invoices` AS SELECT 
 1 AS `invoices_id`,
 1 AS `reservations_id`,
 1 AS `guest_name`,
 1 AS `total_amount`,
 1 AS `amount_paid`,
 1 AS `balance`,
 1 AS `invoice_status`,
 1 AS `payment_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `unpaid_invoices`
--

/*!50001 DROP VIEW IF EXISTS `unpaid_invoices`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `unpaid_invoices` AS select `i`.`invoices_id` AS `invoices_id`,`i`.`reservations_id` AS `reservations_id`,`g`.`first_name` AS `guest_name`,`i`.`total_amount` AS `total_amount`,coalesce(`p`.`amount_paid`,0) AS `amount_paid`,(`i`.`total_amount` - coalesce(`p`.`amount_paid`,0)) AS `balance`,`i`.`invoice_status` AS `invoice_status`,`p`.`payment_status` AS `payment_status` from (((`invoices` `i` join `reservations` `r` on((`i`.`reservations_id` = `r`.`reservation_id`))) join `guests` `g` on((`r`.`guest_id` = `g`.`guest_id`))) left join `payments` `p` on((`i`.`invoices_id` = `p`.`invoice_id`))) where (`i`.`total_amount` > coalesce(`p`.`amount_paid`,0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-01 10:32:32
