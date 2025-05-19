<%@ page import="pe.edu.vallegrande.crud.dto.SupplierDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Ficha de Proveedor - Happy Dent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <style>
        .supplier-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .supplier-header {
            background-color: #1abc9c;
            color: white;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .supplier-section-title {
            color: #1abc9c;
            border-bottom: 2px solid #1abc9c;
            padding-bottom: 0.5rem;
            margin: 1.5rem 0 1rem 0;
        }
        .supplier-info-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            height: 100%;
        }
        .supplier-logo {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 8px;
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
            <div class="supplier-card">
                <!-- Encabezado -->
                <div class="supplier-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2 class="mb-0"><i class="fas fa-truck me-2"></i> FICHA DE PROVEEDOR</h2>
                        </div>
                        <div class="text-end">
                            <small class="d-block">Fecha: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></small>
                        </div>
                    </div>
                </div>

                <!-- Cuerpo -->
                <div class="p-4">
                    <% SupplierDTO supplier = (SupplierDTO) request.getAttribute("supplier"); %>

                    <!-- Datos básicos -->
                    <div class="row align-items-center mb-4">
                        <div class="col-md-2 text-center">
                            <img src="${pageContext.request.contextPath}/asset/default-supplier.png" alt="Logo" class="supplier-logo">
                        </div>
                        <div class="col-md-10">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Nombre:</strong> <%= supplier.getSUPPLIER_NAME() %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>RUC:</strong> <%= supplier.getSUPPLIER_RUC() %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Tipo de Proveedor:</strong> <%= supplier.getSUPPLIER_TYPE() %></p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Estado:</strong>
                                        <span class="badge <%= "A".equals(supplier.getSUPPLIER_STATUS()) ? "bg-success" : "bg-secondary" %> badge-status">
                                            <%= "A".equals(supplier.getSUPPLIER_STATUS()) ? "Activo" : "Inactivo" %>
                                        </span>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección de información de contacto -->
                    <h4 class="supplier-section-title"><i class="fas fa-address-card me-2"></i>INFORMACIÓN DE CONTACTO</h4>
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="supplier-info-section">
                                <p><strong>Teléfono:</strong> <%= supplier.getSUPPLIER_PHONE() %></p>
                                <p><strong>Email:</strong> <%= supplier.getSUPPLIER_EMAIL() %></p>
                                <% if (supplier.getSUPPLIER_WEBSITE() != null && !supplier.getSUPPLIER_WEBSITE().isEmpty()) { %>
                                <p><strong>Sitio Web:</strong>
                                    <a href="<%= supplier.getSUPPLIER_WEBSITE().startsWith("http") ? supplier.getSUPPLIER_WEBSITE() : "http://" + supplier.getSUPPLIER_WEBSITE() %>" target="_blank">
                                        <%= supplier.getSUPPLIER_WEBSITE() %>
                                    </a>
                                </p>
                                <% } %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="supplier-info-section">
                                <p><strong>Dirección:</strong> <%= supplier.getSUPPLIER_ADDRESS() %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Sección de datos adicionales -->
                    <h4 class="supplier-section-title"><i class="fas fa-info-circle me-2"></i>INFORMACIÓN ADICIONAL</h4>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="supplier-info-section">
                                <p><strong>Estado actual:</strong>
                                    <% if ("A".equals(supplier.getSUPPLIER_STATUS())) { %>
                                    <span class="text-success">Proveedor activo en el sistema</span>
                                    <% } else { %>
                                    <span class="text-secondary">Proveedor inactivo</span>
                                    <% } %>
                                </p>
                                <p><strong>Última actualización:</strong>
                                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
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
                    <a href="SupplierServlet?action=list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Volver al listado
                    </a>
                    <% if ("A".equals(supplier.getSUPPLIER_STATUS())) { %>
                    <a href="SupplierServlet?action=edit&id=<%= supplier.getSUPPLIER_ID() %>" class="btn btn-warning">
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