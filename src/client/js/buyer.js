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

$("#resultModal").on("hidden.bs.modal", () => {
    // clear the modal content on close
    $("#result").html("");
});