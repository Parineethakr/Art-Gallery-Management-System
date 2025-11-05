CREATE DATABASE  IF NOT EXISTS `artgal` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `artgal`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: artgal
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `artist_id` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Bio` text,
  `Contact_info` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES (1,'Vincent Van Gogh','Post-impressionist painter','contact@vangogh.com'),(2,'Pablo Picasso','Founder of Cubism','contact@picasso.com'),(3,'Leonardo da Vinci','Renaissance master','contact@davinci.com'),(4,'Frida Kahlo','Surrealist artist','contact@kahlo.com');
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artwork`
--

DROP TABLE IF EXISTS `artwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artwork` (
  `artwork_id` int NOT NULL,
  `Title` varchar(255) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  `creation_yr` int DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `creator_id` int DEFAULT NULL,
  PRIMARY KEY (`artwork_id`),
  KEY `creator_id` (`creator_id`),
  CONSTRAINT `artwork_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `artist` (`artist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artwork`
--

LOCK TABLES `artwork` WRITE;
/*!40000 ALTER TABLE `artwork` DISABLE KEYS */;
INSERT INTO `artwork` VALUES (1,'Starry Night','Oil Painting',1889,50000.00,1),(2,'Guernica','Oil Painting',1937,75000.00,2),(3,'Mona Lisa','Oil Painting',1503,100000.00,3),(4,'The Two Fridas','Oil Painting',1943,60000.00,4),(5,'Sunflowers','Oil Painting',1888,45000.00,1);
/*!40000 ALTER TABLE `artwork` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `artwork_details`
--

DROP TABLE IF EXISTS `artwork_details`;
/*!50001 DROP VIEW IF EXISTS `artwork_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `artwork_details` AS SELECT 
 1 AS `artwork_id`,
 1 AS `Title`,
 1 AS `Type`,
 1 AS `creation_yr`,
 1 AS `price`,
 1 AS `artist_name`,
 1 AS `exhibition_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `attends`
--

DROP TABLE IF EXISTS `attends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attends` (
  `visitor_id` int DEFAULT NULL,
  `exhibition_id` int DEFAULT NULL,
  KEY `visitor_id` (`visitor_id`),
  KEY `exhibition_id` (`exhibition_id`),
  CONSTRAINT `attends_ibfk_1` FOREIGN KEY (`visitor_id`) REFERENCES `visitor` (`visitor_id`),
  CONSTRAINT `attends_ibfk_2` FOREIGN KEY (`exhibition_id`) REFERENCES `exhibition` (`exhibition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attends`
--

LOCK TABLES `attends` WRITE;
/*!40000 ALTER TABLE `attends` DISABLE KEYS */;
INSERT INTO `attends` VALUES (1,1),(2,1),(3,2),(1,3);
/*!40000 ALTER TABLE `attends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction`
--

DROP TABLE IF EXISTS `auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction` (
  `auction_id` int NOT NULL AUTO_INCREMENT,
  `auction_date` date DEFAULT NULL,
  `location` varchar(511) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`auction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction`
--

LOCK TABLES `auction` WRITE;
/*!40000 ALTER TABLE `auction` DISABLE KEYS */;
INSERT INTO `auction` VALUES (1,'2025-04-10','New York Convention Center','Upcoming'),(2,'2025-05-15','London Auction House','Upcoming'),(3,'2025-06-20','Paris Grand Hall','Upcoming');
/*!40000 ALTER TABLE `auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auction_artwork`
--

DROP TABLE IF EXISTS `auction_artwork`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auction_artwork` (
  `artwork_id` int DEFAULT NULL,
  `auction_id` int DEFAULT NULL,
  KEY `artwork_id` (`artwork_id`),
  KEY `auction_id` (`auction_id`),
  CONSTRAINT `auction_artwork_ibfk_1` FOREIGN KEY (`artwork_id`) REFERENCES `artwork` (`artwork_id`),
  CONSTRAINT `auction_artwork_ibfk_2` FOREIGN KEY (`auction_id`) REFERENCES `auction` (`auction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auction_artwork`
--

LOCK TABLES `auction_artwork` WRITE;
/*!40000 ALTER TABLE `auction_artwork` DISABLE KEYS */;
INSERT INTO `auction_artwork` VALUES (1,1),(2,1),(3,2),(4,2),(5,3);
/*!40000 ALTER TABLE `auction_artwork` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `auction_statistics`
--

DROP TABLE IF EXISTS `auction_statistics`;
/*!50001 DROP VIEW IF EXISTS `auction_statistics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `auction_statistics` AS SELECT 
 1 AS `auction_id`,
 1 AS `auction_date`,
 1 AS `location`,
 1 AS `status`,
 1 AS `artworks_in_auction`,
 1 AS `total_bids`,
 1 AS `avg_bid_amount`,
 1 AS `max_bid_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bid`
--

DROP TABLE IF EXISTS `bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bid` (
  `bid_id` int NOT NULL AUTO_INCREMENT,
  `auction_id` int DEFAULT NULL,
  `buyer_id` int DEFAULT NULL,
  `artwork_id` int DEFAULT NULL,
  `bid_amount` decimal(12,2) DEFAULT NULL,
  `bid_time` timestamp NULL DEFAULT NULL,
  `is_winner` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`bid_id`),
  KEY `auction_id` (`auction_id`),
  KEY `artwork_id` (`artwork_id`),
  KEY `buyer_id` (`buyer_id`),
  CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`auction_id`) REFERENCES `auction` (`auction_id`),
  CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`artwork_id`) REFERENCES `artwork` (`artwork_id`),
  CONSTRAINT `bid_ibfk_3` FOREIGN KEY (`buyer_id`) REFERENCES `buyer` (`buyer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid`
--

LOCK TABLES `bid` WRITE;
/*!40000 ALTER TABLE `bid` DISABLE KEYS */;
INSERT INTO `bid` VALUES (1,1,1,1,55000.00,NULL,1),(2,1,2,2,80000.00,NULL,1),(3,2,3,3,105000.00,NULL,1),(4,1,3,1,52000.00,NULL,0);
/*!40000 ALTER TABLE `bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buyer`
--

DROP TABLE IF EXISTS `buyer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buyer` (
  `buyer_id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `Adress` varchar(511) DEFAULT NULL,
  PRIMARY KEY (`buyer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buyer`
--

LOCK TABLES `buyer` WRITE;
/*!40000 ALTER TABLE `buyer` DISABLE KEYS */;
INSERT INTO `buyer` VALUES (1,'Alice Williams','alice@buyer.com','5551234567','123 Art St, NYC'),(2,'David Miller','david@buyer.com','5559876543','456 Gallery Ave, LA'),(3,'Emma Davis','emma@buyer.com','5552223333','789 Museum Rd, Chicago');
/*!40000 ALTER TABLE `buyer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `buyer_purchase_history`
--

DROP TABLE IF EXISTS `buyer_purchase_history`;
/*!50001 DROP VIEW IF EXISTS `buyer_purchase_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `buyer_purchase_history` AS SELECT 
 1 AS `buyer_id`,
 1 AS `Name`,
 1 AS `email`,
 1 AS `total_bids`,
 1 AS `winning_bids`,
 1 AS `total_spent`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `exhibition`
--

DROP TABLE IF EXISTS `exhibition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exhibition` (
  `exhibition_id` int NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Location` varchar(511) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`exhibition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exhibition`
--

LOCK TABLES `exhibition` WRITE;
/*!40000 ALTER TABLE `exhibition` DISABLE KEYS */;
INSERT INTO `exhibition` VALUES (1,'Impressionism Masters','New York','2025-01-15','2025-02-28'),(2,'Modern Art Revolution','London','2025-02-01','2025-03-31'),(3,'Renaissance Revival','Paris','2025-03-15','2025-05-15');
/*!40000 ALTER TABLE `exhibition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participates_in`
--

DROP TABLE IF EXISTS `participates_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participates_in` (
  `artwork_id` int DEFAULT NULL,
  `exhibition_id` int DEFAULT NULL,
  KEY `exhibition_id` (`exhibition_id`),
  KEY `artwork_id` (`artwork_id`),
  CONSTRAINT `participates_in_ibfk_1` FOREIGN KEY (`exhibition_id`) REFERENCES `exhibition` (`exhibition_id`),
  CONSTRAINT `participates_in_ibfk_2` FOREIGN KEY (`artwork_id`) REFERENCES `artwork` (`artwork_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participates_in`
--

LOCK TABLES `participates_in` WRITE;
/*!40000 ALTER TABLE `participates_in` DISABLE KEYS */;
INSERT INTO `participates_in` VALUES (1,1),(5,1),(2,2),(3,3),(4,2);
/*!40000 ALTER TABLE `participates_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `bid_id` int DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `method` varchar(100) DEFAULT NULL,
  `Process_date` date DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `bid_id` (`bid_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`bid_id`) REFERENCES `bid` (`bid_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,55000.00,'Credit Card','2025-04-11','Completed'),(2,2,80000.00,'Bank Transfer','2025-04-11','Completed'),(3,3,105000.00,'Digital Wallet','2025-05-16','Completed');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitor`
--

DROP TABLE IF EXISTS `visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor` (
  `visitor_id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`visitor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor`
--

LOCK TABLES `visitor` WRITE;
/*!40000 ALTER TABLE `visitor` DISABLE KEYS */;
INSERT INTO `visitor` VALUES (1,'John Smith','john@example.com','1234567890'),(2,'Mary Johnson','mary@example.com','0987654321'),(3,'Robert Brown','robert@example.com','1112223333');
/*!40000 ALTER TABLE `visitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'artgal'
--
/*!50003 DROP FUNCTION IF EXISTS `count_artworks_by_artist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `count_artworks_by_artist`(p_artist_id INT) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE v_count INT;
  SELECT COUNT(*) INTO v_count FROM artwork WHERE creator_id = p_artist_id;
  RETURN v_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_artist_total_sales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_artist_total_sales`(p_artist_id INT) RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(12,2);
  SELECT SUM(b.bid_amount) INTO v_total
  FROM bid b
  JOIN artwork a ON b.artwork_id = a.artwork_id
  WHERE a.creator_id = p_artist_id AND b.is_winner = 1;
  RETURN COALESCE(v_total, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_auction_revenue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_auction_revenue`(p_auction_id INT) RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE v_revenue DECIMAL(12,2);
  SELECT SUM(bid_amount) INTO v_revenue
  FROM bid
  WHERE auction_id = p_auction_id AND is_winner = 1;
  RETURN COALESCE(v_revenue, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_highest_bid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_highest_bid`(p_artwork_id INT, p_auction_id INT) RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE v_highest_bid DECIMAL(12,2);
  SELECT MAX(bid_amount) INTO v_highest_bid
  FROM bid
  WHERE artwork_id = p_artwork_id AND auction_id = p_auction_id;
  RETURN COALESCE(v_highest_bid, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_artwork` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_artwork`(
  IN p_title VARCHAR(255),
  IN p_type VARCHAR(100),
  IN p_creation_yr INT,
  IN p_price DECIMAL(12,2),
  IN p_creator_id INT
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error adding artwork';
  END;
  
  START TRANSACTION;
  INSERT INTO artwork (Title, Type, creation_yr, price, creator_id)
  VALUES (p_title, p_type, p_creation_yr, p_price, p_creator_id);
  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `finalize_auction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `finalize_auction`(
  IN p_auction_id INT
)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error finalizing auction';
  END;
  
  START TRANSACTION;
  
  UPDATE bid
  SET is_winner = 1
  WHERE bid_id IN (
    SELECT bid_id FROM (
      SELECT b1.bid_id
      FROM bid b1
      WHERE b1.auction_id = p_auction_id
      AND b1.bid_amount = (
        SELECT MAX(b2.bid_amount)
        FROM bid b2
        WHERE b2.artwork_id = b1.artwork_id
        AND b2.auction_id = p_auction_id
      )
    ) AS winner_bids
  );
  
  UPDATE auction SET status = 'Completed' WHERE auction_id = p_auction_id;
  
  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `place_bid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `place_bid`(
  IN p_auction_id INT,
  IN p_buyer_id INT,
  IN p_artwork_id INT,
  IN p_bid_amount DECIMAL(12,2)
)
BEGIN
  DECLARE v_current_bid DECIMAL(12,2);
  DECLARE v_artwork_price DECIMAL(12,2);
  
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error placing bid';
  END;
  
  SELECT price INTO v_artwork_price FROM artwork WHERE artwork_id = p_artwork_id;
  
  IF p_bid_amount < v_artwork_price THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bid amount must be >= artwork price';
  END IF;
  
  SELECT MAX(bid_amount) INTO v_current_bid 
  FROM bid 
  WHERE artwork_id = p_artwork_id AND auction_id = p_auction_id;
  
  IF v_current_bid IS NOT NULL AND p_bid_amount <= v_current_bid THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bid must be higher than current bid';
  END IF;
  
  START TRANSACTION;
  INSERT INTO bid (auction_id, buyer_id, artwork_id, bid_amount)
  VALUES (p_auction_id, p_buyer_id, p_artwork_id, p_bid_amount);
  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_payment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_payment`(
  IN p_bid_id INT,
  IN p_method VARCHAR(100)
)
BEGIN
  DECLARE v_bid_amount DECIMAL(12,2);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error processing payment';
  END;
  
  SELECT bid_amount INTO v_bid_amount FROM bid WHERE bid_id = p_bid_id;
  
  START TRANSACTION;
  INSERT INTO payment (bid_id, amount, method, Process_date, status)
  VALUES (p_bid_id, v_bid_amount, p_method, CURDATE(), 'Completed');
  COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `artwork_details`
--

/*!50001 DROP VIEW IF EXISTS `artwork_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `artwork_details` AS select `a`.`artwork_id` AS `artwork_id`,`a`.`Title` AS `Title`,`a`.`Type` AS `Type`,`a`.`creation_yr` AS `creation_yr`,`a`.`price` AS `price`,`ar`.`Name` AS `artist_name`,count(distinct `pi`.`exhibition_id`) AS `exhibition_count` from ((`artwork` `a` join `artist` `ar` on((`a`.`creator_id` = `ar`.`artist_id`))) left join `participates_in` `pi` on((`a`.`artwork_id` = `pi`.`artwork_id`))) group by `a`.`artwork_id`,`a`.`Title`,`a`.`Type`,`a`.`creation_yr`,`a`.`price`,`ar`.`Name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `auction_statistics`
--

/*!50001 DROP VIEW IF EXISTS `auction_statistics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `auction_statistics` AS select `auc`.`auction_id` AS `auction_id`,`auc`.`auction_date` AS `auction_date`,`auc`.`location` AS `location`,`auc`.`status` AS `status`,count(distinct `aa`.`artwork_id`) AS `artworks_in_auction`,count(distinct `b`.`bid_id`) AS `total_bids`,round(avg(`b`.`bid_amount`),2) AS `avg_bid_amount`,max(`b`.`bid_amount`) AS `max_bid_amount` from ((`auction` `auc` left join `auction_artwork` `aa` on((`auc`.`auction_id` = `aa`.`auction_id`))) left join `bid` `b` on((`auc`.`auction_id` = `b`.`auction_id`))) group by `auc`.`auction_id`,`auc`.`auction_date`,`auc`.`location`,`auc`.`status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `buyer_purchase_history`
--

/*!50001 DROP VIEW IF EXISTS `buyer_purchase_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `buyer_purchase_history` AS select `b`.`buyer_id` AS `buyer_id`,`b`.`Name` AS `Name`,`b`.`email` AS `email`,count(distinct `bid`.`bid_id`) AS `total_bids`,count(distinct (case when (`bid`.`is_winner` = 1) then `bid`.`bid_id` end)) AS `winning_bids`,sum((case when (`bid`.`is_winner` = 1) then `bid`.`bid_amount` else 0 end)) AS `total_spent` from (`buyer` `b` left join `bid` on((`b`.`buyer_id` = `bid`.`buyer_id`))) group by `b`.`buyer_id`,`b`.`Name`,`b`.`email` */;
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

-- Dump completed on 2025-10-17 14:22:05
