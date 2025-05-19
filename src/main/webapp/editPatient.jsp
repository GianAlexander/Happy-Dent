<%@ page import="pe.edu.vallegrande.crud.dto.PatientDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Editar Paciente - Happy Dent</title>

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
            <h1 class="mt-4">Editar Paciente</h1>

            <div class="card mb-4">
                <div class="card-header" style="background-color: #1abc9c; color: white;">
                    <h5 class="mb-0">Datos del Paciente</h5>
                </div>

                <div class="card-body">
                    <%
                        PatientDTO patient = (PatientDTO) request.getAttribute("patient");
                        if (patient == null) {
                    %>
                    <div class="alert alert-danger" role="alert">
                        No se encontraron datos del paciente.
                    </div>
                    <%
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String birthDate = patient.getPATIENT_BIRTH_DATE() != null ?
                                sdf.format(patient.getPATIENT_BIRTH_DATE()) : "";
                    %>
                    <form action="PatientServlet?action=update" method="post" id="editPatientForm">
                        <input type="hidden" name="PATIENT_ID" value="<%= patient.getPATIENT_ID() %>">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="firstName" class="form-label">Nombre</label>
                                <input type="text" class="form-control" id="firstName" name="PATIENT_FIRST_NAME"
                                       value="<%= patient.getPATIENT_FIRST_NAME() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="lastName" class="form-label">Apellido</label>
                                <input type="text" class="form-control" id="lastName" name="PATIENT_LAST_NAME"
                                       value="<%= patient.getPATIENT_LAST_NAME() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="birthDate" class="form-label">Fecha de Nacimiento</label>
                                <input type="date" class="form-control" id="birthDate" name="PATIENT_BIRTH_DATE"
                                       value="<%= birthDate %>" required>
                            </div>
                            <div class="col-md-3">
                                <label for="docType" class="form-label">Tipo de Documento</label>
                                <select class="form-select" id="docType" name="PATIENT_DOC_TYPE" required>
                                    <option value="DNI" <%= "DNI".equals(patient.getPATIENT_DOC_TYPE()) ? "selected" : "" %>>DNI</option>
                                    <option value="CE" <%= "CE".equals(patient.getPATIENT_DOC_TYPE()) ? "selected" : "" %>>Carné Extranjería</option>
                                    <option value="PAS" <%= "PAS".equals(patient.getPATIENT_DOC_TYPE()) ? "selected" : "" %>>Pasaporte</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="nroDoc" class="form-label">Número de Documento</label>
                                <input type="text" class="form-control" id="nroDoc" name="PATIENT_NRO_DOC"
                                       value="<%= patient.getPATIENT_NRO_DOC() %>" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="phone" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="phone" name="PATIENT_PHONE"
                                       value="<%= patient.getPATIENT_PHONE() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="address" class="form-label">Dirección</label>
                                <input type="text" class="form-control" id="address" name="PATIENT_ADDRESS"
                                       value="<%= patient.getPATIENT_ADDRESS() != null ? patient.getPATIENT_ADDRESS() : "" %>">
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="occupation" class="form-label">Ocupación</label>
                                <input type="text" class="form-control" id="occupation" name="PATIENT_OCCUPATION"
                                       value="<%= patient.getPATIENT_OCCUPATION() != null ? patient.getPATIENT_OCCUPATION() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="reason" class="form-label">Motivo de Consulta</label>
                                <input type="text" class="form-control" id="reason" name="PATIENT_REASON"
                                       value="<%= patient.getPATIENT_REASON() != null ? patient.getPATIENT_REASON() : "" %>">
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="riskCondition" class="form-label">Condición de Riesgo</label>
                                <select class="form-select" id="riskCondition" name="PATIENT_RISK_CONDITION">
                                    <option value="">Seleccione...</option>
                                    <option value="ALERGIAS" <%= "ALERGIAS".equals(patient.getPATIENT_RISK_CONDITION()) ? "selected" : "" %>>Alergias</option>
                                    <option value="DIABETES" <%= "DIABETES".equals(patient.getPATIENT_RISK_CONDITION()) ? "selected" : "" %>>Diabetes</option>
                                    <option value="HIPERTENSION" <%= "HIPERTENSION".equals(patient.getPATIENT_RISK_CONDITION()) ? "selected" : "" %>>Hipertensión</option>
                                    <option value="EMBARAZO" <%= "EMBARAZO".equals(patient.getPATIENT_RISK_CONDITION()) ? "selected" : "" %>>Embarazo</option>
                                    <option value="NINGUNA" <%= "NINGUNA".equals(patient.getPATIENT_RISK_CONDITION()) ? "selected" : "" %>>Ninguna</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="status" class="form-label">Estado</label>
                                <select class="form-select" id="status" name="PATIENT_STATUS">
                                    <option value="A" <%= "A".equals(patient.getPATIENT_STATUS()) ? "selected" : "" %>>Activo</option>
                                    <option value="I" <%= "I".equals(patient.getPATIENT_STATUS()) ? "selected" : "" %>>Inactivo</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="details" class="form-label">Detalles Adicionales</label>
                            <textarea class="form-control" id="details" name="PATIENT_DETAILS" rows="3"><%= patient.getPATIENT_DETAILS() != null ? patient.getPATIENT_DETAILS() : "" %></textarea>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-primary me-2" onclick="confirmarGuardado()">
                                <i class="fas fa-save"></i> Guardar Cambios
                            </button>
                            <a href="listPatients.jsp" class="btn btn-secondary">
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

        const requiredFields = ['firstName', 'lastName', 'birthDate', 'nroDoc', 'phone'];
        requiredFields.forEach(fieldId => {
            const field = document.getElementById(fieldId);
            if (!field.value.trim()) {
                isValid = false;
                field.classList.add('is-invalid');
            } else {
                field.classList.remove('is-invalid');
            }
        });

        const phoneField = document.getElementById('phone');
        const phoneRegex = /^[0-9]{9,15}$/;
        if (phoneField.value && !phoneRegex.test(phoneField.value)) {
            isValid = false;
            phoneField.classList.add('is-invalid');
        }

        const docField = document.getElementById('nroDoc');
        const docRegex = /^[0-9]{8,12}$/;
        if (docField.value && !docRegex.test(docField.value)) {
            isValid = false;
            docField.classList.add('is-invalid');
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
            text: "¿Desea guardar los cambios realizados a este paciente?",
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
                            document.getElementById('editPatientForm').submit();
                        }, 1000);
                    }
                });
            }
        });
    }

    document.querySelectorAll('#editPatientForm input, #editPatientForm select, #editPatientForm textarea').forEach(element => {
        element.addEventListener('change', function() {
            validarFormulario();
        });
    });
</script>

</body>
</html>