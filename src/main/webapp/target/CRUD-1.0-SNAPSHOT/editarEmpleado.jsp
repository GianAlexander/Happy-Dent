<%@ page import="pe.edu.vallegrande.crud.dto.EmpleadoDTO" %>
<%@ page import="pe.edu.vallegrande.crud.controller.EmpleadoController" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <title>Editar Empleado</title>

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
    <a href="index.jsp" class="list-group-item list-group-item-action">Inicio</a>
    <a href="view/listadoClientes.jsp" class="list-group-item list-group-item-action">Clientes</a>
    <a href="view/listadoEmpleados.jsp" class="list-group-item list-group-item-action active">Empleados</a>
    <a href="view/listadoProductos.jsp" class="list-group-item list-group-item-action">Productos</a>
    <a href="view/listadoProveedores.jsp" class="list-group-item list-group-item-action">Proveedores</a>
    <a href="listadoCompras.jsp" class="list-group-item list-group-item-action">Compras</a>
    <a href="listadoVentas.jsp" class="list-group-item list-group-item-action">Ventas</a>
  </div>
</div>

<!-- Page Content -->
<div id="page-content-wrapper">
  <h1 class="mt-4">Editar Empleado</h1>

  <%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
      response.sendRedirect(request.getContextPath() + "/EmpleadoServlet?action=list");
      return;
    }

    int empleadoId;
    try {
      empleadoId = Integer.parseInt(idStr);
    } catch (NumberFormatException e) {
      response.sendRedirect(request.getContextPath() + "/EmpleadoServlet?action=list");
      return;
    }

    EmpleadoController empleadoController = new EmpleadoController();
    EmpleadoDTO empleado = empleadoController.obtenerEmpleadoPorId(empleadoId);

    if (empleado == null) {
      response.sendRedirect(request.getContextPath() + "/EmpleadoServlet?action=list");
      return;
    }
  %>

  <!-- Formulario para editar el empleado -->
  <div class="card mb-4">
    <div class="card-header">
      Editar Empleado
    </div>
    <div class="card-body">
      <form action="../EmpleadoServlet?action=update" method="post">
        <input type="hidden" name="EMPLOYEE_ID" value="<%= empleado.getEMPLOYEE_ID() %>">

        <div class="mb-3">
          <label for="employeeFirstName" class="form-label">Nombre</label>
          <input type="text" class="form-control" id="employeeFirstName" name="EMPLOYEE_FIRST_NAME" value="<%= empleado.getEMPLOYEE_FIRST_NAME() %>" required>
        </div>
        <div class="mb-3">
          <label for="employeeLastName" class="form-label">Apellido</label>
          <input type="text" class="form-control" id="employeeLastName" name="EMPLOYEE_LAST_NAME" value="<%= empleado.getEMPLOYEE_LAST_NAME() %>" required>
        </div>
        <div class="mb-3">
          <label for="employeeDocumentNumber" class="form-label">Número de Documento</label>
          <input type="text" class="form-control" id="employeeDocumentNumber" name="EMPLOYEE_DOCUMENT_NUMBER" value="<%= empleado.getEMPLOYEE_DOCUMENT_NUMBER() %>" required>
        </div>
        <div class="mb-3">
          <label for="employeePhone" class="form-label">Teléfono</label>
          <input type="text" class="form-control" id="employeePhone" name="EMPLOYEE_PHONE" value="<%= empleado.getEMPLOYEE_PHONE() %>" required>
        </div>
        <div class="mb-3">
          <label for="employeeEmail" class="form-label">Correo Electrónico</label>
          <input type="email" class="form-control" id="employeeEmail" name="EMPLOYEE_EMAIL" value="<%= empleado.getEMPLOYEE_EMAIL() %>">
        </div>
        <div class="mb-3">
          <label for="employeeDocumentType" class="form-label">Tipo de Documento</label>
          <input type="text" class="form-control" id="employeeDocumentType" name="EMPLOYEE_DOCUMENT_TYPE" value="<%= empleado.getEMPLOYEE_DOCUMENT_TYPE() %>">
        </div>
        <div class="mb-3">
          <label for="employeeBirthDate" class="form-label">Fecha de Nacimiento</label>
          <input type="date" class="form-control" id="employeeBirthDate" name="EMPLOYEE_BIRTH_DATE" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(empleado.getEMPLOYEE_BIRTH_DATE()) %>">
        </div>
        <div class="mb-3">
          <label for="employeeStatus" class="form-label">Estado</label>
          <select class="form-select" id="employeeStatus" name="EMPLOYEE_STATUS">
            <option value="A" <%= "A".equals(empleado.getEMPLOYEE_STATUS()) ? "selected" : "" %>>Activo</option>
            <option value="I" <%= "I".equals(empleado.getEMPLOYEE_STATUS()) ? "selected" : "" %>>Inactivo</option>
          </select>
        </div>

        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
        <a href="view/listadoEmpleados.jsp" class="btn btn-secondary">Cancelar</a>
      </form>
    </div>
  </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>
