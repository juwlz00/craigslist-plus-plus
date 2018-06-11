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

export { generateTable };