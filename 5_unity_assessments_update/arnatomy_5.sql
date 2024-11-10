-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: arnatomy
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `assessment_types`
--

DROP TABLE IF EXISTS `assessment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessment_types` (
  `assessment_type_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `isVisible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`assessment_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessment_types`
--

LOCK TABLES `assessment_types` WRITE;
/*!40000 ALTER TABLE `assessment_types` DISABLE KEYS */;
INSERT INTO `assessment_types` VALUES (1,'Heart Assessment','Assessment of the heart system for medical studies','2024-11-08 04:30:12',1),(2,'Respiratory System Assessment','Assessment focused on the respiratory system.','2024-11-08 04:45:20',0),(3,'Gastrointestinal System Assessment','Assessment focused on the gastrointestinal system.','2024-11-08 04:45:20',0);
/*!40000 ALTER TABLE `assessment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments`
--

DROP TABLE IF EXISTS `assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assessments` (
  `assessment_id` int NOT NULL AUTO_INCREMENT,
  `userstudent` varchar(50) NOT NULL,
  `grade` decimal(5,2) NOT NULL,
  `dateTaken` date DEFAULT NULL,
  `assessment_type_id` int DEFAULT NULL,
  PRIMARY KEY (`assessment_id`),
  UNIQUE KEY `idx_assessment_type_user` (`assessment_type_id`,`userstudent`),
  KEY `fk_userstudent_assessments` (`userstudent`),
  CONSTRAINT `fk_assessment_type` FOREIGN KEY (`assessment_type_id`) REFERENCES `assessment_types` (`assessment_type_id`),
  CONSTRAINT `fk_userstudent_assessments` FOREIGN KEY (`userstudent`) REFERENCES `users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments`
--

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;
INSERT INTO `assessments` VALUES (14,'student',97.00,'2024-11-09',1);
/*!40000 ALTER TABLE `assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `assessments_with_type`
--

DROP TABLE IF EXISTS `assessments_with_type`;
/*!50001 DROP VIEW IF EXISTS `assessments_with_type`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `assessments_with_type` AS SELECT 
 1 AS `assessment_id`,
 1 AS `assessment_type_id`,
 1 AS `assessmentName`,
 1 AS `description`,
 1 AS `userstudent`,
 1 AS `grade`,
 1 AS `dateTaken`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `menuelement`
--

DROP TABLE IF EXISTS `menuelement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menuelement` (
  `menuID` int NOT NULL,
  `title` varchar(40) NOT NULL,
  `Description` mediumtext NOT NULL,
  PRIMARY KEY (`menuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menuelement`
--

LOCK TABLES `menuelement` WRITE;
/*!40000 ALTER TABLE `menuelement` DISABLE KEYS */;
INSERT INTO `menuelement` VALUES (0,'General pages','General pages'),(1,'User management','User management'),(2,'General','General operations'),(3,'Help','Technical support'),(4,'Hidden Pages','Hidden');
/*!40000 ALTER TABLE `menuelement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `RoleId` varchar(20) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Description` varchar(255) NOT NULL,
  PRIMARY KEY (`RoleId`),
  UNIQUE KEY `role_name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('ROLE1','Admin','Administrator Role'),('ROLE2','Instructor','Instructor Role'),('ROLE3','Student','Student Role');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roleuser`
--

DROP TABLE IF EXISTS `roleuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roleuser` (
  `UserName` varchar(20) NOT NULL,
  `RoleId` varchar(20) NOT NULL,
  `dateAssign` date NOT NULL,
  PRIMARY KEY (`UserName`,`RoleId`),
  KEY `role_id` (`RoleId`),
  CONSTRAINT `fk_roleuser` FOREIGN KEY (`RoleId`) REFERENCES `role` (`RoleId`) ON DELETE CASCADE,
  CONSTRAINT `fk_userrole` FOREIGN KEY (`UserName`) REFERENCES `users` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleuser`
--

LOCK TABLES `roleuser` WRITE;
/*!40000 ALTER TABLE `roleuser` DISABLE KEYS */;
INSERT INTO `roleuser` VALUES ('admin','ROLE1','2024-03-12'),('instructor','ROLE2','2024-03-12'),('student','ROLE3','2024-03-12');
/*!40000 ALTER TABLE `roleuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolewebpage`
--

DROP TABLE IF EXISTS `rolewebpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolewebpage` (
  `RoleId` varchar(20) NOT NULL,
  `pageURL` varchar(255) NOT NULL,
  `dateAssign` date NOT NULL,
  PRIMARY KEY (`RoleId`,`pageURL`),
  KEY `fk_pageURL` (`pageURL`),
  CONSTRAINT `fk_pageURL` FOREIGN KEY (`pageURL`) REFERENCES `webpage` (`pageURL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolewebpage`
--

LOCK TABLES `rolewebpage` WRITE;
/*!40000 ALTER TABLE `rolewebpage` DISABLE KEYS */;
INSERT INTO `rolewebpage` VALUES ('ROLE1','addUser.jsp','2024-03-12'),('ROLE1','deleteUser.jsp','2024-10-31'),('ROLE1','modifyUser.jsp','2024-10-31'),('ROLE1','newUser.jsp','2024-10-31'),('ROLE1','processGradeUpdate.jsp','2024-03-12'),('ROLE1','removeUser.jsp','2024-03-12'),('ROLE1','updateGrade.jsp','2024-10-31'),('ROLE1','updateUser.jsp','2024-10-31'),('ROLE1','validationHashing.jsp','2024-03-12'),('ROLE1','viewGrades.jsp','2024-03-12'),('ROLE1','welcomeMenu.jsp','2024-03-12'),('ROLE2','manageAssessments.jsp','2024-03-12'),('ROLE2','processGradeUpdate.jsp','2024-03-12'),('ROLE2','updateAssessmentVisibility.jsp','2024-03-12'),('ROLE2','updateGrade.jsp','2024-10-31'),('ROLE2','validationHashing.jsp','2024-03-12'),('ROLE2','viewGrades.jsp','2024-03-12'),('ROLE2','welcomeMenu.jsp','2024-03-12'),('ROLE3','viewMyGrades.jsp','2024-11-05'),('ROLE3','welcomeMenu.jsp','2024-10-31');
/*!40000 ALTER TABLE `rolewebpage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `hash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=174 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (132,'admin','admin','ac9689e2272427085e35b9d3e3e8bed88cb3434828b43b86fc0596cad4c6e270'),(172,'instructor','instructor','2bbaa9b5e1ba6ac6cb548cfb2ebb0c0cf46ecde8e3b11ca737013ca3213999cc'),(173,'student','student','ad454dc5db203e4280041fcd250c3de1188cf66613d03a8fc6f0eadc3d1bec97');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpage`
--

DROP TABLE IF EXISTS `webpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpage` (
  `pageURL` varchar(40) NOT NULL,
  `pageTitle` varchar(40) NOT NULL,
  `Description` mediumtext NOT NULL,
  `menuID` int DEFAULT NULL,
  PRIMARY KEY (`pageURL`),
  KEY `fk_menuID` (`menuID`),
  CONSTRAINT `fk_menuID` FOREIGN KEY (`menuID`) REFERENCES `menuelement` (`menuID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpage`
--

LOCK TABLES `webpage` WRITE;
/*!40000 ALTER TABLE `webpage` DISABLE KEYS */;
INSERT INTO `webpage` VALUES ('addUser.jsp','Add User','This page adds users to the system',4),('deleteUser.jsp','Remove User','This page removes users',4),('manageAssessments.jsp','Manage Assessments','This page manages assessment visibility in unity',2),('modifyUser.jsp','Modify User','This page modifies users',1),('newUser.jsp','New User','This page adds a new user to the system',1),('processGradeUpdate.jsp','Update Grade','This page updates grades',4),('removeUser.jsp','Remove User','This page removes users',1),('updateAssessmentVisibility.jsp','Update Assessments','This page updates assessment visibility',4),('updateGrade.jsp','Update Grade','This page updates grades',4),('updateUser.jsp','Update User','This page modifies users',4),('validationHashing.jsp','Validation Hashing','Authenticate User',4),('viewGrades.jsp','View Grades','List all Grades',2),('viewMyGrades.jsp','View My Grades','Page to view the grades of the logged-in user',0),('welcomeMenu.jsp','Welcome','The welcome page',4);
/*!40000 ALTER TABLE `webpage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpageprevious`
--

DROP TABLE IF EXISTS `webpageprevious`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpageprevious` (
  `currentpageURL` varchar(40) NOT NULL,
  `previouspageURL` varchar(40) NOT NULL,
  PRIMARY KEY (`currentpageURL`,`previouspageURL`),
  KEY `fk_previouspage` (`previouspageURL`),
  CONSTRAINT `fk_currentpage` FOREIGN KEY (`currentpageURL`) REFERENCES `webpage` (`pageURL`),
  CONSTRAINT `fk_previouspage` FOREIGN KEY (`previouspageURL`) REFERENCES `webpage` (`pageURL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpageprevious`
--

LOCK TABLES `webpageprevious` WRITE;
/*!40000 ALTER TABLE `webpageprevious` DISABLE KEYS */;
INSERT INTO `webpageprevious` VALUES ('addUser.jsp','addUser.jsp'),('newUser.jsp','addUser.jsp'),('welcomeMenu.jsp','addUser.jsp'),('deleteUser.jsp','deleteUser.jsp'),('removeUser.jsp','deleteUser.jsp'),('welcomeMenu.jsp','deleteUser.jsp'),('manageAssessments.jsp','manageAssessments.jsp'),('updateAssessmentVisibility.jsp','manageAssessments.jsp'),('welcomeMenu.jsp','manageAssessments.jsp'),('modifyUser.jsp','modifyUser.jsp'),('updateUser.jsp','modifyUser.jsp'),('welcomeMenu.jsp','modifyUser.jsp'),('addUser.jsp','newUser.jsp'),('newUser.jsp','newUser.jsp'),('welcomeMenu.jsp','newUser.jsp'),('processGradeUpdate.jsp','processGradeUpdate.jsp'),('viewGrades.jsp','processGradeUpdate.jsp'),('welcomeMenu.jsp','processGradeUpdate.jsp'),('deleteUser.jsp','removeUser.jsp'),('removeUser.jsp','removeUser.jsp'),('welcomeMenu.jsp','removeUser.jsp'),('manageAssessments.jsp','updateAssessmentVisibility.jsp'),('updateAssessmentVisibility.jsp','updateAssessmentVisibility.jsp'),('welcomeMenu.jsp','updateAssessmentVisibility.jsp'),('processGradeUpdate.jsp','updateGrade.jsp'),('updateGrade.jsp','updateGrade.jsp'),('viewGrades.jsp','updateGrade.jsp'),('modifyUser.jsp','updateUser.jsp'),('updateUser.jsp','updateUser.jsp'),('welcomeMenu.jsp','updateUser.jsp'),('welcomeMenu.jsp','validationHashing.jsp'),('updateGrade.jsp','viewGrades.jsp'),('viewGrades.jsp','viewGrades.jsp'),('welcomeMenu.jsp','viewGrades.jsp'),('viewMyGrades.jsp','viewMyGrades.jsp'),('welcomeMenu.jsp','viewMyGrades.jsp'),('manageAssessments.jsp','welcomeMenu.jsp'),('modifyUser.jsp','welcomeMenu.jsp'),('newUser.jsp','welcomeMenu.jsp'),('removeUser.jsp','welcomeMenu.jsp'),('viewGrades.jsp','welcomeMenu.jsp'),('viewMyGrades.jsp','welcomeMenu.jsp'),('welcomeMenu.jsp','welcomeMenu.jsp');
/*!40000 ALTER TABLE `webpageprevious` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `assessments_with_type`
--

/*!50001 DROP VIEW IF EXISTS `assessments_with_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `assessments_with_type` AS select `a`.`assessment_id` AS `assessment_id`,`a`.`assessment_type_id` AS `assessment_type_id`,`at`.`name` AS `assessmentName`,`at`.`description` AS `description`,`a`.`userstudent` AS `userstudent`,`a`.`grade` AS `grade`,`a`.`dateTaken` AS `dateTaken` from (`assessments` `a` join `assessment_types` `at` on((`a`.`assessment_type_id` = `at`.`assessment_type_id`))) */;
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

-- Dump completed on 2024-11-10  2:07:55
