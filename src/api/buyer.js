const path = require("path");
const express = require('express');
const router = express.Router();
const db = require("../database/connection");

// Helpers
const handleSearch = (req, res) => {
    let resObj = {};
    let sql = `SELECT name, category, description, price, \`condition\`, sellerId AS seller
        FROM \`craigslist\`.\`product\` AS p, \`craigslist\`.\`item\` AS i
        WHERE p.productId = i.productId`;
    for (let property in req.body) {
        if (req.body[property] && req.body[property] !== "maxmin") {
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
            resObj.colNames = ["name", "category", "description", "price", "condition", "seller"];
            resObj.results = results;
        }
        res.send(resObj);
    });

};

const handleReceipt = (req, res) => {
    let resObj = {};
    let paymentOrderSql = `SELECT o.orderId, \`date\`, cardNumber, cardType, totalPaid
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
                db.query(itemsSql, (error, resultItems) => {
                    if (error) {
                        resObj.error = "Couldn't get your request.";
                    } else {
                        orderResults[0].items = resultItems;
                        resObj.results = orderResults;
                    }
                    res.send(resObj);
                });
            } else {
                res.send(resObj);
            }
        }
    });
};

// Buyer API Endpoints
router.post("/buyer/search", handleSearch);
router.post("/buyer/receipt", handleReceipt);

// Buyer Index Page
router.get("/buyer", (req, res) => {
    if (req.session.userId && req.session.userType === "buyer") {
        res.sendFile("buyer.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by buyers</h1>");
    }
});

module.exports = router;