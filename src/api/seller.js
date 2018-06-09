const path = require("path");
const express = require('express');
const router = express.Router();

router.get("/seller", (req, res) => {
    if (req.session.userId && req.session.userType === "seller") {
        res.sendFile("seller.html", { root: path.join(__dirname, "/../client") });
    } else {
        res.send("<h1>This page is only accessible by sellers</h1>");
    }
});

module.exports = router;