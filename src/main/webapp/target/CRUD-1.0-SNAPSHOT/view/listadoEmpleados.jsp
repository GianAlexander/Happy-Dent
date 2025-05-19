<%@ page import="java.util.List" %>
<%@ page import="pe.edu.vallegrande.crud.controller.EmpleadoController" %>
<%@ page import="pe.edu.vallegrande.crud.dto.EmpleadoDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Listado de Empleados</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- Custom CSS -->
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
        <a href="listadoEmpleados.jsp" class="list-group-item list-group-item-action active">Empleados</a>
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
        <h1 class="mt-4">Listado de Empleados</h1>

        <!-- Formulario para registrar un nuevo empleado -->
        <div class="container mt-5">
            <h2>Registrar Empleado</h2>
            <form action="EmpleadoServlet?action=add" method="post">
                <div class="mb-3 row">
                    <div class="col-6">
                        <label for="employeeFirstName" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="employeeFirstName" name="EMPLOYEE_FIRST_NAME" required>
                    </div>
                    <div class="col-6">
                        <label for="employeeLastName" class="form-label">Apellido</label>
                        <input type="text" class="form-control" id="employeeLastName" name="EMPLOYEE_LAST_NAME" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="employeeDocType" class="form-label">Tipo de Documento</label>
                    <select class="form-select" id="employeeDocType" name="EMPLOYEE_DOCUMENT_TYPE" required>
                        <option value="" disabled selected>Seleccione tipo de documento</option>
                        <option value="DNI">DNI</option>
                        <option value="CNE">CNE</option>
                        <option value="PAS">PAS</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="employeeDocNumber" class="form-label">Número de Documento</label>
                    <input type="text" class="form-control" id="employeeDocNumber" name="EMPLOYEE_DOCUMENT_NUMBER" required>
                </div>
                <div class="mb-3">
                    <label for="employeePhone" class="form-label">Teléfono</label>
                    <input type="text" class="form-control" id="employeePhone" name="EMPLOYEE_PHONE" required>
                </div>
                <div class="mb-3">
                    <label for="employeeEmail" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="employeeEmail" name="EMPLOYEE_EMAIL">
                </div>
                <div class="mb-3">
                    <label for="employeeBirthDate" class="form-label">Fecha de Nacimiento</label>
                    <input type="date" class="form-control" id="employeeBirthDate" name="EMPLOYEE_BIRTH_DATE">
                </div>
                <button type="submit" class="btn btn-primary">Registrar</button>
                <a href="listadoEmpleados.jsp" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>

        <!-- Listado de empleados -->
        <div class="card mb-4" style="max-width: 90%; margin: auto;">
            <div class="card-header" style="background-color: #ff5900; color: white;">
                <h5>Listado de Empleados</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered">
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
                            <form action="listadoEmpleados.jsp" method="get" class="d-flex">
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
                            EmpleadoController empleadoController = new EmpleadoController();
                            List<EmpleadoDTO> empleados;

                            if ("activos".equals(estadoFiltro)) {
                                empleados = empleadoController.listarActivos();
                            } else if ("inactivos".equals(estadoFiltro)) {
                                empleados = empleadoController.listarInactivos();
                            } else {
                                empleados = empleadoController.listarTodos();
                            }

                            if (empleados.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-muted">No hay empleados disponibles por el momento.</td>
                        </tr>
                        <%
                        } else {
                            for (EmpleadoDTO empleado : empleados) {
                        %>
                        <tr>
                            <td><%= empleado.getEMPLOYEE_ID() %></td>
                            <td><%= empleado.getEMPLOYEE_FIRST_NAME() + " " + empleado.getEMPLOYEE_LAST_NAME() %></td>
                            <td><%= empleado.getEMPLOYEE_DOCUMENT_NUMBER() %></td>
                            <td><%= empleado.getEMPLOYEE_PHONE() %></td>
                            <td><%= empleado.getEMPLOYEE_EMAIL() %></td>
                            <td><%= empleado.getEMPLOYEE_DOCUMENT_TYPE() %></td>
                            <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(empleado.getEMPLOYEE_BIRTH_DATE()) %></td>
                            <td class="text-center">
                                <a href="EmpleadoServlet?action=edit&id=<%= empleado.getEMPLOYEE_ID() %>" class="btn btn-primary btn-sm">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <%
                                    if ("I".equals(empleado.getEMPLOYEE_STATUS())) { // Si está inactivo
                                %>
                                <form action="EmpleadoServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= empleado.getEMPLOYEE_ID() %>"/>
                                    <input type="hidden" name="action" value="restore"/> <!-- Acción para restaurar -->
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                </form>
                                <%
                                } else { // Si está activo
                                %>
                                <form action="EmpleadoServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= empleado.getEMPLOYEE_ID() %>"/>
                                    <input type="hidden" name="action" value="delete"/> <!-- Acción para eliminar -->
                                    <button type="submit" class="btn btn-danger btn-sm">
                                        <i class="fas fa-trash"></i>
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

<!-- Bootstrap JS and dependencies -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
</body>

</html>
