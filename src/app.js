const path = require("path");
const express = require("express");
const session = require("express-session");
const bodyParser = require("body-parser");
const auth = require("./api/auth");
const buyer = require("./api/buyer");
const seller = require("./api/seller");
const app = express();

// Server Configurations
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "/client")));
app.use(session({
    secret: "candy",
    resave: false,
    saveUninitialized: false
}));

// Routing API Endpoints
app.use("/", auth);
app.use("/", buyer);
app.use("/", seller);

// Index Route
app.get("/", (req, res) => {
    if (req.session.userId) {
        res.sendFile("logout.html", { root: path.join(__dirname, "/client") });
    } else {
        res.sendFile("login.html", { root: path.join(__dirname, "/client") });
    }
});

app.listen(process.env.PORT || 8000);
