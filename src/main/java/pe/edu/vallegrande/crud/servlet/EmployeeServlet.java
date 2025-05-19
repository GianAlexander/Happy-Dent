package pe.edu.vallegrande.crud.servlet;

import jakarta.servlet.annotation.WebServlet;
import pe.edu.vallegrande.crud.controller.EmployeeController;
import pe.edu.vallegrande.crud.dto.EmployeeDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
    private static final String ACTION_LIST = "list";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_EDIT = "edit";
    private static final String ACTION_UPDATE = "update";
    private static final String ACTION_DELETE = "delete";
    private static final String ACTION_RESTORE = "restore";
    private static final String ACTION_VIEW = "view";

    private EmployeeController employeeController = new EmployeeController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : ACTION_LIST) {
            case ACTION_LIST:
                listEmployees(request, response);
                break;
            case ACTION_EDIT:
                showEditForm(request, response);
                break;
            case ACTION_DELETE:
                deleteEmployee(request, response);
                break;
            case ACTION_VIEW:
                viewEmployee(request, response);
                break;
            default:
                listEmployees(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case ACTION_ADD:
                addEmployee(request, response);
                break;
            case ACTION_UPDATE:
                updateEmployee(request, response);
                break;
            case ACTION_RESTORE:
                restoreEmployee(request, response);
                break;
            default:
                listEmployees(request, response);
                break;
        }
    }

    private void viewEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para visualizar.");
            response.sendRedirect(request.getContextPath() + "/EmployeeServlet?action=list");
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/EmployeeServlet?action=list");
            return;
        }

        EmployeeDTO employee = employeeController.getEmployeeById(employeeId);
        if (employee != null) {
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("viewEmployee.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/EmployeeServlet?action=list");
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<EmployeeDTO> employees = employeeController.listAll();
        request.setAttribute("employees", employees);
        request.getRequestDispatcher("listEmployee.jsp").forward(request, response);
    }

    private void addEmployee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            EmployeeDTO newEmployee = new EmployeeDTO();
            newEmployee.setEMPLOYEE_FIRST_NAME(request.getParameter("EMPLOYEE_FIRST_NAME"));
            newEmployee.setEMPLOYEE_LAST_NAME(request.getParameter("EMPLOYEE_LAST_NAME"));

            // Convertir String a Date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date birthDate = sdf.parse(request.getParameter("EMPLOYEE_BIRTH_DATE"));
            newEmployee.setEMPLOYEE_BIRTH_DATE(birthDate);

            newEmployee.setEMPLOYEE_DOC_TYPE(request.getParameter("EMPLOYEE_DOC_TYPE"));
            newEmployee.setEMPLOYEE_NRO_DOC(request.getParameter("EMPLOYEE_NRO_DOC"));
            newEmployee.setEMPLOYEE_PHONE(request.getParameter("EMPLOYEE_PHONE"));
            newEmployee.setEMPLOYEE_EMAIL(request.getParameter("EMPLOYEE_EMAIL"));
            newEmployee.setEMPLOYEE_STATUS("A"); // Por defecto, activo

            employeeController.addEmployee(newEmployee);
            response.sendRedirect("EmployeeServlet?action=list");
        } catch (ParseException e) {
            System.out.println("Error al parsear fecha: " + e.getMessage());
            response.sendRedirect("EmployeeServlet?action=list&error=Formato de fecha incorrecto");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para editar.");
            response.sendRedirect(request.getContextPath() + "/EmployeeServlet?action=list");
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/EmployeeServlet?action=list");
            return;
        }

        EmployeeDTO employee = employeeController.getEmployeeById(employeeId);
        if (employee != null) {
            request.setAttribute("employee", employee);
            request.getRequestDispatcher("editEmployee.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/EmployeeServlet?action=list");
        }
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("EMPLOYEE_ID");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para actualizar.");
            response.sendRedirect("EmployeeServlet?action=list");
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("EmployeeServlet?action=list");
            return;
        }

        try {
            EmployeeDTO updatedEmployee = new EmployeeDTO();
            updatedEmployee.setEMPLOYEE_ID(employeeId);
            updatedEmployee.setEMPLOYEE_FIRST_NAME(request.getParameter("EMPLOYEE_FIRST_NAME"));
            updatedEmployee.setEMPLOYEE_LAST_NAME(request.getParameter("EMPLOYEE_LAST_NAME"));

            // Convertir String a Date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date birthDate = sdf.parse(request.getParameter("EMPLOYEE_BIRTH_DATE"));
            updatedEmployee.setEMPLOYEE_BIRTH_DATE(birthDate);

            updatedEmployee.setEMPLOYEE_DOC_TYPE(request.getParameter("EMPLOYEE_DOC_TYPE"));
            updatedEmployee.setEMPLOYEE_NRO_DOC(request.getParameter("EMPLOYEE_NRO_DOC"));
            updatedEmployee.setEMPLOYEE_PHONE(request.getParameter("EMPLOYEE_PHONE"));
            updatedEmployee.setEMPLOYEE_EMAIL(request.getParameter("EMPLOYEE_EMAIL"));
            updatedEmployee.setEMPLOYEE_STATUS(request.getParameter("EMPLOYEE_STATUS"));

            employeeController.updateEmployee(updatedEmployee);
            response.sendRedirect("EmployeeServlet?action=list");
        } catch (ParseException e) {
            System.out.println("Error al parsear fecha: " + e.getMessage());
            response.sendRedirect("EmployeeServlet?action=list&error=Formato de fecha incorrecto");
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para eliminar.");
            response.sendRedirect("EmployeeServlet?action=list");
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("EmployeeServlet?action=list");
            return;
        }

        employeeController.deleteEmployee(employeeId);
        response.sendRedirect("EmployeeServlet?action=list");
    }

    private void restoreEmployee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para restaurar.");
            response.sendRedirect("EmployeeServlet?action=list");
            return;
        }

        int employeeId;
        try {
            employeeId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("EmployeeServlet?action=list");
            return;
        }

        employeeController.restoreEmployee(employeeId);
        response.sendRedirect("EmployeeServlet?action=list");
    }
}