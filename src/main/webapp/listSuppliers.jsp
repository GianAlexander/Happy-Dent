<%@ page import="java.util.List, pe.edu.vallegrande.crud.controller.SupplierController, pe.edu.vallegrande.crud.dto.SupplierDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Listado de Proveedores - Happy Dent</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div id="wrapper">
    <jsp:include page="sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="container-fluid px-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="page-title">Gestión de Proveedores</h1>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registrarProveedorModal">
                    <i class="fas fa-plus me-1"></i> Nuevo Proveedor
                </button>
            </div>

            <!-- Modal para nuevo proveedor -->
            <div class="modal fade" id="registrarProveedorModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-truck me-2"></i>Registrar Proveedor</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="supplierForm" action="${pageContext.request.contextPath}/SupplierServlet" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre del Proveedor</label>
                                        <input type="text" class="form-control" name="SUPPLIER_NAME" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">RUC</label>
                                        <input type="text" class="form-control" name="SUPPLIER_RUC" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" name="SUPPLIER_EMAIL" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Teléfono</label>
                                        <input type="text" class="form-control" name="SUPPLIER_PHONE" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Sitio Web</label>
                                        <input type="url" class="form-control" name="SUPPLIER_WEBSITE">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tipo de Proveedor</label>
                                        <select class="form-select" name="SUPPLIER_TYPE" required>
                                            <option value="Equipos dentales">Equipos dentales</option>
                                            <option value="Materiales dentales">Materiales dentales</option>
                                            <option value="Insumos médicos">Insumos médicos</option>
                                            <option value="Mobiliario clínico">Mobiliario clínico</option>
                                            <option value="Otros">Otros</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Dirección</label>
                                    <textarea class="form-control" name="SUPPLIER_ADDRESS" rows="2" required></textarea>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">Registrar</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta optimizada -->
            <div class="card mb-4 border-0" style="background-color: #f8f9fa;">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Proveedores</h5>
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
                            <div class="col-md-3 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Nombre" id="filterName">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="RUC" id="filterRuc">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Teléfono" id="filterPhone">
                            </div>
                            <div class="col-md-2 col-6">
                                <select class="form-select form-select-sm search-input" id="filterType">
                                    <option value="">Todos los tipos</option>
                                    <option value="Equipos dentales">Equipos dentales</option>
                                    <option value="Materiales dentales">Materiales dentales</option>
                                    <option value="Insumos médicos">Insumos médicos</option>
                                    <option value="Mobiliario clínico">Mobiliario clínico</option>
                                    <option value="Otros">Otros</option>
                                </select>
                            </div>
                            <div class="col-md-2 col-6">
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

                    <!-- Tabla optimizada -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Nombre</th>
                                <th>RUC</th>
                                <th>Teléfono</th>
                                <th>Email</th>
                                <th>Tipo</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="supplierTableBody">
                            <%
                                String estadoFiltro = request.getParameter("estado");
                                List<SupplierDTO> suppliers = new SupplierController().listAll();

                                if ("activos".equals(estadoFiltro)) {
                                    suppliers = new SupplierController().listActive();
                                } else if ("inactivos".equals(estadoFiltro)) {
                                    suppliers = new SupplierController().listInactive();
                                }

                                // Paginación
                                int paginaActual = 1;
                                String paginaParam = request.getParameter("pagina");
                                if (paginaParam != null && !paginaParam.isEmpty()) {
                                    paginaActual = Integer.parseInt(paginaParam);
                                }

                                int registrosPorPagina = 5;
                                int totalRegistros = suppliers.size();
                                int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
                                int inicio = (paginaActual - 1) * registrosPorPagina;
                                int fin = Math.min(inicio + registrosPorPagina, totalRegistros);

                                if (suppliers.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">No hay proveedores registrados</td>
                            </tr>
                            <%
                            } else {
                                for (int i = inicio; i < fin; i++) {
                                    SupplierDTO supplier = suppliers.get(i);
                            %>
                            <tr>
                                <td><%= supplier.getSUPPLIER_NAME() %></td>
                                <td><%= supplier.getSUPPLIER_RUC() %></td>
                                <td><%= supplier.getSUPPLIER_PHONE() %></td>
                                <td><%= supplier.getSUPPLIER_EMAIL() %></td>
                                <td><%= supplier.getSUPPLIER_TYPE() %></td>
                                <td><span class="badge <%= "A".equals(supplier.getSUPPLIER_STATUS()) ? "bg-success" : "bg-secondary" %>">
                                    <%= "A".equals(supplier.getSUPPLIER_STATUS()) ? "Activo" : "Inactivo" %>
                                </span></td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-1">
                                        <!-- Botón View (siempre visible) -->
                                        <a href="SupplierServlet?action=view&id=<%= supplier.getSUPPLIER_ID() %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <% if ("A".equals(supplier.getSUPPLIER_STATUS())) { %>
                                        <a href="SupplierServlet?action=edit&id=<%= supplier.getSUPPLIER_ID() %>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="#" onclick="confirmDelete('<%= supplier.getSUPPLIER_ID() %>')" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                        <% } else { %>
                                        <form action="SupplierServlet" method="post" class="d-inline">
                                            <input type="hidden" name="id" value="<%= supplier.getSUPPLIER_ID() %>">
                                            <input type="hidden" name="action" value="restore">
                                            <button type="submit" class="btn btn-sm btn-success">
                                                <i class="fas fa-undo"></i>
                                            </button>
                                        </form>
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

                        <!-- Paginador optimizado -->
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
    // Función para confirmar eliminación de proveedor
    function confirmDelete(supplierId) {
        Swal.fire({
            title: '¿Eliminar proveedor?',
            text: "Esta acción marcará el proveedor como inactivo",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                // Redirigir a la acción de eliminación
                window.location.href = 'SupplierServlet?action=delete&id=' + supplierId;
            }
        });
    }

    // Función para filtrar la tabla
    function filterTable() {
        const nameFilter = document.getElementById('filterName').value.toLowerCase();
        const rucFilter = document.getElementById('filterRuc').value.toLowerCase();
        const phoneFilter = document.getElementById('filterPhone').value.toLowerCase();
        const typeFilter = document.getElementById('filterType').value.toLowerCase();
        const statusFilter = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#supplierTableBody tr');

        rows.forEach(row => {
            const name = row.cells[0].textContent.toLowerCase();
            const ruc = row.cells[1].textContent.toLowerCase();
            const phone = row.cells[2].textContent.toLowerCase();
            const type = row.cells[4].textContent.toLowerCase();
            const status = row.cells[5].querySelector('.badge').textContent.trim() === 'Activo' ? 'A' : 'I';

            const nameMatch = name.includes(nameFilter) || nameFilter === '';
            const rucMatch = ruc.includes(rucFilter) || rucFilter === '';
            const phoneMatch = phone.includes(phoneFilter) || phoneFilter === '';
            const typeMatch = typeFilter === '' || type === typeFilter.toLowerCase();
            const statusMatch = statusFilter === '' || status === statusFilter;

            if (nameMatch && rucMatch && phoneMatch && typeMatch && statusMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Filtrar al cargar la página
    document.addEventListener('DOMContentLoaded', function () {
        filterTable();
    });

    // Filtrar al presionar Enter en cualquier campo
    document.querySelectorAll('#filterName, #filterRuc, #filterPhone, #filterType, #filterStatus').forEach(input => {
        input.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                filterTable();
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('supplierForm');

        // Validación para RUC (11 dígitos)
        form.querySelector('input[name="SUPPLIER_RUC"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 11) {
                this.value = this.value.substring(0, 11);
            }
        });

        // Validación para teléfono (9 dígitos que empieza con 9)
        form.querySelector('input[name="SUPPLIER_PHONE"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 9) {
                this.value = this.value.substring(0, 9);
            }
        });

        // Validación al enviar el formulario
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // Campos a validar
            const ruc = form.querySelector('input[name="SUPPLIER_RUC"]');
            const phone = form.querySelector('input[name="SUPPLIER_PHONE"]');
            const email = form.querySelector('input[name="SUPPLIER_EMAIL"]');

            let isValid = true;

            // Validar RUC (11 dígitos)
            if (!/^\d{11}$/.test(ruc.value)) {
                showError(ruc, 'El RUC debe tener exactamente 11 dígitos');
                isValid = false;
            }

            // Validar teléfono (9 dígitos que empieza con 9)
            if (!/^9\d{8}$/.test(phone.value)) {
                showError(phone, 'El teléfono debe tener 9 dígitos y comenzar con 9');
                isValid = false;
            }

            // Validar email
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
                showError(email, 'Ingrese un correo electrónico válido');
                isValid = false;
            }

            if (!isValid) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error de validación',
                    text: 'Por favor corrija los campos marcados',
                    confirmButtonColor: '#1abc9c'
                });
                return;
            }

            // Mostrar confirmación
            Swal.fire({
                title: '¿Registrar proveedor?',
                text: "¿Está seguro que desea registrar este proveedor?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1abc9c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Registrando proveedor...',
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

        function showError(field, message) {
            // Eliminar mensaje de error previo si existe
            const existingError = field.nextElementSibling;
            if (existingError && existingError.classList.contains('invalid-feedback')) {
                existingError.remove();
            }

            // Crear nuevo elemento de error
            const errorElement = document.createElement('div');
            errorElement.className = 'invalid-feedback';
            errorElement.textContent = message;
            field.parentNode.appendChild(errorElement);
            field.classList.add('is-invalid');
        }
    });
</script>
</body>
</html>