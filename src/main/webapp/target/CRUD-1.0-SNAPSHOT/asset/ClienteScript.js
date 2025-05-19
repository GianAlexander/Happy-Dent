
function validarNombre(event) {
    const nombre = document.getElementById('clientFName').value;
    const regex = /^[a-zA-Z\s]+$/;

    if (!regex.test(nombre)) {
        event.preventDefault();
        swal("Error", "El nombre solo puede contener letras.", "error");
    }
}

function validarApellido(event) {
    const apellido = document.getElementById('clientLastName').value;
    const regex = /^[a-zA-Z\s]+$/;

    if (!regex.test(apellido)) {
        event.preventDefault();
        swal("Error", "El apellido solo puede contener letras.", "error");
    }
}

function validarDNI(event) {
    const dni = document.getElementById('clientDNI').value;
    const regex = /^[0-9]+$/;

    if (!regex.test(dni)) {
        event.preventDefault();
        swal("Error", "El DNI solo puede contener números.", "error");
    }
}

function validarEmail(event) {
    const email = document.getElementById('clientEmail').value;

    if (!email) {
        event.preventDefault();
        swal("Error", "El correo electrónico es obligatorio.", "error");
        return;
    }
    const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!regex.test(email)) {
        event.preventDefault();
        swal("Error", "El correo electrónico no es válido.", "error");
    }
}



function validarTelefono(event) {
    const telefono = document.getElementById('clientPhone').value;
    const regex = /^[0-9]{9}$/;

    if (!regex.test(telefono)) {
        event.preventDefault();
        swal("Error", "El teléfono debe tener 9 dígitos numéricos.", "error");
    }
}

function validarFecha(event) {
    const fechaNacimiento = document.getElementById('clientBirthDate').value;

    if (!fechaNacimiento) {
        event.preventDefault();
        swal("Error", "La fecha de nacimiento es obligatoria.", "error");
    }
}


function mostrarAlertaExito() {
    swal({
        title: "Éxito",
        text: "Cliente registrado correctamente.",
        icon: "success",
        timer: 10000,
    });
}


function enviarFormulario(event) {
    validarNombre(event);
    validarApellido(event);
    validarDNI(event);
    validarEmail(event);
    validarTelefono(event);
    validarFecha(event);  // Llamar a la validación de la fecha

    if (event.defaultPrevented) {
        return;
    }
    mostrarAlertaExito();
}

function exportToCSV() {
    const rows = document.querySelectorAll("#clientTable tbody tr");
    const csvData = [['ID', 'Nombres y Apellidos', 'N. de documento', 'Telefono', 'Correo Electronico', 'Tipo de Doc',  'F. Nacimiento']];     rows.forEach(row => {
        const cols = row.querySelectorAll('td');
        const rowData = [];
        cols.forEach((col, index) => {
            if (col.querySelector('button') === null) {
                let cellValue = col.innerText.trim();
                if (index === 6) {
                    const date = new Date(cellValue);
                    cellValue = date.toLocaleDateString('es-PE');
                }
                rowData.push(cellValue.replace(/,/g, ''));
            }
        });
        csvData.push(rowData);
    });
    const csvContent = "data:text/csv;charset=utf-8," + csvData.map(e => e.join(",")).join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "Clientes.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}
function exportToXLS() {
    const wb = XLSX.utils.book_new();
    const rows = document.querySelectorAll("#clientTable tbody tr");
    const data = [['ID', 'Nombres y Apellidos', 'N. de documento', 'Telefono', 'Correo Electronico', 'Tipo de Doc',  'F. Nacimiento']];
    rows.forEach(row => {
        const cols = row.querySelectorAll('td');
        const rowData = [];
        cols.forEach((col, index) => {
            if (col.querySelector('button') === null) {
                let cellValue = col.innerText.trim();
                if (index === 6) {
                    const date = new Date(cellValue);
                    cellValue = date.toLocaleDateString('es-PE');
                }
                rowData.push(cellValue);
            }
        });
        data.push(rowData);
    });
    const ws = XLSX.utils.aoa_to_sheet(data);
    XLSX.utils.book_append_sheet(wb, ws, 'Clientes');
    XLSX.writeFile(wb, 'Clientes.xlsx');
}
async function exportTableToPDF() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    const tableData = [];
    const rows = document.querySelectorAll("#clientTable tbody tr");
    rows.forEach(row => {
        const rowData = [];
        const cells = row.querySelectorAll("td");
        cells.forEach((cell, index) => {
            if (cell.querySelector('button') === null) {
                let cellValue = cell.textContent.trim();
                if (index === 6) {
                    const date = new Date(cellValue);
                    cellValue = date.toLocaleDateString('es-PE');
                }
                rowData.push(cellValue);
            }
        });
        tableData.push(rowData);
    });
    doc.autoTable({
        head: [['ID', 'Nombres y Apellidos', 'N. de documento', 'Telefono', 'Correo Electronico', 'Tipo de Doc',  'F. Nacimiento']],
        body: tableData,
        startY: 10,
        headStyles: { fillColor: [22, 160, 133] },
        styles: { fontSize: 10, cellPadding: 2, halign: 'center' }
    });

    doc.save('Clientes.pdf');
}
console.log(csvData); // Para CSV
console.log(data); // Para XLSX
console.log(tableData); // Para PDF
