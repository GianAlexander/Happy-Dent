<%@ page import="pe.edu.vallegrande.crud.dto.ProductDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Editar Producto - Happy Dent</title>

    <!-- Bootstrap y estilos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">

    <!-- SweetAlert2 para mensajes bonitos -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>

<!-- Contenedor principal -->
<div id="wrapper">

    <!-- Incluir el sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Contenido principal -->
    <div id="page-content-wrapper">
        <div class="container-fluid px-4">
            <h1 class="mt-4">Editar Producto</h1>

            <!-- Tarjeta para el formulario de edición -->
            <div class="card mb-4">
                <div class="card-header" style="background-color: #1abc9c; color: white;">
                    <h5 class="mb-0">Datos del Producto</h5>
                </div>

                <div class="card-body">
                    <%
                        ProductDTO product = (ProductDTO) request.getAttribute("product");
                        if (product == null) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        No se encontraron datos del producto.
                    </div>
                    <%
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String expirationDate = product.getPRODUCT_EXPIRATION_DATE() != null ?
                                sdf.format(product.getPRODUCT_EXPIRATION_DATE()) : "";
                    %>
                    <form action="ProductServlet?action=update" method="post" id="editProductForm">
                        <input type="hidden" name="PRODUCT_ID" value="<%= product.getPRODUCT_ID() %>">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="productName" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="productName" name="PRODUCT_NAME"
                                       value="<%= product.getPRODUCT_NAME() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="productBrand" class="form-label">Marca</label>
                                <input type="text" class="form-control" id="productBrand" name="PRODUCT_BRAND"
                                       value="<%= product.getPRODUCT_BRAND() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="productPresentation" class="form-label">Presentación</label>
                                <input type="text" class="form-control" id="productPresentation" name="PRODUCT_PRESENTATION"
                                       value="<%= product.getPRODUCT_PRESENTATION() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="productStock" class="form-label">Stock</label>
                                <input type="number" class="form-control" id="productStock" name="PRODUCT_STOCK"
                                       value="<%= product.getPRODUCT_STOCK() %>" min="0" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="productPrice" class="form-label">Precio (S/)</label>
                                <input type="number" step="0.01" class="form-control" id="productPrice" name="PRODUCT_PRICE"
                                       value="<%= product.getPRODUCT_PRICE() %>" min="0" required>
                            </div>
                            <div class="col-md-6">
                                <label for="productExpirationDate" class="form-label">Fecha de Expiración</label>
                                <input type="date" class="form-control" id="productExpirationDate" name="PRODUCT_EXPIRATION_DATE"
                                       value="<%= expirationDate %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="productBatch" class="form-label">Lote</label>
                                <input type="text" class="form-control" id="productBatch" name="PRODUCT_BATCH"
                                       value="<%= product.getPRODUCT_BATCH() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="productStatus" class="form-label">Estado</label>
                                <select class="form-select" id="productStatus" name="PRODUCT_STATUS" required>
                                    <option value="A" <%= "A".equals(product.getPRODUCT_STATUS()) ? "selected" : "" %>>Activo</option>
                                    <option value="I" <%= "I".equals(product.getPRODUCT_STATUS()) ? "selected" : "" %>>Inactivo</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="productDescription" class="form-label">Descripción</label>
                            <textarea class="form-control" id="productDescription" name="PRODUCT_DESCRIPTION" rows="3"><%= product.getPRODUCT_DESCRIPTION() != null ? product.getPRODUCT_DESCRIPTION() : "" %></textarea>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-primary me-2" onclick="confirmarGuardado()">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="ProductServlet?action=list" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Cancelar
                            </a>
                        </div>
                    </form>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function validarFormulario() {
        let isValid = true;

        // Validar campos requeridos
        const requiredFields = ['productName', 'productBrand', 'productPresentation', 'productStock',
            'productPrice', 'productExpirationDate', 'productBatch'];
        requiredFields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('is-invalid');
            } else {
                field.classList.remove('is-invalid');
            }
        });

        // Validar stock (número positivo)
        const stockField = document.getElementById('productStock');
        if (parseInt(stockField.value) < 0) {
            isValid = false;
            stockField.classList.add('is-invalid');
        }

        // Validar precio (número positivo)
        const priceField = document.getElementById('productPrice');
        if (parseFloat(priceField.value) <= 0) {
            isValid = false;
            priceField.classList.add('is-invalid');
        }

        // Validar fecha de expiración (no pasada)
        const expirationDateField = document.getElementById('productExpirationDate');
        if (expirationDateField.value) {
            const expDate = new Date(expirationDateField.value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            if (expDate < today) {
                isValid = false;
                expirationDateField.classList.add('is-invalid');
            }
        }

        return isValid;
    }

    function confirmarGuardado() {
        if (!validarFormulario()) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Por favor complete todos los campos requeridos correctamente.',
                confirmButtonColor: '#1abc9c'
            });
            return;
        }

        Swal.fire({
            title: '¿Está seguro?',
            text: "¿Desea guardar los cambios realizados a este producto?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#1abc9c',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, guardar cambios',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Guardando cambios...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                        setTimeout(() => {
                            document.getElementById('editProductForm').submit();
                        }, 1000);
                    }
                });
            }
        });
    }

    // Validación en tiempo real para stock
    document.getElementById('productStock').addEventListener('input', function(e) {
        if (parseInt(this.value) < 0) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });

    // Validación en tiempo real para precio
    document.getElementById('productPrice').addEventListener('input', function(e) {
        if (parseFloat(this.value) <= 0) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });

    // Validación en tiempo real para fecha de expiración
    document.getElementById('productExpirationDate').addEventListener('change', function() {
        const expDate = new Date(this.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (expDate < today) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });

    // Agregar validación al cambiar campos
    document.querySelectorAll('#editProductForm input, #editProductForm select, #editProductForm textarea').forEach(element => {
        element.addEventListener('change', function() {
            validarFormulario();
        });
    });

    // Validar al cargar la página
    document.addEventListener('DOMContentLoaded', function() {
        validarFormulario();
    });
</script>

</body>
</html>