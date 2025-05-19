<%@ page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.crud.controller.PurchaseController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.PurchaseDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.PurchaseDetailDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.ProductDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.SupplierDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.EmployeeDTO" %>
<%@ page import="pe.edu.vallegrande.crud.controller.SupplierController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.EmployeeController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ProductController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.SupplierDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.EmployeeDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.ProductDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Gestión de Compras - Happy Dent</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    <style>
        .product-row select, .product-row input {
            font-size: 0.9rem;
        }
        .subtotal-cell {
            font-weight: bold;
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
                <h1 class="page-title">Gestión de Compras</h1>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#nuevaCompraModal">
                    <i class="fas fa-plus me-1"></i> Nueva Compra
                </button>
            </div>

            <!-- Modal para nueva compra -->
            <div class="modal fade" id="nuevaCompraModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-cart-plus me-2"></i>Registrar Nueva Compra</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="purchaseForm" action="${pageContext.request.contextPath}/PurchaseServlet" method="post">
                                <input type="hidden" name="action" value="add">

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Fecha de Compra</label>
                                        <input type="date" class="form-control" name="PURCHASE_DATE" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Proveedor</label>
                                        <select class="form-select" name="SUPPLIER_ID" required>
                                            <option value="" selected disabled>Seleccione proveedor</option>
                                            <%
                                                List<SupplierDTO> suppliers = new SupplierController().listAll();
                                                for (SupplierDTO supplier : suppliers) {
                                            %>
                                            <option value="<%= supplier.getSUPPLIER_ID() %>"><%= supplier.getSUPPLIER_NAME() %></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Empleado</label>
                                        <select class="form-select" name="EMPLOYEE_ID" required>
                                            <option value="" selected disabled>Seleccione empleado</option>
                                            <%
                                                List<EmployeeDTO> employees = new EmployeeController().listActive();
                                                for (EmployeeDTO employee : employees) {
                                            %>
                                            <option value="<%= employee.getEMPLOYEE_ID() %>">
                                                <%= employee.getEMPLOYEE_FIRST_NAME() %> <%= employee.getEMPLOYEE_LAST_NAME() %>
                                            </option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5>Detalles de la Compra</h5>
                                    <button type="button" class="btn btn-success btn-sm" onclick="addProductRow()">
                                        <i class="fas fa-plus me-1"></i> Agregar Producto
                                    </button>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered" id="productsTable">
                                        <thead class="table-light">
                                        <tr>
                                            <th width="40%">Producto</th>
                                            <th width="15%">Precio Unitario</th>
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
                                                       name="PURCHASE_DETAIL_PRICE" step="0.01" min="0">
                                            </td>
                                            <td>
                                                <input type="number" class="form-control quantity-input"
                                                       name="PURCHASE_DETAIL_QUANTITY" min="1" value="1"
                                                       oninput="calculateSubtotal(this)">
                                            </td>
                                            <td>
                                                <input type="number" class="form-control subtotal-input" readonly
                                                       name="PURCHASE_DETAIL_SUBTOTAL" step="0.01">
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
                                                   name="PURCHASE_TOTAL" readonly step="0.01">
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 mt-4">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">Registrar Compra</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de listado -->
            <div class="card mb-4 border-0" style="background-color: #f8f9fa;">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Compras Registradas</h5>
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
                    <!-- Filtros de búsqueda -->
                    <div class="search-box mb-3">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Proveedor" id="filterSupplier">
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
                                    <option value="A">Activos</option>
                                    <option value="I">Inactivos</option>
                                </select>
                            </div>
                            <div class="col-md-1 col-6">
                                <button class="btn btn-primary btn-sm search-btn w-100" onclick="filterTable()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla de compras -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Fecha</th>
                                <th>Proveedor</th>
                                <th>Empleado</th>
                                <th>Total</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="purchaseTableBody">
                            <%
                                String estadoFiltro = request.getParameter("estado");
                                List<PurchaseDTO> purchases = new PurchaseController().listAllPurchases();

                                if ("activos".equals(estadoFiltro)) {
                                    purchases = new PurchaseController().listActivePurchases();
                                } else if ("inactivos".equals(estadoFiltro)) {
                                    purchases = new PurchaseController().listInactivePurchases();
                                }

                                // Paginación
                                int paginaActual = 1;
                                String paginaParam = request.getParameter("pagina");
                                if (paginaParam != null && !paginaParam.isEmpty()) {
                                    paginaActual = Integer.parseInt(paginaParam);
                                }

                                int registrosPorPagina = 5;
                                int totalRegistros = purchases.size();
                                int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
                                int inicio = (paginaActual - 1) * registrosPorPagina;
                                int fin = Math.min(inicio + registrosPorPagina, totalRegistros);

                                if (purchases.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">No hay compras registradas</td>
                            </tr>
                            <%
                            } else {
                                for (int i = inicio; i < fin; i++) {
                                    PurchaseDTO purchase = purchases.get(i);

                                    // Obtener nombre del proveedor
                                    String supplierName = "Proveedor no encontrado";
                                    for (SupplierDTO supplier : suppliers) {
                                        if (supplier.getSUPPLIER_ID() == purchase.getSUPPLIER_ID()) {
                                            supplierName = supplier.getSUPPLIER_NAME();
                                            break;
                                        }
                                    }

                                    // Obtener nombre del empleado
                                    String employeeName = "Empleado no encontrado";
                                    for (EmployeeDTO employee : employees) {
                                        if (employee.getEMPLOYEE_ID() == purchase.getEMPLOYEE_ID()) {
                                            employeeName = employee.getEMPLOYEE_FIRST_NAME() + " " + employee.getEMPLOYEE_LAST_NAME();
                                            break;
                                        }
                                    }
                            %>
                            <tr>
                                <td><%= purchase.getPURCHASE_ID() %></td>
                                <td><%= purchase.getPURCHASE_DATE() %></td>
                                <td><%= supplierName %></td>
                                <td><%= employeeName %></td>
                                <td>S/ <%= String.format("%.2f", purchase.getPURCHASE_TOTAL()) %></td>
                                <td>
                                        <span class="badge <%= purchase.getPURCHASE_STATUS() == 'A' ? "bg-success" : "bg-secondary" %>">
                                            <%= purchase.getPURCHASE_STATUS() == 'A' ? "Activo" : "Inactivo" %>
                                        </span>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-1">
                                        <a href="PurchaseServlet?action=view&id=<%= purchase.getPURCHASE_ID() %>"
                                           class="btn btn-sm btn-info" title="Ver detalles">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                            </tbody>
                        </table>

                        <!-- Paginador -->
                        <% if (totalPaginas > 1) { %>
                        <nav aria-label="Paginación">
                            <ul class="pagination justify-content-center">
                                <li class="page-item <%= paginaActual == 1 ? "disabled" : "" %>">
                                    <a class="page-link" href="?estado=<%= estadoFiltro != null ? estadoFiltro : "todos" %>&pagina=<%= paginaActual - 1 %>">&laquo;</a>
                                </li>
                                <% for (int i = 1; i <= totalPaginas; i++) { %>
                                <li class="page-item <%= i == paginaActual ? "active" : "" %>">
                                    <a class="page-link" href="?estado=<%= estadoFiltro != null ? estadoFiltro : "todos" %>&pagina=<%= i %>"><%= i %></a>
                                </li>
                                <% } %>
                                <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : "" %>">
                                    <a class="page-link" href="?estado=<%= estadoFiltro != null ? estadoFiltro : "todos" %>&pagina=<%= paginaActual + 1 %>">&raquo;</a>
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

    window.jsPDF = window.jspdf.jsPDF;
    // Almacena todos los datos de compras en JavaScript
    const allPurchasesData = [
        <%
        PurchaseController purchaseController = new PurchaseController();
        SupplierController supplierController = new SupplierController();
        EmployeeController employeeController = new EmployeeController();

        List<PurchaseDTO> allPurchases = purchaseController.listAllPurchases();
        for (PurchaseDTO purchase : allPurchases) {
            SupplierDTO supplier = supplierController.getSupplierById(purchase.getSUPPLIER_ID());
            EmployeeDTO employee = employeeController.getEmployeeById(purchase.getEMPLOYEE_ID());

            String supplierName = supplier != null ?
                supplier.getSUPPLIER_NAME() : "Proveedor no encontrado";
            String employeeName = employee != null ?
                employee.getEMPLOYEE_FIRST_NAME() + " " + employee.getEMPLOYEE_LAST_NAME() : "Empleado no encontrado";

            String status = purchase.getPURCHASE_STATUS() == 'A' ? "Activo" : "Inactivo";
        %>
        {
            id: <%= purchase.getPURCHASE_ID() %>,
            fecha: "<%= purchase.getPURCHASE_DATE() %>",
            proveedor: "<%= supplierName.replace("\"", "\\\"") %>",
            empleado: "<%= employeeName.replace("\"", "\\\"") %>",
            total: <%= purchase.getPURCHASE_TOTAL() %>,
            estado: "<%= status %>"
        },
        <% } %>
    ];

    // Función para exportar a CSV
    function exportToCSV() {
        if (allPurchasesData.length === 0) {
            Swal.fire({
                icon: 'warning',
                title: 'No hay datos',
                text: 'No hay datos para exportar',
                confirmButtonColor: '#1abc9c'
            });
            return;
        }

        // Crear el contenido CSV
        let csvContent = "ID,Fecha,Proveedor,Empleado,Total,Estado\n";

        allPurchasesData.forEach(purchase => {
            const rowData = [
                purchase.id,
                purchase.fecha,
                purchase.proveedor,
                purchase.empleado,
                purchase.total,
                purchase.estado
            ];

            // Escapar comas y comillas
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
    link.setAttribute("download", "compras_happy_dent.csv");
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

// Función para exportar a Excel (XLSX)
function exportToXLS() {
    if (allPurchasesData.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'No hay datos',
            text: 'No hay datos para exportar',
            confirmButtonColor: '#1abc9c'
        });
        return;
    }

    // Crear un libro de Excel
    const workbook = XLSX.utils.book_new();
    const worksheetData = [];

    // Encabezados
    worksheetData.push([
        "ID", "Fecha", "Proveedor", "Empleado", "Total", "Estado"
    ]);

    // Datos
    allPurchasesData.forEach(purchase => {
        worksheetData.push([
            purchase.id,
            purchase.fecha,
            purchase.proveedor,
            purchase.empleado,
            purchase.total,
            purchase.estado
        ]);
    });

    const worksheet = XLSX.utils.aoa_to_sheet(worksheetData);
    XLSX.utils.book_append_sheet(workbook, worksheet, "Compras");

    // Generar y descargar el archivo
    XLSX.writeFile(workbook, "compras_happy_dent.xlsx");

    Swal.fire({
        icon: 'success',
        title: 'Exportación completada',
        text: 'Los datos se han exportado a Excel correctamente',
        confirmButtonColor: '#1abc9c'
    });
}

// Función para exportar a PDF
function exportTableToPDF() {
    if (allPurchasesData.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: 'No hay datos',
            text: 'No hay datos para exportar',
            confirmButtonColor: '#1abc9c'
        });
        return;
    }

    // Configuración del PDF
    const doc = new jsPDF({
        orientation: 'landscape'
    });

    // Título
    doc.setFontSize(18);
    doc.text('Reporte de Compras - Happy Dent', 14, 15);
    doc.setFontSize(12);

    // Formatear fecha
    const currentDate = new Date();
    const formattedDate = currentDate.getDate() + '/' + (currentDate.getMonth() + 1) + '/' + currentDate.getFullYear();
    doc.text('Generado el: ' + formattedDate, 14, 22);

    // Encabezados de la tabla
    const headers = [
        "ID",
        "Fecha",
        "Proveedor",
        "Empleado",
        "Total",
        "Estado"
    ];

    // Datos de la tabla
    const data = allPurchasesData.map(purchase => [
        purchase.id,
        purchase.fecha,
        purchase.proveedor,
        purchase.empleado,
        'S/ ' + purchase.total.toFixed(2),
        purchase.estado
    ]);

    // Generar la tabla en el PDF
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
            5: { cellWidth: 20 }
        }
    });

    // Guardar el PDF
    doc.save("compras_happy_dent.pdf");

    Swal.fire({
        icon: 'success',
        title: 'Exportación completada',
        text: 'Los datos se han exportado a PDF correctamente',
        confirmButtonColor: '#1abc9c'
    });
}


    // Función para confirmar eliminación de compra
    function confirmDelete(purchaseId) {
        Swal.fire({
            title: '¿Eliminar compra?',
            text: "Esta acción marcará la compra como inactiva",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'PurchaseServlet?action=delete&id=' + purchaseId;
            }
        });
    }

    // Función para agregar fila de producto
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
                       name="PURCHASE_DETAIL_PRICE" step="0.01" min="0">
            </td>
            <td>
                <input type="number" class="form-control quantity-input"
                       name="PURCHASE_DETAIL_QUANTITY" min="1" value="1"
                       oninput="calculateSubtotal(this)">
            </td>
            <td>
                <input type="number" class="form-control subtotal-input" readonly
                       name="PURCHASE_DETAIL_SUBTOTAL" step="0.01">
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

    // Función para actualizar precio cuando se selecciona un producto
    function updatePrice(selectElement) {
        const row = selectElement.closest('tr');
        const selectedOption = selectElement.options[selectElement.selectedIndex];
        const price = selectedOption.getAttribute('data-price');

        row.querySelector('.price-input').value = price;
        calculateSubtotal(row.querySelector('.quantity-input'));
    }

    // Función para calcular subtotal
    function calculateSubtotal(inputElement) {
        const row = inputElement.closest('tr');
        const price = parseFloat(row.querySelector('.price-input').value) || 0;
        const quantity = parseInt(inputElement.value) || 0;
        const subtotal = price * quantity;

        row.querySelector('.subtotal-input').value = subtotal.toFixed(2);
        calculateTotal();
    }

    // Función para calcular el total
    function calculateTotal() {
        let total = 0;
        document.querySelectorAll('.subtotal-input').forEach(input => {
            total += parseFloat(input.value) || 0;
        });

        document.getElementById('totalAmount').value = total.toFixed(2);
    }

    // Función para eliminar fila de producto
    function removeProductRow(button) {
        const row = button.closest('tr');
        if (document.querySelectorAll('#productsTable tbody tr').length > 1) {
            row.remove();
            calculateTotal();
            updateRemoveButtons();
        }
    }

    // Función para actualizar estado de botones de eliminar
    function updateRemoveButtons() {
        const rows = document.querySelectorAll('#productsTable tbody tr');
        rows.forEach((row, index) => {
            const button = row.querySelector('.btn-danger');
            button.disabled = rows.length <= 1;
        });
    }

    // Función para filtrar la tabla
    function filterTable() {
        const supplierFilter = document.getElementById('filterSupplier').value.toLowerCase();
        const employeeFilter = document.getElementById('filterEmployee').value.toLowerCase();
        const dateFromFilter = document.getElementById('filterDateFrom').value;
        const dateToFilter = document.getElementById('filterDateTo').value;
        const amountMinFilter = parseFloat(document.getElementById('filterAmountMin').value) || 0;
        const statusFilter = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#purchaseTableBody tr');

        rows.forEach(row => {
            if (row.cells.length < 7) return; // Saltar filas vacías

            const supplier = row.cells[2].textContent.toLowerCase();
            const employee = row.cells[3].textContent.toLowerCase();
            const dateStr = row.cells[1].textContent;
            const date = new Date(dateStr);
            const amountStr = row.cells[4].textContent.replace('S/ ', '').trim();
            const amount = parseFloat(amountStr) || 0;
            const status = row.cells[5].querySelector('.badge').textContent.trim() === 'Activo' ? 'A' : 'I';

            const supplierMatch = supplier.includes(supplierFilter) || supplierFilter === '';
            const employeeMatch = employee.includes(employeeFilter) || employeeFilter === '';
            const dateFromMatch = dateFromFilter === '' || new Date(dateFromFilter) <= date;
            const dateToMatch = dateToFilter === '' || new Date(dateToFilter) >= date;
            const amountMatch = amount >= amountMinFilter;
            const statusMatch = statusFilter === '' || status === statusFilter;

            if (supplierMatch && employeeMatch && dateFromMatch && dateToMatch && amountMatch && statusMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Validación del formulario de compra
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('purchaseForm');

        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // Validar que al menos un producto tenga cantidad y precio
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

            // Mostrar confirmación
            Swal.fire({
                title: '¿Registrar compra?',
                text: "¿Está seguro que desea registrar esta compra?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1abc9c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Registrando compra...',
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

        // Inicializar primera fila
        updateRemoveButtons();
        calculateTotal();
    });
</script>
</body>
</html>