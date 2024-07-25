-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           8.2.0 - MySQL Community Server - GPL
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour symfapp_fresh_db
CREATE DATABASE IF NOT EXISTS `symfapp_fresh_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `symfapp_fresh_db`;

-- Listage de la structure de table symfapp_fresh_db. alert
CREATE TABLE IF NOT EXISTS `alert` (
  `id` int NOT NULL AUTO_INCREMENT,
  `food_id` int NOT NULL,
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `alerted_date` datetime NOT NULL,
  `refrigerator_id` int NOT NULL,
  `recipient_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_17FD46C1BA8E87C4` (`food_id`),
  KEY `IDX_17FD46C1915EAEB` (`refrigerator_id`),
  KEY `IDX_17FD46C1E92F8F78` (`recipient_id`),
  CONSTRAINT `FK_17FD46C1915EAEB` FOREIGN KEY (`refrigerator_id`) REFERENCES `refrigerator` (`id`),
  CONSTRAINT `FK_17FD46C1BA8E87C4` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`),
  CONSTRAINT `FK_17FD46C1E92F8F78` FOREIGN KEY (`recipient_id`) REFERENCES `fresh_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de procédure symfapp_fresh_db. disableAllTokenForUser
DELIMITER //
CREATE PROCEDURE `disableAllTokenForUser`(IN `userId` INT)
BEGIN
    UPDATE email_token
    SET expire_date = NOW()
    WHERE fresh_user_id = userId
      AND expire_date > NOW();
END//
DELIMITER ;

-- Listage de la structure de table symfapp_fresh_db. email_token
CREATE TABLE IF NOT EXISTS `email_token` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fresh_user_id` int NOT NULL,
  `send_date` datetime NOT NULL,
  `expire_date` datetime NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_C27AE0B45F37A13B` (`token`),
  KEY `IDX_C27AE0B445196B6` (`fresh_user_id`),
  CONSTRAINT `FK_C27AE0B445196B6` FOREIGN KEY (`fresh_user_id`) REFERENCES `fresh_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de l'évènement symfapp_fresh_db. every_day_insert_alert
DELIMITER //
CREATE EVENT `every_day_insert_alert` ON SCHEDULE EVERY 1 DAY STARTS '2024-01-09 00:01:00' ON COMPLETION PRESERVE ENABLE DO BEGIN
  INSERT INTO alert (food_id, refrigerator_id, message, recipient_id)
    SELECT f.id AS food_id,
           r.id AS refrigerator_id,
           CASE
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = 1 THEN CONCAT('Il reste ', DATEDIFF(expire_date, CURRENT_DATE), ' jour pour utiliser cet aliment')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = 0 THEN 'Cet aliment expire aujourd\'hui'
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = -1 THEN CONCAT('Cet aliment est périmé depuis ', ABS(DATEDIFF(expire_date, CURRENT_DATE)), ' jour')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) < -1 THEN CONCAT('Cet aliment est périmé depuis ', ABS(DATEDIFF(expire_date, CURRENT_DATE)), ' jours')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) < 4 THEN CONCAT('Il reste ', DATEDIFF(expire_date, CURRENT_DATE), ' jours pour utiliser cet aliment')
           END AS message,
           r.owner_id as owner_id
    FROM food f INNER JOIN refrigerator r ON f.refrigerator_id = r.id
    WHERE DATEDIFF(expire_date, CURRENT_DATE) < 4;
END//
DELIMITER ;

-- Listage de la structure de table symfapp_fresh_db. food
CREATE TABLE IF NOT EXISTS `food` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refrigerator_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `adding_date` datetime DEFAULT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_D43829F7915EAEB` (`refrigerator_id`),
  CONSTRAINT `FK_D43829F7915EAEB` FOREIGN KEY (`refrigerator_id`) REFERENCES `refrigerator` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table symfapp_fresh_db. food_recipe_in_refrigerator
CREATE TABLE IF NOT EXISTS `food_recipe_in_refrigerator` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refrigerator_id` int NOT NULL,
  `food_id` int NOT NULL,
  `quantity` int NOT NULL,
  `recipe_id` int NOT NULL,
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_22D2F3CD59D8A214` (`recipe_id`),
  KEY `IDX_22D2F3CD915EAEB` (`refrigerator_id`),
  KEY `IDX_22D2F3CDBA8E87C4` (`food_id`),
  CONSTRAINT `FK_22D2F3CD59D8A214` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`),
  CONSTRAINT `FK_22D2F3CD915EAEB` FOREIGN KEY (`refrigerator_id`) REFERENCES `refrigerator` (`id`),
  CONSTRAINT `FK_22D2F3CDBA8E87C4` FOREIGN KEY (`food_id`) REFERENCES `food` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table symfapp_fresh_db. food_recipe_not_in_refrigerator
CREATE TABLE IF NOT EXISTS `food_recipe_not_in_refrigerator` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `can_be_regroup` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_B0D4BE2259D8A214` (`recipe_id`),
  CONSTRAINT `FK_B0D4BE2259D8A214` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table symfapp_fresh_db. fresh_user
CREATE TABLE IF NOT EXISTS `fresh_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `roles` json NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `register_date` datetime DEFAULT NULL,
  `last_connection` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_569E4F03E7927C74` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de procédure symfapp_fresh_db. genereAlertForUser
DELIMITER //
CREATE PROCEDURE `genereAlertForUser`(IN userId INT)
BEGIN
   INSERT INTO alert (food_id, refrigerator_id, message, recipient_id)
   SELECT f.id AS food_id,
           r.id AS refrigerator_id,
           CASE
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = 1 THEN CONCAT('Il reste ', DATEDIFF(expire_date, CURRENT_DATE), ' jour pour utiliser cet aliment')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = 0 THEN 'Cet aliment expire aujourd\'hui'
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = -1 THEN CONCAT('Cet aliment est périmé depuis ', ABS(DATEDIFF(expire_date, CURRENT_DATE)), ' jour')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) < -1 THEN CONCAT('Cet aliment est périmé depuis ', ABS(DATEDIFF(expire_date, CURRENT_DATE)), ' jours')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) < 4 THEN CONCAT('Il reste ', DATEDIFF(expire_date, CURRENT_DATE), ' jours pour utiliser cet aliment')
           END AS message,
           r.owner_id as recipient_id
   FROM food f INNER JOIN refrigerator r ON f.refrigerator_id = r.id
   WHERE DATEDIFF(expire_date, CURRENT_DATE) < 4 AND r.owner_id = userId;
END//
DELIMITER ;

-- Listage de la structure de procédure symfapp_fresh_db. getFoodAlreadyExistForUser
DELIMITER //
CREATE PROCEDURE `getFoodAlreadyExistForUser`(
	IN `foodName` VARCHAR(255),
	IN `expireDate` DATETIME,
	IN `userId` INT
)
    SQL SECURITY INVOKER
BEGIN
    DECLARE foodCount INT;

    -- Compter le nombre d'aliments avec le même nom et la même date d'expiration pour l'utilisateur donné
    SELECT COUNT(*) INTO foodCount
    FROM food f
    INNER JOIN refrigerator r ON f.refrigerator_id = r.id
    WHERE r.owner_id = userId AND f.name LIKE CONCAT('%', foodName, '%') AND f.expire_date = expireDate;

    -- Si au moins un aliment existe, afficher la liste des aliments
    IF foodCount > 0 THEN
        SELECT f.id, f.name, f.quantity, f.adding_date, f.expire_date
        FROM food f
        INNER JOIN refrigerator r ON f.refrigerator_id = r.id
        WHERE r.owner_id = userId AND f.name LIKE CONCAT('%', foodName, '%') AND f.expire_date = expireDate;
    ELSE
        SELECT 0;
    END IF;
END//
DELIMITER ;

-- Listage de la structure de procédure symfapp_fresh_db. getLastTokenForUser
DELIMITER //
CREATE PROCEDURE `getLastTokenForUser`(IN `userId` INT)
    SQL SECURITY INVOKER
BEGIN
    SELECT *
    FROM email_token
    WHERE fresh_user_id = userId
      AND expire_date >= NOW()
    ORDER BY expire_date ASC
    LIMIT 1;
END//
DELIMITER ;

-- Listage de la structure de procédure symfapp_fresh_db. getTodayAlertForUser
DELIMITER //
CREATE PROCEDURE `getTodayAlertForUser`(
	IN `recipientId` INT
)
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
SELECT a.id AS alert_id, a.food_id
FROM alert a
WHERE DATEDIFF(a.alerted_date, CURRENT_DATE) = 0
  AND a.recipient_id = recipientId
  AND (a.food_id, a.alerted_date) IN (
    SELECT a.food_id, MAX(a.alerted_date) AS max_date
    FROM alert a
    WHERE DATEDIFF(a.alerted_date, CURRENT_DATE) = 0
      AND a.recipient_id = recipientId
    GROUP BY a.food_id
  );

END//
DELIMITER ;

-- Listage de la structure de fonction symfapp_fresh_db. isTokenValid
DELIMITER //
CREATE FUNCTION `isTokenValid`(
	`tokenParam` VARCHAR(255)
) RETURNS tinyint
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
DECLARE expirationDate TIMESTAMP;

-- Récupérer la date d'expiration du token
SELECT expire_date INTO expirationDate
FROM email_token
WHERE token = tokenParam COLLATE utf8mb4_unicode_ci
LIMIT 1;

RETURN expirationDate IS NOT NULL AND expirationDate > NOW();
END//
DELIMITER ;

-- Listage de la structure de table symfapp_fresh_db. messenger_messages
CREATE TABLE IF NOT EXISTS `messenger_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue_name` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `available_at` datetime NOT NULL COMMENT '(DC2Type:datetime_immutable)',
  `delivered_at` datetime DEFAULT NULL COMMENT '(DC2Type:datetime_immutable)',
  PRIMARY KEY (`id`),
  KEY `IDX_75EA56E0FB7336F0` (`queue_name`),
  KEY `IDX_75EA56E0E3BD61CE` (`available_at`),
  KEY `IDX_75EA56E016BA31DB` (`delivered_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table symfapp_fresh_db. recipe
CREATE TABLE IF NOT EXISTS `recipe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` datetime NOT NULL,
  `last_cooking_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_DA88B1377E3C61F9` (`owner_id`),
  CONSTRAINT `FK_DA88B1377E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `fresh_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de table symfapp_fresh_db. refrigerator
CREATE TABLE IF NOT EXISTS `refrigerator` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `adding_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_4619AF357E3C61F9` (`owner_id`),
  CONSTRAINT `FK_4619AF357E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `fresh_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Les données exportées n'étaient pas sélectionnées.

-- Listage de la structure de déclencheur symfapp_fresh_db. after_insert_food
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `after_insert_food` AFTER INSERT ON `food` FOR EACH ROW BEGIN
	INSERT INTO alert (food_id, refrigerator_id, message, recipient_id)
   SELECT f.id AS food_id,
           r.id AS refrigerator_id,
           CASE
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = 1 THEN CONCAT('Il reste ', DATEDIFF(expire_date, CURRENT_DATE), ' jour pour utiliser cet aliment')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = 0 THEN 'Cet aliment expire aujourd\'hui'
             WHEN DATEDIFF(expire_date, CURRENT_DATE) = -1 THEN CONCAT('Cet aliment est périmé depuis ', ABS(DATEDIFF(expire_date, CURRENT_DATE)), ' jour')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) < -1 THEN CONCAT('Cet aliment est périmé depuis ', ABS(DATEDIFF(expire_date, CURRENT_DATE)), ' jours')
             WHEN DATEDIFF(expire_date, CURRENT_DATE) < 4 THEN CONCAT('Il reste ', DATEDIFF(expire_date, CURRENT_DATE), ' jours pour utiliser cet aliment')
           END AS message,
           r.owner_id as owner_id
   FROM food f INNER JOIN refrigerator r ON f.refrigerator_id = r.id
   WHERE DATEDIFF(expire_date, CURRENT_DATE) < 4 AND f.id = NEW.id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Listage de la structure de déclencheur symfapp_fresh_db. before_insert_alert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_alert` BEFORE INSERT ON `alert` FOR EACH ROW BEGIN
	SET NEW.alerted_date = NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Listage de la structure de déclencheur symfapp_fresh_db. before_insert_email_token
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_email_token` BEFORE INSERT ON `email_token` FOR EACH ROW BEGIN
    SET NEW.send_date = NOW();
    SET NEW.expire_date = NEW.send_date + INTERVAL 3 HOUR;
    SET NEW.token = MD5(CONCAT(NEW.send_date, RAND()));
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Listage de la structure de déclencheur symfapp_fresh_db. before_insert_food
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_food` BEFORE INSERT ON `food` FOR EACH ROW BEGIN
	SET NEW.adding_date = NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Listage de la structure de déclencheur symfapp_fresh_db. before_insert_fresh_user
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_fresh_user` BEFORE INSERT ON `fresh_user` FOR EACH ROW BEGIN
    SET NEW.register_date = NOW();
    SET NEW.last_connection = NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Listage de la structure de déclencheur symfapp_fresh_db. before_insert_refrigerator
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `before_insert_refrigerator` BEFORE INSERT ON `refrigerator` FOR EACH ROW BEGIN
	SET NEW.adding_date = NOW();
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
