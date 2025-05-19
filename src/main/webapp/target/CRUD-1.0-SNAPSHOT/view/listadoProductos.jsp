<%@ page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ProductoController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.ProductoDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Listado de Productos</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.6/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.14/jspdf.plugin.autotable.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <script src="${pageContext.request.contextPath}/asset/ProductScript.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>

<body>

<!-- Sidebar -->
<div id="sidebar-wrapper" class="bg-dark">
    <div class="sidebar-heading text-center py-4 text-light fs-4 fw-bold">
        <i class="fas fa-bread-slice me-2"></i>PANADERIA
    </div>
    <div class="list-group list-group-flush">
        <a href="../index.jsp" class="list-group-item list-group-item-action">Inicio</a>
        <a href="listadoClientes.jsp" class="list-group-item list-group-item-action">Clientes</a>
        <a href="listadoEmpleados.jsp" class="list-group-item list-group-item-action">Empleados</a>
        <a href="listadoProductos.jsp" class="list-group-item list-group-item-action active">Productos</a>
        <a href="listadoProveedores.jsp" class="list-group-item list-group-item-action">Proveedores</a>
        <a href="listadoCompras.jsp" class="list-group-item list-group-item-action">Compras</a>
        <a href="listadoVentas.jsp" class="list-group-item list-group-item-action">Ventas</a>
    </div>
</div>

<!-- Page Content -->
<div id="page-content-wrapper">
    <div class="container-fluid">
        <h1 class="mt-4">Listado de Productos</h1>

        <!-- Formulario para agregar un nuevo producto -->
        <div class="container mt-5">
            <h2>Registrar Producto</h2>
            <form action="<%= request.getContextPath() %>/ProductoServlet?action=add" method="post">
                <div class="mb-3">
                    <label for="productName" class="form-label">Nombre del Producto</label>
                    <input type="text" class="form-control" id="productName" name="PRODUCT_NAME" required>
                </div>
                <div class="mb-3">
                    <label for="productCategory" class="form-label">Categoría</label>
                    <input type="text" class="form-control" id="productCategory" name="PRODUCT_CATEGORY" required>
                </div>
                <div class="mb-3">
                    <label for="productPrice" class="form-label">Precio</label>
                    <input type="number" step="0.01" class="form-control" id="productPrice" name="PRODUCT_PRICE" required>
                </div>
                <div class="mb-3">
                    <label for="productStock" class="form-label">Stock</label>
                    <input type="number" class="form-control" id="productStock" name="PRODUCT_STOCK" required>
                </div>
                <div class="mb-3">
                    <label for="productExpiryDate" class="form-label">Fecha de Expiración</label>
                    <input type="date" class="form-control" id="productExpiryDate" name="PRODUCT_EXPIRY_DATE" required>
                </div>
                <button type="submit" class="btn btn-primary">Registrar</button>
                <a href="listadoProductos.jsp" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>

        <!-- Listado de productos -->
        <div class="card mb-4" style="max-width: 90%; margin: auto;">
            <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff5900; color: white;">
                <h5 class="mb-0">Listado de Productos</h5>
                <div class="dropdown">
                    <button class="btn btn-light dropdown-toggle" type="button" id="exportDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        Exportar Datos
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="exportDropdown">
                        <li><a class="dropdown-item" href="#" onclick="exportToCSV()">Exportar a CSV</a></li>
                        <li><a class="dropdown-item" href="#" onclick="exportToXLS()">Exportar a Excel</a></li>
                        <li><a class="dropdown-item" href="#" onclick="exportTableToPDF()">Exportar a PDF</a></li>
                    </ul>
                </div>
            </div>

            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered" id="productTable">
                        <thead class="table-secondary">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Categoría</th>
                            <th>Precio</th>
                            <th>Stock</th>
                            <th>Fecha de Expiración</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                        <tr>
                            <th colspan="8">
                                <form action="listadoProductos.jsp" method="get" class="d-flex">
                                    <select class="form-select" name="estado" onchange="this.form.submit()">
                                        <option value="">Seleccionar estado</option>
                                        <option value="todos">Todos</option>
                                        <option value="activos">Activos</option>
                                        <option value="inactivos">Inactivos</option>
                                    </select>
                                </form>
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            String estadoFiltro = request.getParameter("estado");
                            ProductoController productoController = new ProductoController();
                            List<ProductoDTO> productos;

                            if ("activos".equals(estadoFiltro)) {
                                productos = productoController.listarActivos();
                            } else if ("inactivos".equals(estadoFiltro)) {
                                productos = productoController.listarInactivos();
                            } else {
                                productos = productoController.listarTodos();
                            }

                            if (productos.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-muted">No hay productos disponibles.</td>
                        </tr>
                        <%
                        } else {
                            for (ProductoDTO producto : productos) {
                        %>
                        <tr>
                            <td><%= producto.getPRODUCT_ID() %></td>
                            <td><%= producto.getPRODUCT_NAME() %></td>
                            <td><%= producto.getPRODUCT_CATEGORY() %></td>
                            <td><%= producto.getPRODUCT_PRICE() %></td>
                            <td><%= producto.getPRODUCT_STOCK() %></td>
                            <td><%= producto.getPRODUCT_EXPIRY_DATE() %></td>
                            <td class="text-center">
                                <a href="ProductoServlet?action=edit&id=<%= producto.getPRODUCT_ID() %>" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <%
                                    if ("I".equals(producto.getPRODUCT_STATUS())) { // Si está inactivo
                                %>
                                <form action="ProductoServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= producto.getPRODUCT_ID() %>"/>
                                    <input type="hidden" name="action" value="restore"/>
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                </form>
                                <%
                                } else { // Si está activo
                                %>
                                <form action="ProductoServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= producto.getPRODUCT_ID() %>"/>
                                    <input type="hidden" name="action" value="delete"/>
                                    <button type="submit" class="btn btn-danger btn-sm">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
                                <%
                                    }
                                %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
