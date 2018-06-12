const generateTable = (resObj) => {
    const { colNames, results, error } = resObj;
    let html = "";
    if (error) {
        html += `<div class="alert alert-danger" role="alert">${error}</div>`
    } else if (results && results.length > 0) {
        html += `<table class="table"><thead><tr>`;
        colNames.forEach((col) => {
            html += `<th scope="col">${col}</th>`;
        });
        html += `</tr></thead><tbody>`;
        results.forEach((row) => {
            html += `<tr>`;
            colNames.forEach((col) => {
                html += `<td>${row[col]}</td>`;
            });
            html += `</tr>`;
        });
        html += `</tbody></table>`;
    } else {
        html += `<div class="alert alert-info" role="alert">
        There is nothing in the database with the given constaints.
        </div>`
    }
    return html;
};

const generateReceipt = (resObj) => {
    const { results, error } = resObj;
    let html = "";
    if (error) {
        html += `<div class="alert alert-danger" role="alert">${error}</div>`
    } else if (results && results[0]) {
        html += `
        <div class="container">
            <div class="row">
                <div class="col">
                    <h3>Invoice</h3>
                </div>
                <div class="col">
                    <h3 class="text-right">Order #${results[0].orderId}</h3>
                </div>
            </div>
            <hr>
            <div class="row">
                <div class="col">
                    <address>
                        <strong>Payment Method:</strong>
                        <br> ${results[0].cardType}
                        <br> ${results[0].cardNumber}
                    </address>
                </div>
                <div class="col text-right">
                    <address>
                        <strong>Order Date:</strong>
                        <br> ${results[0].date}
                        <br>
                        <br>
                    </address>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <h3>
                        <strong>Order Summary</strong>
                    </h3>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">ItemId</th>
                            <th scope="col">Product Name</th>
                            <th scope="col">Item Description</th>
                            <th scope="col">Seller</th>
                            <th scope="col">Price</th>
                        </tr>
                    </thead>
                    <tbody>
        `;
        console.log(results);
        results[0].items.forEach((item) => {
            html += `
            <tr>
                <th scope="row">${item.itemId}</td>
                <td>${item.name}</td>
                <td>${item.description}</td>
                <td>${item.seller}</td>
                <td>${item.price}</td>
            </tr>
            `;

        });
        html += `
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <th scope="row">Total</td>
                            <th scope="row">${results[0].totalPaid}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        `;
    } else {
        html += `<div class="alert alert-info" role="alert">
        There is nothing in the database with the given constaints.
        </div>`
    }

    return html;
}

export { generateTable, generateReceipt };