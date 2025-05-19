<%@ page import="pe.edu.vallegrande.crud.dto.SupplierDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Editar Proveedor - Happy Dent</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>

<div id="wrapper">

    <jsp:include page="sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="container-fluid px-4">
            <h1 class="mt-4">Editar Proveedor</h1>

            <div class="card mb-4">
                <div class="card-header" style="background-color: #1abc9c; color: white;">
                    <h5 class="mb-0">Datos del Proveedor</h5>
                </div>

                <div class="card-body">
                    <%
                        SupplierDTO supplier = (SupplierDTO) request.getAttribute("supplier");
                        if (supplier == null) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        No se encontraron datos del proveedor.
                    </div>
                    <%
                    } else {
                    %>
                    <form action="SupplierServlet?action=update" method="post" id="editSupplierForm">
                        <input type="hidden" name="SUPPLIER_ID" value="<%= supplier.getSUPPLIER_ID() %>">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="supplierName" class="form-label">Nombre del Proveedor</label>
                                <input type="text" class="form-control" id="supplierName" name="SUPPLIER_NAME"
                                       value="<%= supplier.getSUPPLIER_NAME() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="supplierRuc" class="form-label">RUC</label>
                                <input type="text" class="form-control" id="supplierRuc" name="SUPPLIER_RUC"
                                       value="<%= supplier.getSUPPLIER_RUC() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="supplierEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="supplierEmail" name="SUPPLIER_EMAIL"
                                       value="<%= supplier.getSUPPLIER_EMAIL() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="supplierPhone" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="supplierPhone" name="SUPPLIER_PHONE"
                                       value="<%= supplier.getSUPPLIER_PHONE() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="supplierWebsite" class="form-label">Sitio Web</label>
                                <input type="url" class="form-control" id="supplierWebsite" name="SUPPLIER_WEBSITE"
                                       value="<%= supplier.getSUPPLIER_WEBSITE() != null ? supplier.getSUPPLIER_WEBSITE() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="supplierType" class="form-label">Tipo de Proveedor</label>
                                <select class="form-select" id="supplierType" name="SUPPLIER_TYPE" required>
                                    <option value="Equipos dentales" <%= "Equipos dentales".equals(supplier.getSUPPLIER_TYPE()) ? "selected" : "" %>>Equipos dentales</option>
                                    <option value="Materiales dentales" <%= "Materiales dentales".equals(supplier.getSUPPLIER_TYPE()) ? "selected" : "" %>>Materiales dentales</option>
                                    <option value="Insumos médicos" <%= "Insumos médicos".equals(supplier.getSUPPLIER_TYPE()) ? "selected" : "" %>>Insumos médicos</option>
                                    <option value="Mobiliario clínico" <%= "Mobiliario clínico".equals(supplier.getSUPPLIER_TYPE()) ? "selected" : "" %>>Mobiliario clínico</option>
                                    <option value="Otros" <%= "Otros".equals(supplier.getSUPPLIER_TYPE()) ? "selected" : "" %>>Otros</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="supplierAddress" class="form-label">Dirección</label>
                            <textarea class="form-control" id="supplierAddress" name="SUPPLIER_ADDRESS" rows="3" required><%= supplier.getSUPPLIER_ADDRESS() != null ? supplier.getSUPPLIER_ADDRESS() : "" %></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="supplierStatus" class="form-label">Estado</label>
                            <select class="form-select" id="supplierStatus" name="SUPPLIER_STATUS">
                                <option value="A" <%= "A".equals(supplier.getSUPPLIER_STATUS()) ? "selected" : "" %>>Activo</option>
                                <option value="I" <%= "I".equals(supplier.getSUPPLIER_STATUS()) ? "selected" : "" %>>Inactivo</option>
                            </select>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-primary me-2" onclick="confirmarGuardado()">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="SupplierServlet?action=list" class="btn btn-secondary">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function validarFormulario() {
        let isValid = true;

        const requiredFields = ['supplierName', 'supplierRuc', 'supplierEmail', 'supplierPhone', 'supplierAddress'];
        requiredFields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('is-invalid');
            } else {
                field.classList.remove('is-invalid');
            }
        });

        const rucField = document.getElementById('supplierRuc');
        const rucRegex = /^[0-9]{11}$/;
        if (rucField.value && !rucRegex.test(rucField.value)) {
            isValid = false;
            rucField.classList.add('is-invalid');
        }

        const phoneField = document.getElementById('supplierPhone');
        const phoneRegex = /^9[0-9]{8}$/;
        if (phoneField.value && !phoneRegex.test(phoneField.value)) {
            isValid = false;
            phoneField.classList.add('is-invalid');
        }

        // Validar email
        const emailField = document.getElementById('supplierEmail');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (emailField.value && !emailRegex.test(emailField.value)) {
            isValid = false;
            emailField.classList.add('is-invalid');
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
            text: "¿Desea guardar los cambios realizados a este proveedor?",
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
                            document.getElementById('editSupplierForm').submit();
                        }, 1000);
                    }
                });
            }
        });
    }

    document.querySelectorAll('#editSupplierForm input, #editSupplierForm select, #editSupplierForm textarea').forEach(element => {
        element.addEventListener('change', function() {
            validarFormulario();
        });
    });

    document.getElementById('supplierRuc').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '');
        if (this.value.length > 11) {
            this.value = this.value.substring(0, 11);
        }
    });

    document.getElementById('supplierPhone').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '');
        if (this.value.length > 9) {
            this.value = this.value.substring(0, 9);
        }
    });
</script>

</body>
</html>