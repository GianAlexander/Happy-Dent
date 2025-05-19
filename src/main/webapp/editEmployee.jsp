<%@ page import="pe.edu.vallegrande.crud.dto.EmployeeDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Editar Empleado - Happy Dent</title>

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
            <h1 class="mt-4">Editar Empleado</h1>

            <!-- Tarjeta para el formulario de edición -->
            <div class="card mb-4">
                <div class="card-header" style="background-color: #1abc9c; color: white;">
                    <h5 class="mb-0">Datos del Empleado</h5>
                </div>

                <div class="card-body">
                    <%
                        EmployeeDTO employee = (EmployeeDTO) request.getAttribute("employee");
                        if (employee == null) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        No se encontraron datos del empleado.
                    </div>
                    <%
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String birthDate = employee.getEMPLOYEE_BIRTH_DATE() != null ?
                                sdf.format(employee.getEMPLOYEE_BIRTH_DATE()) : "";
                    %>
                    <form action="EmployeeServlet?action=update" method="post" id="editEmployeeForm">
                        <input type="hidden" name="EMPLOYEE_ID" value="<%= employee.getEMPLOYEE_ID() %>">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="firstName" name="EMPLOYEE_FIRST_NAME"
                                       value="<%= employee.getEMPLOYEE_FIRST_NAME() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Apellido</label>
                                <input type="text" class="form-control" id="lastName" name="EMPLOYEE_LAST_NAME"
                                       value="<%= employee.getEMPLOYEE_LAST_NAME() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="birthDate" class="form-label">Fecha de Nacimiento</label>
                                <input type="date" class="form-control" id="birthDate" name="EMPLOYEE_BIRTH_DATE"
                                       value="<%= birthDate %>" required>
                            </div>
                            <div class="col-md-3">
                                <label for="docType" class="form-label">Tipo de Documento</label>
                                <select class="form-select" id="docType" name="EMPLOYEE_DOC_TYPE" required>
                                    <option value="DNI" <%= "DNI".equals(employee.getEMPLOYEE_DOC_TYPE()) ? "selected" : "" %>>DNI</option>
                                    <option value="CE" <%= "CE".equals(employee.getEMPLOYEE_DOC_TYPE()) ? "selected" : "" %>>Carné Extranjería</option>
                                    <option value="PAS" <%= "PAS".equals(employee.getEMPLOYEE_DOC_TYPE()) ? "selected" : "" %>>Pasaporte</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="nroDoc" class="form-label">Número de Documento</label>
                                <input type="text" class="form-control" id="nroDoc" name="EMPLOYEE_NRO_DOC"
                                       value="<%= employee.getEMPLOYEE_NRO_DOC() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="phone" name="EMPLOYEE_PHONE"
                                       value="<%= employee.getEMPLOYEE_PHONE() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="EMPLOYEE_EMAIL"
                                       value="<%= employee.getEMPLOYEE_EMAIL() != null ? employee.getEMPLOYEE_EMAIL() : "" %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="status" class="form-label">Estado</label>
                                <select class="form-select" id="status" name="EMPLOYEE_STATUS">
                                    <option value="A" <%= "A".equals(employee.getEMPLOYEE_STATUS()) ? "selected" : "" %>>Activo</option>
                                    <option value="I" <%= "I".equals(employee.getEMPLOYEE_STATUS()) ? "selected" : "" %>>Inactivo</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-primary me-2" onclick="confirmarGuardado()">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="EmployeeServlet?action=list" class="btn btn-secondary">
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
        const requiredFields = ['firstName', 'lastName', 'birthDate', 'nroDoc', 'phone', 'email'];
        requiredFields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('is-invalid');
            } else {
                field.classList.remove('is-invalid');
            }
        });

        // Validar formato de teléfono
        const phoneField = document.getElementById('phone');
        const phoneRegex = /^9\d{8}$/;
        if (phoneField.value && !phoneRegex.test(phoneField.value)) {
            isValid = false;
            phoneField.classList.add('is-invalid');
        }

        // Validar número de documento (8 dígitos)
        const docField = document.getElementById('nroDoc');
        const docRegex = /^\d{8}$/;
        if (docField.value && !docRegex.test(docField.value)) {
            isValid = false;
            docField.classList.add('is-invalid');
        }

        // Validar email
        const emailField = document.getElementById('email');
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (emailField.value && !emailRegex.test(emailField.value)) {
            isValid = false;
            emailField.classList.add('is-invalid');
        }

        // Validar fecha de nacimiento no futura
        const birthDateField = document.getElementById('birthDate');
        if (birthDateField.value) {
            const today = new Date();
            const birthDate = new Date(birthDateField.value);
            if (birthDate >= today) {
                isValid = false;
                birthDateField.classList.add('is-invalid');
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
            text: "¿Desea guardar los cambios realizados a este empleado?",
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
                            document.getElementById('editEmployeeForm').submit();
                        }, 1000);
                    }
                });
            }
        });
    }

    // Validación en tiempo real para nombres (solo letras)
    document.getElementById('firstName').addEventListener('input', function(e) {
        this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
        if (/[0-9]/.test(this.value)) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });

    document.getElementById('lastName').addEventListener('input', function(e) {
        this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
        if (/[0-9]/.test(this.value)) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });

    // Validación para número de documento (8 dígitos)
    document.getElementById('nroDoc').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '');
        if (this.value.length > 8) {
            this.value = this.value.substring(0, 8);
        }
    });

    // Validación para teléfono (9 dígitos que empieza con 9)
    document.getElementById('phone').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '');
        if (this.value.length > 9) {
            this.value = this.value.substring(0, 9);
        }
    });

    // Agregar validación al cambiar campos
    document.querySelectorAll('#editEmployeeForm input, #editEmployeeForm select').forEach(element => {
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