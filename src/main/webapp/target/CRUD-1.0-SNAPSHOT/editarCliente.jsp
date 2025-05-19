<%@ page import="pe.edu.vallegrande.crud.dto.ClienteDTO" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ClienteController" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Editar Cliente</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">

</head>

<body>

<!-- Sidebar -->
<div id="wrapper">
    <div id="sidebar-wrapper" class="bg-dark">
        <div class="sidebar-heading text-center py-4 text-light fs-4 fw-bold">
            <i class="fas fa-bread-slice me-2"></i>PANADERIA
        </div>
        <div class="list-group list-group-flush">
            <a href="index.jsp" class="list-group-item list-group-item-action">Inicio</a>
            <a href="view/listadoClientes.jsp" class="list-group-item list-group-item-action active">Clientes</a>
            <a href="view/listadoEmpleados.jsp" class="list-group-item list-group-item-action">Empleados</a>
            <a href="view/listadoProductos.jsp" class="list-group-item list-group-item-action">Productos</a>
            <a href="view/listadoProveedores.jsp" class="list-group-item list-group-item-action">Proveedores</a>
            <a href="listadoCompras.jsp" class="list-group-item list-group-item-action">Compras</a>
            <a href="listadoVentas.jsp" class="list-group-item list-group-item-action">Ventas</a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <h1 class="mt-4">Editar Cliente</h1>

        <%
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ClienteServlet?action=list");
                return;
            }

            int clienteId;
            try {
                clienteId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/ClienteServlet?action=list");
                return;
            }

            ClienteController clienteController = new ClienteController();
            ClienteDTO cliente = clienteController.obtenerClientePorId(clienteId);

            if (cliente == null) {
                response.sendRedirect(request.getContextPath() + "/ClienteServlet?action=list");
                return;
            }
        %>

        <!-- Formulario para editar el cliente -->
        <div class="card mb-4">
            <div class="card-header">
                Editar Cliente
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/ClienteServlet?action=update" method="post" onsubmit="enviarFormulario(event)">
                    <div class="mb-3 row">
                        <div class="col-6">
                            <label for="clientFName" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="clientFName" name="CLIENT_FIRST_NAME" required>
                        </div>
                        <div class="col-6">
                            <label for="clientLastName" class="form-label">Apellido</label>
                            <input type="text" class="form-control" id="clientLastName" name="CLIENT_LAST_NAME" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="clientDocType" class="form-label">Tipo de Documento</label>
                        <select class="form-select" id="clientDocType" name="CLIENT_DOCUMENT_TYPE" required>
                            <option value="" disabled selected>Seleccione tipo de documento</option>
                            <option value="DNI">DNI</option>
                            <option value="CNE">CNE</option>
                            <option value="PAS">PAS</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="clientDNI" class="form-label">DNI</label>
                        <input type="text" class="form-control" id="clientDNI" name="CLIENT_DOCUMENT_NUMBER" required>
                    </div>
                    <div class="mb-3">
                        <label for="clientPhone" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="clientPhone" name="CLIENT_PHONE" required>
                    </div>
                    <div class="mb-3">
                        <label for="clientEmail" class="form-label">Correo Electrónico</label>
                        <input type="email" class="form-control" id="clientEmail" name="CLIENT_EMAIL">
                    </div>
                    <div class="mb-3">
                        <label for="clientBirthDate" class="form-label">Fecha de Nacimiento</label>
                        <input type="date" class="form-control" id="clientBirthDate" name="CLIENT_BIRTH_DATE">
                    </div>
                    <button type="submit" class="btn btn-primary">Registrar</button>
                    <a href="view/listadoClientes.jsp" class="btn btn-secondary">Cancelar</a>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
