const path = require("path");
const express = require('express');
const router = express.Router();
const db = require("../database/connection");

// Endpoint Handlers
const handleRating = (req, res) => {
    let resObj = {};
    let sql = `
        SELECT \`sellerId\` AS seller, AVG(\`stars\`) AS stars
        FROM \`craigslist\`.\`seller\` AS s, \`craigslist\`.\`buyer\` AS b, \`craigslist\`.\`review\` AS r
        WHERE r.buyerId = b.userId AND r.sellerId = s.userId AND s.userId = "${req.session.userId}"
        GROUP BY \`sellerId\`;
    `;

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

const handleSellerUpdate = (req, res) => {
    let resObj = {};
    let checkItemSql = `SELECT sellerId FROM \`craigslist\`.\`item\` WHERE itemId='${req.body.itemId}'`;
    let sql = `UPDATE \`craigslist\`.\`item\` SET`;

    let i = 0;
    for (let property in req.body) {
        if (req.body[property] && property !== "itemId") {
            if (i == 0) {
                sql += ` \`${property}\`="${req.body[property]}"`;
                i += 1;
            }
            else {
                sql += ` AND \`${property}\`="${req.body[property]}"`;
            }
        }
    }
    sql += ` WHERE itemId = '${req.body.itemId}';`;

    db.query(checkItemSql, (error1, results1) => {
        if (error1) {
            resObj.error = "Couldn't get your request.";
            res.send(resObj);
        } else {
            if (results1[0]) {
                if (results1[0].sellerId === req.session.userId) {
                    db.query(sql, (error2, results2) => {
                        if (error2) {
                            if (error2.sqlMessage === "Price has to be positive.") {
                                resObj.error = "Item price has to be positive.";
                            } else {
                                resObj.error = "Couldn't get your request.";
                            }
                            return res.send(resObj);
                        } else {
                            let selectItemsSql = `
                                SELECT itemId, description, price, \`condition\`
                                FROM \`craigslist\`.\`item\`
                                WHERE itemId='${req.body.itemId}' AND sellerId = "${req.session.userId}";
                            `;
                            db.query(selectItemsSql, (er, results3) => {
                                if (er) {
                                    resObj.error = "Couldn't get your request.";
                                } else {
                                    resObj.colNames = ["itemId", "description", "price", "condition"];
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
                resObj.error = "There are no item matching that Id.";
                res.send(resObj);
            }
        }
    });
};

const handleSellerDelete = (req, res) => {
    let resObj = {};
    let checkItemSql = `SELECT sellerId FROM \`craigslist\`.\`item\` WHERE itemId='${req.body.itemId}'`;
    let sql = `DELETE FROM \`craigslist\`.\`item\` WHERE itemId = '${req.body.itemId}' AND sellerId = "${req.session.userId}";`;

    db.query(checkItemSql, (error1, results1) => {
        if (error1) {
            resObj.error = "Couldn't get your request.";
            res.send(resObj);
        } else {
            if (results1[0]) {
                if (results1[0].sellerId === req.session.userId) {
                    db.query(sql, (error2, results2) => {
                        if (error2) {
                            resObj.error = "Couldn't get your request.";
                        } else {
                            let selectSql = `SELECT itemid, description, price, \`condition\` FROM \`craigslist\`.\`item\`;`;
                            db.query(selectSql, (er, results3) => {
                                if (er) {
                                    resObj.error = "Couldn't get your request.";
                                } else {
                                    resObj.colNames = ["itemid", "description", "price", "condition"];
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
                resObj.error = "There are no item matching that Id.";
                res.send(resObj);
            }
        }
    });
};

// Seller API Endpoints
router.post("/seller/rating", handleRating);
router.post("/seller/update", handleSellerUpdate);
router.post("/seller/delete", handleSellerDelete);

// Seller Index Page
router.get("/seller", (req, res) => {
    if (req.session.userId && req.session.userType === "seller") {
        res.sendFile("seller.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by sellers</h1>");
    }
});

module.exports = router;
