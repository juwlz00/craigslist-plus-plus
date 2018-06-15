const path = require("path");
const express = require('express');
const router = express.Router();
const db = require("../database/connection");

// Helpers
const handleSearch = (req, res) => {
    let resObj = {};
    resObj.colNames = [];
    let colSelection = ``;
    if (typeof req.body.cols === "string") {
        colSelection = `\`${req.body.cols}\``;
        resObj.colNames.push(req.body.cols);
    } else if (typeof req.body.cols === "object") {
        let first = true;
        req.body.cols.forEach((col) => {
            if (first) {
                colSelection += `\`${col}\``;
                first = false;
            } else {
                colSelection += `, \`${col}\``;
            }
            resObj.colNames.push(col);
        });
    } else {
        colSelection = `\`name\`, \`category\`, \`description\`, \`price\`, \`condition\`, \`sellerId\``;
        resObj.colNames = ["name", "category", "description", "price", "condition", "sellerId"];
    }
    let sql = `SELECT ${colSelection}
        FROM \`craigslist\`.\`product\` AS p, \`craigslist\`.\`item\` AS i
        WHERE p.productId = i.productId`;
    for (let property in req.body) {
        if (req.body[property] &&
            property !== "maxmin" &&
            property !== "cols") {
            if (property === "price") {
                if (req.body.maxmin === "max") {
                    sql += ` AND price<${req.body.price}`;
                } else if (req.body.maxmin === "min") {
                    sql += ` AND price>${req.body.price}`;
                } else {
                    resObj.error = "Please place a max or min range on price.";
                    return res.send(resObj);
                }
            } else if (property !== "maxmin") {
                sql += ` AND \`${property}\`="${req.body[property]}"`;
            }
        }
    }
    sql += `;`;

    db.query(sql, (error, results) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
        } else {
            resObj.results = results;
        }
        res.send(resObj);
    });

};

const handleReceipt = (req, res) => {
    let resObj = {};
    let paymentOrderSql = `SELECT buyerId, o.orderId, \`date\`, cardNumber, cardType, totalPaid
        FROM \`craigslist\`.\`order\` AS o, \`craigslist\`.\`payment\` AS p
        WHERE o.orderId='${req.body.orderId}' AND o.orderId=p.orderId;`;
    let itemsSql = `SELECT itemId, \`name\`, description, sellerId AS seller, price
        FROM \`craigslist\`.\`product\` AS p, \`craigslist\`.\`item\` AS i
        WHERE i.orderId='${req.body.orderId}' AND p.productId = i.productId;`;
    db.query(paymentOrderSql, (error, orderResults) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
            res.send(resObj);
        } else {
            if (orderResults[0]) {
                if (orderResults[0].buyerId !== req.session.userId) {
                    resObj.error = "You do not have user access rights to this.";
                    res.send(resObj);
                } else {
                    db.query(itemsSql, (er, resultItems) => {
                        if (er) {
                            resObj.error = "Couldn't get your request.";
                        } else {
                            orderResults[0].items = resultItems;
                            resObj.results = orderResults;
                        }
                        res.send(resObj);
                    });
                }
            } else {
                res.send(resObj);
            }
        }
    });
};

const handleReviewCheck = (req, res) => {
    let resObj = {};
    let sql = `SELECT s.userid AS sellerId FROM craigslist.seller s
                WHERE NOT EXISTS
                (SELECT b.userid
                FROM craigslist.buyer b
                WHERE NOT EXISTS
                (SELECT r.stars
                FROM craigslist.review r
                WHERE s.userId = r.sellerId
                AND b.userid = r.buyerId));`;
    db.query(sql, (error, results) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
        } else {
            resObj.colNames = ["sellerId"];
            resObj.results = results;
        }
        res.send(resObj);
    });
};

const handleInventory = (req, res) => {
    let resObj = {};
    let sql = `SELECT \`name\`, COUNT(itemId) AS quantity
        FROM \`craigslist\`.\`product\` AS p, \`craigslist\`.\`item\` AS i
        WHERE p.productId = i.productId
        GROUP BY \`name\``;
    db.query(sql, (error, results) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
        } else {
            resObj.colNames = ["name", "quantity"];
            resObj.results = results;
        }
        res.send(resObj);
    });
};

const handleAvgCost = (req, res) => {
    let resObj = {};
    let viewExistsSql = `DROP VIEW IF EXISTS \`craigslist\`.\`avgcost\`;`;
    let createViewSql = `CREATE VIEW \`craigslist\`.\`avgCost\`(\`name\`,\`avgPrice\`) AS
                SELECT \`name\`, AVG(\`price\`) AS \`avgPrice\`
                FROM \`craigslist\`.\`product\` AS p, \`craigslist\`.\`item\` AS i
                WHERE p.productId = i.productId
                GROUP BY \`name\`;
               `;
    const maxmin = req.body.type === "most" ? "MAX" : "MIN";
    let maxminSql = `SELECT \`name\`, \`avgPrice\`
                FROM \`craigslist\`.\`avgCost\`
                WHERE \`avgPrice\` = (
                SELECT ${maxmin}(\`avgPrice\`)
                FROM \`craigslist\`.\`avgCost\`
                )
                `;
    db.query(viewExistsSql, (error, results) => {
        if(error) {
            resObj.error = "Couldn't get your request.";
            return res.send(resObj);
        }else{
            db.query(createViewSql, (error2, results) => {
                if (error2) {
                    resObj.error = "Couldn't get your request.";
                    return res.send(resObj);
                } else {
                    db.query(maxminSql, (error3, results) => {
                        if (error3) {
                            resObj.error = "Couldn't get your request.";
                        } else {
                            resObj.colNames = ["name", "avgPrice"];
                            resObj.sql = createViewSql + '</br>' + maxminSql;
                            resObj.results = results;
                        }
                        res.send(resObj);
                    });
                }
            });

        }
    });
}

const handleAvgStars = (req, res) => {
    let resObj = {};
    let viewExistsSql = `DROP VIEW IF EXISTS \`craigslist\`.\`avgReview\`;`;
    let createViewSql = `CREATE VIEW \`craigslist\`.\`avgReview\`(\`sellerId\`,\`avgStars\`) AS
                        SELECT \`sellerId\`, AVG(\`stars\`) AS \`avgStars\`
                        FROM \`craigslist\`.\`review\` AS r
                        GROUP BY \`sellerId\`;
                        `;
    const maxmin = req.body.rating === "best" ? "MAX" : "MIN";
    let maxminSql = `SELECT \`sellerId\`, \`avgStars\`
                    FROM \`craigslist\`.\`avgReview\`
                    WHERE \`avgStars\` = (
                    SELECT ${maxmin}(\`avgStars\`)
                    FROM \`craigslist\`.\`avgReview\`
                    )`
    db.query(viewExistsSql, (error, results) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
            return res.send(resObj);
        } else{
            db.query(createViewSql, (error2, results) => {
                if (error2) {
                    resObj.error = "Couldn't get your request.";
                    return res.send(resObj);
                } else {
                    db.query(maxminSql, (error3, results) => {
                        if (error3) {
                            resObj.error = "Couldn't get your request.";
                        } else {
                            resObj.colNames = ["sellerId", "avgStars"];
                            resObj.results = results;
                            resObj.sql = createViewSql + "</br>" + maxminSql;
                        }
                        res.send(resObj);
                    });
                }
            });

        }
    });
}

const handleDeleteOrder = (req, res) =>{
    let resObj = {};
    let checkOrderSql = `SELECT buyerId FROM \`craigslist\`.\`order\` WHERE orderId='${req.body.delOrderId}';`;
    let deleteSql = `DELETE FROM \`craigslist\`.\`order\` WHERE \`orderId\` = '${req.body.delOrderId}';`;
    db.query(checkOrderSql, (error, results1) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
            res.send(resObj);
        } else {
            if (results1[0]) {
                if (results1[0].buyerId === req.session.userId) {
                    db.query(deleteSql, (error2, results2) => {
                        if (error2) {
                            resObj.error = "Couldn't get your request.";
                            res.send(resObj);
                        } else {
                            let selectAllOrdersSql = `SELECT p.orderId, paymentId, cardNumber, cardType, totalPaid, \`date\`, buyerId
                                FROM \`craigslist\`.\`payment\` AS p, \`craigslist\`.\`order\` AS o
                                WHERE p.orderId = o.orderId;`;
                            db.query(selectAllOrdersSql, (error3, results3) => {
                                if (error3) {
                                    resObj.error = "Couldn't get your request.";
                                } else {
                                    resObj.colNames = ["orderId", "paymentId", "cardNumber", "cardType", "totalPaid", "date", "buyerId"];
                                    resObj.results = results3;
                                }
                                res.send(resObj);
                            });
                        }
                    });
                } else {
                    resObj.error = "You do not have user access rights to this.";
                    res.send(resObj);
                }
            } else {
                resObj.error = "There are no orders matching that Id.";
                res.send(resObj);
            }
        }
    });
};

// Buyer API Endpoints
router.post("/buyer/search", handleSearch);
router.post("/buyer/receipt", handleReceipt);
router.get("/buyer/reviewcheck", handleReviewCheck);
router.get("/buyer/inventory", handleInventory);
router.post("/buyer/avgcost", handleAvgCost);
router.post("/buyer/avgstar", handleAvgStars);
router.post("/buyer/deleteorder", handleDeleteOrder);

// Buyer Index Page
router.get("/buyer", (req, res) => {
    if (req.session.userId && req.session.userType === "buyer") {
        res.sendFile("buyer.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by buyers</h1>");
    }
});

module.exports = router;