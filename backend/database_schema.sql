-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: pharmacy_app_db
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adres`
--

DROP TABLE IF EXISTS `adres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adres` (
  `adres_id` int NOT NULL AUTO_INCREMENT,
  `il` varchar(45) COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `ilce` varchar(45) COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `mahalle` varchar(45) COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `cadde_sokak` varchar(45) COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `kapi_no` int DEFAULT NULL,
  `posta_kodu` int DEFAULT NULL,
  PRIMARY KEY (`adres_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adres`
--

LOCK TABLES `adres` WRITE;
/*!40000 ALTER TABLE `adres` DISABLE KEYS */;
INSERT INTO `adres` VALUES (1,'HATAY','KIRIKHAN','Atatürk Mah.','Yeşilyurt Cad.',14,31400),(2,'HATAY','İSKENDERUN','Çay Mah.','Atatürk Bulvarı',25,31200),(3,'HATAY','ANTAKYA','Cebrail Mah.','İstiklal Cad.',42,31030),(4,'KIRKLARELİ','MERKEZ','Karacaibrahim Mah.','Şehit Nusret Cad.',8,39000),(5,'KIRKLARELİ','BABAESKİ','Fevzi Çakmak Mah.','Atatürk Cad.',12,39400),(6,'İSTANBUL','BEŞİKTAŞ','Levent Mah.','Büyükdere Cad.',120,34330),(7,'İSTANBUL','ÜSKÜDAR','Mimar Sinan Mah.','Paşalimanı Cad.',12,34672),(8,'ANKARA','ÇANKAYA','Kızılay Mah.','Atatürk Bulvarı',88,6420),(9,'ANKARA','KEÇİÖREN','Etlik Mah.','Aşağı Eğlence Cad.',34,6010),(10,'ANKARA','YENİMAHALLE','Demetevler Mah.','İvedik Cad.',110,6200),(11,'İZMİR','KONAK','Alsancak Mah.','Kordon Boyu',5,35220),(12,'İZMİR','KARŞIYAKA','Bostanlı Mah.','Cemal Gürsel Cad.',45,35590),(13,'İZMİR','BORNOVA','Kazımdirik Mah.','Ankara Caddesi',78,35100),(14,'BURSA','OSMANGAZİ','Şehreküstü Mah.','Atatürk Cad.',10,16010),(15,'BURSA','NİLÜFER','Fethiye Mah.','Mudanya Yolu',22,16140),(16,'BURSA','YILDIRIM','Mollaarap Mah.','Teleferik Cad.',18,16340),(17,'KIRKLARELİ','LÜLEBURGAZ','Yıldırım Mah.','İstanbul Cad.',33,39750),(18,'KIRKLARELİ','BABAESKİ','Fevzi Çakmak Mah.','Atatürk Cad.',12,39400),(19,'KIRKLARELİ','VİZE','Evren Mah.','Kale Cad.',5,39480),(20,'HATAY','İSKENDERUN','Numune Mah.','Eilçeler Cad.',15,31200),(21,'HATAY','İSKENDERUN','Mustafa Kemal Mah.','Atatürk Cad.',50,31200),(22,'HATAY','İSKENDERUN','Çay Mah.','İnönü Cad.',12,31200),(23,'HATAY','İSKENDERUN','Savaş Mah.','Sahil Cad.',8,31200),(24,'KIRKLARELİ','MERKEZ','Karacaibrahim Mah.','Fevzi Çakmak Cad.',4,39000),(25,'KIRKLARELİ','MERKEZ','Bademlik Mah.','Cumhuriyet Cad.',11,39000),(26,'KIRKLARELİ','MERKEZ','Kocahıdır Mah.','Atatürk Cad.',25,39000),(27,'KIRKLARELİ','MERKEZ','Demirtaş Mah.','Zübeyde Hanım Cad.',9,39000);
/*!40000 ALTER TABLE `adres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doktor`
--

DROP TABLE IF EXISTS `doktor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doktor` (
  `doktor_id` int NOT NULL AUTO_INCREMENT,
  `doktor_ad_soyad` varchar(45) NOT NULL,
  `diploma_no` bigint NOT NULL,
  `uzmanlik` varchar(45) NOT NULL,
  PRIMARY KEY (`doktor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doktor`
--

LOCK TABLES `doktor` WRITE;
/*!40000 ALTER TABLE `doktor` DISABLE KEYS */;
INSERT INTO `doktor` VALUES (1,'Dr. Can Yücel',45123,'Pratisyen Hekim'),(2,'Dr. Zeynep Kaya',78910,'İç Hastalıkları (Dahiliye)');
/*!40000 ALTER TABLE `doktor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eczane`
--

DROP TABLE IF EXISTS `eczane`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eczane` (
  `eczane_id` int NOT NULL AUTO_INCREMENT,
  `eczane_ad` varchar(45) COLLATE utf8mb4_turkish_ci NOT NULL,
  `eczaci_ad_soyad` varchar(45) COLLATE utf8mb4_turkish_ci NOT NULL,
  `eczaci_diploma_no` int NOT NULL,
  `telefon` bigint DEFAULT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `adres_id` int DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `sifre` varchar(100) COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  PRIMARY KEY (`eczane_id`),
  UNIQUE KEY `email` (`email`),
  KEY `adres_id` (`adres_id`),
  CONSTRAINT `eczane_ibfk_1` FOREIGN KEY (`adres_id`) REFERENCES `adres` (`adres_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eczane`
--

LOCK TABLES `eczane` WRITE;
/*!40000 ALTER TABLE `eczane` DISABLE KEYS */;
INSERT INTO `eczane` VALUES (1,'Kırıkhan Yavuz Eczanesi','Ahmet Yavuz',10452,3265027700,36.50020000,36.36310000,1,'kirikhan@eczane.com','123456'),(2,'İskenderun Sahil Eczanesi','Mehmet Erdem',10893,3266141629,36.58780000,36.17510000,2,'sahil@eczane.com','123456'),(3,'Antakya Şifa Eczanesi','Ayşe Yılmaz',10111,3262223344,36.20230000,36.16050000,3,'antakya@eczane.com','123456'),(4,'Kırklareli Merkez Eczanesi','Fatma Kaya',10222,2882125566,41.73500000,27.22500000,4,'kirklareli@eczane.com','123456'),(5,'Babaeski Hayat Eczanesi','Ali Demir',10333,2885127788,41.42840000,27.10750000,5,'babaeski@eczane.com','123456'),(6,'Beşiktaş Levent Eczanesi','Selin Arslan',1011,2122223344,41.04220000,29.00770000,6,'levent@eczane.com','123456'),(7,'Üsküdar Paşa Eczanesi','Murat Yıldız',1010,2164445566,41.02500000,29.01500000,7,'uskudar@eczane.com','123456'),(8,'Kızılay Güven Eczanesi','Cem Korkmaz',1012,3124112233,39.92080000,32.85410000,8,'kizilay@eczane.com','123456'),(9,'Keçiören Etlik Eczanesi','Ebru Kaya',1013,3124223344,39.97000000,32.84000000,9,'etlik@eczane.com','123456'),(10,'Yenimahalle Demet Eczanesi','Burak Deniz',1008,3123331122,39.96000000,32.82000000,10,'yenimahalle@eczane.com','123456'),(11,'Alsancak Kordon Eczanesi','Ozan Aksoy',1014,2324215566,38.43890000,27.14310000,11,'alsancakkordoneczanesi@eczane.com','123456'),(12,'Karşıyaka Bostanlı Eczanesi','Deniz Çiftçi',1015,2324226677,38.45000000,27.10000000,12,'karşıyakabostanlıeczanesi@eczane.com','123456'),(13,'Bornova Özlem Eczanesi','Kerem Can',1020,2323884455,38.46000000,27.22000000,13,'bornovaozlemeczanesi@eczane.com','123456'),(14,'Osmangazi Ulucami Eczanesi','Kemal Sunal',1016,2242211122,40.18280000,29.06650000,14,'osmangaziulucamieczanesi@eczane.com','123456'),(15,'Nilüfer Fethiye Eczanesi','Cemile Öztürk',1017,2242233344,40.20000000,28.98000000,15,'nilüferfethiyeeczanesi@eczane.com','123456'),(16,'Yıldırım Teleferik Eczanesi','Hakan Taştan',1021,2243667788,40.18000000,29.10000000,16,'yıldırımteleferikeczanesi@eczane.com','123456'),(17,'Lüleburgaz Yıldız Eczanesi','Merve Demir',1022,2884178899,41.40500000,27.35500000,17,'lüleburgazyıldızeczanesi@eczane.com','123456'),(18,'Babaeski Hayat Eczanesi','Onur Toprak',1019,2885127788,41.42830000,27.11080000,18,'babaeskihayateczanesi@eczane.com','123456'),(19,'Vize Kale Eczanesi','Sibel Çelik',1023,2883181122,41.93800000,27.76500000,19,'vizekaleeczanesi@eczane.com','123456'),(20,'İskenderun Gelişim Eczanesi','Caner Şahin',10894,3266150011,36.58500000,36.17000000,20,'iskenderungelisim@eczane.com','123456'),(21,'İskenderun Körfez Eczanesi','Bahar Aydın',10895,3266162233,36.59000000,36.18000000,21,'iskenderunkorfez@eczane.com','123456'),(22,'İskenderun Park Eczanesi','Tolga Çetin',10896,3266174455,36.58200000,36.16500000,22,'iskenderunpark@eczane.com','123456'),(23,'İskenderun Akdeniz Eczanesi','Deniz Aksoy',10897,3266186677,36.59500000,36.17500000,23,'iskenderunakdeniz@eczane.com','123456'),(24,'Kırklareli Çağdaş Eczanesi','Volkan Korkmaz',10223,2882143344,41.74000000,27.22000000,24,'kirklarelicagdas@eczane.com','123456'),(25,'Kırklareli Umut Eczanesi','Gözde Yılmaz',10224,2882155566,41.73000000,27.23000000,25,'kirklareliumut@eczane.com','123456'),(26,'Kırklareli Şifa Eczanesi','Emre Aydın',10225,2882167788,41.73800000,27.22500000,26,'kirklarelisifa@eczane.com','123456'),(27,'Kırklareli Park Eczanesi','Melis Çelik',10226,2882189900,41.73200000,27.21800000,27,'kirklarelipark@eczane.com','123456'),(28,'Aylin Eczanesi','Aylin Yali',10982,3266148281,36.59192300,36.16783200,NULL,'aylin@eczane.com','aylin123');
/*!40000 ALTER TABLE `eczane` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eczane_ilac`
--

DROP TABLE IF EXISTS `eczane_ilac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eczane_ilac` (
  `eczane_id` int NOT NULL,
  `ilac_id` int NOT NULL,
  `stok_miktari` int DEFAULT '0',
  `stok` int DEFAULT '50',
  PRIMARY KEY (`eczane_id`,`ilac_id`),
  KEY `ilac_id` (`ilac_id`),
  CONSTRAINT `eczane_ilac_ibfk_1` FOREIGN KEY (`eczane_id`) REFERENCES `eczane` (`eczane_id`),
  CONSTRAINT `eczane_ilac_ibfk_2` FOREIGN KEY (`ilac_id`) REFERENCES `ilac` (`ilac_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eczane_ilac`
--

LOCK TABLES `eczane_ilac` WRITE;
/*!40000 ALTER TABLE `eczane_ilac` DISABLE KEYS */;
INSERT INTO `eczane_ilac` VALUES (1,1,68,50),(1,2,30,50),(1,3,48,50),(1,4,58,50),(1,5,42,50),(1,6,49,50),(1,7,46,50),(1,8,37,50),(1,9,50,50),(1,10,66,50),(1,11,38,50),(1,12,54,50),(1,13,58,50),(1,14,56,50),(1,15,59,50),(1,16,46,50),(1,17,61,50),(1,18,37,50),(1,19,40,50),(1,20,69,50),(1,21,62,50),(1,22,65,50),(1,23,56,50),(1,24,38,50),(1,25,57,50),(1,26,56,50),(1,27,68,50),(1,28,34,50),(1,29,48,50),(1,30,32,50),(1,31,31,50),(1,32,58,50),(1,33,30,50),(1,34,67,50),(1,35,66,50),(2,1,50,50),(2,2,58,50),(2,3,31,50),(2,4,53,50),(2,5,58,50),(2,6,44,50),(2,7,50,50),(2,8,47,50),(2,9,34,50),(2,10,45,50),(2,11,55,50),(2,12,68,50),(2,13,40,50),(2,14,45,50),(2,15,56,50),(2,16,43,50),(2,17,42,50),(2,18,70,50),(2,19,50,50),(2,20,62,50),(2,21,70,50),(2,22,64,50),(2,23,56,50),(2,24,36,50),(2,25,37,50),(2,26,55,50),(2,27,54,50),(2,28,63,50),(2,29,47,50),(2,30,50,50),(2,31,50,50),(2,32,30,50),(2,33,48,50),(2,34,51,50),(2,35,44,50),(3,1,64,50),(3,2,50,50),(3,3,54,50),(3,4,59,50),(3,5,46,50),(3,6,47,50),(3,7,58,50),(3,8,42,50),(3,9,43,50),(3,10,44,50),(3,11,42,50),(3,12,58,50),(3,13,37,50),(3,14,33,50),(3,15,50,50),(3,16,60,50),(3,17,39,50),(3,18,53,50),(3,19,46,50),(3,20,30,50),(3,21,59,50),(3,22,62,50),(3,23,51,50),(3,24,64,50),(3,25,33,50),(3,26,63,50),(3,27,58,50),(3,28,43,50),(3,29,52,50),(3,30,48,50),(3,31,50,50),(3,32,35,50),(3,33,33,50),(3,34,53,50),(3,35,55,50),(4,1,39,50),(4,2,41,50),(4,3,69,50),(4,4,57,50),(4,5,61,50),(4,6,68,50),(4,7,43,50),(4,8,44,50),(4,9,37,50),(4,10,61,50),(4,11,69,50),(4,12,64,50),(4,13,39,50),(4,14,44,50),(4,15,42,50),(4,16,48,50),(4,17,56,50),(4,18,55,50),(4,19,50,50),(4,20,60,50),(4,21,66,50),(4,22,31,50),(4,23,30,50),(4,24,58,50),(4,25,33,50),(4,26,63,50),(4,27,42,50),(4,28,40,50),(4,29,48,50),(4,30,41,50),(4,31,57,50),(4,32,66,50),(4,33,43,50),(4,34,62,50),(4,35,54,50),(5,1,33,50),(5,2,55,50),(5,3,60,50),(5,4,51,50),(5,5,50,50),(5,6,47,50),(5,7,43,50),(5,8,64,50),(5,9,38,50),(5,10,37,50),(5,11,63,50),(5,12,50,50),(5,13,70,50),(5,14,52,50),(5,15,56,50),(5,16,51,50),(5,17,56,50),(5,18,50,50),(5,19,59,50),(5,20,66,50),(5,21,39,50),(5,22,63,50),(5,23,63,50),(5,24,38,50),(5,25,62,50),(5,26,33,50),(5,27,68,50),(5,28,70,50),(5,29,66,50),(5,30,69,50),(5,31,55,50),(5,32,62,50),(5,33,38,50),(5,34,62,50),(5,35,62,50),(6,1,33,50),(6,2,68,50),(6,3,54,50),(6,4,43,50),(6,5,52,50),(6,6,45,50),(6,7,34,50),(6,8,41,50),(6,9,41,50),(6,10,59,50),(6,11,46,50),(6,12,53,50),(6,13,54,50),(6,14,35,50),(6,15,43,50),(6,16,45,50),(6,17,51,50),(6,18,42,50),(6,19,30,50),(6,20,54,50),(6,21,47,50),(6,22,30,50),(6,23,31,50),(6,24,35,50),(6,25,68,50),(6,26,51,50),(6,27,62,50),(6,28,66,50),(6,29,57,50),(6,30,65,50),(6,31,63,50),(6,32,44,50),(6,33,66,50),(6,34,32,50),(6,35,34,50),(7,1,61,50),(7,2,58,50),(7,3,47,50),(7,4,31,50),(7,5,47,50),(7,6,64,50),(7,7,59,50),(7,8,64,50),(7,9,46,50),(7,10,35,50),(7,11,31,50),(7,12,61,50),(7,13,70,50),(7,14,58,50),(7,15,57,50),(7,16,62,50),(7,17,30,50),(7,18,43,50),(7,19,48,50),(7,20,57,50),(7,21,41,50),(7,22,46,50),(7,23,48,50),(7,24,62,50),(7,25,42,50),(7,26,37,50),(7,27,43,50),(7,28,37,50),(7,29,49,50),(7,30,61,50),(7,31,63,50),(7,32,56,50),(7,33,33,50),(7,34,50,50),(7,35,54,50),(8,1,68,50),(8,2,64,50),(8,3,50,50),(8,4,69,50),(8,5,65,50),(8,6,68,50),(8,7,64,50),(8,8,56,50),(8,9,67,50),(8,10,70,50),(8,11,68,50),(8,12,61,50),(8,13,34,50),(8,14,48,50),(8,15,70,50),(8,16,37,50),(8,17,63,50),(8,18,62,50),(8,19,33,50),(8,20,68,50),(8,21,57,50),(8,22,57,50),(8,23,33,50),(8,24,55,50),(8,25,38,50),(8,26,35,50),(8,27,55,50),(8,28,70,50),(8,29,67,50),(8,30,43,50),(8,31,46,50),(8,32,41,50),(8,33,64,50),(8,34,62,50),(8,35,54,50),(9,1,69,50),(9,2,63,50),(9,3,44,50),(9,4,54,50),(9,5,69,50),(9,6,41,50),(9,7,64,50),(9,8,49,50),(9,9,32,50),(9,10,40,50),(9,11,39,50),(9,12,44,50),(9,13,64,50),(9,14,64,50),(9,15,47,50),(9,16,45,50),(9,17,31,50),(9,18,66,50),(9,19,43,50),(9,20,70,50),(9,21,44,50),(9,22,57,50),(9,23,43,50),(9,24,48,50),(9,25,40,50),(9,26,49,50),(9,27,40,50),(9,28,40,50),(9,29,31,50),(9,30,42,50),(9,31,33,50),(9,32,41,50),(9,33,45,50),(9,34,64,50),(9,35,63,50),(10,1,41,50),(10,2,34,50),(10,3,60,50),(10,4,43,50),(10,5,57,50),(10,6,64,50),(10,7,34,50),(10,8,67,50),(10,9,35,50),(10,10,34,50),(10,11,60,50),(10,12,30,50),(10,13,58,50),(10,14,54,50),(10,15,59,50),(10,16,52,50),(10,17,35,50),(10,18,38,50),(10,19,51,50),(10,20,30,50),(10,21,31,50),(10,22,38,50),(10,23,37,50),(10,24,65,50),(10,25,30,50),(10,26,61,50),(10,27,66,50),(10,28,61,50),(10,29,47,50),(10,30,59,50),(10,31,43,50),(10,32,44,50),(10,33,57,50),(10,34,35,50),(10,35,50,50),(11,1,63,50),(11,2,53,50),(11,3,49,50),(11,4,58,50),(11,5,34,50),(11,6,69,50),(11,7,39,50),(11,8,58,50),(11,9,38,50),(11,10,33,50),(11,11,49,50),(11,12,53,50),(11,13,52,50),(11,14,45,50),(11,15,46,50),(11,16,35,50),(11,17,65,50),(11,18,31,50),(11,19,60,50),(11,20,31,50),(11,21,54,50),(11,22,48,50),(11,23,65,50),(11,24,69,50),(11,25,68,50),(11,26,34,50),(11,27,45,50),(11,28,50,50),(11,29,58,50),(11,30,34,50),(11,31,37,50),(11,32,36,50),(11,33,43,50),(11,34,68,50),(11,35,52,50),(12,1,68,50),(12,2,66,50),(12,3,38,50),(12,4,45,50),(12,5,42,50),(12,6,56,50),(12,7,57,50),(12,8,50,50),(12,9,55,50),(12,10,34,50),(12,11,66,50),(12,12,54,50),(12,13,58,50),(12,14,33,50),(12,15,61,50),(12,16,45,50),(12,17,32,50),(12,18,57,50),(12,19,47,50),(12,20,45,50),(12,21,43,50),(12,22,31,50),(12,23,58,50),(12,24,70,50),(12,25,38,50),(12,26,54,50),(12,27,30,50),(12,28,68,50),(12,29,57,50),(12,30,68,50),(12,31,65,50),(12,32,50,50),(12,33,30,50),(12,34,36,50),(12,35,33,50),(13,1,55,50),(13,2,56,50),(13,3,37,50),(13,4,60,50),(13,5,35,50),(13,6,34,50),(13,7,45,50),(13,8,68,50),(13,9,42,50),(13,10,35,50),(13,11,56,50),(13,12,63,50),(13,13,55,50),(13,14,30,50),(13,15,62,50),(13,16,67,50),(13,17,36,50),(13,18,48,50),(13,19,61,50),(13,20,68,50),(13,21,57,50),(13,22,39,50),(13,23,39,50),(13,24,70,50),(13,25,59,50),(13,26,69,50),(13,27,39,50),(13,28,32,50),(13,29,39,50),(13,30,38,50),(13,31,32,50),(13,32,33,50),(13,33,53,50),(13,34,69,50),(13,35,55,50),(14,1,32,50),(14,2,61,50),(14,3,52,50),(14,4,34,50),(14,5,48,50),(14,6,55,50),(14,7,60,50),(14,8,60,50),(14,9,43,50),(14,10,65,50),(14,11,34,50),(14,12,50,50),(14,13,63,50),(14,14,30,50),(14,15,33,50),(14,16,60,50),(14,17,53,50),(14,18,64,50),(14,19,36,50),(14,20,62,50),(14,21,44,50),(14,22,31,50),(14,23,49,50),(14,24,69,50),(14,25,34,50),(14,26,33,50),(14,27,59,50),(14,28,61,50),(14,29,63,50),(14,30,57,50),(14,31,49,50),(14,32,70,50),(14,33,41,50),(14,34,66,50),(14,35,58,50),(15,1,52,50),(15,2,47,50),(15,3,65,50),(15,4,54,50),(15,5,59,50),(15,6,70,50),(15,7,35,50),(15,8,68,50),(15,9,61,50),(15,10,59,50),(15,11,43,50),(15,12,39,50),(15,13,50,50),(15,14,30,50),(15,15,38,50),(15,16,40,50),(15,17,66,50),(15,18,54,50),(15,19,57,50),(15,20,43,50),(15,21,57,50),(15,22,57,50),(15,23,58,50),(15,24,55,50),(15,25,69,50),(15,26,35,50),(15,27,48,50),(15,28,41,50),(15,29,69,50),(15,30,32,50),(15,31,33,50),(15,32,42,50),(15,33,68,50),(15,34,37,50),(15,35,54,50),(16,1,53,50),(16,2,34,50),(16,3,40,50),(16,4,42,50),(16,5,58,50),(16,6,62,50),(16,7,42,50),(16,8,55,50),(16,9,50,50),(16,10,40,50),(16,11,63,50),(16,12,65,50),(16,13,65,50),(16,14,57,50),(16,15,42,50),(16,16,37,50),(16,17,69,50),(16,18,59,50),(16,19,46,50),(16,20,68,50),(16,21,58,50),(16,22,33,50),(16,23,44,50),(16,24,32,50),(16,25,52,50),(16,26,38,50),(16,27,51,50),(16,28,65,50),(16,29,43,50),(16,30,52,50),(16,31,57,50),(16,32,36,50),(16,33,62,50),(16,34,43,50),(16,35,34,50),(17,1,34,50),(17,2,58,50),(17,3,49,50),(17,4,69,50),(17,5,54,50),(17,6,56,50),(17,7,48,50),(17,8,46,50),(17,9,53,50),(17,10,64,50),(17,11,68,50),(17,12,59,50),(17,13,42,50),(17,14,35,50),(17,15,48,50),(17,16,53,50),(17,17,42,50),(17,18,70,50),(17,19,34,50),(17,20,35,50),(17,21,40,50),(17,22,41,50),(17,23,44,50),(17,24,38,50),(17,25,55,50),(17,26,42,50),(17,27,45,50),(17,28,57,50),(17,29,52,50),(17,30,53,50),(17,31,46,50),(17,32,36,50),(17,33,57,50),(17,34,50,50),(17,35,56,50),(18,1,70,50),(18,2,35,50),(18,3,58,50),(18,4,37,50),(18,5,34,50),(18,6,50,50),(18,7,56,50),(18,8,35,50),(18,9,61,50),(18,10,70,50),(18,11,68,50),(18,12,39,50),(18,13,65,50),(18,14,43,50),(18,15,56,50),(18,16,38,50),(18,17,37,50),(18,18,47,50),(18,19,58,50),(18,20,39,50),(18,21,65,50),(18,22,47,50),(18,23,49,50),(18,24,43,50),(18,25,36,50),(18,26,47,50),(18,27,34,50),(18,28,50,50),(18,29,50,50),(18,30,61,50),(18,31,35,50),(18,32,52,50),(18,33,38,50),(18,34,58,50),(18,35,31,50),(19,1,69,50),(19,2,56,50),(19,3,44,50),(19,4,56,50),(19,5,69,50),(19,6,40,50),(19,7,68,50),(19,8,33,50),(19,9,61,50),(19,10,45,50),(19,11,41,50),(19,12,49,50),(19,13,58,50),(19,14,36,50),(19,15,40,50),(19,16,36,50),(19,17,38,50),(19,18,58,50),(19,19,35,50),(19,20,57,50),(19,21,30,50),(19,22,68,50),(19,23,30,50),(19,24,63,50),(19,25,46,50),(19,26,69,50),(19,27,60,50),(19,28,41,50),(19,29,55,50),(19,30,60,50),(19,31,47,50),(19,32,65,50),(19,33,34,50),(19,34,30,50),(19,35,64,50),(20,1,21,50),(20,2,27,50),(20,3,30,50),(20,4,27,50),(20,5,26,50),(20,6,29,50),(20,7,29,50),(20,8,37,50),(20,9,36,50),(20,10,31,50),(20,11,25,50),(20,12,33,50),(20,13,29,50),(20,14,28,50),(20,15,34,50),(20,16,23,50),(20,17,37,50),(20,18,33,50),(20,19,35,50),(20,20,35,50),(20,21,28,50),(20,22,39,50),(20,23,26,50),(20,24,36,50),(20,25,21,50),(20,26,20,50),(20,27,39,50),(20,28,31,50),(20,29,39,50),(20,30,20,50),(20,31,24,50),(20,32,22,50),(20,33,40,50),(20,34,29,50),(20,35,25,50),(21,1,20,50),(21,2,25,50),(21,3,27,50),(21,4,40,50),(21,5,38,50),(21,6,27,50),(21,7,24,50),(21,8,40,50),(21,9,26,50),(21,10,33,50),(21,11,23,50),(21,12,38,50),(21,13,20,50),(21,14,30,50),(21,15,28,50),(21,16,32,50),(21,17,32,50),(21,18,25,50),(21,19,31,50),(21,20,20,50),(21,21,27,50),(21,22,36,50),(21,23,39,50),(21,24,25,50),(21,25,29,50),(21,26,32,50),(21,27,30,50),(21,28,37,50),(21,29,34,50),(21,30,40,50),(21,31,35,50),(21,32,38,50),(21,33,20,50),(21,34,31,50),(21,35,35,50),(22,1,40,50),(22,2,35,50),(22,3,33,50),(22,4,40,50),(22,5,39,50),(22,6,36,50),(22,7,23,50),(22,8,30,50),(22,9,21,50),(22,10,35,50),(22,11,30,50),(22,12,24,50),(22,13,31,50),(22,14,24,50),(22,15,28,50),(22,16,29,50),(22,17,20,50),(22,18,36,50),(22,19,39,50),(22,20,23,50),(22,21,20,50),(22,22,32,50),(22,23,39,50),(22,24,36,50),(22,25,23,50),(22,26,31,50),(22,27,23,50),(22,28,25,50),(22,29,34,50),(22,30,35,50),(22,31,31,50),(22,32,34,50),(22,33,33,50),(22,34,22,50),(22,35,36,50),(23,1,30,50),(23,2,21,50),(23,3,39,50),(23,4,28,50),(23,5,26,50),(23,6,24,50),(23,7,26,50),(23,8,35,50),(23,9,38,50),(23,10,24,50),(23,11,29,50),(23,12,31,50),(23,13,29,50),(23,14,31,50),(23,15,30,50),(23,16,35,50),(23,17,25,50),(23,18,20,50),(23,19,27,50),(23,20,34,50),(23,21,28,50),(23,22,20,50),(23,23,36,50),(23,24,37,50),(23,25,38,50),(23,26,40,50),(23,27,22,50),(23,28,36,50),(23,29,31,50),(23,30,29,50),(23,31,29,50),(23,32,20,50),(23,33,34,50),(23,34,28,50),(23,35,39,50),(24,1,30,50),(24,2,34,50),(24,3,40,50),(24,4,37,50),(24,5,25,50),(24,6,34,50),(24,7,36,50),(24,8,37,50),(24,9,38,50),(24,10,36,50),(24,11,25,50),(24,12,21,50),(24,13,31,50),(24,14,31,50),(24,15,22,50),(24,16,39,50),(24,17,25,50),(24,18,29,50),(24,19,31,50),(24,20,26,50),(24,21,38,50),(24,22,31,50),(24,23,22,50),(24,24,39,50),(24,25,25,50),(24,26,33,50),(24,27,26,50),(24,28,31,50),(24,29,39,50),(24,30,20,50),(24,31,28,50),(24,32,36,50),(24,33,37,50),(24,34,34,50),(24,35,21,50),(25,1,23,50),(25,2,35,50),(25,3,21,50),(25,4,22,50),(25,5,30,50),(25,6,20,50),(25,7,35,50),(25,8,30,50),(25,9,25,50),(25,10,35,50),(25,11,21,50),(25,12,23,50),(25,13,31,50),(25,14,26,50),(25,15,36,50),(25,16,23,50),(25,17,26,50),(25,18,21,50),(25,19,30,50),(25,20,27,50),(25,21,22,50),(25,22,32,50),(25,23,32,50),(25,24,22,50),(25,25,39,50),(25,26,26,50),(25,27,36,50),(25,28,20,50),(25,29,35,50),(25,30,31,50),(25,31,31,50),(25,32,22,50),(25,33,39,50),(25,34,24,50),(25,35,27,50),(26,1,21,50),(26,2,27,50),(26,3,33,50),(26,4,20,50),(26,5,24,50),(26,6,21,50),(26,7,34,50),(26,8,24,50),(26,9,20,50),(26,10,30,50),(26,11,27,50),(26,12,25,50),(26,13,26,50),(26,14,35,50),(26,15,34,50),(26,16,27,50),(26,17,32,50),(26,18,39,50),(26,19,40,50),(26,20,20,50),(26,21,21,50),(26,22,29,50),(26,23,21,50),(26,24,38,50),(26,25,23,50),(26,26,26,50),(26,27,40,50),(26,28,39,50),(26,29,34,50),(26,30,36,50),(26,31,37,50),(26,32,35,50),(26,33,24,50),(26,34,38,50),(26,35,37,50),(27,1,28,50),(27,2,31,50),(27,3,33,50),(27,4,29,50),(27,5,28,50),(27,6,34,50),(27,7,24,50),(27,8,40,50),(27,9,26,50),(27,10,32,50),(27,11,20,50),(27,12,25,50),(27,13,26,50),(27,14,34,50),(27,15,33,50),(27,16,21,50),(27,17,27,50),(27,18,33,50),(27,19,23,50),(27,20,39,50),(27,21,23,50),(27,22,22,50),(27,23,40,50),(27,24,31,50),(27,25,37,50),(27,26,31,50),(27,27,25,50),(27,28,33,50),(27,29,29,50),(27,30,28,50),(27,31,32,50),(27,32,37,50),(27,33,25,50),(27,34,39,50),(27,35,37,50);
/*!40000 ALTER TABLE `eczane_ilac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_pharmacies`
--

DROP TABLE IF EXISTS `favorite_pharmacies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_pharmacies` (
  `favorite_id` int NOT NULL AUTO_INCREMENT,
  `hasta_tckn` bigint NOT NULL,
  `eczane_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`favorite_id`),
  KEY `hasta_tckn` (`hasta_tckn`),
  KEY `eczane_id` (`eczane_id`),
  CONSTRAINT `favorite_pharmacies_ibfk_1` FOREIGN KEY (`hasta_tckn`) REFERENCES `hasta` (`hasta_tckn`) ON DELETE CASCADE,
  CONSTRAINT `favorite_pharmacies_ibfk_2` FOREIGN KEY (`eczane_id`) REFERENCES `eczane` (`eczane_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_pharmacies`
--

LOCK TABLES `favorite_pharmacies` WRITE;
/*!40000 ALTER TABLE `favorite_pharmacies` DISABLE KEYS */;
INSERT INTO `favorite_pharmacies` VALUES (1,55544433322,1,'2026-08-04 09:59:28'),(3,55544433322,3,'2026-08-10 18:23:41'),(4,55544433322,2,'2026-08-10 18:52:49');
/*!40000 ALTER TABLE `favorite_pharmacies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_products`
--

DROP TABLE IF EXISTS `favorite_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_products` (
  `favorite_id` int NOT NULL AUTO_INCREMENT,
  `hasta_tckn` bigint NOT NULL,
  `ilac_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`favorite_id`),
  KEY `hasta_tckn` (`hasta_tckn`),
  KEY `ilac_id` (`ilac_id`),
  CONSTRAINT `favorite_products_ibfk_1` FOREIGN KEY (`hasta_tckn`) REFERENCES `hasta` (`hasta_tckn`) ON DELETE CASCADE,
  CONSTRAINT `favorite_products_ibfk_2` FOREIGN KEY (`ilac_id`) REFERENCES `ilac` (`ilac_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_products`
--

LOCK TABLES `favorite_products` WRITE;
/*!40000 ALTER TABLE `favorite_products` DISABLE KEYS */;
INSERT INTO `favorite_products` VALUES (2,55544433322,1,'2026-08-10 19:00:28'),(9,12452516598,1,'2026-08-12 15:23:09'),(10,12452516598,3,'2026-08-12 15:23:17'),(11,12452516598,5,'2026-08-13 11:28:03');
/*!40000 ALTER TABLE `favorite_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hasta`
--

DROP TABLE IF EXISTS `hasta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hasta` (
  `hasta_tckn` bigint NOT NULL,
  `hasta_ad_soyad` varchar(45) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `cinsiyet` varchar(1) DEFAULT NULL,
  `dog_tar` date DEFAULT NULL,
  `telefon` bigint DEFAULT NULL,
  `adres_id` int DEFAULT NULL,
  PRIMARY KEY (`hasta_tckn`),
  UNIQUE KEY `email` (`email`),
  KEY `adres_id` (`adres_id`),
  CONSTRAINT `hasta_ibfk_1` FOREIGN KEY (`adres_id`) REFERENCES `adres` (`adres_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hasta`
--

LOCK TABLES `hasta` WRITE;
/*!40000 ALTER TABLE `hasta` DISABLE KEYS */;
INSERT INTO `hasta` VALUES (11122233344,'Ahmet Yılmaz','ahmet@gmail.com','hashed_password_456','E','1995-08-20',5329876543,1),(12452516598,'Yasin Test','yasin@gmail.com','123456',NULL,NULL,NULL,NULL),(55544433322,'Merve Yalçın','merve@gmail.com','hashed_password_123','K','2002-05-12',5551234567,3);
/*!40000 ALTER TABLE `hasta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ilac`
--

DROP TABLE IF EXISTS `ilac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ilac` (
  `ilac_id` int NOT NULL AUTO_INCREMENT,
  `barkod` bigint NOT NULL,
  `ilac_ad` varchar(45) NOT NULL,
  `description` text,
  `alis_fiyat` int DEFAULT NULL,
  `satis_fiyat` int DEFAULT NULL,
  `stok` int DEFAULT NULL,
  `eczane_id` int DEFAULT NULL,
  `uretici_id` int DEFAULT NULL,
  `anlasma_baslangic` date DEFAULT NULL,
  `anlasma_bitis` date DEFAULT NULL,
  PRIMARY KEY (`ilac_id`),
  KEY `eczane_id` (`eczane_id`),
  KEY `uretici_id` (`uretici_id`),
  CONSTRAINT `ilac_ibfk_1` FOREIGN KEY (`eczane_id`) REFERENCES `eczane` (`eczane_id`),
  CONSTRAINT `ilac_ibfk_2` FOREIGN KEY (`uretici_id`) REFERENCES `uretici` (`uretici_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ilac`
--

LOCK TABLES `ilac` WRITE;
/*!40000 ALTER TABLE `ilac` DISABLE KEYS */;
INSERT INTO `ilac` VALUES (1,869954601001,'Parol 500 mg','Ağrı kesici ve ateş düşürücü tablet.',35,45,500,1,1,'2025-01-01','2027-01-01'),(2,869954602002,'Aferin Sinüs','Soğuk algınlığı ve sinüs açıcı kapsül.',65,85,500,2,2,'2025-01-01','2027-01-01'),(3,869954603003,'Bepanthol Krem','Cilt bakım ve onarıcı merhem.',110,140,500,3,1,'2025-01-01','2027-01-01'),(4,869954604004,'Apranax Fort','Kuvvetli ağrı kesici ve iltihap giderici.',75,95,500,4,2,'2025-01-01','2027-01-01'),(5,869954605005,'Majezik 100 mg','Güçlü etkiye sahip eklem ve kas ağrısı ilacı.',80,110,500,5,1,'2025-01-01','2027-01-01'),(6,869954606006,'Cataflam 50 mg','Hızlı etkili ağrı kesici ve antiinflamatuar.',90,120,500,1,2,'2025-01-01','2027-01-01'),(7,869954607007,'Arveles 25 mg','Kas ve eklem ağrıları için etken maddeli film tablet.',70,95,500,2,1,'2025-01-01','2027-01-01'),(8,869954608008,'Calpol 6 Plus Şurup','Çocuklar için ateş düşürücü ve ağrı kesici şurup.',50,70,500,3,2,'2025-01-01','2027-01-01'),(9,869954609009,'Illiadin Merhem / Sprey','Burun tıkanıklığı açıcı sprey.',45,60,500,4,1,'2025-01-01','2027-01-01'),(10,869954610010,'Tylol Hot Poşet','Grip ve soğuk algınlığı için sıcak içecek tozu.',85,115,500,5,2,'2025-01-01','2027-01-01'),(11,869954611011,'Sudafed Tablet','Üst solunum yolu dekonjestanı.',60,80,500,1,1,'2025-01-01','2027-01-01'),(12,869954612012,'Vicks VapoRub','Nefes açıcı ve rahatlatıcı okaliptüs merhemi.',95,130,500,2,2,'2025-01-01','2027-01-01'),(13,869954613013,'Rennie Gargara / Tablet','Mide asidini düzenleyici ve antiasit.',55,75,500,3,1,'2025-01-01','2027-01-01'),(14,869954614014,'Gaviscon Double Action','Reflü ve mide yanması için süspansiyon.',120,160,500,4,2,'2025-01-01','2027-01-01'),(15,869954615015,'Biteral 500 mg','Antibakteriyel ve antiprotozoal tablet.',140,185,500,5,1,'2025-01-01','2027-01-01'),(16,869954616016,'Majezik Gargara','Boğaz ağrısı ve iltihabı için gargara solüsyonu.',90,125,500,1,2,'2025-01-01','2027-01-01'),(17,869954617017,'Theraflu Fort','Grip ve nezle belirtilerini gideren sıcak içecek.',95,130,500,2,1,'2025-01-01','2027-01-01'),(18,869954618018,'Otrivine Burun Spreyi','Hızlı burun açıcı sprey.',50,70,500,3,2,'2025-01-01','2027-01-01'),(19,869954619019,'Supradyn All Day','Günlük multivitamin ve mineral desteği.',180,240,500,4,1,'2025-01-01','2027-01-01'),(20,869954620020,'Redoxon C Vitamini + Çinko','Bağışıklık destekleyici efervesan tablet.',130,170,500,5,2,'2025-01-01','2027-01-01'),(21,869954636036,'Bioderma Sensibio H2O Micellar Su','Hassas ciltler için durulama gerektirmeyen temizleme suyu.',420,550,500,1,1,'2025-01-01','2027-01-01'),(22,869954637037,'Avene Thermal Spring Water','Hassas ve tahriş olmuş ciltler için yatıştırıcı su.',280,360,500,2,2,'2025-01-01','2027-01-01'),(23,869954638038,'Mustela Bebe Şampuanı','Yeni doğan bebekler için göz yakmayan saç ve vücut şampuanı',320,410,500,3,1,'2025-01-01','2027-01-01'),(24,869954639039,'Sudocrem Pişik Bakım Kremi','Bebeklerde pişik önleyici ve cildi yenileyici koruyucu krem',240,310,500,4,2,'2025-01-01','2027-01-01'),(25,869954640040,'Orzax Ocean Plus Omega 3','Yüksek kaliteli balık yağı kapsülü.',390,500,500,5,1,'2025-01-01','2027-01-01'),(26,869954641041,'Imuncol C Vitamini Propolis','Bağışıklık destekleyici takviye edici şurup/tablet.',210,275,500,1,2,'2025-01-01','2027-01-01'),(27,869954642042,'Rutin Diital Ateş Ölçer','Hızlı ve hassas ölçüm yapan dijital termometre.',150,200,500,2,1,'2025-01-01','2027-01-01'),(28,869954643043,'Confor Plus Boyunluk','Yumuşak sünger boyun destek yastığı.',90,130,500,3,2,'2025-01-01','2027-01-01'),(29,869954644044,'Elastik Bandaj 10 cm x 5 m','Eklem destekleyici tıbbi sargı bandajı.',40,65,500,4,1,'2025-01-01','2027-01-01'),(30,869954645045,'Hansaplast Yara Bandı Kutusu (20li)','Çeşitli ebatlarda suya dayanıklı yara bandı seti.',60,90,500,5,2,'2025-01-01','2027-01-01'),(31,869954646046,'Stérimar Burun Hijyeni Spreyi','100 doğal izotonik deniz suyu spreyi.',180,240,500,1,1,'2025-01-01','2027-01-01'),(32,869954647047,'Bepanthol Sensiderm Egzama Kremi','Kaşıntı ve kızarıklık giderici medikal bakım kremi.',340,440,500,2,2,'2025-01-01','2027-01-01'),(33,869954648048,'Solgar Solgar Vitamin D3 1000 IU','Kemik ve bağışıklık desteği damla/kapsül.',270,350,500,3,1,'2025-01-01','2027-01-01'),(34,869954649049,'Pharmaton Vital Kapsül','Ginseng içeren multivitamin ve mineral kompleksi.',450,580,500,4,2,'2025-01-01','2027-01-01'),(35,869954650050,'Enfeksiyon Maskesi Cerrahi (50li)','3 katlı telli tek kullanımlık koruyucu maske kutusu.',75,110,500,5,1,'2025-01-01','2027-01-01');
/*!40000 ALTER TABLE `ilac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `ilac_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` int NOT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `ilac_id` (`ilac_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`ilac_id`) REFERENCES `ilac` (`ilac_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,1,45),(2,2,1,3,45),(3,3,1,3,45),(4,9,1,12,45),(5,9,4,5,95),(6,9,5,8,110),(7,9,3,6,140),(8,9,2,9,85),(9,10,5,1,110),(10,10,3,2,140);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `hasta_tckn` bigint NOT NULL,
  `eczane_id` int NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `hasta_tckn` (`hasta_tckn`),
  KEY `idx_eczane_id` (`eczane_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`hasta_tckn`) REFERENCES `hasta` (`hasta_tckn`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`eczane_id`) REFERENCES `eczane` (`eczane_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,55544433322,1,'Pending',130.00,'2026-08-04 09:59:28'),(2,55544433322,1,'Pending',135.00,'2026-08-04 12:24:18'),(3,55544433322,1,'Pending',135.00,'2026-08-04 12:31:22'),(6,55544433322,2,'Talep Alındı',1395.00,'2026-08-08 08:41:49'),(9,55544433322,2,'Tamamlandı',3500.00,'2026-08-08 12:03:07'),(10,12452516598,2,'Hazırlanıyor',390.00,'2026-08-11 11:09:15');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacy_duty_schedule`
--

DROP TABLE IF EXISTS `pharmacy_duty_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_duty_schedule` (
  `duty_id` int NOT NULL AUTO_INCREMENT,
  `eczane_id` int NOT NULL,
  `duty_date` date NOT NULL,
  PRIMARY KEY (`duty_id`),
  KEY `eczane_id` (`eczane_id`),
  CONSTRAINT `pharmacy_duty_schedule_ibfk_1` FOREIGN KEY (`eczane_id`) REFERENCES `eczane` (`eczane_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacy_duty_schedule`
--

LOCK TABLES `pharmacy_duty_schedule` WRITE;
/*!40000 ALTER TABLE `pharmacy_duty_schedule` DISABLE KEYS */;
INSERT INTO `pharmacy_duty_schedule` VALUES (1,20,'2026-08-12'),(2,24,'2026-08-12'),(3,21,'2026-08-13'),(4,25,'2026-08-13'),(5,22,'2026-08-14'),(6,26,'2026-08-14'),(7,23,'2026-08-15'),(8,27,'2026-08-15'),(9,2,'2026-08-16'),(10,4,'2026-08-16'),(11,20,'2026-08-17'),(12,25,'2026-08-17'),(13,21,'2026-08-18'),(14,26,'2026-08-18');
/*!40000 ALTER TABLE `pharmacy_duty_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recete`
--

DROP TABLE IF EXISTS `recete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recete` (
  `recete_id` int NOT NULL AUTO_INCREMENT,
  `recete_tarih` date DEFAULT NULL,
  `hasta_tckn` bigint DEFAULT NULL,
  `ilac_id` int DEFAULT NULL,
  `doktor_id` int NOT NULL,
  `ilac_adet` int DEFAULT NULL,
  `kullanim_doz` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`recete_id`),
  KEY `hasta_tckn` (`hasta_tckn`),
  KEY `ilac_id` (`ilac_id`),
  KEY `doktor_id` (`doktor_id`),
  CONSTRAINT `recete_ibfk_1` FOREIGN KEY (`hasta_tckn`) REFERENCES `hasta` (`hasta_tckn`),
  CONSTRAINT `recete_ibfk_2` FOREIGN KEY (`ilac_id`) REFERENCES `ilac` (`ilac_id`),
  CONSTRAINT `recete_ibfk_3` FOREIGN KEY (`doktor_id`) REFERENCES `doktor` (`doktor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recete`
--

LOCK TABLES `recete` WRITE;
/*!40000 ALTER TABLE `recete` DISABLE KEYS */;
INSERT INTO `recete` VALUES (1,'2026-06-01',55544433322,1,1,2,'Günde 2 defa tok karnına'),(2,'2026-06-01',55544433322,2,2,1,'Günde 3 defa');
/*!40000 ALTER TABLE `recete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uretici`
--

DROP TABLE IF EXISTS `uretici`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uretici` (
  `uretici_id` int NOT NULL AUTO_INCREMENT,
  `uretici_ad` varchar(45) DEFAULT NULL,
  `hesap_no` bigint DEFAULT NULL,
  PRIMARY KEY (`uretici_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uretici`
--

LOCK TABLES `uretici` WRITE;
/*!40000 ALTER TABLE `uretici` DISABLE KEYS */;
INSERT INTO `uretici` VALUES (1,'Deva Holding',1234567890123),(2,'Bayer İlaç Sanayi',9876543210123);
/*!40000 ALTER TABLE `uretici` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-14 11:53:04
