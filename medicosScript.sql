-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: medicos
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
-- Table structure for table `citas`
--

DROP TABLE IF EXISTS `citas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citas` (
  `id_cita` int NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT NULL,
  `id_exploracion` int DEFAULT NULL,
  `id_medico` int DEFAULT NULL,
  `id_expediente` int DEFAULT NULL,
  PRIMARY KEY (`id_cita`),
  KEY `id_expediente` (`id_expediente`),
  KEY `id_exploracion` (`id_exploracion`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`id_expediente`) REFERENCES `expedientes` (`id_expediente`),
  CONSTRAINT `citas_ibfk_2` FOREIGN KEY (`id_exploracion`) REFERENCES `exploraciones` (`id_exploracion`),
  CONSTRAINT `citas_ibfk_3` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id_medicos`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citas`
--

LOCK TABLES `citas` WRITE;
/*!40000 ALTER TABLE `citas` DISABLE KEYS */;
INSERT INTO `citas` VALUES (20,'2024-08-13 20:23:03',20,6,11);
/*!40000 ALTER TABLE `citas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `citas_after_insert` AFTER INSERT ON `citas` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('citas', 'INSERT', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `citas_after_update` AFTER UPDATE ON `citas` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('citas', 'UPDATE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `citas_after_delete` AFTER DELETE ON `citas` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('citas', 'DELETE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `diagnosticos`
--

DROP TABLE IF EXISTS `diagnosticos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnosticos` (
  `id_diagnostico` int NOT NULL AUTO_INCREMENT,
  `tratamiento` text,
  `fecha` date DEFAULT NULL,
  `dx` varchar(255) DEFAULT NULL,
  `id_expediente` int DEFAULT NULL,
  PRIMARY KEY (`id_diagnostico`),
  KEY `id_expediente` (`id_expediente`),
  CONSTRAINT `diagnosticos_ibfk_1` FOREIGN KEY (`id_expediente`) REFERENCES `expedientes` (`id_expediente`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnosticos`
--

LOCK TABLES `diagnosticos` WRITE;
/*!40000 ALTER TABLE `diagnosticos` DISABLE KEYS */;
INSERT INTO `diagnosticos` VALUES (31,'Paracetamol','2024-08-13','Traumas con los trans',11);
/*!40000 ALTER TABLE `diagnosticos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `diagnosticos_after_insert` AFTER INSERT ON `diagnosticos` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('diagnosticos', 'INSERT', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `diagnosticos_after_update` AFTER UPDATE ON `diagnosticos` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('diagnosticos', 'UPDATE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `diagnosticos_after_delete` AFTER DELETE ON `diagnosticos` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('diagnosticos', 'DELETE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `expedientes`
--

DROP TABLE IF EXISTS `expedientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expedientes` (
  `id_expediente` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) DEFAULT NULL,
  `apellidos_p` varchar(100) DEFAULT NULL,
  `apellidos_m` varchar(100) DEFAULT NULL,
  `alergias` varchar(255) DEFAULT NULL,
  `enfermedades_cronicas` varchar(255) DEFAULT NULL,
  `antecedentes_familiares` varchar(255) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `id_medico` int DEFAULT NULL,
  `id_receta` int DEFAULT NULL,
  PRIMARY KEY (`id_expediente`),
  KEY `id_medico` (`id_medico`),
  KEY `fk_expedientes_recetas` (`id_receta`),
  CONSTRAINT `expedientes_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id_medicos`),
  CONSTRAINT `fk_expedientes_recetas` FOREIGN KEY (`id_receta`) REFERENCES `recetas` (`id_receta`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expedientes`
--

LOCK TABLES `expedientes` WRITE;
/*!40000 ALTER TABLE `expedientes` DISABLE KEYS */;
INSERT INTO `expedientes` VALUES (11,'Estrella','Aguillon','Torrijos','A los trans','Tiene amsiedad ','Su hermano se droga','2003-09-17',5,12),(16,'q','q','q','q','ninguna','q','2024-08-17',2,NULL);
/*!40000 ALTER TABLE `expedientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `expedientes_after_insert` AFTER INSERT ON `expedientes` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('expedientes', 'INSERT', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `expedientes_after_update` AFTER UPDATE ON `expedientes` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('expedientes', 'UPDATE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `expedientes_after_delete` AFTER DELETE ON `expedientes` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('expedientes', 'DELETE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `exploraciones`
--

DROP TABLE IF EXISTS `exploraciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exploraciones` (
  `id_exploracion` int NOT NULL AUTO_INCREMENT,
  `peso` decimal(5,2) DEFAULT NULL,
  `altura` decimal(5,2) DEFAULT NULL,
  `temperatura` decimal(5,2) DEFAULT NULL,
  `latidos_por_min` int DEFAULT NULL,
  `id_expediente` int DEFAULT NULL,
  PRIMARY KEY (`id_exploracion`),
  KEY `id_expediente` (`id_expediente`),
  CONSTRAINT `exploraciones_ibfk_1` FOREIGN KEY (`id_expediente`) REFERENCES `expedientes` (`id_expediente`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exploraciones`
--

LOCK TABLES `exploraciones` WRITE;
/*!40000 ALTER TABLE `exploraciones` DISABLE KEYS */;
INSERT INTO `exploraciones` VALUES (20,60.00,1.60,30.00,120,11);
/*!40000 ALTER TABLE `exploraciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `exploraciones_after_insert` AFTER INSERT ON `exploraciones` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('exploraciones', 'INSERT', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `exploraciones_after_update` AFTER UPDATE ON `exploraciones` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('exploraciones', 'UPDATE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `exploraciones_after_delete` AFTER DELETE ON `exploraciones` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('exploraciones', 'DELETE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `logs_acciones`
--

DROP TABLE IF EXISTS `logs_acciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs_acciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tabla` varchar(50) DEFAULT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `id_medico` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `logs_acciones_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id_medicos`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_acciones`
--

LOCK TABLES `logs_acciones` WRITE;
/*!40000 ALTER TABLE `logs_acciones` DISABLE KEYS */;
INSERT INTO `logs_acciones` VALUES (3,'expedientes','DELETE','2024-08-14 02:15:56',2),(5,'expedientes','DELETE','2024-08-14 02:30:19',6),(6,'expedientes','DELETE','2024-08-14 02:32:37',5),(7,'expedientes','INSERT','2024-08-14 02:38:13',6),(8,'expedientes','INSERT','2024-08-14 02:39:02',5),(9,'expedientes','UPDATE','2024-08-14 02:40:09',5),(10,'expedientes','DELETE','2024-08-14 02:40:09',5),(11,'medicos','INSERT','2024-08-14 02:47:45',6),(12,'expedientes','UPDATE','2024-08-14 02:52:31',NULL),(13,'expedientes','UPDATE','2024-08-14 02:53:13',6),(14,'expedientes','UPDATE','2024-08-14 02:53:34',6),(15,'expedientes','INSERT','2024-08-14 02:54:06',6),(16,'expedientes','UPDATE','2024-08-14 02:54:26',6),(17,'expedientes','DELETE','2024-08-14 02:54:26',6),(18,'medicos','UPDATE','2024-08-14 02:57:40',6),(19,'medicos','INSERT','2024-08-14 03:13:04',6),(20,'medicos','DELETE','2024-08-14 03:13:39',NULL),(21,'medicos','DELETE','2024-08-14 03:14:24',6);
/*!40000 ALTER TABLE `logs_acciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicos`
--

DROP TABLE IF EXISTS `medicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicos` (
  `id_medicos` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) DEFAULT NULL,
  `apellidos_p` varchar(100) DEFAULT NULL,
  `apellidos_m` varchar(100) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `contraseña` varchar(100) DEFAULT NULL,
  `RFC` varchar(13) DEFAULT NULL,
  `cedula` varchar(50) DEFAULT NULL,
  `id_rol` int DEFAULT NULL,
  `admin_permision` tinyint DEFAULT NULL,
  PRIMARY KEY (`id_medicos`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `medicos_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicos`
--

LOCK TABLES `medicos` WRITE;
/*!40000 ALTER TABLE `medicos` DISABLE KEYS */;
INSERT INTO `medicos` VALUES (2,'Ana','López','Martínez','ana.lopez@example.com','hola','ALM987654321','12334',2,1),(3,'Carlos','Hernández','Ramírez','carlos.hernandez@example.com','clave789','CHR123987456',NULL,3,NULL),(5,'Samuel','Elizalde','Barrera','pan@gmail.com','hola','1231',NULL,10,0),(6,'Jeni','Jeni','Jenni','j@gmail.com','j','Jenni',NULL,3,1),(9,'Samuel','Samuel','Samuel','1234@gmail.com','hola','1234','1234',11,1);
/*!40000 ALTER TABLE `medicos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `medicos_after_insert` AFTER INSERT ON `medicos` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('medicos', 'INSERT', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `medicos_after_update` AFTER UPDATE ON `medicos` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('medicos', 'UPDATE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `medicos_after_delete` AFTER DELETE ON `medicos` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('medicos', 'DELETE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `recetas`
--

DROP TABLE IF EXISTS `recetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recetas` (
  `id_receta` int NOT NULL AUTO_INCREMENT,
  `informacion` varchar(1000) DEFAULT NULL,
  `id_diagnostico` int DEFAULT NULL,
  `id_cita` int DEFAULT NULL,
  PRIMARY KEY (`id_receta`),
  KEY `id_cita` (`id_cita`),
  KEY `id_diagnostico` (`id_diagnostico`),
  CONSTRAINT `recetas_ibfk_1` FOREIGN KEY (`id_cita`) REFERENCES `citas` (`id_cita`),
  CONSTRAINT `recetas_ibfk_2` FOREIGN KEY (`id_diagnostico`) REFERENCES `diagnosticos` (`id_diagnostico`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recetas`
--

LOCK TABLES `recetas` WRITE;
/*!40000 ALTER TABLE `recetas` DISABLE KEYS */;
INSERT INTO `recetas` VALUES (12,'Ocupa alejarse mas de los trans',31,20);
/*!40000 ALTER TABLE `recetas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `recetas_after_insert` AFTER INSERT ON `recetas` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('recetas', 'INSERT', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `recetas_after_update` AFTER UPDATE ON `recetas` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('recetas', 'UPDATE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `recetas_after_delete` AFTER DELETE ON `recetas` FOR EACH ROW BEGIN
    INSERT INTO logs_acciones (tabla, accion, fecha, id_medico)
    VALUES ('recetas', 'DELETE', NOW(), @id_medico);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Médico General'),(2,'Especialista'),(3,'Médico de Urgencias'),(4,'Médico de Familia'),(5,'Médico de Salud Pública'),(6,'Médico Investigador'),(7,'Docente o Profesor de Medicina'),(8,'Médico Forense'),(9,'Médico de Medicina Ocupacional'),(10,'Médico Geriatra'),(11,'Médico Pediatra'),(12,'Médico Cirujano'),(13,'Médico Anestesiólogo'),(14,'Médico Psiquiatra'),(15,'Médico Deportista'),(16,'Consultor Médico'),(17,'Médico de Cuidados Paliativos');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_medicos`
--

DROP TABLE IF EXISTS `vw_medicos`;
/*!50001 DROP VIEW IF EXISTS `vw_medicos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_medicos` AS SELECT 
 1 AS `id_medicos`,
 1 AS `nombres`,
 1 AS `apellidos_p`,
 1 AS `apellidos_m`,
 1 AS `RFC`,
 1 AS `nombre_rol`,
 1 AS `admin_permision`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_pacientes`
--

DROP TABLE IF EXISTS `vw_pacientes`;
/*!50001 DROP VIEW IF EXISTS `vw_pacientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_pacientes` AS SELECT 
 1 AS `id_expediente`,
 1 AS `nombres`,
 1 AS `apellidos_p`,
 1 AS `apellidos_m`,
 1 AS `fecha_nacimiento`,
 1 AS `id_medico`,
 1 AS `id_receta`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'medicos'
--

--
-- Dumping routines for database 'medicos'
--
/*!50003 DROP PROCEDURE IF EXISTS `borrarExpedientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `borrarExpedientes`(IN idExp INT)
BEGIN
    -- Declare variables
    DECLARE done INT DEFAULT 0;
    DECLARE diag_id INT;
    DECLARE cur CURSOR FOR SELECT id_diagnostico FROM diagnosticos WHERE id_expediente = idExp;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 1. Actualizar el expediente
    UPDATE expedientes 
    SET id_receta = NULL 
    WHERE id_expediente = idExp;

    -- 2. Borrar las recetas relacionadas con los diagnósticos asociados al expediente
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO diag_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        DELETE FROM recetas WHERE id_diagnostico = diag_id;
    END LOOP;

    CLOSE cur;

    -- 3. Borrar los registros en las tablas relacionadas
    DELETE FROM citas WHERE id_expediente = idExp;
    DELETE FROM exploraciones WHERE id_expediente = idExp;
    DELETE FROM diagnosticos WHERE id_expediente = idExp;

    -- 4. Borrar el expediente
    DELETE FROM expedientes WHERE id_expediente = idExp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarReceta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_agregarReceta`(
    IN trat VARCHAR(255),
    IN dx VARCHAR(255),
    IN idExp INT,
    IN peso DECIMAL(5,2),
    IN altura DECIMAL(5,2),
    IN temp DECIMAL(5,2),
    IN lpm INT,
    IN idmed INT,
    IN info TEXT
)
BEGIN
    DECLARE idDiagno INT;
    DECLARE idExplor INT;
    DECLARE idCita INT;
    DECLARE idReceta INT;

    -- Start the transaction
    START TRANSACTION;
    
    -- Insert into the 'diagnosticos' table
    INSERT INTO diagnosticos (tratamiento, fecha, dx, id_expediente)
    VALUES (trat, NOW(), dx, idExp);
    SET idDiagno = LAST_INSERT_ID();
    
    -- Insert into the 'exploraciones' table
    INSERT INTO exploraciones (peso, altura, temperatura, latidos_por_min, id_expediente)
    VALUES (peso, altura, temp, lpm, idExp);
    SET idExplor = LAST_INSERT_ID();
    
    -- Insert into the 'citas' table
    INSERT INTO citas (fecha, id_exploracion, id_medico, id_expediente)
    VALUES (NOW(), idExplor, idmed, idExp);
    SET idCita = LAST_INSERT_ID();
    
    -- Insert into the 'Receta' table
    INSERT INTO recetas (informacion, id_diagnostico, id_cita)
    VALUES (info, idDiagno, idCita);
    SET idReceta = LAST_INSERT_ID();
    
    -- Update the 'expedientes' table with the new 'id_receta'
    UPDATE expedientes SET id_receta = idReceta WHERE id_expediente = idExp;
    
    -- Commit the transaction
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarMedico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_borrarMedico`(
    IN p_id_medico INT
)
BEGIN
    UPDATE expedientes 		-- actualizar los expedientes 
    SET id_medico = NULL
    WHERE id_medico = p_id_medico;
-- eliminar el medico
    DELETE FROM medicos
    WHERE id_medicos = p_id_medico;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ingresarExpediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ingresarExpediente`(
    IN p_nombre VARCHAR(100),
    IN p_apellido_paterno VARCHAR(100),
    IN p_apellido_materno VARCHAR(100),
    IN p_alergias VARCHAR(255),
    IN p_enfermedades_cronicas VARCHAR(255),
    IN p_antecedentes_familiares VARCHAR(255),
    IN p_fecha_nacimiento DATE,
    IN p_id_medico INT,
    IN p_id_receta INT
)
BEGIN
    INSERT INTO expedientes (
        nombres,
        apellidos_p,
        apellidos_m,
        alergias,
        enfermedades_cronicas,
        antecedentes_familiares,
        fecha_nacimiento,
        id_medico,
        id_receta
    ) VALUES (
        p_nombre,
        p_apellido_paterno,
        p_apellido_materno,
        p_alergias,
        p_enfermedades_cronicas,
        p_antecedentes_familiares,
        p_fecha_nacimiento,
        p_id_medico,
        p_id_receta
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_RegistrarMedico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_RegistrarMedico`(
    IN nombre VARCHAR(100),
    IN apellidosp VARCHAR(100),
    IN apellidosm VARCHAR(100),
    IN correo VARCHAR(100),
    IN contrasenia VARCHAR(100),
    IN RFC VARCHAR(13),
    IN idrol INT,
    IN adminp TINYINT,
    IN cedula VARCHAR(10)
)
BEGIN
    INSERT INTO medicos (
        nombres, 
        apellidos_p, 
        apellidos_m, 
        correo, 
        contraseña, 
        RFC, 
        id_rol, 
        admin_permision,
        cedula
    ) 
    VALUES (
        nombre, 
        apellidosp, 
        apellidosm, 
        correo, 
        contrasenia, 
        RFC, 
        idrol, 
        adminp,
        cedula
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_medicos`
--

/*!50001 DROP VIEW IF EXISTS `vw_medicos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_medicos` AS select `m`.`id_medicos` AS `id_medicos`,`m`.`nombres` AS `nombres`,`m`.`apellidos_p` AS `apellidos_p`,`m`.`apellidos_m` AS `apellidos_m`,`m`.`RFC` AS `RFC`,`r`.`nombre_rol` AS `nombre_rol`,`m`.`admin_permision` AS `admin_permision` from (`medicos` `m` join `roles` `r` on((`m`.`id_rol` = `r`.`id_rol`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_pacientes`
--

/*!50001 DROP VIEW IF EXISTS `vw_pacientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pacientes` AS select `expedientes`.`id_expediente` AS `id_expediente`,`expedientes`.`nombres` AS `nombres`,`expedientes`.`apellidos_p` AS `apellidos_p`,`expedientes`.`apellidos_m` AS `apellidos_m`,`expedientes`.`fecha_nacimiento` AS `fecha_nacimiento`,`expedientes`.`id_medico` AS `id_medico`,`expedientes`.`id_receta` AS `id_receta` from `expedientes` */;
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

-- Dump completed on 2024-08-14  3:32:35
