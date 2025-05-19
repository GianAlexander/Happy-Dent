package pe.edu.vallegrande.crud.servlet;

import jakarta.servlet.annotation.WebServlet;
import pe.edu.vallegrande.crud.controller.SupplierController;
import pe.edu.vallegrande.crud.dto.SupplierDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/SupplierServlet")
public class SupplierServlet extends HttpServlet {
    private static final String ACTION_LIST = "list";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_EDIT = "edit";
    private static final String ACTION_UPDATE = "update";
    private static final String ACTION_DELETE = "delete";
    private static final String ACTION_RESTORE = "restore";
    private static final String ACTION_VIEW = "view";

    private SupplierController supplierController = new SupplierController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : ACTION_LIST) {
            case ACTION_LIST:
                listSuppliers(request, response);
                break;
            case ACTION_EDIT:
                showEditForm(request, response);
                break;
            case ACTION_DELETE:
                deleteSupplier(request, response);
                break;
            case ACTION_VIEW:
                viewSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case ACTION_ADD:
                addSupplier(request, response);
                break;
            case ACTION_UPDATE:
                updateSupplier(request, response);
                break;
            case ACTION_RESTORE:
                restoreSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    private void viewSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para visualizar.");
            response.sendRedirect(request.getContextPath() + "/SupplierServlet?action=list");
            return;
        }

        int supplierId;
        try {
            supplierId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/SupplierServlet?action=list");
            return;
        }

        SupplierDTO supplier = supplierController.getSupplierById(supplierId);
        if (supplier != null) {
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("viewSupplier.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/SupplierServlet?action=list");
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<SupplierDTO> suppliers = supplierController.listAll();
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("listSuppliers.jsp").forward(request, response);
    }

    private void addSupplier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        SupplierDTO newSupplier = new SupplierDTO();
        newSupplier.setSUPPLIER_NAME(request.getParameter("SUPPLIER_NAME"));
        newSupplier.setSUPPLIER_RUC(request.getParameter("SUPPLIER_RUC"));
        newSupplier.setSUPPLIER_EMAIL(request.getParameter("SUPPLIER_EMAIL"));
        newSupplier.setSUPPLIER_PHONE(request.getParameter("SUPPLIER_PHONE"));
        newSupplier.setSUPPLIER_WEBSITE(request.getParameter("SUPPLIER_WEBSITE"));
        newSupplier.setSUPPLIER_ADDRESS(request.getParameter("SUPPLIER_ADDRESS"));
        newSupplier.setSUPPLIER_TYPE(request.getParameter("SUPPLIER_TYPE"));
        newSupplier.setSUPPLIER_STATUS("A"); // Por defecto, activo

        supplierController.addSupplier(newSupplier);
        response.sendRedirect("SupplierServlet?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para editar.");
            response.sendRedirect(request.getContextPath() + "/SupplierServlet?action=list");
            return;
        }

        int supplierId;
        try {
            supplierId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/SupplierServlet?action=list");
            return;
        }

        SupplierDTO supplier = supplierController.getSupplierById(supplierId);
        if (supplier != null) {
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("editSupplier.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/SupplierServlet?action=list");
        }
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("SUPPLIER_ID");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para actualizar.");
            response.sendRedirect("SupplierServlet?action=list");
            return;
        }

        int supplierId;
        try {
            supplierId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("SupplierServlet?action=list");
            return;
        }

        SupplierDTO updatedSupplier = new SupplierDTO();
        updatedSupplier.setSUPPLIER_ID(supplierId);
        updatedSupplier.setSUPPLIER_NAME(request.getParameter("SUPPLIER_NAME"));
        updatedSupplier.setSUPPLIER_RUC(request.getParameter("SUPPLIER_RUC"));
        updatedSupplier.setSUPPLIER_EMAIL(request.getParameter("SUPPLIER_EMAIL"));
        updatedSupplier.setSUPPLIER_PHONE(request.getParameter("SUPPLIER_PHONE"));
        updatedSupplier.setSUPPLIER_WEBSITE(request.getParameter("SUPPLIER_WEBSITE"));
        updatedSupplier.setSUPPLIER_ADDRESS(request.getParameter("SUPPLIER_ADDRESS"));
        updatedSupplier.setSUPPLIER_TYPE(request.getParameter("SUPPLIER_TYPE"));
        updatedSupplier.setSUPPLIER_STATUS(request.getParameter("SUPPLIER_STATUS"));

        supplierController.updateSupplier(updatedSupplier);
        response.sendRedirect("SupplierServlet?action=list");
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para eliminar.");
            response.sendRedirect("SupplierServlet?action=list");
            return;
        }

        int supplierId;
        try {
            supplierId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("SupplierServlet?action=list");
            return;
        }

        supplierController.deleteSupplier(supplierId);
        response.sendRedirect("SupplierServlet?action=list");
    }

    private void restoreSupplier(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para restaurar.");
            response.sendRedirect("SupplierServlet?action=list");
            return;
        }

        int supplierId;
        try {
            supplierId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("SupplierServlet?action=list");
            return;
        }

        supplierController.restoreSupplier(supplierId);
        response.sendRedirect("SupplierServlet?action=list");
    }
}