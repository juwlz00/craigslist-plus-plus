const path = require("path");
const express = require('express');
const router = express.Router();

router.get("/buyer", (req, res) => {
    if (req.session.userId && req.session.userType === "buyer") {
        res.sendFile("buyer.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by buyers</h1>");
    }
});

module.exports = router;