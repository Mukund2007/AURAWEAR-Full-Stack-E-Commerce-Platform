-- MySQL dump 10.13  Distrib 9.6.0, for macos15 (arm64)
--
-- Host: [CONFIGURED VIA ENV]    Database: [CONFIGURED VIA ENV]
-- ------------------------------------------------------
-- Server version	9.6.0

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
-- [SANITIZED: GTID/binlog info removed]
-- [SANITIZED: GTID/binlog info removed]

--
-- GTID state at the beginning of the backup 
--

-- [SANITIZED: GTID/binlog info removed]

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_email` varchar(100) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `size` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
-- [SANITIZED: Real cart data removed — populate via application]
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_email` varchar(100) DEFAULT NULL,
  `total` double DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_id` varchar(100) DEFAULT NULL,
  `shipping_name` varchar(100) DEFAULT NULL,
  `shipping_phone` varchar(20) DEFAULT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `shipping_city` varchar(50) DEFAULT NULL,
  `shipping_state` varchar(50) DEFAULT NULL,
  `shipping_pincode` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
-- [SANITIZED: Real orders data removed — populate via application]
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT '1',
  `price` decimal(10,2) DEFAULT NULL,
  `size` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
-- [SANITIZED: Real order_items data removed — populate via application]
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `original_price` int DEFAULT NULL,
  `discount` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `reviews` int DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `stock_quantity` int NOT NULL DEFAULT 100,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` (`id`, `name`, `price`, `original_price`, `discount`, `category`, `type`, `size`, `color`, `gender`, `rating`, `reviews`, `brand`, `image`, `stock_quantity`) VALUES (1, 'V-01 Tech Hoodie', 2999, 3999, 25, 'Tops', 'Hoodie', 'M', 'Charcoal', 'Men', 0.0, 0, 'AuraWear', 'v01-hoodie.jpg', 100),(2, 'Modular Cargo Pant', 2499, 3299, 24, 'Bottoms', 'Cargo', 'S', 'Olive', 'Men', 0.0, 0, 'AuraWear', 'modular-cargo.jpg', 100),(3, 'Sneaker Alpha', 3499, 4499, 22, 'Footwear', 'Sneaker', 'UK8', 'White', 'Unisex', 0.0, 0, 'AuraWear', 'sneak-alpha.jpg', 100),(4, 'Structured Shell Jacket', 3999, 4999, 20, 'Outerwear', 'Jacket', 'M', 'Charcoal', 'Men', 0.0, 0, 'AuraWear', 'shell-jacket.jpg', 100),(5, 'Ribbed Mock Neck', 999, 1399, 28, 'Tops', 'Long Sleeve', 'S', 'Cream', 'Women', 0.0, 0, 'AuraWear', 'mock-neck.jpg', 100),(6, 'Architectural Wool Coat', 5999, 7499, 20, 'Outerwear', 'Coat', 'M', 'Charcoal', 'Women', 0.0, 0, 'AuraWear', 'wool-coat.jpg', 100),(7, 'Technical Crossbody Bag', 1799, 2399, 25, 'Accessories', 'Bag', 'Free', 'Sand', 'Unisex', 0.0, 0, 'AuraWear', 'crossbody-bag.jpg', 100),(8, 'Heavyweight Beanie V2', 699, 999, 30, 'Accessories', 'Beanie', 'Free', 'Sage', 'Unisex', 0.0, 0, 'AuraWear', 'beanie-v2.jpg', 100),(9, 'Hydro Shield Parka', 4999, 5999, 16, 'Outerwear', 'Parka', 'L', 'Black', 'Men', 0.0, 0, 'AuraWear', 'hydro-parka.jpg', 100),(10, 'Minimalist Slide Sandal', 1199, 1599, 25, 'Footwear', 'Slide', 'UK9', 'Charcoal', 'Men', 0.0, 0, 'AuraWear', 'minimal-slide.jpg', 100),(11, 'Spectral Runner Sneaker', 3299, 4299, 23, 'Footwear', 'Sneaker', 'UK8', 'Grey', 'Unisex', 0.0, 0, 'AuraWear', 'spectral-runner.jpg', 100),(12, 'Tailored Tech Blazer', 3799, 4799, 20, 'Outerwear', 'Blazer', 'M', 'Slate', 'Men', 0.0, 0, 'AuraWear', 'tech-blazer.jpg', 100),(13, 'Structured Knit Tee', 1299, 1699, 23, 'Tops', 'Tee', 'M', 'Off-White', 'Unisex', 0.0, 0, 'AuraWear', 'knit-tee.jpg', 100),(14, 'Thermal Grid Long Sleeve', 1599, 2099, 23, 'Tops', 'Long Sleeve', 'L', 'Olive', 'Men', 0.0, 0, 'AuraWear', 'thermal-grid.jpg', 100),(15, 'Modular Utility Vest', 2299, 2999, 23, 'Outerwear', 'Vest', 'M', 'Black', 'Unisex', 0.0, 0, 'AuraWear', 'utility-vest.jpg', 100),(16, 'Aura Frame Sunglasses', 1499, 1999, 25, 'Accessories', 'Sunglasses', 'Free', 'Obsidian', 'Unisex', 0.0, 0, 'AuraWear', 'aura-glasses.jpg', 100),(17, 'Premium Canvas Backpack', 2499, 3299, 24, 'Accessories', 'Bag', 'Free', 'Khaki', 'Unisex', 0.0, 0, 'AuraWear', 'canvas-backpack.jpg', 100),(18, 'Technical Webbing Belt', 799, 1099, 27, 'Accessories', 'Belt', 'Free', 'Charcoal', 'Unisex', 0.0, 0, 'AuraWear', 'web-belt.jpg', 100),(19, 'Chunky Sole Combat Boot', 3899, 4999, 22, 'Footwear', 'Boot', 'UK7', 'Jet Black', 'Women', 0.0, 0, 'AuraWear', 'combat-boot.jpg', 100),(20, 'Pleated Architectural Pant', 2299, 2999, 23, 'Bottoms', 'Pants', 'M', 'Sand', 'Women', 0.0, 0, 'AuraWear', 'pleated-pant.jpg', 100),(21, 'Relaxed Fit Cargo Short', 1199, 1599, 25, 'Bottoms', 'Short', 'L', 'Sage', 'Men', 0.0, 0, 'AuraWear', 'cargo-short.jpg', 100),(22, 'High-Density Crop Zip', 1899, 2499, 24, 'Tops', 'Sweatshirt', 'S', 'Lilac', 'Women', 0.0, 0, 'AuraWear', 'crop-zip.jpg', 100),(23, 'Modular Track Jacket', 2499, 3299, 24, 'Outerwear', 'Jacket', 'L', 'Navy', 'Men', 0.0, 0, 'AuraWear', 'track-jacket.jpg', 100),(24, 'Tonal Knit Co-ord Set', 2799, 3699, 24, 'Sets', 'Co-ord', 'S', 'Cream', 'Women', 0.0, 0, 'AuraWear', 'knit-coord.jpg', 100),(25, 'Techno Weave Wristwatch', 4499, 5999, 25, 'Accessories', 'Watch', 'Free', 'Matte Black', 'Unisex', 0.0, 0, 'AuraWear', 'tech-watch.jpg', 100),(26, 'Minimal Knit Polo', 1099, 1499, 26, 'Tops', 'Polo', 'M', 'Ash Grey', 'Men', 0.0, 0, 'AuraWear', 'knit-polo.jpg', 100),(27, 'Linen Blend Overshirt', 1699, 2299, 26, 'Tops', 'Overshirt', 'L', 'Oatmeal', 'Men', 0.0, 0, 'AuraWear', 'linen-overshirt.jpg', 100),(28, 'Waterproof Commuter Pant', 2199, 2899, 24, 'Bottoms', 'Pants', 'M', 'Black', 'Men', 0.0, 0, 'AuraWear', 'commuter-pant.jpg', 100),(29, 'Technical Windbreaker', 2699, 3499, 22, 'Outerwear', 'Windbreaker', 'M', 'Signal Red', 'Unisex', 0.0, 0, 'AuraWear', 'tech-windbreaker.jpg', 100),(30, 'Oversized Boxy Tee', 999, 1399, 28, 'Tops', 'Tee', 'XL', 'Faded Black', 'Men', 0.0, 0, 'AuraWear', 'boxy-tee.jpg', 100),(31, 'Thermal Base Layer Mock', 1299, 1699, 23, 'Tops', 'Long Sleeve', 'S', 'Taupe', 'Women', 0.0, 0, 'AuraWear', 'base-mock.jpg', 100),(32, 'Modular Shell Pant', 2399, 3099, 22, 'Bottoms', 'Pants', 'L', 'Charcoal', 'Men', 0.0, 0, 'AuraWear', 'shell-pant.jpg', 100),(33, 'Technical Mesh Slide', 1099, 1499, 26, 'Footwear', 'Slide', 'UK6', 'Pearl White', 'Women', 0.0, 0, 'AuraWear', 'mesh-slide.jpg', 100),(34, 'Lightweight Ribbed Beanie', 599, 799, 25, 'Accessories', 'Beanie', 'Free', 'Rust', 'Unisex', 0.0, 0, 'AuraWear', 'ribbed-beanie.jpg', 100),(35, 'Curated Studio Co-ord', 2999, 3999, 25, 'Sets', 'Co-ord', 'M', 'Sage', 'Women', 0.0, 0, 'AuraWear', 'studio-coord.jpg', 100),(36, 'Structured Knit Short', 1299, 1699, 23, 'Bottoms', 'Short', 'M', 'Off-White', 'Unisex', 0.0, 0, 'AuraWear', 'knit-short.jpg', 100),(37, 'Technical Trench Coat', 5499, 6999, 21, 'Outerwear', 'Coat', 'L', 'Olive', 'Women', 0.0, 0, 'AuraWear', 'trench-coat.jpg', 100),(38, 'Aura Leather Duffel', 4999, 6499, 23, 'Accessories', 'Bag', 'Free', 'Obsidian', 'Unisex', 0.0, 0, 'AuraWear', 'leather-duffel.jpg', 100),(39, 'Technical Run Sneaker', 3199, 3999, 20, 'Footwear', 'Sneaker', 'UK9', 'Charcoal', 'Men', 0.0, 0, 'AuraWear', 'run-sneaker.jpg', 100),(40, 'Relaxed Linen Short', 999, 1399, 28, 'Bottoms', 'Short', 'M', 'Black', 'Unisex', 0.0, 0, 'AuraWear', 'linen-short.jpg', 100),(41, 'Pique Technical Polo', 899, 1199, 25, 'Tops', 'Polo', 'S', 'White', 'Men', 0.0, 0, 'AuraWear', 'pique-polo.jpg', 100),(42, 'High-Neck Technical Fleece', 2799, 3699, 24, 'Outerwear', 'Fleece', 'L', 'Sand', 'Men', 0.0, 0, 'AuraWear', 'tech-fleece.jpg', 100),(43, 'Modular Sling Bag', 1399, 1899, 26, 'Accessories', 'Bag', 'Free', 'Grey', 'Unisex', 0.0, 0, 'AuraWear', 'sling-bag.jpg', 100),(44, 'Technical Leather Belt', 1199, 1599, 25, 'Accessories', 'Belt', 'Free', 'Black', 'Men', 0.0, 0, 'AuraWear', 'tech-belt.jpg', 100),(45, 'Chunky Platform Derby', 3699, 4799, 22, 'Footwear', 'Derby', 'UK8', 'Matte Black', 'Men', 0.0, 0, 'AuraWear', 'platform-derby.jpg', 100),(46, 'Structured Knit Hoodie', 2899, 3799, 23, 'Tops', 'Hoodie', 'S', 'Lilac', 'Women', 0.0, 0, 'AuraWear', 'knit-hoodie.jpg', 100),(47, 'Waterproof Shell Mitten', 899, 1199, 25, 'Accessories', 'Glove', 'Free', 'Charcoal', 'Unisex', 0.0, 0, 'AuraWear', 'shell-mitten.jpg', 100),(48, 'Premium Knit Jogger', 1799, 2399, 25, 'Bottoms', 'Jogger', 'S', 'Oatmeal', 'Women', 0.0, 0, 'AuraWear', 'knit-jogger.jpg', 100),(49, 'Urban Trail Pant', 1999, 2599, 23, 'Bottoms', 'Pants', 'M', 'Olive', 'Men', 0.0, 0, 'AuraWear', 'trail-pant.jpg', 100),(50, 'Tech Weave Overshirt', 1899, 2499, 24, 'Tops', 'Overshirt', 'L', 'Jet Black', 'Men', 0.0, 0, 'AuraWear', 'tech-overshirt.jpg', 100);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profiles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `style_preference` varchar(50) DEFAULT NULL,
  `clothing_size` varchar(10) DEFAULT NULL,
  `fit_preference` varchar(30) DEFAULT NULL,
  `interests` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
-- [SANITIZED: Real user_profiles data removed — populate via application]
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `verified` tinyint(1) DEFAULT '0',
  `role` varchar(50) DEFAULT 'customer',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
-- [SANITIZED: Real users data removed — populate via application]
-- [SANITIZED: Admin role assignment removed — set via admin panel or direct DB update]
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_email` varchar(100) DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
-- [SANITIZED: Real wishlist data removed — populate via application]
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_settings`
--

DROP TABLE IF EXISTS `shop_settings`;
CREATE TABLE `shop_settings` (
  `setting_key` varchar(50) NOT NULL,
  `setting_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `shop_settings` WRITE;
INSERT INTO `shop_settings` VALUES ('free_shipping_threshold','999'),('shipping_charge','99');
UNLOCK TABLES;


--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT NOT NULL,
  `user_email` VARCHAR(255) NOT NULL,
  `rating` INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  `review_text` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `unique_review` (`product_id`, `user_email`),
  FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- [SANITIZED: GTID/binlog info removed]
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-28  8:28:40
