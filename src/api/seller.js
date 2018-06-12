const path = require("path");
const express = require('express');
const router = express.Router();
const db = require("../database/connection");

// Helpers
const handleRating = (req, res) => {
    let resObj = {};
    let sql = `SELECT \`sellerId\` AS seller, AVG(\`stars\`) AS stars
                FROM \`craigslist\`.\`seller\` AS s, \`craigslist\`.\`buyer\` AS b, \`craigslist\`.\`review\` AS r
                WHERE r.buyerId = b.userId AND r.sellerId = s.userId AND s.userId = "${req.session.userId}"
                GROUP BY \`sellerId\`;`;

    db.query(sql, (error, results) => {
        if (error) {
            resObj.error = "Couldn't get your request.";
        } else {
            resObj.colNames = ["seller", "stars"];
            resObj.results = results;
        }
        res.send(resObj);
    });

};

// Seller API Endpoints
router.post("/seller/rating", handleRating);

// Seller Index Page
router.get("/seller", (req, res) => {
    if (req.session.userId && req.session.userType === "seller") {
        res.sendFile("seller.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by sellers</h1>");
    }
});

module.exports = router;