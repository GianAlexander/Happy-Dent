<%@ page import="pe.edu.vallegrande.crud.dto.EmployeeDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ficha de Empleado - Happy Dent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <style>
        .employee-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .employee-header {
            background-color: #1abc9c;
            color: white;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .employee-section-title {
            color: #1abc9c;
            border-bottom: 2px solid #1abc9c;
            padding-bottom: 0.5rem;
            margin: 1.5rem 0 1rem 0;
        }
        .employee-info-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            height: 100%;
        }
        .employee-photo {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #1abc9c;
        }
        .badge-status {
            font-size: 0.9rem;
            padding: 0.5rem 0.75rem;
        }
    </style>
</head>
<body>
<div id="wrapper">
    <jsp:include page="sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="container-fluid px-4 py-3">
            <div class="employee-card">
                <!-- Encabezado -->
                <div class="employee-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2 class="mb-0"><i class="fas fa-user-tie me-2"></i> FICHA DE EMPLEADO</h2>
                        </div>
                        <div class="text-end">
                            <small class="d-block">Fecha: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></small>
                        </div>
                    </div>
                </div>

                <!-- Cuerpo -->
                <div class="p-4">
                    <% EmployeeDTO employee = (EmployeeDTO) request.getAttribute("employee"); %>

                    <!-- Datos básicos -->
                    <div class="row align-items-center mb-4">
                        <div class="col-md-2 text-center">
                            <img src="${pageContext.request.contextPath}/asset/default-employee.png" alt="Foto" class="employee-photo">
                        </div>
                        <div class="col-md-10">
                            <div class="row">
                                <div class="col-md-4">
                                    <p><strong>Nombre:</strong> <%= employee.getEMPLOYEE_FIRST_NAME() %></p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Apellido:</strong> <%= employee.getEMPLOYEE_LAST_NAME() %></p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Documento:</strong> <%= employee.getEMPLOYEE_DOC_TYPE() %> <%= employee.getEMPLOYEE_NRO_DOC() %></p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Fecha Nacimiento:</strong>
                                        <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(employee.getEMPLOYEE_BIRTH_DATE()) %>
                                    </p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Edad:</strong>
                                        <%
                                            java.util.Date birthDate = employee.getEMPLOYEE_BIRTH_DATE();
                                            java.util.Calendar cal = java.util.Calendar.getInstance();
                                            cal.setTime(birthDate);
                                            int birthYear = cal.get(java.util.Calendar.YEAR);
                                            int birthMonth = cal.get(java.util.Calendar.MONTH);
                                            int birthDay = cal.get(java.util.Calendar.DAY_OF_MONTH);

                                            cal.setTime(new java.util.Date());
                                            int currentYear = cal.get(java.util.Calendar.YEAR);
                                            int currentMonth = cal.get(java.util.Calendar.MONTH);
                                            int currentDay = cal.get(java.util.Calendar.DAY_OF_MONTH);

                                            int age = currentYear - birthYear;
                                            if (currentMonth < birthMonth || (currentMonth == birthMonth && currentDay < birthDay)) {
                                                age--;
                                            }
                                        %>
                                        <%= age %> años
                                    </p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Teléfono:</strong> <%= employee.getEMPLOYEE_PHONE() %></p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Email:</strong> <%= employee.getEMPLOYEE_EMAIL() %></p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Estado:</strong>
                                        <span class="badge <%= "A".equals(employee.getEMPLOYEE_STATUS()) ? "bg-success" : "bg-secondary" %> badge-status">
                                            <%= "A".equals(employee.getEMPLOYEE_STATUS()) ? "Activo" : "Inactivo" %>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección de información de contacto -->
                    <h4 class="employee-section-title"><i class="fas fa-address-card me-2"></i>INFORMACIÓN DE CONTACTO</h4>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="employee-info-section">
                                <p><strong>Teléfono principal:</strong> <%= employee.getEMPLOYEE_PHONE() %></p>
                                <p><strong>Email:</strong> <%= employee.getEMPLOYEE_EMAIL() %></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="employee-info-section">
                                <p><strong>Tipo de documento:</strong> <%= employee.getEMPLOYEE_DOC_TYPE() %></p>
                                <p><strong>Número de documento:</strong> <%= employee.getEMPLOYEE_NRO_DOC() %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Sección de datos adicionales -->
                    <h4 class="employee-section-title"><i class="fas fa-info-circle me-2"></i>DATOS ADICIONALES</h4>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="employee-info-section">
                                <p><strong>Fecha de registro:</strong>
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(employee.getEMPLOYEE_BIRTH_DATE()) %>
                                </p>
                                <p><strong>Estado actual:</strong>
                                    <% if ("A".equals(employee.getEMPLOYEE_STATUS())) { %>
                                    <span class="text-success">Empleado activo en el sistema</span>
                                    <% } else { %>
                                    <span class="text-secondary">Empleado inactivo</span>
                                    <% } %>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pie de página -->
                <div class="bg-light p-3 text-center border-top">
                    <button class="btn btn-primary me-2" onclick="window.print()">
                        <i class="fas fa-print me-1"></i> Imprimir
                    </button>
                    <a href="EmployeeServlet?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Volver al listado
                    </a>
                    <% if ("A".equals(employee.getEMPLOYEE_STATUS())) { %>
                    <a href="EmployeeServlet?action=edit&id=<%= employee.getEMPLOYEE_ID() %>" class="btn btn-warning">
                        <i class="fas fa-edit me-1"></i> Editar
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>