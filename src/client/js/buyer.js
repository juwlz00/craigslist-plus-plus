import { generateTable, generateReceipt } from "./util.js";

$("#buyerSearch").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/search",
        type: "POST",
        data: $("#buyerSearch").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#buyerReceipt").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/receipt",
        type: "POST",
        data: $("#buyerReceipt").serialize(),
        success: (response) => {
            const resultHtml = generateReceipt(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#buyerInventory").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/inventory",
        type: "GET",
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});


$("#buyerProductAvg").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/avgcost",
        type: "POST",
        data: $("#buyerProductAvg").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#buyerSellerAvg").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/avgstar",
        type: "POST",
        data: $("#buyerSellerAvg").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#buyerDeleteOrder").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/deleteorder",
        type: "POST",
        data: $("#buyerDeleteOrder").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#resultModal").on("hidden.bs.modal", () => {
    // clear the modal content on close
    $("#result").html("");
});