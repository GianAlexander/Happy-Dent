<%@ page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ProveedorController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.ProveedorDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Listado de Proveedores</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.6/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.14/jspdf.plugin.autotable.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
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
        <a href="listadoProductos.jsp" class="list-group-item list-group-item-action">Productos</a>
        <a href="listadoProveedores.jsp" class="list-group-item list-group-item-action active">Proveedores</a>
        <a href="listadoCompras.jsp" class="list-group-item list-group-item-action">Compras</a>
        <a href="listadoVentas.jsp" class="list-group-item list-group-item-action">Ventas</a>
    </div>
</div>

<!-- Page Content -->
<div id="page-content-wrapper">

    <!-- Content -->
    <div class="container-fluid">
        <h1 class="mt-4">Listado de Proveedores</h1>

        <!-- Card para agregar un nuevo proveedor -->
        <div class="container mt-5">
            <h2>Registrar Proveedor</h2>
            <form action="<%= request.getContextPath() %>/ProveedorServlet?action=add" method="post">
                <div class="mb-3">
                    <label for="supplierName" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="supplierName" name="SUPPLIER_NAME" required>
                </div>
                <div class="mb-3">
                    <label for="supplierRUC" class="form-label">RUC</label>
                    <input type="text" class="form-control" id="supplierRUC" name="SUPPLIER_RUC" required>
                </div>
                <div class="mb-3">
                    <label for="supplierEmail" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="supplierEmail" name="SUPPLIER_EMAIL">
                </div>
                <div class="mb-3">
                    <label for="supplierPhone" class="form-label">Teléfono</label>
                    <input type="text" class="form-control" id="supplierPhone" name="SUPPLIER_PHONE">
                </div>
                <div class="mb-3">
                    <label for="supplierAddress" class="form-label">Dirección</label>
                    <input type="text" class="form-control" id="supplierAddress" name="SUPPLIER_ADDRESS">
                </div>
                <div class="mb-3">
                    <label for="supplierWebsite" class="form-label">Sitio Web</label>
                    <input type="text" class="form-control" id="supplierWebsite" name="SUPPLIER_WEBSITE">
                </div>
                <button type="submit" class="btn btn-primary">Registrar</button>
                <a href="listadoProveedores.jsp" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>

        <!-- Card para listado de proveedores -->
        <div class="card mb-4" style="max-width: 90%; margin: auto;">
            <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff5900; color: white;">
                <h5 class="mb-0">Listado de Proveedores</h5>
            </div>

            <div class="card-body">

                <div class="table-responsive">
                    <table class="table table-hover table-bordered">
                        <thead class="table-secondary">
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>RUC</th>
                            <th>Teléfono</th>
                            <th>Correo</th>
                            <th>Dirección</th>
                            <th>Sitio Web</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            ProveedorController proveedorController = new ProveedorController();
                            List<ProveedorDTO> proveedores = proveedorController.listarTodos();

                            if (proveedores.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-muted">No hay proveedores disponibles por el momento.</td>
                        </tr>
                        <%
                        } else {
                            for (ProveedorDTO proveedor : proveedores) {
                        %>
                        <tr>
                            <td><%= proveedor.getSUPPLIER_ID() %></td>
                            <td><%= proveedor.getSUPPLIER_NAME() %></td>
                            <td><%= proveedor.getSUPPLIER_RUC() %></td>
                            <td><%= proveedor.getSUPPLIER_PHONE() %></td>
                            <td><%= proveedor.getSUPPLIER_EMAIL() %></td>
                            <td><%= proveedor.getSUPPLIER_ADDRESS() %></td>
                            <td><%= proveedor.getSUPPLIER_WEBSITE() %></td>
                            <td class="text-center">
                                <a href="ProveedorServlet?action=edit&id=<%= proveedor.getSUPPLIER_ID() %>" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <form action="ProveedorServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= proveedor.getSUPPLIER_ID() %>"/>
                                    <input type="hidden" name="action" value="delete"/>
                                    <button type="submit" class="btn btn-danger btn-sm">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </form>
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
