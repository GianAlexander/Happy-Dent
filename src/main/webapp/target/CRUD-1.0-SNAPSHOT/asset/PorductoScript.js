function validarNombreProducto(event) {
    const nombre = document.getElementById('productName').value;
    const regex = /^[a-zA-Z\s]+$/;

    if (!regex.test(nombre)) {
        event.preventDefault();
        swal("Error", "El nombre del producto solo puede contener letras.", "error");
    }
}

function validarCategoria(event) {
    const categoria = document.getElementById('productCategory').value;
    const regex = /^[a-zA-Z\s]+$/;

    if (!regex.test(categoria)) {
        event.preventDefault();
        swal("Error", "La categoría solo puede contener letras.", "error");
    }
}

function validarPrecio(event) {
    const precio = document.getElementById('productPrice').value;
    const regex = /^[0-9]+(\.[0-9]{1,2})?$/; // Permite números con hasta dos decimales

    if (!regex.test(precio)) {
        event.preventDefault();
        swal("Error", "El precio debe ser un número válido con hasta dos decimales.", "error");
    }
}

function validarStock(event) {
    const stock = document.getElementById('productStock').value;
    const regex = /^[0-9]+$/;

    if (!regex.test(stock)) {
        event.preventDefault();
        swal("Error", "El stock debe ser un número entero positivo.", "error");
    }
}

function mostrarAlertaExitoProducto() {
    swal({
        title: "Éxito",
        text: "Producto registrado correctamente.",
        icon: "success",
        timer: 10000,
    });
}

function enviarFormularioProducto(event) {
    validarNombreProducto(event);
    validarCategoria(event);
    validarPrecio(event);
    validarStock(event);

    if (event.defaultPrevented) {
        return;
    }
    mostrarAlertaExitoProducto();
}

function exportToCSV() {
    const rows = document.querySelectorAll("#productTable tbody tr");
    const csvData = [['ID', 'Nombre', 'Categoría', 'Precio', 'Stock']];
    rows.forEach(row => {
        const cols = row.querySelectorAll('td');
        const rowData = [];
        cols.forEach((col, index) => {
            if (col.querySelector('button') === null) {
                let cellValue = col.innerText.trim();
                rowData.push(cellValue.replace(/,/g, ''));
            }
        });
        csvData.push(rowData);
    });
    const csvContent = "data:text/csv;charset=utf-8," + csvData.map(e => e.join(",")).join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "Productos.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

function exportToXLS() {
    const wb = XLSX.utils.book_new();
    const rows = document.querySelectorAll("#productTable tbody tr");
    const data = [['ID', 'Nombre', 'Categoría', 'Precio', 'Stock']];
    rows.forEach(row => {
        const cols = row.querySelectorAll('td');
        const rowData = [];
        cols.forEach(col => {
            if (col.querySelector('button') === null) {
                let cellValue = col.innerText.trim();
                rowData.push(cellValue);
            }
        });
        data.push(rowData);
    });
    const ws = XLSX.utils.aoa_to_sheet(data);
    XLSX.utils.book_append_sheet(wb, ws, 'Productos');
    XLSX.writeFile(wb, 'Productos.xlsx');
}

async function exportTableToPDF() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    const tableData = [];
    const rows = document.querySelectorAll("#productTable tbody tr");
    rows.forEach(row => {
        const rowData = [];
        const cells = row.querySelectorAll("td");
        cells.forEach(cell => {
            if (cell.querySelector('button') === null) {
                let cellValue = cell.textContent.trim();
                rowData.push(cellValue);
            }
        });
        tableData.push(rowData);
    });
    doc.autoTable({
        head: [['ID', 'Nombre', 'Categoría', 'Precio', 'Stock']],
        body: tableData,
        startY: 10,
        headStyles: { fillColor: [22, 160, 133] },
        styles: { fontSize: 10, cellPadding: 2, halign: 'center' }
    });

    doc.save('Productos.pdf');
}
