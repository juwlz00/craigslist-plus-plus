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
  CHECK (`totalPaid`>=0.0),
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
  CHECK (`price`>=0.0),
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

-- check constraint for "price" attribute in item table
delimiter //
CREATE TRIGGER `craigslist`.`price_insert_check`
BEFORE INSERT ON `craigslist`.`item`
FOR EACH ROW
	IF NEW.price < 0.0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Price has to be positive.';
	END IF;
//

delimiter //
CREATE TRIGGER `craigslist`.`price_update_check`
BEFORE UPDATE ON `craigslist`.`item`
FOR EACH ROW
	IF NEW.price < 0.0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Price has to be positive.';
	END IF;
//

-- check constraint for "totalPaid" attribute in order table
delimiter //
CREATE TRIGGER `craigslist`.`totalPaid_insert_check`
BEFORE INSERT ON `craigslist`.`order`
FOR EACH ROW
	IF NEW.totalPaid < 0.0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Total paid has to be positive.';
	END IF;
//

-- check sold item is not updated
delimiter //
CREATE TRIGGER `craigslist`.`item_sold_update_check`
BEFORE UPDATE ON `craigslist`.`item`
FOR EACH ROW
	IF OLD.orderId IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Item is sold.';
	END IF;
//

-- check sold item is not deleted
delimiter //
CREATE TRIGGER `craigslist`.`item_sold_delete_check`
BEFORE DELETE ON `craigslist`.`item`
FOR EACH ROW
	IF OLD.orderId IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Item is sold.';
	END IF;
//

delimiter //
CREATE TRIGGER `craigslist`.`totalPaid_update_check`
BEFORE UPDATE ON `craigslist`.`order`
FOR EACH ROW
	IF NEW.totalPaid < 0.0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Total paid has to be positive.';
	END IF;
//

delimiter //
CREATE PROCEDURE `craigslist`.`insert_data`()
BEGIN

	INSERT INTO `craigslist`.`buyer` (userId, password)  VALUES ('Billy', 'pass');
	INSERT INTO `craigslist`.`buyer` (userId, password)  VALUES ('Bob', 'pass');
	INSERT INTO `craigslist`.`buyer` (userId, password)  VALUES ('Bradly', 'pass');
	INSERT INTO `craigslist`.`buyer` (userId, password)  VALUES ('Bessy', 'pass');
	INSERT INTO `craigslist`.`buyer` (userId, password)  VALUES ('Butch', 'pass');
	INSERT INTO `craigslist`.`buyer` (userId, password)  VALUES ('Becky', 'pass');

	INSERT INTO `craigslist`.`seller` (userId, password)  VALUES ('Sally', 'pass');
	INSERT INTO `craigslist`.`seller` (userId, password)  VALUES ('Sam', 'pass');
	INSERT INTO `craigslist`.`seller` (userId, password)  VALUES ('Sandy', 'pass');
	INSERT INTO `craigslist`.`seller` (userId, password)  VALUES ('Sophie', 'pass');
	INSERT INTO `craigslist`.`seller` (userId, password)  VALUES ('Seth', 'pass');

	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('11123', 'AppleUSB-C cable', 'Electronics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('78921', 'Screen Protector', 'Electronics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('11124', 'iPhone 4', 'Electronics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('18859', 'Apple7 Ringed Binder', 'Utilities');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('18860', '7Pack of Red Pens', 'Utilities');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('35556', 'Mens Nike Roshes', 'LifeStyle');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('15759', 'Red Beenie', 'LifeStyle');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('52032', 'Insanly Large Hammer', 'Home Hardware');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('23568', 'Garden Hose', 'Home Hardware');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('25687', 'Baby gate', 'Home Hardware');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30000', 'BBQ grill', 'Food');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30001', 'Hot Dog', 'Food');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30002', 'Sushi', 'Food');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30003', 'Car spoiler', 'Automobile');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30004', 'Car tire caps', 'Automobile');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30005', '1995 Engine', 'Automobile');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30006', 'Hair curler', 'Cosmetics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30007', 'Shower Gel', 'Cosmetics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30008', 'Used Tooth Brush', 'Cosmetics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30009', 'Hair Gel', 'Cosmetics');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30010', 'Lazer Gaming Mouse', 'Gaming');
	INSERT INTO `craigslist`.`product` (productId, name, category)  VALUES ('30020', 'BB Gun', 'Gaming');

	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100000', 'Billy', '2017-02-02', '8.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100001', 'Billy', '2017-02-02', '120.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100014', 'Billy', '2017-02-02', '10.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100016', 'Billy', '2017-02-02', '150.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100002', 'Billy', '2017-02-02', '5.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100003', 'Bradly', '2017-02-02', '12.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100004', 'Bradly', '2017-02-02', '10.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100005', 'Bradly', '2017-02-02', '120.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100019', 'Bradly', '2017-02-02', '152.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100006', 'Bob', '2017-02-02', '5.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100007', 'Bob', '2017-02-02', '20.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100008', 'Bob', '2017-02-02', '40.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100009', 'Bessy', '2017-02-02', '200.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100010', 'Bessy', '2017-02-02', '50.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100015', 'Bessy', '2017-02-02', '70.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100011', 'Butch', '2017-02-02', '6.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100012', 'Butch', '2017-02-02', '9.44');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100013', 'Butch', '2017-02-02', '86.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100017', 'Becky', '2017-02-02', '6.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100018', 'Becky', '2017-02-02', '135.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100020', 'Becky', '2017-02-02', '164.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100021', 'Becky', '2017-02-02', '141.99');

	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('18800', '30010', 'Seth', '100017', 'you should really buy this product', 'Used', 24.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43636', '30006', 'Sandy', '100009', 'new in box', 'Used', 162.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('58803', '30005', 'Sandy', '100015', 'slightly cracked but still runs', 'Used', 182.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('68319', '78921', 'Sally', '100012', 'havent even touched it', 'Used', 139.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('88694', '30008', 'Sally', '100006', 'havent even touched it', 'Bad', 184.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('16939', '30007', 'Sandy', '100014', 'this product is the best product ever', 'Good', 99.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('30421', '30008', 'Sam', '100003', '8/10 i just want to get rid of this product', 'Used', 49.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('12321', '30009', 'Sophie', '100011', 'very studry and classic looking', 'New', 79.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('73424', '18860', 'Sophie', '100004', 'you really need this in your home', 'Good', 31.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('42073', '30002', 'Seth', '100014', 'used a couple of times but clean', 'Good', 44.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('91560', '30008', 'Sally', '100003', 'dirty but sturdy', 'Used', 109.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('56899', '30010', 'Sam', '100003', 'this product is the best product ever', 'Used', 89.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('68193', '78921', 'Sophie', '100017', 'a little cracked on the side', 'Good', 160.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('88463', '30006', 'Sally', '100020', 'has a small hole', 'Used', 82.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('66710', '30010', 'Sam', '100010', 'cheap stuff for sale as well! come check out my other stuff', 'New', 183.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('42638', '30000', 'Sam', '100000', '8/10 i just want to get rid of this product', 'New', 158.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('68539', '30009', 'Sophie', '100019', 'one of my most valued properties', 'Good', 126.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('75416', '15759', 'Sam', '100005', 'hardly used still have the box', 'Used', 137.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('29383', '30003', 'Sophie', '100018', 'you should really buy this product', 'Bad', 72.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('74923', '18860', 'Sam', '100003', 'hardly used still have the box', 'Good', 17.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('35299', '11123', 'Seth', '100019', 'insane deal this is new and so cheap!', 'Used', 195.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('85586', '35556', 'Sally', '100018', 'good deal! and good product', 'Bad', 105.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('62421', '30006', 'Sally', '100007', 'brand new in box', 'Used', 128.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('39230', '30020', 'Sam', '100016', 'brand new in box', 'Bad', 25.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('73501', '30009', 'Sandy', '100012', 'good deal! and good product', 'Bad', 50.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('23770', '30003', 'Sandy', '100003', '10 out of 10 you need to buy', 'New', 17.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('46780', '30010', 'Sandy', '100004', 'i wonder if anyone will buy this', 'Used', 195.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('70662', '30020', 'Seth', '100011', '10 out of 10 you need to buy', 'Bad', 81.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('82620', '30006', 'Sophie', '100010', 'you should really buy this product', 'Good', 149.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43524', '30003', 'Sam', '100000', 'one of my most valued properties', 'Good', 31.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('32750', '18859', 'Sophie', '100004', 'a little ruffled up', 'Good', 41.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('39513', '18860', 'Seth', '100007', 'a little ruffled up', 'Used', 122.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15411', '30008', 'Sophie', '100011', 'sturdy rings', 'Good', 86.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15783', '52032', 'Sophie', '100002', 'new in box', 'Good', 140.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('47816', '30000', 'Sandy', '100014', 'doesnt work, sell for parts', 'Bad', 61.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('34468', '30008', 'Sally', '100011', 'one of my most valued properties', 'New', 46.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43771', '30007', 'Sally', '100009', 'this product is the best product ever', 'New', 46.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('95774', '15759', 'Sandy', '100018', 'slightly cracked but still runs', 'New', 100.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('32403', '11123', 'Sam', '100008', 'slightly worn with dirt', 'Good', 130.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('95390', '15759', 'Sally', '100019', '8/10 i just want to get rid of this product', 'New', 65.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('85942', '18859', 'Seth', '100016', 'i need to make some money please buy', 'Bad', 67.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43444', '11123', 'Seth', '100016', 'colourful and bright', 'Bad', 117.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('94609', '30020', 'Sophie', '100017', 'a little cracked on the side', 'Used', 28.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('79974', '35556', 'Sandy', '100002', 'slightly worn with dirt', 'Good', 127.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('76762', '30020', 'Sally', '100004', 'new in box', 'Used', 149.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('63167', '30009', 'Seth', '100002', 'you should really buy this product', 'Good', 157.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('94978', '30007', 'Sam', '100008', 'brand new in box', 'New', 200.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('10994', '30002', 'Sandy', '100001', 'slightly worn with dirt', 'Good', 20.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('90255', '30000', 'Seth', '100005', 'never used', 'Used', 24.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('97423', '23568', 'Sam', '100021', 'this product is the best product ever', 'New', 108.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('35992', '30003', 'Sandy', '100016', 'dirty but sturdy', 'Used', 47.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('81353', '30009', 'Sam', '100008', 'needs some cleaning but its very good!', 'Bad', 23.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('27654', '30006', 'Sophie', '100005', 'brand new in box', 'Used', 81.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('84067', '18859', 'Sally', '100007', 'never used', 'Good', 89.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('33050', '30001', 'Sandy', '100020', 'slightly cracked but still runs', 'New', 28.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('87269', '15759', 'Sally', '100006', 'has a small hole', 'Good', 44.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('54792', '30009', 'Sam', '100019', 'i need to get rid of this product help', 'Used', 171.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('88623', '30010', 'Sam', '100010', 'insane deal this is new and so cheap!', 'New', 62.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('35311', '78921', 'Sophie', '100004', 'havent even touched it', 'Used', 46.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('71927', '23568', 'Seth', '100013', 'i cant think of a description', 'Used', 176.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('11346', '25687', 'Seth', '100018', 'i need to get rid of this product help', 'Used', 36.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('68270', '15759', 'Sophie', '100019', 'you really need this in your home', 'Used', 51.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('77723', '30001', 'Sophie', '100000', 'a little ruffled up', 'Used', 191.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('82774', '25687', 'Sandy', '100000', 'never used', 'Used', 74.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('46244', '30001', 'Sophie', '100016', '8/10 i just want to get rid of this product', 'Used', 190.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('17122', '15759', 'Seth', '100021', 'never used', 'Bad', 156.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('87888', '30001', 'Sam', '100010', 'colourful and bright', 'Good', 93.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('19922', '18860', 'Sophie', '100011', 'has a small hole', 'New', 111.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('18490', '11124', 'Sophie', '100007', 'colourful and bright', 'Good', 135.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('91343', '11123', 'Sandy', '100014', 'you should really buy this product', 'Good', 65.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('67226', '30001', 'Sophie', '100001', 'slightly worn with dirt', 'Used', 125.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('24156', '23568', 'Sophie', '100003', 'used a couple of times but clean', 'Used', 28.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('83312', '11124', 'Sophie', '100011', 'a little ruffled up', 'Used', 43.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('46846', '30000', 'Sophie', '100010', 'worn for 2 days hardly used', 'Bad', 64.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('73065', '78921', 'Sam', '100000', 'super duper worth, come buy', 'New', 108.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('36082', '15759', 'Sally', '100012', 'cheap stuff for sale as well! come check out my other stuff', 'Good', 154.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('83770', '25687', 'Sophie', '100018', 'colourful and bright', 'Bad', 85.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('11399', '30000', 'Sally', '100006', 'colourful and bright', 'New', 143.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('92183', '30007', 'Sally', '100016', '8/10 i just want to get rid of this product', 'Bad', 27.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('92418', '30008', 'Sandy', '100021', 'cheap stuff for sale as well! come check out my other stuff', 'Used', 141.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('88089', '30020', 'Seth', '100007', 'brand new in box', 'Good', 169.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15875', '23568', 'Sam', '100008', 'very studry and classic looking', 'Used', 120.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('87560', '11123', 'Seth', '100013', 'a little cracked on the side', 'Good', 62.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('80841', '18859', 'Seth', '100013', 'never used', 'Bad', 88.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('71267', '30005', 'Sandy', '100001', 'havent even touched it', 'Good', 167.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('63746', '30007', 'Sandy', '100016', 'hardly used still have the box', 'Used', 156.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15675', '30006', 'Sophie', '100007', 'slightly cracked but still runs', 'New', 109.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('60179', '18860', 'Seth', '100014', '8/10 i just want to get rid of this product', 'New', 73.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('94699', '18859', 'Sam', '100001', 'very studry and classic looking', 'Bad', 128.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('24784', '30007', 'Seth', '100009', 'dirty but sturdy', 'Good', 184.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('44748', '30009', 'Sally', '100015', 'hardly used still have the box', 'Bad', 100.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('87392', '30004', 'Sam', '100009', 'dirty but sturdy', 'New', 138.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('14164', '35556', 'Seth', '100017', 'used a couple of times but clean', 'Good', 41.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('64099', '18860', 'Sophie', '100019', 'clean and clear', 'Good', 64.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('19138', '30010', 'Seth', '100016', '10 out of 10 you need to buy', 'Bad', 147.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('81604', '30006', 'Sam', '100009', 'has a small hole', 'New', 155.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('36776', '30001', 'Sally', '100000', 'colourful and bright', 'New', 165.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('22131', '35556', 'Sandy', '100014', 'new in box', 'Used', 35.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('23986', '25687', 'Sam', '100019', 'i need to get rid of this product help', 'Good', 117.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('98500', '30020', 'Seth', '100005', 'sturdy rings', 'Used', 153.99);


	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('111', '100000', '602582', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('222', '100001', '632535', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('333', '100002', '643534', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('444', '100003', '987967', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('555', '100004', '688769', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('666', '100005', '962582', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('777', '100006', '462582', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('888', '100007', '602882', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('999', '100008', '634682', 'MasterCard');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('121', '100009', '522582', 'American Express');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('131', '100010', '725782', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('141', '100011', '925682', 'American Express');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('151', '100012', '824482', 'American Express');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('161', '100013', '825482', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('171', '100014', '608254', 'American Express');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('181', '100015', '654292', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('191', '100016', '124434', 'American Express');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('221', '100017', '754666', 'American Express');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('231', '100018', '854265', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('241', '100019', '854251', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('251', '100020', '854265', 'Visa');
	INSERT INTO `craigslist`.`payment` (paymentId, orderId, cardNumber, cardType) VALUES('261', '100021', '124322', 'Visa');

	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('0000', 'Bradly', 'Sally', '5', 'trustworthy person');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1111', 'Becky', 'Sally', '5', 'would do business again');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2222', 'Billy', 'Sam', '4', 'honest person');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('3333', 'Becky', 'Sam', '4', 'really good product');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('4444', 'Butch', 'Sam', '5', 'super nice guy');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('5555', 'Billy', 'Sandy', '3', 'not a bad seller');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('6666', 'Bob', 'Sandy', '2', 'she lied about the product');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('7777', 'Bob', 'Seth', '2', 'horrible quality');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('8888', 'Bessy', 'Seth', '1', 'i felt lied to');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('9999', 'Bradly', 'Seth', '1', 'never doing business again with him');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1212', 'Becky', 'Seth', '2', 'not very honest');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1313', 'Butch', 'Sophie', '3', 'decent quality');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1414', 'Bessy', 'Sophie', '5', 'trustworthy and will do business again');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1515', 'Becky', 'Sandy', '5', 'tvery good person i would reccomend her');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1616', 'Becky', 'Sophie', '3', 'decent guy! i wasnt lied to');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1717', 'Butch', 'Sally', '2', 'not very honest, i dont like her');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1818', 'Butch', 'Seth', '1', 'horrible horrible person, dont do buisness with him');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('1919', 'Butch', 'Sandy', '2', 'one of the worst sellers');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2020', 'Billy', 'Sally', '5', 'very nice person, i enjoyed the game');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2121', 'Billy', 'Sophie', '4', 'cool person will buy again');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2626', 'Billy', 'Seth', '4', 'decent person i was not lied to');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2323', 'Bradly', 'Sandy', '2', 'she sold me a fake item');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2424', 'Bessy', 'Sandy', '5', '10/10 would do buisness again');
	INSERT INTO `craigslist`.`review` (reviewId, buyerId, sellerId, stars, description) VALUES('2525', 'Bob', 'Sophie', '1', 'she can not communicate on the item, poor product as well');

END;
//

CALL `craigslist`.`insert_data`();

-- check all orders are associated with at least one item
-- this is at the bottom so it doesn't interfere with initial insertion
delimiter //
CREATE TRIGGER `craigslist`.`order_participation_check`
BEFORE INSERT ON `craigslist`.`order`
FOR EACH ROW
	IF NOT EXISTS(SELECT itemId FROM `craigslist`.`item` i WHERE i.orderId=NEW.orderId) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Order Id is not associated with any items.';
	END IF;
//