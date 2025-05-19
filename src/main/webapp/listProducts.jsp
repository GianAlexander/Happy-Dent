<%@ page import="java.util.List, pe.edu.vallegrande.crud.controller.ProductController, pe.edu.vallegrande.crud.dto.ProductDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Listado de Productos - Happy Dent</title>

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
                <h1 class="page-title">Gestión de Productos</h1>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registrarProductoModal">
                    <i class="fas fa-plus me-1"></i> Nuevo Producto
                </button>
            </div>

            <!-- Modal para nuevo producto -->
            <div class="modal fade" id="registrarProductoModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-box me-2"></i>Registrar Producto</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="productForm" action="${pageContext.request.contextPath}/ProductServlet" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre del Producto</label>
                                        <input type="text" class="form-control" name="PRODUCT_NAME" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Marca</label>
                                        <input type="text" class="form-control" name="PRODUCT_BRAND" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Presentación</label>
                                        <input type="text" class="form-control" name="PRODUCT_PRESENTATION" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Stock</label>
                                        <input type="number" class="form-control" name="PRODUCT_STOCK" min="0" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Precio (S/)</label>
                                        <input type="number" step="0.01" class="form-control" name="PRODUCT_PRICE" min="0" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha de Expiración</label>
                                        <input type="date" class="form-control" name="PRODUCT_EXPIRATION_DATE" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Lote</label>
                                        <input type="text" class="form-control" name="PRODUCT_BATCH" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Descripción</label>
                                    <textarea class="form-control" name="PRODUCT_DESCRIPTION" rows="3"></textarea>
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
                    <h5 class="mb-0">Productos</h5>
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
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Marca" id="filterBrand">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Lote" id="filterBatch">
                            </div>
                            <div class="col-md-2 col-6">
                                <select class="form-select form-select-sm search-input" id="filterStock">
                                    <option value="">Stock</option>
                                    <option value="low">Bajo stock (<10)</option>
                                    <option value="normal">Stock normal</option>
                                    <option value="out">Agotados</option>
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
                                <th>Marca</th>
                                <th>Presentación</th>
                                <th>Stock</th>
                                <th>Precio</th>
                                <th>Lote</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="productTableBody">
                            <%
                                String estadoFiltro = request.getParameter("estado");
                                List<ProductDTO> products = new ProductController().listAll();

                                if ("activos".equals(estadoFiltro)) {
                                    products = new ProductController().listActive();
                                } else if ("inactivos".equals(estadoFiltro)) {
                                    products = new ProductController().listInactive();
                                }

                                // Paginación
                                int paginaActual = 1;
                                String paginaParam = request.getParameter("pagina");
                                if (paginaParam != null && !paginaParam.isEmpty()) {
                                    paginaActual = Integer.parseInt(paginaParam);
                                }

                                int registrosPorPagina = 5;
                                int totalRegistros = products.size();
                                int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
                                int inicio = (paginaActual - 1) * registrosPorPagina;
                                int fin = Math.min(inicio + registrosPorPagina, totalRegistros);

                                if (products.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-4">No hay productos registrados</td>
                            </tr>
                            <%
                            } else {
                                for (int i = inicio; i < fin; i++) {
                                    ProductDTO product = products.get(i);
                            %>
                            <tr>
                                <td><%= product.getPRODUCT_NAME() %></td>
                                <td><%= product.getPRODUCT_BRAND() %></td>
                                <td><%= product.getPRODUCT_PRESENTATION() %></td>
                                <td>
                                    <span class="badge <%= product.getPRODUCT_STOCK() < 10 ? (product.getPRODUCT_STOCK() == 0 ? "bg-danger" : "bg-warning") : "bg-success" %>">
                                        <%= product.getPRODUCT_STOCK() %>
                                    </span>
                                </td>
                                <td>S/ <%= String.format("%.2f", product.getPRODUCT_PRICE()) %></td>
                                <td><%= product.getPRODUCT_BATCH() %></td>
                                <td><span class="badge <%= "A".equals(product.getPRODUCT_STATUS()) ? "bg-success" : "bg-secondary" %>">
                                    <%= "A".equals(product.getPRODUCT_STATUS()) ? "Activo" : "Inactivo" %>
                                </span></td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-1">
                                        <!-- Botón View (siempre visible) -->
                                        <a href="ProductServlet?action=view&id=<%= product.getPRODUCT_ID() %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <% if ("A".equals(product.getPRODUCT_STATUS())) { %>
                                        <a href="ProductServlet?action=edit&id=<%= product.getPRODUCT_ID() %>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="#" onclick="confirmDelete('<%= product.getPRODUCT_ID() %>')" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                        <% } else { %>
                                        <form action="ProductServlet" method="post" class="d-inline">
                                            <input type="hidden" name="id" value="<%= product.getPRODUCT_ID() %>">
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
    function confirmDelete(productId) {
        Swal.fire({
            title: '¿Eliminar producto?',
            text: "Esta acción no se puede deshacer",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                // Redirigir a la acción de eliminación
                window.location.href = 'ProductServlet?action=delete&id=' + productId;
            }
        });
    }

    function filterTable() {
        const nameFilter = document.getElementById('filterName').value.toLowerCase();
        const brandFilter = document.getElementById('filterBrand').value.toLowerCase();
        const batchFilter = document.getElementById('filterBatch').value.toLowerCase();
        const stockFilter = document.getElementById('filterStock').value;
        const statusFilter = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#productTableBody tr');

        rows.forEach(row => {
            const name = row.cells[0].textContent.toLowerCase();
            const brand = row.cells[1].textContent.toLowerCase();
            const batch = row.cells[5].textContent.toLowerCase();
            const stock = parseInt(row.cells[3].textContent.trim());
            const status = row.cells[6].querySelector('.badge').textContent.trim() === 'Activo' ? 'A' : 'I';

            const nameMatch = name.includes(nameFilter) || nameFilter === '';
            const brandMatch = brand.includes(brandFilter) || brandFilter === '';
            const batchMatch = batch.includes(batchFilter) || batchFilter === '';

            let stockMatch = true;
            if (stockFilter === 'low') {
                stockMatch = stock < 10;
            } else if (stockFilter === 'normal') {
                stockMatch = stock >= 10;
            } else if (stockFilter === 'out') {
                stockMatch = stock === 0;
            }

            const statusMatch = statusFilter === '' || status === statusFilter;

            if (nameMatch && brandMatch && batchMatch && stockMatch && statusMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        filterTable();
    });

    document.querySelectorAll('#filterName, #filterBrand, #filterBatch, #filterStock, #filterStatus').forEach(input => {
        input.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                filterTable();
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('productForm');

        form.querySelector('input[name="PRODUCT_STOCK"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
        });

        form.querySelector('input[name="PRODUCT_PRICE"]').addEventListener('input', function(e) {
            if (this.value.includes('.')) {
                const parts = this.value.split('.');
                if (parts.length > 1 && parts[1].length > 2) {
                    this.value = parts[0] + '.' + parts[1].substring(0, 2);
                }
            }
        });

        form.querySelector('input[name="PRODUCT_EXPIRATION_DATE"]').addEventListener('change', function() {
            const expirationDate = new Date(this.value);
            const today = new Date();
            if (expirationDate <= today) {
                const errorElement = document.createElement('div');
                errorElement.className = 'invalid-feedback';
                errorElement.textContent = 'La fecha de expiración debe ser futura';
                this.parentNode.appendChild(errorElement);
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                const errorElement = this.nextElementSibling;
                if (errorElement && errorElement.classList.contains('invalid-feedback')) {
                    errorElement.remove();
                }
            }
        });

        // Validación al enviar el formulario
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // Campos a validar
            const name = form.querySelector('input[name="PRODUCT_NAME"]');
            const brand = form.querySelector('input[name="PRODUCT_BRAND"]');
            const presentation = form.querySelector('input[name="PRODUCT_PRESENTATION"]');
            const stock = form.querySelector('input[name="PRODUCT_STOCK"]');
            const price = form.querySelector('input[name="PRODUCT_PRICE"]');
            const batch = form.querySelector('input[name="PRODUCT_BATCH"]');

            let isValid = true;

            // Validar campos requeridos
            if (!name.value.trim()) {
                name.classList.add('is-invalid');
                isValid = false;
            }

            if (!brand.value.trim()) {
                brand.classList.add('is-invalid');
                isValid = false;
            }

            if (!presentation.value.trim()) {
                presentation.classList.add('is-invalid');
                isValid = false;
            }

            if (!stock.value.trim() || parseInt(stock.value) < 0) {
                stock.classList.add('is-invalid');
                isValid = false;
            }

            if (!price.value.trim() || parseFloat(price.value) <= 0) {
                price.classList.add('is-invalid');
                isValid = false;
            }


            if (!batch.value.trim()) {
                batch.classList.add('is-invalid');
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
                title: '¿Registrar producto?',
                text: "¿Está seguro que desea registrar este producto?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1abc9c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Registrando producto...',
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
    });
</script>
</body>
</html>