<%@ page import="pe.edu.vallegrande.crud.dto.SaleDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.SaleDetailDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.PatientDTO" %>
<%@ page import="pe.edu.vallegrande.crud.dto.EmployeeDTO" %>
<%@ page import="pe.edu.vallegrande.crud.controller.PatientController" %>
<%@ page import="pe.edu.vallegrande.crud.controller.EmployeeController" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Boleta de Venta - Happy Dent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">

    <style>
        .invoice-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        .invoice-header {
            background-color: #1abc9c;
            color: white;
            padding: 1.5rem;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .invoice-title {
            font-size: 1.8rem;
            font-weight: bold;
        }
        .invoice-subtitle {
            font-size: 1.2rem;
        }
        .invoice-body {
            padding: 2rem;
        }
        .invoice-info {
            margin-bottom: 2rem;
        }
        .invoice-table {
            width: 100%;
            margin-bottom: 2rem;
        }
        .invoice-table th {
            background-color: #f8f9fa;
            padding: 0.75rem;
            text-align: left;
        }
        .invoice-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #dee2e6;
        }
        .invoice-total {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 5px;
            font-weight: bold;
        }
        .invoice-footer {
            text-align: center;
            padding: 1rem;
            border-top: 1px solid #dee2e6;
            margin-top: 2rem;
        }
        .method-icon {
            font-size: 1.2rem;
            margin-right: 0.5rem;
        }
        .status-badge {
            font-size: 0.9rem;
            padding: 0.5rem 0.75rem;
        }
        .print-only {
            display: none;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            .invoice-card, .invoice-card * {
                visibility: visible;
            }
            .invoice-card {
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
        <div class="container-fluid px-4 py-3">
            <div class="invoice-card">
                <div class="invoice-header">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="invoice-title">HAPPY DENT</div>
                            <div class="invoice-subtitle">Clínica Odontológica</div>
                        </div>
                        <div class="col-md-6 text-end">
                            <div style="font-size: 1.5rem; font-weight: bold;">BOLETA DE VENTA</div>
                            <div>N° ${sale.SALE_ID}</div>
                        </div>
                    </div>
                </div>

                <div class="invoice-body">
                    <%
                        SaleDTO sale = (SaleDTO) request.getAttribute("sale");
                        List<SaleDetailDTO> details = (List<SaleDetailDTO>) request.getAttribute("details");

                        // Obtener datos del paciente
                        PatientDTO patient = new PatientController().getPatientById(sale.getPATIENT_ID());

                        // Obtener datos del empleado
                        EmployeeDTO employee = new EmployeeController().getEmployeeById(sale.getEMPLOYEE_ID());

                        // Formatear fecha
                        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
                    %>

                    <div class="invoice-info">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Fecha:</strong> <%= dateFormat.format(sale.getSALE_DATE()) %></p>
                                <p>
                                    <strong>Método de pago:</strong>
                                    <span class="<%= sale.getSALE_METHOD() == 'C' ? "method-cash" :
                                                  sale.getSALE_METHOD() == 'T' ? "method-card" : "method-transfer" %>">
                                        <i class="fas <%= sale.getSALE_METHOD() == 'C' ? "fa-money-bill-wave" :
                                                         sale.getSALE_METHOD() == 'T' ? "fa-credit-card" : "fa-university" %> method-icon"></i>
                                        <%= sale.getSALE_METHOD() == 'C' ? "EFECTIVO" :
                                                sale.getSALE_METHOD() == 'T' ? "TARJETA" : "TRANSFERENCIA" %>
                                    </span>
                                </p>
                            </div>
                            <div class="col-md-6">
                                <p>
                                    <strong>Estado:</strong>
                                    <span class="badge <%= sale.getSALE_STATUS() == 'A' ? "bg-success" : "bg-danger" %> status-badge">
                                        <%= sale.getSALE_STATUS() == 'A' ? "ACTIVA" : "CANCELADA" %>
                                    </span>
                                </p>
                                <p><strong>Atendido por:</strong> <%= employee.getEMPLOYEE_FIRST_NAME() %> <%= employee.getEMPLOYEE_LAST_NAME() %></p>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <h5 class="mb-3"><i class="fas fa-user me-2"></i>DATOS DEL PACIENTE</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Nombre:</strong> <%= patient.getPATIENT_FIRST_NAME() %> <%= patient.getPATIENT_LAST_NAME() %></p>
                                <p><strong>Documento:</strong> <%= patient.getPATIENT_DOC_TYPE() %> <%= patient.getPATIENT_NRO_DOC() %></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Teléfono:</strong> <%= patient.getPATIENT_PHONE() %></p>
                                <p><strong>Dirección:</strong> <%= patient.getPATIENT_ADDRESS() %></p>
                            </div>
                        </div>
                    </div>

                    <h5 class="mb-3"><i class="fas fa-list me-2"></i>DETALLES DE LA VENTA</h5>
                    <table class="table table-hover">
                        <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Descripción</th>
                            <th class="text-end">Precio Unit.</th>
                            <th class="text-end">Cantidad</th>
                            <th class="text-end">Subtotal</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            int counter = 1;
                            for (SaleDetailDTO detail : details) {
                        %>
                        <tr>
                            <td><%= counter++ %></td>
                            <td><%= detail.getProduct().getPRODUCT_NAME() %></td>
                            <td class="text-end">S/ <%= String.format("%.2f", detail.getSALE_DETAIL_PRICE()) %></td>
                            <td class="text-end"><%= detail.getSALE_DETAIL_QUANTITY() %></td>
                            <td class="text-end">S/ <%= String.format("%.2f", detail.getSALE_DETAIL_SUBTOTAL()) %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>

                    <!-- Totales -->
                    <div class="row justify-content-end">
                        <div class="col-md-5">
                            <div class="invoice-total">
                                <div class="d-flex justify-content-between">
                                    <span>Subtotal:</span>
                                    <span>S/ <%= String.format("%.2f", sale.getSALE_TOTAL()) %></span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>IGV (18%):</span>
                                    <%
                                        double igv = sale.getSALE_TOTAL().doubleValue() * 0.18;
                                        double subtotal = sale.getSALE_TOTAL().doubleValue() - igv;
                                    %>
                                    <span>S/ <%= String.format("%.2f", igv) %></span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Total:</span>
                                    <span>S/ <%= String.format("%.2f", sale.getSALE_TOTAL()) %></span>
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
                    <div class="invoice-footer no-print">
                        <button class="btn btn-primary me-2" onclick="window.print()">
                            <i class="fas fa-print me-1"></i> Imprimir Boleta
                        </button>
                        <a href="SaleServlet?action=list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Volver al listado
                        </a>
                        <% if (sale.getSALE_STATUS() == 'A') { %>
                        <button onclick="confirmCancel(${sale.SALE_ID})" class="btn btn-danger">
                            <i class="fas fa-times-circle me-1"></i> Cancelar Venta
                        </button>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    // Función para confirmar cancelación de venta
    function confirmCancel(saleId) {
        Swal.fire({
            title: '¿Cancelar venta?',
            text: "Esta acción no se puede deshacer. Se devolverá el stock de productos.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, cancelar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'SaleServlet?action=cancel&id=' + saleId;
            }
        });
    }
</script>
</body>
</html>