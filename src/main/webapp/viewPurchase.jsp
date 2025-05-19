<%@ page import="pe.edu.vallegrande.crud.dto.PurchaseDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.PurchaseDetailDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.SupplierDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.EmployeeDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.ProductDTO" %>
<%@ page import="pe.edu.vallegrande.crud.controller.SupplierController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.EmployeeController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.ProductController" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Boleta de Compra - Happy Dent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">
    <style>
        /* Estilos específicos para la boleta que no interfieren con el diseño principal */
        .boleta-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .boleta-header {
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: white;
            padding: 1.5rem;
            border-radius: 8px 8px 0 0;
        }
        .boleta-body {
            background: white;
            padding: 2rem;
            border-radius: 0 0 8px 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .boleta-title {
            font-size: 1.8rem;
            font-weight: bold;
        }
        .boleta-subtitle {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .print-only {
            display: none;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            .boleta-container, .boleta-container * {
                visibility: visible;
            }
            .boleta-container {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                box-shadow: none;
            }
            .no-print {
                display: none;
            }
            .print-only {
                display: block;
            }
        }
    </style>
</head>
<body>
<div id="wrapper">
    <jsp:include page="sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="container-fluid px-4 py-4">
            <div class="boleta-container">
                <!-- Encabezado de la boleta -->
                <div class="boleta-header">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="boleta-title">HAPPY DENT</div>
                            <div class="boleta-subtitle">Tu sonrisa, nuestra pasión</div>
                        </div>
                        <div class="col-md-6 text-end">
                            <div class="boleta-title">BOLETA DE COMPRA</div>
                            <div>N° ${purchase.PURCHASE_ID}</div>
                        </div>
                    </div>
                </div>

                <!-- Cuerpo de la boleta -->
                <div class="boleta-body">
                    <%
                        PurchaseDTO purchase = (PurchaseDTO) request.getAttribute("purchase");
                        List<PurchaseDetailDTO> details = (List<PurchaseDetailDTO>) request.getAttribute("details");

                        // Obtener datos del proveedor
                        SupplierDTO supplier = new SupplierController().getSupplierById(purchase.getSUPPLIER_ID());

                        // Obtener datos del empleado
                        EmployeeDTO employee = new EmployeeController().getEmployeeById(purchase.getEMPLOYEE_ID());

                        // Formatear fecha
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    %>

                    <!-- Información del proveedor y compra -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5 class="mb-3 text-primary"><i class="fas fa-truck me-2"></i>INFORMACIÓN DEL PROVEEDOR</h5>
                            <p><strong>Nombre:</strong> <%= supplier.getSUPPLIER_NAME() %></p>
                            <p><strong>RUC:</strong> <%= supplier.getSUPPLIER_RUC() %></p>
                            <p><strong>Dirección:</strong> <%= supplier.getSUPPLIER_ADDRESS() %></p>
                            <p><strong>Teléfono:</strong> <%= supplier.getSUPPLIER_PHONE() %></p>
                        </div>
                        <div class="col-md-6">
                            <h5 class="mb-3 text-primary"><i class="fas fa-shopping-cart me-2"></i>INFORMACIÓN DE COMPRA</h5>
                            <p><strong>Fecha:</strong> <%= dateFormat.format(purchase.getPURCHASE_DATE()) %></p>
                            <p><strong>Empleado:</strong> <%= employee.getEMPLOYEE_FIRST_NAME() %> <%= employee.getEMPLOYEE_LAST_NAME() %></p>
                            <p>
                                <strong>Estado:</strong>
                                <span class="badge <%= purchase.getPURCHASE_STATUS() == 'A' ? "bg-success" : "bg-secondary" %>">
                                    <%= purchase.getPURCHASE_STATUS() == 'A' ? "ACTIVO" : "INACTIVO" %>
                                </span>
                            </p>
                        </div>
                    </div>

                    <!-- Detalles de la compra -->
                    <h5 class="mb-3 text-primary"><i class="fas fa-list me-2"></i>DETALLES DE LA COMPRA</h5>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                            <tr>
                                <th width="50%">Producto</th>
                                <th width="15%" class="text-end">Precio Unit.</th>
                                <th width="15%" class="text-end">Cantidad</th>
                                <th width="20%" class="text-end">Subtotal</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (PurchaseDetailDTO detail : details) {
                                    ProductDTO product = new ProductController().getProductById(detail.getPRODUCT_ID());
                            %>
                            <tr>
                                <td><%= product.getPRODUCT_NAME() %></td>
                                <td class="text-end">S/ <%= String.format("%.2f", detail.getPURCHASE_DETAIL_PRICE()) %></td>
                                <td class="text-end"><%= detail.getPURCHASE_DETAIL_QUANTITY() %></td>
                                <td class="text-end">S/ <%= String.format("%.2f", detail.getPURCHASE_DETAIL_SUBTOTAL()) %></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Totales -->
                    <div class="row justify-content-end mt-4">
                        <div class="col-md-5">
                            <div class="bg-light p-3 rounded">
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Total:</span>
                                    <span>S/ <%= String.format("%.2f", purchase.getPURCHASE_TOTAL()) %></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Mensaje para impresión -->
                    <div class="print-only mt-4">
                        <p class="text-center">¡Gracias por su preferencia!</p>
                        <p class="text-center">Válido como comprobante de pago</p>
                    </div>

                    <!-- Pie de página -->
                    <div class="d-flex justify-content-between mt-4 no-print">
                        <div>
                            <a href="PurchaseServlet?action=list" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Volver al listado
                            </a>
                        </div>
                        <div>
                            <button class="btn btn-primary me-2" onclick="window.print()">
                                <i class="fas fa-print me-1"></i> Imprimir Boleta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Función para imprimir solo la boleta
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelector('.print-button').addEventListener('click', function() {
            window.print();
        });
    });
</script>
</body>
</html>