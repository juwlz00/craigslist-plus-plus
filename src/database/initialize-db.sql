CREATE DATABASE `craigslist`;

CREATE TABLE `craigslist`.`buyer` (
  `userId` VARCHAR(20),
  `password` VARCHAR(6),
  PRIMARY KEY (`userId`));

CREATE TABLE `craigslist`.`seller` (
  `userId` VARCHAR(20),
  `password` VARCHAR(6),
  PRIMARY KEY (`userId`));

CREATE TABLE `craigslist`.`product` (
  `productId` VARCHAR(20),
  `name` VARCHAR(20),
  `category` VARCHAR(20),
  PRIMARY KEY (`productId`));

CREATE TABLE `craigslist`.`review` (
  `reviewId` VARCHAR(20),
  `buyerId` VARCHAR(20) NOT NULL,
  `sellerId` VARCHAR(20) NOT NULL,
  `stars` INT,
  `description` VARCHAR(100),
  PRIMARY KEY (`reviewId`),
  FOREIGN KEY (`buyerId`) REFERENCES `craigslist`.`buyer`(`userId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`sellerId`) REFERENCES `craigslist`.`seller`(`userId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE TABLE `craigslist`.`order`  (
  `orderId` VARCHAR(20),
  `totalPaid` FLOAT,
  `date` DATE,
  `buyerId` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`orderId`),
  FOREIGN KEY (`buyerId`) REFERENCES `craigslist`.`buyer`(`userId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE TABLE `craigslist`.`payment` (
  `paymentId` VARCHAR(20),
  `cardNumber` VARCHAR(20),
  `cardType` VARCHAR(20),
  `orderId` VARCHAR(20) NOT NULL UNIQUE,
  PRIMARY KEY (`paymentId`),
  FOREIGN KEY (`orderId`) REFERENCES `craigslist`.`order`(`orderId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE);

CREATE TABLE `craigslist`.`item`  (
  `itemId` VARCHAR(20),
  `productId` VARCHAR(20) NOT NULL,
  `sellerId` VARCHAR(20) NOT NULL,
  `orderId` VARCHAR(20),
  `description` VARCHAR(100),
  `condition` VARCHAR(20),
  `price` FLOAT,
  PRIMARY KEY (`itemId`),
  FOREIGN KEY (`productId`) REFERENCES `craigslist`.`product`(`productId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`sellerId`) REFERENCES `craigslist`.`seller`(`userId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (`orderId`) REFERENCES `craigslist`.`order`(`orderId`)
  ON DELETE CASCADE
  ON UPDATE CASCADE);
