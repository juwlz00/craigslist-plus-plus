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
