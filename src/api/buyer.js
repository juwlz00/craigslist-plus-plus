const path = require("path");
const express = require('express');
const router = express.Router();

// Helpers
const handleSearch = (req, res) => {
    console.log(req.body);
    res.send(req.body);
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