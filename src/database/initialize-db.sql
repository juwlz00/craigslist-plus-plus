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
  ON DELETE SET NULL
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

delimiter //
CREATE TRIGGER `craigslist`.`totalPaid_update_check`
BEFORE UPDATE ON `craigslist`.`order`
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

	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100000', 'Billy', '2017-02-02', '186.97');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100001', 'Billy', '2017-01-14', '582.93');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100014', 'Billy', '2017-03-14', '862.94');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100016', 'Billy', '2017-03-23', '479.94');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100002', 'Billy', '2017-01-14', '356.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100003', 'Bradly', '2017-03-15', '233.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100004', 'Bradly', '2017-04-28', '619.94');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100005', 'Bradly', '2017-05-19', '674.39');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100019', 'Bradly', '2017-06-10', '217.97');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100006', 'Bob', '2017-05-13', '178.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100007', 'Bob', '2017-04-15', '722.9');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100008', 'Bob', '2017-06-13', '591.96');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100009', 'Bessy', '2017-06-24', '330.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100010', 'Bessy', '2017-05-28', '188.99');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100015', 'Bessy', '2017-01-25', '176.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100011', 'Butch', '2017-04-21', '397.96');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100012', 'Butch', '2017-06-24', '818.93');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100013', 'Butch', '2017-03-20', '143.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100017', 'Becky', '2017-06-21', '433.97');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100018', 'Becky', '2017-08-29', '315.98');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100020', 'Becky', '2017-03-28', '729.93');
	INSERT INTO `craigslist`.`order` (orderId, buyerId, date, totalPaid) VALUES('100021', 'Becky', '2017-01-27', '512.96');


	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('82588', '30005', 'Sally','100014', '10 out of 10 you need to buy', 'Used', 114.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('86843', '30003', 'Seth','100012', 'new in box', 'Bad', 185.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('38826', '35556', 'Sandy','100020', 'cheap stuff for sale as well! come check out my other stuff', 'Used', 188.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('76288', '30001', 'Seth','100010', 'i need to get rid of this product help', 'Used', 130.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('85008', '25687', 'Sam','100003', 'you really need this in your home', 'New', 41.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43352', '18859', 'Sophie','100000', 'havent even touched it', 'Bad', 48.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('85143', '30010', 'Sophie','100010', 'sturdy rings', 'Bad', 66.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43895', '23568', 'Sophie','100007', 'colourful and bright', 'Bad', 93.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('25263', '30002', 'Sally', null, '8/10 i just want to get rid of this product', 'Bad', 152.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('28483', '30001', 'Sally','100002', 'this product is the best product ever', 'Bad', 144.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('86340', '30002', 'Sandy','100016', 'havent even touched it', 'Good', 182.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('97807', '30008', 'Sally', null, 'very studry and classic looking', 'New', 183.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('54853', '30005', 'Seth','100002', 'very studry and classic looking', 'Bad', 66.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('62390', '52032', 'Sophie','100007', 'sturdy rings', 'Good', 49.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('70930', '11123', 'Sally','100011', 'dirty but sturdy', 'Bad', 153.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('31635', '30008', 'Sam','100010', 'dirty but sturdy', 'Used', 120.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('10068', '30000', 'Sophie','100016', 'dirty but still good', 'Good', 93.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('12488', '30008', 'Sandy', null, 'never used', 'New', 88.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('40426', '30000', 'Seth','100002', 'doesnt work, sell for parts', 'Used', 98.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('87111', '30010', 'Sophie','100010', 'sturdy rings', 'Bad', 162.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('85155', '30006', 'Sandy', null, 'you should really buy this product', 'Used', 164.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15356', '30008', 'Seth','100001', 'very studry and classic looking', 'Used', 160.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('75548', '23568', 'Sophie','100005', 'super duper worth, come buy', 'New', 142.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('28060', '30001', 'Sophie','100001', 'new in box', 'New', 20.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('39605', '11123', 'Sam','100014', 'super duper worth, come buy', 'New', 61.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('34312', '30002', 'Seth','100003', 'i need to get rid of this product help', 'Used', 156.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('17450', '30002', 'Seth','100017', 'i need to make some money please buy', 'Used', 88.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('41665', '30007', 'Sally','100010', 'a little cracked on the side', 'Bad', 46.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('89134', '30003', 'Sally','100004', 'colourful and bright', 'Bad', 163.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('63401', '25687', 'Sandy','100016', 'hardly used still have the box', 'New', 130.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('38366', '11124', 'Sam', null, 'havent even touched it', 'Good', 94.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('12634', '35556', 'Seth','100006', '8/10 i just want to get rid of this product', 'New', 77.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('31014', '11124', 'Sophie','100006', 'hardly used still have the box', 'New', 44.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('70575', '25687', 'Seth','100008', 'i need to make some money please buy', 'Used', 86.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('67720', '30003', 'Sam','100007', 'good deal! and good product', 'Used', 183.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('56414', '11124', 'Sophie','100020', 'very clean and new!', 'Good', 34.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('97585', '30003', 'Sophie','100011', 'dirty but still good', 'Bad', 105.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('81297', '30020', 'Sally','100008', 'this product is the best product ever', 'Bad', 124.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('34129', '30006', 'Sandy','100001', 'super duper worth, come buy', 'Used', 58.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('43140', '18859', 'Sally','100001', 'doesnt work, sell for parts', 'New', 160.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('84875', '23568', 'Sally','100002', '10 out of 10 you need to buy', 'Bad', 171.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('98704', '30006', 'Seth','100020', 'dirty but still good', 'New', 17.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('82748', '30005', 'Sam','100000', 'a little used but still charges', 'New', 20.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('89917', '30004', 'Sam','100020', 'you should really buy this product', 'Good', 197.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('16172', '30004', 'Seth','100018', 'i need to get rid of this product help', 'Bad', 140.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('74116', '30001', 'Seth','100003', 'one of my most valued properties', 'Used', 87.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('69956', '30003', 'Sandy','100001', '8/10 i just want to get rid of this product', 'New', 44.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('47400', '11123', 'Sam','100020', 'super duper worth, come buy', 'Good', 58.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('14664', '18859', 'Sophie','100001', 'very clean and new!', 'Used', 23.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('75956', '30010', 'Sally','100009', 'i wonder if anyone will buy this', 'Used', 70.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('22126', '18860', 'Sally','100016', 'a little used but still charges', 'Bad', 78.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('70861', '30002', 'Sam','100018', 'super duper worth, come buy', 'Bad', 100.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('60543', '23568', 'Sophie','100021', 'havent even touched it', 'New', 134.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('44055', '18859', 'Sam','100003', 'you really need this in your home', 'New', 158.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('65605', '52032', 'Sam','100016', 'sturdy rings', 'Good', 172.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('25672', '30001', 'Seth','100017', 'has a small hole', 'New', 54.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('20798', '30010', 'Sally','100002', 'dirty but still good', 'Used', 199.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15957', '30010', 'Seth','100007', 'worn for 2 days hardly used', 'Good', 25.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('50381', '30010', 'Sally','100011', 'dirty but still good', 'Good', 134.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('66330', '78921', 'Seth','100021', 'very clean and new!', 'New', 176.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('42983', '30006', 'Sally','100000', 'slightly cracked but still runs', 'Bad', 116.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('32223', '18860', 'Sandy','100007', 'new in box', 'Good', 193.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('89814', '30004', 'Sophie','100001', 'hardly used still have the box', 'Bad', 111.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('37781', '35556', 'Sally','100018', 'cheap stuff for sale as well! come check out my other stuff', 'Bad', 191.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('25935', '15759', 'Sally', null, 'a little ruffled up', 'Good', 135.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('54201', '30008', 'Sally','100008', 'worn for 2 days hardly used', 'Good', 59.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('97854', '30002', 'Seth','100016', '10 out of 10 you need to buy', 'Good', 99.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('31521', '30020', 'Sophie','100020', 'super duper worth, come buy', 'Used', 124.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('41978', '52032', 'Sophie','100011', 'slightly worn with dirt', 'New', 196.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('39012', '11123', 'Sally','100015', 'clean and clear', 'Bad', 146.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('60848', '11124', 'Sandy','100006', 'good deal! and good product', 'Good', 134.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('37436', '30004', 'Sophie','100002', '8/10 i just want to get rid of this product', 'Bad', 179.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('39869', '30005', 'Sandy','100015', 'worn for 2 days hardly used', 'Bad', 44.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('91349', '23568', 'Sophie','100021', 'colourful and bright', 'New', 43.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('82434', '30001', 'Sam', null, 'a little used but still charges', 'Good', 80.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('62813', '15759', 'Sam','100019', 'hardly used still have the box', 'Good', 193.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('90473', '30000', 'Sandy','100003', '10 out of 10 you need to buy', 'Good', 17.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('54175', '30008', 'Sandy','100021', 'i need to make some money please buy', 'Good', 156.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('62927', '78921', 'Sally','100007', 'havent even touched it', 'Good', 59.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('40329', '30004', 'Sophie','100009', 'never used', 'New', 107.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('21371', '30004', 'Sally','100012', 'one of my most valued properties', 'Used', 144.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('36110', '30006', 'Sandy', null, 'i need to make some money please buy', 'New', 132.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('26710', '30000', 'Sam', null, 'a little cracked on the side', 'Good', 29.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('19956', '30000', 'Sophie','100003', 'needs some cleaning but its very good!', 'Bad', 15.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('35637', '30003', 'Sam','100020', 'brand new in box', 'New', 105.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('22524', '18860', 'Sam', null, 'doesnt work, sell for parts', 'Good', 88.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('84054', '30007', 'Sam','100015', 'slightly cracked but still runs', 'Used', 106.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('94136', '11123', 'Sophie','100007', 'brand new in box', 'New', 66.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('59961', '30000', 'Sally','100005', 'doesnt work, sell for parts', 'Bad', 90.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('49572', '11123', 'Sally', null, 'a little used but still charges', 'Used', 132.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('26351', '30000', 'Sam','100016', 'dirty but sturdy', 'Used', 58.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('15005', '30005', 'Sophie','100013', 'i need to get rid of this product help', 'Used', 188.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('35824', '78921', 'Seth','100006', 'brand new in box', 'Good', 194.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('32289', '30010', 'Sam','100006', 'i cant think of a description', 'Used', 98.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('88676', '35556', 'Seth','100004', 'never used', 'Bad', 192.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('55273', '30006', 'Seth', null, 'dirty but still good', 'Good', 26.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('52876', '11123', 'Sophie','100019', 'new in box', 'New', 121.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('78972', '30001', 'Sam','100010', 'colourful and bright', 'Bad', 193.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('58696', '30001', 'Sam','100015', 'doesnt work, sell for parts', 'Good', 98.99);
	INSERT INTO `craigslist`.`item` (itemId, productId, sellerId, orderId, description, `condition`, price)  VALUES ('56426', '18860', 'Sam','100006', 'one of my most valued properties', 'Bad', 67.99);

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

delimiter //
CALL `craigslist`.`insert_data`();
//

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
