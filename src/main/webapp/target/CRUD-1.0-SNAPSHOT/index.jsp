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
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Panadería - Gestión</title>

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
            <a href="index.jsp" class="list-group-item list-group-item-action active">Inicio</a>
            <a href="view/listadoClientes.jsp" class="list-group-item list-group-item-action">Clientes</a>
            <a href="view/listadoEmpleados.jsp" class="list-group-item list-group-item-action">Empleados</a>
            <a href="view/listadoProductos.jsp" class="list-group-item list-group-item-action">Productos</a>
            <a href="view/listadoProveedores.jsp" class="list-group-item list-group-item-action">Proveedores</a>
            <a href="listadoCompras.jsp" class="list-group-item list-group-item-action">Compras</a>
            <a href="listadoVentas.jsp" class="list-group-item list-group-item-action">Ventas</a>
        </div>
    </div>

    <!-- Page Content -->
    <div id="page-content-wrapper">

        <!-- Content -->
        <div class="container-fluid px-4">
            <h1 class="mt-4">Bienvenido a la Gestión de la Panadería</h1>
            <p>Aquí puedes administrar clientes, productos, proveedores, compras y ventas de nuestra panadería. Utiliza el menú de la izquierda para navegar a través de las distintas secciones y realizar las operaciones necesarias.</p>
        </div>
    </div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
