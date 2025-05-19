<%@ page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.crud.controller.SaleController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.PatientController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.EmployeeController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.*" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ProductController" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Gestión de Ventas - Happy Dent</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <style>
        .badge-cancelled {
            background-color: #dc3545;
        }
        .badge-active {
            background-color: #28a745;
        }
        .method-cash {
            color: #28a745;
        }
        .method-card {
            color: #007bff;
        }
        .method-transfer {
            color: #6c757d;
        }
    </style>
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div id="wrapper">
    <jsp:include page="sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="container-fluid px-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="page-title">Gestión de Ventas</h1>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#nuevaVentaModal">
                    <i class="fas fa-plus me-1"></i> Nueva Venta
                </button>
            </div>

            <div class="modal fade" id="nuevaVentaModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-cash-register me-2"></i>Registrar Nueva Venta</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="saleForm" action="${pageContext.request.contextPath}/SaleServlet" method="post">
                                <input type="hidden" name="action" value="add">

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Fecha de Venta</label>
                                        <input type="date" class="form-control" name="SALE_DATE" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Paciente</label>
                                        <select class="form-select" name="PATIENT_ID" required id="patientSelect">
                                            <option value="" selected disabled>Seleccione paciente</option>
                                            <%
                                                PatientController patientController = new PatientController();
                                                List<PatientDTO> activePatients = patientController.listActive();
                                                if (activePatients != null && !activePatients.isEmpty()) {
                                                    for (PatientDTO patient : activePatients) {
                                            %>
                                            <option value="<%= patient.getPATIENT_ID() %>">
                                                <%= patient.getPATIENT_FIRST_NAME() %> <%= patient.getPATIENT_LAST_NAME() %>
                                            </option>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <option value="" disabled>No hay pacientes activos</option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Empleado</label>
                                        <select class="form-select" name="EMPLOYEE_ID" required id="employeeSelect">
                                            <option value="" selected disabled>Seleccione empleado</option>
                                            <%
                                                EmployeeController employeeController = new EmployeeController();
                                                List<EmployeeDTO> activeEmployees = employeeController.listActive();
                                                if (activeEmployees != null && !activeEmployees.isEmpty()) {
                                                    for (EmployeeDTO employee : activeEmployees) {
                                            %>
                                            <option value="<%= employee.getEMPLOYEE_ID() %>">
                                                <%= employee.getEMPLOYEE_FIRST_NAME() %> <%= employee.getEMPLOYEE_LAST_NAME() %>
                                            </option>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <option value="" disabled>No hay empleados activos</option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <label class="form-label">Método de Pago</label>
                                        <select class="form-select" name="SALE_METHOD" required>
                                            <option value="" selected disabled>Seleccione método</option>
                                            <option value="C">Efectivo</option>
                                            <option value="T">Tarjeta</option>
                                            <option value="B">Transferencia Bancaria</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5>Detalles de la Venta</h5>
                                    <button type="button" class="btn btn-success btn-sm" onclick="addProductRow()">
                                        <i class="fas fa-plus me-1"></i> Agregar Producto
                                    </button>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered" id="productsTable">
                                        <thead class="table-light">
                                        <tr>
                                            <th width="40%">Producto</th>
                                            <th width="15%">Precio Unit.</th>
                                            <th width="15%">Cantidad</th>
                                            <th width="15%">Subtotal</th>
                                            <th width="15%">Acciones</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr class="product-row">
                                            <td>
                                                <select class="form-select product-select" name="PRODUCT_ID" required
                                                        onchange="updatePrice(this)">
                                                    <option value="" selected disabled>Seleccione producto</option>
                                                    <%
                                                        List<ProductDTO> products = new ProductController().listActive();
                                                        for (ProductDTO product : products) {
                                                    %>
                                                    <option value="<%= product.getPRODUCT_ID() %>"
                                                            data-price="<%= product.getPRODUCT_PRICE() %>">
                                                        <%= product.getPRODUCT_NAME() %>
                                                    </option>
                                                    <%
                                                        }
                                                    %>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="number" class="form-control price-input" readonly
                                                       name="SALE_DETAIL_PRICE" step="0.01" min="0">
                                            </td>
                                            <td>
                                                <input type="number" class="form-control quantity-input"
                                                       name="SALE_DETAIL_QUANTITY" min="1" value="1"
                                                       oninput="calculateSubtotal(this)">
                                            </td>
                                            <td>
                                                <input type="number" class="form-control subtotal-input" readonly
                                                       name="SALE_DETAIL_SUBTOTAL" step="0.01">
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-danger btn-sm"
                                                        onclick="removeProductRow(this)" disabled>
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="row mt-3">
                                    <div class="col-md-4 offset-md-8">
                                        <div class="input-group">
                                            <span class="input-group-text bg-light fw-bold">Total</span>
                                            <input type="number" class="form-control fw-bold" id="totalAmount"
                                                   name="SALE_TOTAL" readonly step="0.01">
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 mt-4">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">Registrar Venta</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mb-4 border-0" style="background-color: #f8f9fa;">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Ventas Registradas</h5>
                    <div class="dropdown">
                        <button class="btn btn-light btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            Exportar Datos
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#" onclick="exportToCSV()">CSV</a></li>
                            <li><a class="dropdown-item" href="#" onclick="exportToXLS()">Excel</a></li>
                            <li><a class="dropdown-item" href="#" onclick="exportTableToPDF()">PDF</a></li>
                        </ul>
                    </div>
                </div>

                <div class="card-body">
                    <div class="search-box mb-3">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Paciente" id="filterPatient">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Empleado" id="filterEmployee">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="date" class="form-control form-control-sm search-input" placeholder="Fecha desde" id="filterDateFrom">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="date" class="form-control form-control-sm search-input" placeholder="Fecha hasta" id="filterDateTo">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="number" class="form-control form-control-sm search-input" placeholder="Monto mínimo" id="filterAmountMin">
                            </div>
                            <div class="col-md-1 col-6">
                                <select class="form-select form-select-sm search-input" id="filterStatus">
                                    <option value="">Todos</option>
                                    <option value="A">Activas</option>
                                    <option value="C">Canceladas</option>
                                </select>
                            </div>
                            <div class="col-md-1 col-6">
                                <button class="btn btn-primary btn-sm search-btn w-100" onclick="filterTable()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Fecha</th>
                                <th>Paciente</th>
                                <th>Empleado</th>
                                <th>Total</th>
                                <th>Método</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="saleTableBody">
                            <%
                                List<PatientDTO> patients = new PatientController().listAll();
                                List<EmployeeDTO> employees = new EmployeeController().listAll();

                                String filter = request.getParameter("filter");
                                List<SaleDTO> sales = new SaleController().listAllSales();

                                if ("active".equals(filter)) {
                                    sales = new SaleController().listActiveSales();
                                } else if ("cancelled".equals(filter)) {
                                    sales = new SaleController().listCancelledSales();
                                }
                                int paginaActual = 1;
                                String paginaParam = request.getParameter("pagina");
                                if (paginaParam != null && !paginaParam.isEmpty()) {
                                    paginaActual = Integer.parseInt(paginaParam);
                                }

                                int registrosPorPagina = 5;
                                int totalRegistros = sales.size();
                                int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
                                int inicio = (paginaActual - 1) * registrosPorPagina;
                                int fin = Math.min(inicio + registrosPorPagina, totalRegistros);

                                if (sales.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">No hay ventas registradas</td>
                            </tr>
                            <%
                            } else {
                                for (int i = inicio; i < fin; i++) {
                                    SaleDTO sale = sales.get(i);
                                    String patientName = "Paciente no encontrado";
                                    for (PatientDTO patient : patients) {
                                        if (patient.getPATIENT_ID() == sale.getPATIENT_ID()) {
                                            patientName = patient.getPATIENT_FIRST_NAME() + " " + patient.getPATIENT_LAST_NAME();
                                            break;
                                        }
                                    }
                                    String employeeName = "Empleado no encontrado";
                                    for (EmployeeDTO employee : employees) {
                                        if (employee.getEMPLOYEE_ID() == sale.getEMPLOYEE_ID()) {
                                            employeeName = employee.getEMPLOYEE_FIRST_NAME() + " " + employee.getEMPLOYEE_LAST_NAME();
                                            break;
                                        }
                                    }
                                    String methodIcon = "";
                                    String methodClass = "";
                                    switch(sale.getSALE_METHOD()) {
                                        case 'C':
                                            methodIcon = "fa-money-bill-wave";
                                            methodClass = "method-cash";
                                            break;
                                        case 'T':
                                            methodIcon = "fa-credit-card";
                                            methodClass = "method-card";
                                            break;
                                        case 'B':
                                            methodIcon = "fa-university";
                                            methodClass = "method-transfer";
                                            break;
                                    }
                            %>
                            <tr>
                                <td><%= sale.getSALE_ID() %></td>
                                <td><%= sale.getSALE_DATE() %></td>
                                <td><%= patientName %></td>
                                <td><%= employeeName %></td>
                                <td>S/ <%= String.format("%.2f", sale.getSALE_TOTAL()) %></td>
                                <td class="<%= methodClass %>">
                                    <i class="fas <%= methodIcon %> me-1"></i>
                                    <%= sale.getSALE_METHOD() == 'C' ? "Efectivo" :
                                            sale.getSALE_METHOD() == 'T' ? "Tarjeta" : "Transferencia" %>
                                </td>
                                <td>
                                    <span class="badge <%= sale.getSALE_STATUS() == 'A' ? "badge-active" : "badge-cancelled" %>">
                                        <%= sale.getSALE_STATUS() == 'A' ? "Activa" : "Cancelada" %>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-1">
                                        <a href="SaleServlet?action=view&id=<%= sale.getSALE_ID() %>"
                                           class="btn btn-sm btn-info" title="Ver detalles">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <% if (sale.getSALE_STATUS() == 'A') { %>
                                        <button onclick="confirmCancel(<%= sale.getSALE_ID() %>)"
                                                class="btn btn-sm btn-danger" title="Cancelar venta">
                                            <i class="fas fa-times-circle"></i>
                                        </button>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                            </tbody>
                        </table>

                        <% if (totalPaginas > 1) { %>
                        <nav aria-label="Paginación">
                            <ul class="pagination justify-content-center">
                                <li class="page-item <%= paginaActual == 1 ? "disabled" : "" %>">
                                    <a class="page-link" href="?filter=<%= filter != null ? filter : "" %>&pagina=<%= paginaActual - 1 %>">&laquo;</a>
                                </li>
                                <% for (int i = 1; i <= totalPaginas; i++) { %>
                                <li class="page-item <%= i == paginaActual ? "active" : "" %>">
                                    <a class="page-link" href="?filter=<%= filter != null ? filter : "" %>&pagina=<%= i %>"><%= i %></a>
                                </li>
                                <% } %>
                                <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : "" %>">
                                    <a class="page-link" href="?filter=<%= filter != null ? filter : "" %>&pagina=<%= paginaActual + 1 %>">&raquo;</a>
                                </li>
                            </ul>
                        </nav>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

    const allSalesData = [
        <%
        SaleController saleController = new SaleController();
        PatientController patientController1 = new PatientController();
        EmployeeController employeeController1 = new EmployeeController();

        List<SaleDTO> allSales = saleController.listAllSales();
        for (SaleDTO sale : allSales) {
            PatientDTO patient = patientController1.getPatientById(sale.getPATIENT_ID());
            EmployeeDTO employee = employeeController1.getEmployeeById(sale.getEMPLOYEE_ID());

            String patientName = patient != null ?
                patient.getPATIENT_FIRST_NAME() + " " + patient.getPATIENT_LAST_NAME() : "Paciente no encontrado";
            String employeeName = employee != null ?
                employee.getEMPLOYEE_FIRST_NAME() + " " + employee.getEMPLOYEE_LAST_NAME() : "Empleado no encontrado";

            String method = "";
            switch(sale.getSALE_METHOD()) {
                case 'C': method = "Efectivo"; break;
                case 'T': method = "Tarjeta"; break;
                case 'B': method = "Transferencia"; break;
            }

            String status = sale.getSALE_STATUS() == 'A' ? "Activa" : "Cancelada";
        %>
        {
            id: <%= sale.getSALE_ID() %>,
            fecha: "<%= sale.getSALE_DATE() %>",
            paciente: "<%= patientName.replace("\"", "\\\"") %>",
            empleado: "<%= employeeName.replace("\"", "\\\"") %>",
            total: <%= sale.getSALE_TOTAL() %>,
            metodo: "<%= method %>",
            estado: "<%= status %>"
        },
        <% } %>
    ];

    window.jsPDF = window.jspdf.jsPDF;

    function exportToCSV() {
        if (allSalesData.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'No hay datos',
                text: 'No hay datos para exportar',
                confirmButtonColor: '#1abc9c'
            });
            return;
        }

        let csvContent = "ID,Fecha,Paciente,Empleado,Total,Método,Estado\n";

        allSalesData.forEach(sale => {
            const rowData = [
                sale.id,
                sale.fecha,
                sale.paciente,
                sale.empleado,
                sale.total,
                sale.metodo,
                sale.estado
            ];

                const escapedData = rowData.map(function(item) {
                    return '"' + item.replace(/"/g, '""') + '"';
                });

            csvContent += escapedData.join(",") + "\n";
        });

        // Crear y descargar el archivo
        const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
        const url = URL.createObjectURL(blob);
        const link = document.createElement("a");
        link.setAttribute("href", url);
        link.setAttribute("download", "ventas_happy_dent.csv");
        link.style.visibility = "hidden";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        Swal.fire({
            icon: 'success',
            title: 'Exportación completada',
            text: 'Los datos se han exportado a CSV correctamente',
            confirmButtonColor: '#1abc9c'
        });
    }

    function exportToXLS() {
        if (allSalesData.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'No hay datos',
                text: 'No hay datos para exportar',
                confirmButtonColor: '#1abc9c'
            });
            return;
        }

        const workbook = XLSX.utils.book_new();
        const worksheetData = [];

        worksheetData.push([
            "ID", "Fecha", "Paciente", "Empleado", "Total", "Método", "Estado"
        ]);

        allSalesData.forEach(sale => {
            worksheetData.push([
                sale.id,
                sale.fecha,
                sale.paciente,
                sale.empleado,
                sale.total,
                sale.metodo,
                sale.estado
            ]);
        });

        const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);
        XLSX.utils.book_append_sheet(workbook, worksheet, "Ventas");

        XLSX.writeFile(workbook, "ventas_happy_dent.xlsx");

        Swal.fire({
            icon: 'success',
            title: 'Exportación completada',
            text: 'Los datos se han exportado a Excel correctamente',
            confirmButtonColor: '#1abc9c'
        });
    }

    function exportTableToPDF() {
        if (allSalesData.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'No hay datos',
                text: 'No hay datos para exportar',
                confirmButtonColor: '#1abc9c'
            });
            return;
        }

        const doc = new jsPDF({
            orientation: 'landscape'
        });

        doc.setFontSize(18);
        doc.text('Reporte de Ventas - Happy Dent', 14, 15);
        doc.setFontSize(12);

        const currentDate = new Date();
        const formattedDate = currentDate.getDate() + '/' + (currentDate.getMonth() + 1) + '/' + currentDate.getFullYear();
        doc.text('Generado el: ' + formattedDate, 14, 22);

        const headers = [
            "ID",
            "Fecha",
            "Paciente",
            "Empleado",
            "Total",
            "Método",
            "Estado"
        ];

        const data = allSalesData.map(sale => [
            sale.id,
            sale.fecha,
            sale.paciente,
            sale.empleado,
            'S/ ' + sale.total.toFixed(2),
            sale.metodo,
            sale.estado
        ]);

        doc.autoTable({
            head: [headers],
            body: data,
            startY: 30,
            styles: {
                fontSize: 8,
                cellPadding: 2
            },
            headStyles: {
                fillColor: [25, 118, 210],
                textColor: 255,
                fontStyle: 'bold'
            },
            alternateRowStyles: {
                fillColor: [240, 240, 240]
            },
            columnStyles: {
                0: { cellWidth: 10 },
                1: { cellWidth: 20 },
                2: { cellWidth: 40 },
                3: { cellWidth: 40 },
                4: { cellWidth: 20 },
                5: { cellWidth: 25 },
                6: { cellWidth: 20 }
            }
        });

        doc.save("ventas_happy_dent.pdf");

        Swal.fire({
            icon: 'success',
            title: 'Exportación completada',
            text: 'Los datos se han exportado a PDF correctamente',
            confirmButtonColor: '#1abc9c'
        });
    }

    function confirmCancel(saleId) {
        Swal.fire({
            title: '¿Cancelar venta?',
            text: "Esta acción no se puede deshacer. Se devolverá el stock de productos.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, cancelar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'SaleServlet?action=cancel&id=' + saleId;
            }
        });
    }

    function filterTable() {
        const patientFilter = document.getElementById('filterPatient').value.toLowerCase();
        const employeeFilter = document.getElementById('filterEmployee').value.toLowerCase();
        const dateFromFilter = document.getElementById('filterDateFrom').value;
        const dateToFilter = document.getElementById('filterDateTo').value;
        const amountMinFilter = parseFloat(document.getElementById('filterAmountMin').value) || 0;
        const statusFilter = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#saleTableBody tr');

        rows.forEach(row => {
            if (row.cells.length < 8) return;

            const patient = row.cells[2].textContent.toLowerCase();
            const employee = row.cells[3].textContent.toLowerCase();
            const dateStr = row.cells[1].textContent;
            const date = new Date(dateStr);
            const amountStr = row.cells[4].textContent.replace('S/ ', '').trim();
            const amount = parseFloat(amountStr) || 0;
            const status = row.cells[6].querySelector('.badge').textContent.trim() === 'Activa' ? 'A' : 'C';

            const patientMatch = patient.includes(patientFilter) || patientFilter === '';
            const employeeMatch = employee.includes(employeeFilter) || employeeFilter === '';
            const dateFromMatch = dateFromFilter === '' || new Date(dateFromFilter) <= date;
            const dateToMatch = dateToFilter === '' || new Date(dateToFilter) >= date;
            const amountMatch = amount >= amountMinFilter;
            const statusMatch = statusFilter === '' || status === statusFilter;

            if (patientMatch && employeeMatch && dateFromMatch && dateToMatch && amountMatch && statusMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function addProductRow() {
        const tbody = document.querySelector('#productsTable tbody');
        const newRow = document.createElement('tr');
        newRow.className = 'product-row';

        newRow.innerHTML = `
            <td>
                <select class="form-select product-select" name="PRODUCT_ID" required
                        onchange="updatePrice(this)">
                    <option value="" selected disabled>Seleccione producto</option>
                    <% for (ProductDTO product : products) { %>
                    <option value="<%= product.getPRODUCT_ID() %>"
                            data-price="<%= product.getPRODUCT_PRICE() %>">
                        <%= product.getPRODUCT_NAME() %>
                    </option>
                    <% } %>
                </select>
            </td>
            <td>
                <input type="number" class="form-control price-input" readonly
                       name="SALE_DETAIL_PRICE" step="0.01" min="0">
            </td>
            <td>
                <input type="number" class="form-control quantity-input"
                       name="SALE_DETAIL_QUANTITY" min="1" value="1"
                       oninput="calculateSubtotal(this)">
            </td>
            <td>
                <input type="number" class="form-control subtotal-input" readonly
                       name="SALE_DETAIL_SUBTOTAL" step="0.01">
            </td>
            <td class="text-center">
                <button type="button" class="btn btn-danger btn-sm"
                        onclick="removeProductRow(this)">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        `;

        tbody.appendChild(newRow);
        updateRemoveButtons();
    }

    function updatePrice(selectElement) {
        const row = selectElement.closest('tr');
        const selectedOption = selectElement.options[selectElement.selectedIndex];
        const price = selectedOption.getAttribute('data-price');

        row.querySelector('.price-input').value = price;
        calculateSubtotal(row.querySelector('.quantity-input'));
    }

    function calculateSubtotal(inputElement) {
        const row = inputElement.closest('tr');
        const price = parseFloat(row.querySelector('.price-input').value) || 0;
        const quantity = parseInt(inputElement.value) || 0;
        const subtotal = price * quantity;

        row.querySelector('.subtotal-input').value = subtotal.toFixed(2);
        calculateTotal();
    }

    function calculateTotal() {
        let total = 0;
        document.querySelectorAll('.subtotal-input').forEach(input => {
            total += parseFloat(input.value) || 0;
        });

        document.getElementById('totalAmount').value = total.toFixed(2);
    }

    function removeProductRow(button) {
        const row = button.closest('tr');
        if (document.querySelectorAll('#productsTable tbody tr').length > 1) {
            row.remove();
            calculateTotal();
            updateRemoveButtons();
        }
    }

    function updateRemoveButtons() {
        const rows = document.querySelectorAll('#productsTable tbody tr');
        rows.forEach((row, index) => {
            const button = row.querySelector('.btn-danger');
            button.disabled = rows.length <= 1;
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('saleForm');

        form.addEventListener('submit', function(e) {
            e.preventDefault();

            let validProducts = 0;
            document.querySelectorAll('.product-row').forEach(row => {
                const productSelect = row.querySelector('.product-select');
                const quantityInput = row.querySelector('.quantity-input');
                const priceInput = row.querySelector('.price-input');

                if (productSelect.value && quantityInput.value && priceInput.value) {
                    validProducts++;
                }
            });

            if (validProducts === 0) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error de validación',
                    text: 'Debe agregar al menos un producto válido',
                    confirmButtonColor: '#1abc9c'
                });
                return;
            }

            Swal.fire({
                title: '¿Registrar venta?',
                text: "¿Está seguro que desea registrar esta venta?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1abc9c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Registrando venta...',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                            setTimeout(() => {
                                form.submit();
                            }, 1000);
                        }
                    });
                }
            });
        });

        updateRemoveButtons();
        calculateTotal();
    });
</script>
</body>
</html>