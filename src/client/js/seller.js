import { generateTable } from "./util.js";

$("#sellerRating").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/seller/rating",
        type: "POST",
        data: $("#sellerRating").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#sellerUpdate").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/seller/update",
        type: "POST",
        data: $("#sellerUpdate").serialize(),
        success: (response) => {
            const resultHtml = generateTable(response);
            $("#result").html(resultHtml);
            $("#resultModal").modal();
        }
    });
});

$("#sellerDelete").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/seller/delete",
        type: "POST",
        data: $("#sellerDelete").serialize(),
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