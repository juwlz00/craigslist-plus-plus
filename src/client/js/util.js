const generateTable = (colNames, results) => {
    let html = "";
    if (results.length > 0) {
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
    }
    return html;
};

export { generateTable };