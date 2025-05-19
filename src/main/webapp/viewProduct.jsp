<%@ page import="pe.edu.vallegrande.crud.dto.ProductDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ficha de Producto - Happy Dent</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
  <style>
    .product-card {
      background-color: white;
      border-radius: 10px;
      box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
      overflow: hidden;
    }
    .product-header {
      background-color: #3498db;
      color: white;
      padding: 1.5rem;
      margin-bottom: 1.5rem;
    }
    .product-section-title {
      color: #3498db;
      border-bottom: 2px solid #3498db;
      padding-bottom: 0.5rem;
      margin: 1.5rem 0 1rem 0;
    }
    .product-info-section {
      background-color: #f8f9fa;
      border-radius: 8px;
      padding: 1rem;
      margin-bottom: 1rem;
      height: 100%;
    }
    .product-image {
      width: 200px;
      height: 200px;
      object-fit: contain;
      border-radius: 8px;
      border: 4px solid #3498db;
      background-color: white;
      padding: 10px;
    }
    .badge-status {
      font-size: 0.9rem;
      padding: 0.5rem 0.75rem;
    }
    .stock-indicator {
      font-weight: bold;
    }
    .stock-low {
      color: #e74c3c;
    }
    .stock-normal {
      color: #2ecc71;
    }
    .stock-out {
      color: #7f8c8d;
      text-decoration: line-through;
    }
    .price-tag {
      font-size: 1.5rem;
      font-weight: bold;
      color: #e67e22;
    }
    .expiration-status {
      font-weight: bold;
    }
    .expiration-valid {
      color: #27ae60;
    }
    .expiration-warning {
      color: #f39c12;
    }
    .expiration-expired {
      color: #e74c3c;
    }
  </style>
</head>
<body>
<div id="wrapper">
  <jsp:include page="sidebar.jsp" />

  <div id="page-content-wrapper">
    <div class="container-fluid px-4 py-3">
      <div class="product-card">
        <!-- Encabezado -->
        <div class="product-header">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h2 class="mb-0"><i class="fas fa-box me-2"></i> FICHA TÉCNICA DE PRODUCTO</h2>
            </div>
            <div class="text-end">
              <small class="d-block">Fecha: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></small>
            </div>
          </div>
        </div>

        <!-- Cuerpo -->
        <div class="p-4">
          <% ProductDTO product = (ProductDTO) request.getAttribute("product");
            java.util.Date today = new java.util.Date();
            boolean isExpired = product.getPRODUCT_EXPIRATION_DATE().before(today);
            boolean isCloseToExpire = false;

            if (!isExpired) {
              java.util.Calendar cal = java.util.Calendar.getInstance();
              cal.setTime(today);
              cal.add(java.util.Calendar.DAY_OF_MONTH, 30);
              isCloseToExpire = product.getPRODUCT_EXPIRATION_DATE().before(cal.getTime());
            }
          %>

          <!-- Datos básicos -->
          <div class="row align-items-center mb-4">
            <div class="col-md-3 text-center">
              <img src="${pageContext.request.contextPath}/asset/default-product.png" alt="Producto" class="product-image">
            </div>
            <div class="col-md-9">
              <div class="row">
                <div class="col-md-6">
                  <h3 class="mb-3"><%= product.getPRODUCT_NAME() %></h3>
                  <p class="mb-2"><strong>Marca:</strong> <%= product.getPRODUCT_BRAND() %></p>
                  <p class="mb-2"><strong>Presentación:</strong> <%= product.getPRODUCT_PRESENTATION() %></p>
                </div>
                <div class="col-md-6">
                  <div class="price-tag mb-3">S/ <%= String.format("%.2f", product.getPRODUCT_PRICE()) %></div>
                  <p class="mb-2">
                    <strong>Stock:</strong>
                    <span class="stock-indicator
                                            <%= product.getPRODUCT_STOCK() == 0 ? "stock-out" :
                                               (product.getPRODUCT_STOCK() < 10 ? "stock-low" : "stock-normal") %>">
                                            <%= product.getPRODUCT_STOCK() %> unidades
                                        </span>
                  </p>
                  <p class="mb-2">
                    <strong>Estado:</strong>
                    <span class="badge <%= "A".equals(product.getPRODUCT_STATUS()) ? "bg-success" : "bg-secondary" %> badge-status">
                                            <%= "A".equals(product.getPRODUCT_STATUS()) ? "Activo" : "Inactivo" %>
                                        </span>
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Sección de información técnica -->
          <h4 class="product-section-title"><i class="fas fa-info-circle me-2"></i>INFORMACIÓN TÉCNICA</h4>
          <div class="row mb-4">
            <div class="col-md-6">
              <div class="product-info-section">
                <p><strong>Lote:</strong> <%= product.getPRODUCT_BATCH() %></p>
                <p>
                  <strong>Fecha de Expiración:</strong>
                  <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(product.getPRODUCT_EXPIRATION_DATE()) %>
                  <span class="expiration-status
                                        <%= isExpired ? "expiration-expired" :
                                           (isCloseToExpire ? "expiration-warning" : "expiration-valid") %>">
                                        (<%= isExpired ? "VENCIDO" :
                          (isCloseToExpire ? "PRÓXIMO A VENCER" : "VIGENTE") %>)
                                    </span>
                </p>
                <%
                  if (isCloseToExpire || isExpired) {
                    long diffInMillies = Math.abs(product.getPRODUCT_EXPIRATION_DATE().getTime() - today.getTime());
                    long diff = diffInMillies / (24 * 60 * 60 * 1000);
                %>
                <p class="mb-0">
                  <strong>Tiempo restante:</strong>
                  <%= isExpired ? "Vencido hace " + diff + " días" : diff + " días" %>
                </p>
                <% } %>
              </div>
            </div>
            <div class="col-md-6">
              <div class="product-info-section">
                <p><strong>Descripción:</strong></p>
                <p><%= product.getPRODUCT_DESCRIPTION() != null && !product.getPRODUCT_DESCRIPTION().isEmpty() ?
                        product.getPRODUCT_DESCRIPTION() : "No hay descripción disponible" %></p>
              </div>
            </div>
          </div>
        </div>

        <!-- Pie de página -->
        <div class="bg-light p-3 text-center border-top">
          <button class="btn btn-primary me-2" onclick="window.print()">
            <i class="fas fa-print me-1"></i> Imprimir
          </button>
          <a href="ProductServlet?action=list" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-1"></i> Volver al listado
          </a>
          <% if ("A".equals(product.getPRODUCT_STATUS())) { %>
          <a href="ProductServlet?action=edit&id=<%= product.getPRODUCT_ID() %>" class="btn btn-warning">
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