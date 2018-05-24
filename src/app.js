const express = require("express");
const bodyParser = require("body-parser");

const app = express().use(bodyParser.json());

app.get("/", (req, res) => {
    res.send("Server Running");
});

app.listen(process.env.PORT || 3000);