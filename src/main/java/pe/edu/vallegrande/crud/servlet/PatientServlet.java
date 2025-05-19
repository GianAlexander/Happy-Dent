package pe.edu.vallegrande.crud.servlet;

import jakarta.servlet.annotation.WebServlet;
import pe.edu.vallegrande.crud.controller.PatientController;
import pe.edu.vallegrande.crud.dto.PatientDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/PatientServlet")
public class PatientServlet extends HttpServlet {
    private static final String ACTION_LIST = "list";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_EDIT = "edit";
    private static final String ACTION_UPDATE = "update";
    private static final String ACTION_DELETE = "delete";
    private static final String ACTION_RESTORE = "restore";
    private static final String ACTION_VIEW = "view";

    private PatientController patientController = new PatientController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : ACTION_LIST) {
            case ACTION_LIST:
                listPatients(request, response);
                break;
            case ACTION_EDIT:
                showEditForm(request, response);
                break;
            case ACTION_DELETE:
                deletePatient(request, response);
                break;
            case ACTION_VIEW: // Nuevo caso para visualizar ficha médica
                viewPatient(request, response);
                break;
            default:
                listPatients(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case ACTION_ADD:
                addPatient(request, response);
                break;
            case ACTION_UPDATE:
                updatePatient(request, response);
                break;
            case ACTION_RESTORE:
                restorePatient(request, response);
                break;
            default:
                listPatients(request, response);
                break;
        }
    }

    private void viewPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para visualizar.");
            response.sendRedirect(request.getContextPath() + "/PatientServlet?action=list");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/PatientServlet?action=list");
            return;
        }

        PatientDTO patient = patientController.getPatientById(patientId);
        if (patient != null) {
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("viewPatient.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/PatientServlet?action=list");
        }
    }

    private void listPatients(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<PatientDTO> patients = patientController.listAll();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("listPatients.jsp").forward(request, response);
    }

    private void addPatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            PatientDTO newPatient = new PatientDTO();
            newPatient.setPATIENT_FIRST_NAME(request.getParameter("PATIENT_FIRST_NAME"));
            newPatient.setPATIENT_LAST_NAME(request.getParameter("PATIENT_LAST_NAME"));

            // Convertir String a Date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date birthDate = sdf.parse(request.getParameter("PATIENT_BIRTH_DATE"));
            newPatient.setPATIENT_BIRTH_DATE(birthDate);

            newPatient.setPATIENT_DOC_TYPE(request.getParameter("PATIENT_DOC_TYPE"));
            newPatient.setPATIENT_NRO_DOC(request.getParameter("PATIENT_NRO_DOC"));
            newPatient.setPATIENT_PHONE(request.getParameter("PATIENT_PHONE"));
            newPatient.setPATIENT_ADDRESS(request.getParameter("PATIENT_ADDRESS"));
            newPatient.setPATIENT_OCCUPATION(request.getParameter("PATIENT_OCCUPATION"));
            newPatient.setPATIENT_REASON(request.getParameter("PATIENT_REASON"));
            newPatient.setPATIENT_RISK_CONDITION(request.getParameter("PATIENT_RISK_CONDITION"));
            newPatient.setPATIENT_DETAILS(request.getParameter("PATIENT_DETAILS"));
            newPatient.setPATIENT_STATUS("A"); // Por defecto, activo

            patientController.addPatient(newPatient);
            response.sendRedirect("PatientServlet?action=list");
        } catch (ParseException e) {
            System.out.println("Error al parsear fecha: " + e.getMessage());
            response.sendRedirect("PatientServlet?action=list&error=Formato de fecha incorrecto");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para editar.");
            response.sendRedirect(request.getContextPath() + "/PatientServlet?action=list");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/PatientServlet?action=list");
            return;
        }

        PatientDTO patient = patientController.getPatientById(patientId);
        if (patient != null) {
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("editPatient.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/PatientServlet?action=list");
        }
    }

    private void updatePatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("PATIENT_ID");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para actualizar.");
            response.sendRedirect("PatientServlet?action=list");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("PatientServlet?action=list");
            return;
        }

        try {
            PatientDTO updatedPatient = new PatientDTO();
            updatedPatient.setPATIENT_ID(patientId);
            updatedPatient.setPATIENT_FIRST_NAME(request.getParameter("PATIENT_FIRST_NAME"));
            updatedPatient.setPATIENT_LAST_NAME(request.getParameter("PATIENT_LAST_NAME"));

            // Convertir String a Date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date birthDate = sdf.parse(request.getParameter("PATIENT_BIRTH_DATE"));
            updatedPatient.setPATIENT_BIRTH_DATE(birthDate);

            updatedPatient.setPATIENT_DOC_TYPE(request.getParameter("PATIENT_DOC_TYPE"));
            updatedPatient.setPATIENT_NRO_DOC(request.getParameter("PATIENT_NRO_DOC"));
            updatedPatient.setPATIENT_PHONE(request.getParameter("PATIENT_PHONE"));
            updatedPatient.setPATIENT_ADDRESS(request.getParameter("PATIENT_ADDRESS"));
            updatedPatient.setPATIENT_OCCUPATION(request.getParameter("PATIENT_OCCUPATION"));
            updatedPatient.setPATIENT_REASON(request.getParameter("PATIENT_REASON"));
            updatedPatient.setPATIENT_RISK_CONDITION(request.getParameter("PATIENT_RISK_CONDITION"));
            updatedPatient.setPATIENT_DETAILS(request.getParameter("PATIENT_DETAILS"));
            updatedPatient.setPATIENT_STATUS(request.getParameter("PATIENT_STATUS"));

            patientController.updatePatient(updatedPatient);
            response.sendRedirect("PatientServlet?action=list");
        } catch (ParseException e) {
            System.out.println("Error al parsear fecha: " + e.getMessage());
            response.sendRedirect("PatientServlet?action=list&error=Formato de fecha incorrecto");
        }
    }

    private void deletePatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para eliminar.");
            response.sendRedirect("PatientServlet?action=list");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("PatientServlet?action=list");
            return;
        }

        patientController.deletePatient(patientId);
        response.sendRedirect("PatientServlet?action=list");
    }

    private void restorePatient(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para restaurar.");
            response.sendRedirect("PatientServlet?action=list");
            return;
        }

        int patientId;
        try {
            patientId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("PatientServlet?action=list");
            return;
        }

        patientController.restorePatient(patientId);
        response.sendRedirect("PatientServlet?action=list");
    }
}