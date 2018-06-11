import { generateTable } from "./util.js";

$("#buyerSearch").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/search",
        type: "POST",
        data: $("#buyerSearch").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response.colNames, response.results);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

