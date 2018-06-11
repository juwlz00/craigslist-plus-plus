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
                    resObj.error = "Please place a max or min range on price."
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
            resObj.error = "Couldn't get your request."
        } else {
            resObj.colNames = ["name", "category", "description", "price", "condition", "seller"];
            resObj.results = results;
        }
        res.send(resObj);
    });

};

// Buyer API Endpoints
router.post("/buyer/search", handleSearch);

// Buyer Index Page
router.get("/buyer", (req, res) => {
    if (req.session.userId && req.session.userType === "buyer") {
        res.sendFile("buyer.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by buyers</h1>");
    }
});

module.exports = router;