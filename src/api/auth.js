const express = require('express');
const router = express.Router();
const db = require("../database/connection");

// Endpoint Handlers
const authenticate = (userId, password, userType, next) => {
    const userTable = userType === "buyer" ? "craigslist.buyer" : "craigslist.seller";
    const sql = `SELECT * FROM ${userTable} WHERE userId="${userId}"`;
    db.query(sql, (error, results) => {
        if (error) {
            next(error);
        }
        if (results[0] && results[0].password === password) {
            next(null, userId, userType);
        } else {
            next(new Error("Auth failed"));
        }
    });
};

const handleLogin = (req, res) => {
    authenticate(
        req.body.userId,
        req.body.password,
        req.body.userType,
        (error, userId, userType) => {
            if (userId) {
                req.session.regenerate(() => {
                    req.session.userId = userId;
                    req.session.userType = userType;
                    res.redirect(`/${userType}`);
                });
            } else {
                res.redirect("/");
            }
        }
    );
};

const handleLogout = (req, res) => {
    req.session.destroy(() => {
        res.redirect("/");
    });
};

// Routes
router.post("/login", handleLogin);
router.post("/logout", handleLogout);

module.exports = router;
