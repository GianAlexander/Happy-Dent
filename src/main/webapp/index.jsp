<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>HAPPY DENT - Gestión</title>

    <!-- Bootstrap y estilos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
</head>

<body>

<!-- Contenedor principal -->
<div id="wrapper">

    <!-- Incluir el sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Contenido principal -->
    <div id="page-content-wrapper">
        <div class="container-fluid px-4">
            <h1 class="mt-4">Bienvenido a Happy Dent</h1>
            <p class="lead">Sistema de Gestión Integral para tu Clínica Dental</p>

            <!-- Sección de Acciones Rápidas (Ventas y Pacientes) -->
            <!-- Sección de Acciones Rápidas (Ventas y Pacientes) -->
            <div class="row">
                <!-- Ventas -->
                <div class="col-md-6 mb-4">
                    <a href="${pageContext.request.contextPath}/listSale.jsp" class="dashboard-card large-card card-sales">
                        <i class="fas fa-cash-register"></i>
                        <h3>Ventas</h3>
                        <p>Gestiona tus ventas y transacciones</p>
                    </a>
                </div>
                <!-- Pacientes -->
                <div class="col-md-6 mb-4">
                    <a href="${pageContext.request.contextPath}/listPatients.jsp" class="dashboard-card large-card card-patients">
                        <i class="fas fa-users"></i>
                        <h3>Pacientes</h3>
                        <p>Administra la información de tus pacientes</p>
                    </a>
                </div>
            </div>

            <!-- Sección de Productos, Compras y Empleados -->
            <div class="row section-spacing">
                <!-- Productos -->
                <div class="col-md-4 mb-4">
                    <a href="${pageContext.request.contextPath}/listProducts.jsp" class="dashboard-card small-card card-products">
                        <i class="fas fa-boxes"></i>
                        <h3>Productos</h3>
                        <p>Gestiona el inventario de productos</p>
                    </a>
                </div>
                <!-- Compras -->
                <div class="col-md-4 mb-4">
                    <a href="${pageContext.request.contextPath}/listPurchase.jsp" class="dashboard-card small-card card-purchases">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Compras</h3>
                        <p>Gestiona las compras y proveedores</p>
                    </a>
                </div>
                <!-- Empleados -->
                <div class="col-md-4 mb-4">
                    <a href="${pageContext.request.contextPath}/listEmployee.jsp" class="dashboard-card small-card card-employees">
                        <i class="fas fa-user-tie"></i>
                        <h3>Empleados</h3>
                        <p>Administra la información de tus empleados</p>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>