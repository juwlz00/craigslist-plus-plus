$("#buyerSearch").submit(() => {
    $.ajax({
        url: "/buyer/search",
        type: "POST",
        data: $("#buyerSearch").serialize(),
        success: (response) => {
            $("#result").html(response);
        }
    });
});
