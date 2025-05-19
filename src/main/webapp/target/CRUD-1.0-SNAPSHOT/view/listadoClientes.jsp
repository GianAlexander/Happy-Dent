<%@ page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ClienteController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.ClienteDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Listado de Clientes</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.6/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.14/jspdf.plugin.autotable.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <script src="${pageContext.request.contextPath}/asset/ClienteScript.js"></script>
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
        <a href="listadoClientes.jsp" class="list-group-item list-group-item-action active">Clientes</a>
        <a href="listadoEmpleados.jsp" class="list-group-item list-group-item-action">Empleados</a>
        <a href="listadoProductos.jsp" class="list-group-item list-group-item-action">Productos</a>
        <a href="listadoProveedores.jsp" class="list-group-item list-group-item-action">Proveedores</a>
        <a href="listadoCompras.jsp" class="list-group-item list-group-item-action">Compras</a>
        <a href="listadoVentas.jsp" class="list-group-item list-group-item-action">Ventas</a>
    </div>
</div>

<!-- Page Content -->
<div id="page-content-wrapper">

    <!-- Content -->
    <div class="container-fluid">
        <h1 class="mt-4">Listado de Clientes</h1>

        <!-- Card para agregar un nuevo cliente -->
        <div class="container mt-5">
            <h2>Registrar Cliente</h2>
            <form action="<%= request.getContextPath() %>/ClienteServlet?action=add" method="post" onsubmit="enviarFormulario(event)">
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
                <a href="listadoClientes.jsp" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>

        <!-- Card para listado de clientes -->
        <div class="card mb-4" style="max-width: 90%; margin: auto;">
            <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff5900; color: white;">
                <h5 class="mb-0">Listado de Clientes</h5>

                <!-- Menú desplegable de exportación -->
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
                    <table class="table table-hover table-bordered" id="clientTable">
                        <thead class="table-secondary">
                        <tr>
                            <th>ID</th>
                            <th>Nombre Completo</th>
                            <th>Número de Doc.</th>
                            <th>Teléfono</th>
                            <th>Correo</th>
                            <th>Tipo de Doc.</th>
                            <th>Fecha de Nacimiento</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                        <tr>
                            <th colspan="8">
                                <form action="listadoClientes.jsp" method="get" class="d-flex">
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
                            ClienteController clientController = new ClienteController();
                            List<ClienteDTO> clients;

                            if ("activos".equals(estadoFiltro)) {
                                clients = clientController.listarActivos();
                            } else if ("inactivos".equals(estadoFiltro)) {
                                clients = clientController.listarInactivos();
                            } else {
                                clients = clientController.listarTodos();
                            }

                            if (clients.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-muted">No hay clientes disponibles por el momento.</td>
                        </tr>
                        <%
                        } else {
                            for (ClienteDTO client : clients) {
                        %>
                        <tr>
                            <td><%= client.getCLIENT_ID() %></td>
                            <td><%= client.getCLIENT_FIRST_NAME() + " " + client.getCLIENT_LAST_NAME() %></td>
                            <td><%= client.getCLIENT_DOCUMENT_NUMBER() %></td>
                            <td><%= client.getCLIENT_PHONE() %></td>
                            <td><%= client.getCLIENT_EMAIL() %></td>
                            <td><%= client.getCLIENT_DOCUMENT_TYPE() %></td>
                            <td><%= client.getCLIENT_BIRTH_DATE() %></td>
                            <td class="text-center">
                                <a href="ClienteServlet?action=edit&id=<%= client.getCLIENT_ID() %>" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <%
                                    if ("I".equals(client.getCLIENT_STATUS())) { // Si está inactivo
                                %>
                                <form action="ClienteServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= client.getCLIENT_ID() %>"/>
                                    <input type="hidden" name="action" value="restore"/> <!-- Acción para restaurar -->
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                </form>
                                <%
                                } else { // Si está activo
                                %>
                                <form action="ClienteServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= client.getCLIENT_ID() %>"/>
                                    <input type="hidden" name="action" value="delete"/> <!-- Acción para eliminar -->
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
