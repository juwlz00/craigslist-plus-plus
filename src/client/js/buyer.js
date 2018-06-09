$('#filter').submit(() => {
    $.ajax({
        url:"/buyer/search",
        type: "GET",
        
    })
});