<%@ page import="java.util.List, pe.edu.vallegrande.crud.controller.PatientController, pe.edu.vallegrande.crud.dto.PatientDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Listado de Pacientes - Happy Dent</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/asset/styles.css">


</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div id="wrapper">
    <jsp:include page="sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="container-fluid px-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="page-title">Gestión de Pacientes</h1>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registrarPacienteModal">
                    <i class="fas fa-plus me-1"></i> Nuevo Paciente
                </button>
            </div>

            <!-- Modal para nuevo paciente -->
            <div class="modal fade" id="registrarPacienteModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i>Registrar Paciente</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="patientForm" action="${pageContext.request.contextPath}/PatientServlet" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nombre</label>
                                        <input type="text" class="form-control" name="PATIENT_FIRST_NAME" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Apellido</label>
                                        <input type="text" class="form-control" name="PATIENT_LAST_NAME" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Fecha de Nacimiento</label>
                                        <input type="date" class="form-control" name="PATIENT_BIRTH_DATE" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tipo de Documento</label>
                                        <select class="form-select" name="PATIENT_DOC_TYPE" required>
                                            <option value="DNI">DNI</option>
                                            <option value="CE">Carnet de Extranjería</option>
                                            <option value="PAS">Pasaporte</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Número de Documento</label>
                                        <input type="text" class="form-control" name="PATIENT_NRO_DOC" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Teléfono</label>
                                        <input type="text" class="form-control" name="PATIENT_PHONE" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Dirección</label>
                                    <input type="text" class="form-control" name="PATIENT_ADDRESS" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Ocupación</label>
                                    <input type="text" class="form-control" name="PATIENT_OCCUPATION">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Motivo de Consulta</label>
                                    <textarea class="form-control" name="PATIENT_REASON" rows="2"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Condición de Riesgo</label>
                                    <input type="text" class="form-control" name="PATIENT_RISK_CONDITION">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Detalles Adicionales</label>
                                    <textarea class="form-control" name="PATIENT_DETAILS" rows="3"></textarea>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                    <button type="submit" class="btn btn-primary">Registrar</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta optimizada -->
            <div class="card mb-4 border-0" style="background-color: #f8f9fa;">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Pacientes</h5>
                    <div class="dropdown">
                        <button class="btn btn-light btn-sm dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            Exportar Datos
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#" onclick="exportToCSV()">CSV</a></li>
                            <li><a class="dropdown-item" href="#" onclick="exportToXLS()">Excel</a></li>
                            <li><a class="dropdown-item" href="#" onclick="exportTableToPDF()">PDF</a></li>
                        </ul>
                    </div>
                </div>

                <div class="card-body">
                    <!-- Filtros de búsqueda - Actualizado con nuevos campos -->
                    <div class="search-box mb-3">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Nombre" id="filterName">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Apellido" id="filterLastName">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Documento" id="filterDoc">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Teléfono" id="filterPhone">
                            </div>
                            <div class="col-md-2 col-6">
                                <input type="text" class="form-control form-control-sm search-input" placeholder="Motivo Consulta" id="filterReason">
                            </div>
                            <div class="col-md-1 col-6">
                                <select class="form-select form-select-sm search-input" id="filterStatus">
                                    <option value="">Todos</option>
                                    <option value="A">Activos</option>
                                    <option value="I">Inactivos</option>
                                </select>
                            </div>
                            <div class="col-md-1 col-6">
                                <button class="btn btn-primary btn-sm search-btn w-100" onclick="filterTable()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla optimizada - Actualizada con motivo de consulta -->
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Documento</th>
                                <th>Teléfono</th>
                                <th>Motivo de Consulta</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                            </thead>
                            <tbody id="patientTableBody">
                            <%
                                String estadoFiltro = request.getParameter("estado");
                                List<PatientDTO> patients = new PatientController().listAll();

                                if ("activos".equals(estadoFiltro)) {
                                    patients = new PatientController().listActive();
                                } else if ("inactivos".equals(estadoFiltro)) {
                                    patients = new PatientController().listInactive();
                                }

                                // Paginación
                                int paginaActual = 1;
                                String paginaParam = request.getParameter("pagina");
                                if (paginaParam != null && !paginaParam.isEmpty()) {
                                    paginaActual = Integer.parseInt(paginaParam);
                                }

                                int registrosPorPagina = 5;
                                int totalRegistros = patients.size();
                                int totalPaginas = (int) Math.ceil((double) totalRegistros / registrosPorPagina);
                                int inicio = (paginaActual - 1) * registrosPorPagina;
                                int fin = Math.min(inicio + registrosPorPagina, totalRegistros);

                                if (patients.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">No hay pacientes registrados</td>
                            </tr>
                            <%
                            } else {
                                for (int i = inicio; i < fin; i++) {
                                    PatientDTO patient = patients.get(i);
                            %>
                            <tr>
                                <td><%= patient.getPATIENT_FIRST_NAME() %></td>
                                <td><%= patient.getPATIENT_LAST_NAME() %></td>
                                <td><%= patient.getPATIENT_DOC_TYPE() %>: <%= patient.getPATIENT_NRO_DOC() %></td>
                                <td><%= patient.getPATIENT_PHONE() %></td>
                                <td><%= patient.getPATIENT_REASON() != null ? patient.getPATIENT_REASON() : "N/A" %></td>
                                <td><span class="badge <%= "A".equals(patient.getPATIENT_STATUS()) ? "bg-success" : "bg-secondary" %>">
                                    <%= "A".equals(patient.getPATIENT_STATUS()) ? "Activo" : "Inactivo" %>
                                </span></td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-1">
                                        <!-- Botón View (siempre visible) -->
                                        <a href="PatientServlet?action=view&id=<%= patient.getPATIENT_ID() %>" class="btn btn-sm btn-info">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <% if ("A".equals(patient.getPATIENT_STATUS())) { %>
                                        <a href="PatientServlet?action=edit&id=<%= patient.getPATIENT_ID() %>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="#" onclick="confirmDelete('<%= patient.getPATIENT_ID() %>')" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                        <% } else { %>
                                        <form action="PatientServlet" method="post" class="d-inline">
                                            <input type="hidden" name="id" value="<%= patient.getPATIENT_ID() %>">
                                            <input type="hidden" name="action" value="restore">
                                            <button type="submit" class="btn btn-sm btn-success">
                                                <i class="fas fa-undo"></i>
                                            </button>
                                        </form>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                            </tbody>
                        </table>

                        <!-- Paginador optimizado -->
                        <% if (totalPaginas > 1) { %>
                        <nav aria-label="Paginación">
                            <ul class="pagination justify-content-center">
                                <li class="page-item <%= paginaActual == 1 ? "disabled" : "" %>">
                                    <a class="page-link" href="?estado=<%= estadoFiltro != null ? estadoFiltro : "todos" %>&pagina=<%= paginaActual - 1 %>">&laquo;</a>
                                </li>
                                <% for (int i = 1; i <= totalPaginas; i++) { %>
                                <li class="page-item <%= i == paginaActual ? "active" : "" %>">
                                    <a class="page-link" href="?estado=<%= estadoFiltro != null ? estadoFiltro : "todos" %>&pagina=<%= i %>"><%= i %></a>
                                </li>
                                <% } %>
                                <li class="page-item <%= paginaActual == totalPaginas ? "disabled" : "" %>">
                                    <a class="page-link" href="?estado=<%= estadoFiltro != null ? estadoFiltro : "todos" %>&pagina=<%= paginaActual + 1 %>">&raquo;</a>
                                </li>
                            </ul>
                        </nav>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Función para confirmar eliminación de paciente
    function confirmDelete(patientId) {
        Swal.fire({
            title: '¿Eliminar paciente?',
            text: "Esta acción no se puede deshacer",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        }).then((result) => {
            if (result.isConfirmed) {
                // Redirigir a la acción de eliminación
                window.location.href = 'PatientServlet?action=delete&id=' + patientId;
            }
        });
    }

    // Función para filtrar la tabla - Actualizada con nuevos campos
    function filterTable() {
        const nameFilter = document.getElementById('filterName').value.toLowerCase();
        const lastNameFilter = document.getElementById('filterLastName').value.toLowerCase();
        const docFilter = document.getElementById('filterDoc').value.toLowerCase();
        const phoneFilter = document.getElementById('filterPhone').value.toLowerCase();
        const reasonFilter = document.getElementById('filterReason').value.toLowerCase();
        const statusFilter = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#patientTableBody tr');

        rows.forEach(row => {
            const name = row.cells[0].textContent.toLowerCase();
            const lastName = row.cells[1].textContent.toLowerCase();
            const doc = row.cells[2].textContent.toLowerCase();
            const phone = row.cells[3].textContent.toLowerCase();
            const reason = row.cells[4].textContent.toLowerCase();
            const status = row.cells[5].querySelector('.badge').textContent.trim() === 'Activo' ? 'A' : 'I';

            const nameMatch = name.includes(nameFilter) || nameFilter === '';
            const lastNameMatch = lastName.includes(lastNameFilter) || lastNameFilter === '';
            const docMatch = doc.includes(docFilter) || docFilter === '';
            const phoneMatch = phone.includes(phoneFilter) || phoneFilter === '';
            const reasonMatch = reason.includes(reasonFilter) || reasonFilter === '';
            const statusMatch = statusFilter === '' || status === statusFilter;

            if (nameMatch && lastNameMatch && docMatch && phoneMatch && reasonMatch && statusMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Filtrar al cargar la página
    document.addEventListener('DOMContentLoaded', function () {
        filterTable();
    });

    // Filtrar al presionar Enter en cualquier campo
    document.querySelectorAll('#filterName, #filterLastName, #filterDoc, #filterPhone, #filterReason, #filterStatus').forEach(input => {
        input.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                filterTable();
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('patientForm');

        // Crear elementos para mensajes de error
        function createErrorElement(field, message) {
            // Eliminar mensaje de error previo si existe
            const existingError = field.nextElementSibling;
            if (existingError && existingError.classList.contains('invalid-feedback')) {
                existingError.remove();
            }

            // Crear nuevo elemento de error
            const errorElement = document.createElement('div');
            errorElement.className = 'invalid-feedback';
            errorElement.textContent = message;
            field.parentNode.appendChild(errorElement);
        }

        // Validación en tiempo real para nombres (solo letras)
        form.querySelector('input[name="PATIENT_FIRST_NAME"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
            if (/[0-9]/.test(this.value)) {
                createErrorElement(this, 'No se permiten números en el nombre');
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                const errorElement = this.nextElementSibling;
                if (errorElement && errorElement.classList.contains('invalid-feedback')) {
                    errorElement.remove();
                }
            }
        });

        form.querySelector('input[name="PATIENT_LAST_NAME"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
            if (/[0-9]/.test(this.value)) {
                createErrorElement(this, 'No se permiten números en el apellido');
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                const errorElement = this.nextElementSibling;
                if (errorElement && errorElement.classList.contains('invalid-feedback')) {
                    errorElement.remove();
                }
            }
        });

        // Validación para número de documento (8 dígitos)
        form.querySelector('input[name="PATIENT_NRO_DOC"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 8) {
                this.value = this.value.substring(0, 8);
            }
        });

        form.querySelector('input[name="PATIENT_NRO_DOC"]').addEventListener('blur', function() {
            if (!/^\d{8}$/.test(this.value)) {
                createErrorElement(this, 'El documento debe tener exactamente 8 dígitos');
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                const errorElement = this.nextElementSibling;
                if (errorElement && errorElement.classList.contains('invalid-feedback')) {
                    errorElement.remove();
                }
            }
        });

        // Validación para teléfono (9 dígitos que empieza con 9)
        form.querySelector('input[name="PATIENT_PHONE"]').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 9) {
                this.value = this.value.substring(0, 9);
            }
        });

        form.querySelector('input[name="PATIENT_PHONE"]').addEventListener('blur', function() {
            if (!/^9\d{8}$/.test(this.value)) {
                createErrorElement(this, 'El teléfono debe tener 9 dígitos y comenzar con 9');
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                const errorElement = this.nextElementSibling;
                if (errorElement && errorElement.classList.contains('invalid-feedback')) {
                    errorElement.remove();
                }
            }
        });

        // Validación para fecha de nacimiento (no futura)
        form.querySelector('input[name="PATIENT_BIRTH_DATE"]').addEventListener('change', function() {
            const birthDate = new Date(this.value);
            const today = new Date();
            if (birthDate >= today) {
                createErrorElement(this, 'La fecha de nacimiento no puede ser futura');
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
                const errorElement = this.nextElementSibling;
                if (errorElement && errorElement.classList.contains('invalid-feedback')) {
                    errorElement.remove();
                }
            }
        });

        // Validación al enviar el formulario
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            // Campos a validar
            const firstName = form.querySelector('input[name="PATIENT_FIRST_NAME"]');
            const lastName = form.querySelector('input[name="PATIENT_LAST_NAME"]');
            const birthDate = form.querySelector('input[name="PATIENT_BIRTH_DATE"]');
            const docNumber = form.querySelector('input[name="PATIENT_NRO_DOC"]');
            const phone = form.querySelector('input[name="PATIENT_PHONE"]');

            let isValid = true;

            // Validar nombres (solo letras)
            const nameRegex = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;
            if (!nameRegex.test(firstName.value.trim())) {
                createErrorElement(firstName, 'El nombre solo puede contener letras');
                firstName.classList.add('is-invalid');
                isValid = false;
            }

            if (!nameRegex.test(lastName.value.trim())) {
                createErrorElement(lastName, 'El apellido solo puede contener letras');
                lastName.classList.add('is-invalid');
                isValid = false;
            }

            // Validar fecha de nacimiento
            if (!birthDate.value) {
                createErrorElement(birthDate, 'La fecha de nacimiento es requerida');
                birthDate.classList.add('is-invalid');
                isValid = false;
            } else {
                const birthDateObj = new Date(birthDate.value);
                const today = new Date();
                if (birthDateObj >= today) {
                    createErrorElement(birthDate, 'La fecha de nacimiento no puede ser futura');
                    birthDate.classList.add('is-invalid');
                    isValid = false;
                }
            }

            // Validar número de documento
            if (!/^\d{8}$/.test(docNumber.value)) {
                createErrorElement(docNumber, 'El documento debe tener exactamente 8 dígitos');
                docNumber.classList.add('is-invalid');
                isValid = false;
            }

            // Validar teléfono
            if (!/^9\d{8}$/.test(phone.value)) {
                createErrorElement(phone, 'El teléfono debe tener 9 dígitos y comenzar con 9');
                phone.classList.add('is-invalid');
                isValid = false;
            }

            if (!isValid) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error de validación',
                    text: 'Por favor corrija los campos marcados',
                    confirmButtonColor: '#1abc9c'
                });
                return;
            }

            // Mostrar confirmación
            Swal.fire({
                title: '¿Registrar paciente?',
                text: "¿Está seguro que desea registrar este paciente?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#1abc9c',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Registrando paciente...',
                        allowOutsideClick: false,
                        didOpen: () => {
                            Swal.showLoading();
                            setTimeout(() => {
                                form.submit();
                            }, 1000);
                        }
                    });
                }
            });
        });
    });
</script>
</body>
</html>