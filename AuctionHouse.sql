CREATE DATABASE IF NOT EXISTS `AuctionHouse` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `AuctionHouse`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE IF NOT EXISTS `Users` (
  `username` varchar(50) PRIMARY KEY,
  `password` varchar(50),
  `employeeId` int
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Auction` (
	`auctionId` int,
    `itemId` int,
    `itemName` varchar(50),
    `minPrice` float,
    `initialPrice` float,
    `bidIncrement` float,
    `closeDateTime` datetime,
    PRIMARY KEY(`auctionId`, `itemId`),
    FOREIGN KEY(`itemId`) references `Electronics`(`itemId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Electronics` (
	`itemId` int PRIMARY KEY,
	`serialNumber` int,
    `brand`  varchar(50),
    `model` varchar(50),
    `year` int,
    `powerSupply` varchar(50),
    `cpu`  varchar(50),
    `gpu`  varchar(50),
    `ram`  varchar(50),
    `screenSize` float,
    `touchScreen` bool,
    `camera`  varchar(50),
    `storage` int,
    `chip`  varchar(50),
    `type` varchar(50)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Sells` (
	`username` varchar(50),
    `auctionId` int,
    PRIMARY KEY(`username`, `auctionId`),
    FOREIGN KEY(`username`) references `Users`(`username`) ON DELETE CASCADE,
    FOREIGN KEY(`auctionId`) references `Auction`(`auctionId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Bids` (
	`amount` float,
    `upperLimit` float,
    `increment` float,
    `username` varchar(50),
    `auctionId` int,
    `bidId` int PRIMARY KEY,
    FOREIGN KEY(`username`) references `Users`(`username`) ON DELETE CASCADE,
    FOREIGN KEY(`auctionId`) references `Auction`(`auctionId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Buys` (
    `username` varchar(50),
    `auctionId` int,
    `price` float,
    PRIMARY KEY(`username`, `auctionId`),
    FOREIGN KEY(`username`) references `Users`(`username`) ON DELETE CASCADE,
    FOREIGN KEY(`auctionId`) references `Auction`(`auctionId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Alerts` (
	`alertId` int PRIMARY KEY,
    `username` varchar(50),
    `alert` varchar(200),
    `dateTime` datetime,
    FOREIGN KEY(`username`) references `Users`(`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Posts` (
    `postId` int PRIMARY KEY,
    `username` varchar(50),
    `employee` varchar(50),
    `question` varchar(200),
    `answer` varchar(200),
    FOREIGN KEY(`username`) references `Users`(`username`) ON DELETE CASCADE,
	FOREIGN KEY(`employee`) references `Users`(`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Interested` (
    `username` varchar(50),
    `itemId` int,
    PRIMARY KEY(`username`, `itemId`),
    FOREIGN KEY(`username`) references `Users`(`username`) ON DELETE CASCADE,
	FOREIGN KEY(`itemId`) references `Electronics`(`itemId`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT IGNORE INTO `Users` (`username`, `password`) VALUES ('admin', 'admin');
INSERT IGNORE INTO `Users` (`username`,`password`, `employeeId`) VALUES ('salerep1', '123', '1');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;