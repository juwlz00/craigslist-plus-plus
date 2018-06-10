$("#buyerSearch").submit((event) => {
    event.preventDefault();
    $.ajax({
        url: "/buyer/search",
        type: "POST",
        data: $("#buyerSearch").serialize(),
        success: (response) => {
            $("#result").html(response);
            alert(itemTable(jsonObj))
        }
    });
});

function itemTable(response){
    var tab = "<table><tr>";
    var {colName, colNum, table} = response;
    for(var i=0; i<colNum; i++){
        tab += "<th>" + colName[i] + "</th>";
    }
    tab += "</tr><tr>";
    for(var j=0; j<table.length; j++){
        for(var k=0; k<colNum; k++){
           tab += "<td>" + table[j][colName[k]] + "</td>";
        }
    }
    tab += "</tr></table>"
    return tab;
}

function searchQuery(qObj){
    var query = "SELECT `pId`, `name`, `category`, `sellerId`, `price`, `condition`,description` FROM `craigslist`.`product` AS p, `craigslist`.`item` AS i";
    query += "WHERE";
    for(var p in qObj){
        if(p == "price"){
            if(qObj.hasOwnProperty("max"))
                query += p + "<" + qobj.p;
            else if(qObj.hasOwnProperty("min"))
                query += p + ">" + qobj.p;
        }
        else
            query += p + "=" + qObj.p;     
    }
}

var jsonObj = {
    "colNum":4,
    "colName":["name","id","price","seller"],
    "table":[{"name":"apple", "id":1, "price":20, "seller":"bob"},
    {"name":"orange", "id":2, "price":99.2, "seller":"krabs"},
    {"name":"pear", "id":3, "price":0, "seller":"pat"}]
}