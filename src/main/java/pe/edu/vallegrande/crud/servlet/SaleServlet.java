package pe.edu.vallegrande.crud.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.edu.vallegrande.crud.controller.SaleController;
import pe.edu.vallegrande.crud.dto.SaleDTO;
import pe.edu.vallegrande.crud.dto.SaleDetailDTO;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SaleServlet")
public class SaleServlet extends HttpServlet {
    private static final String ACTION_LIST = "list";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_CANCEL = "cancel";
    private static final String ACTION_VIEW = "view";
    private static final String ACTION_NEW = "new";

    private SaleController saleController = new SaleController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : ACTION_LIST) {
            case ACTION_LIST:
                listSales(request, response);
                break;
            case ACTION_NEW:
                showNewForm(request, response);
                break;
            case ACTION_VIEW:
                viewSale(request, response);
                break;
            case ACTION_CANCEL:
                cancelSale(request, response);
                break;
            default:
                listSales(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case ACTION_ADD:
                addSale(request, response);
                break;
            default:
                listSales(request, response);
                break;
        }
    }

    private void listSales(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filter = request.getParameter("filter");
        List<SaleDTO> sales;

        if ("cancelled".equals(filter)) {
            sales = saleController.listCancelledSales();
        } else if ("active".equals(filter)) {
            sales = saleController.listActiveSales();
        } else {
            sales = saleController.listAllSales();
        }

        request.setAttribute("sales", sales);
        request.setAttribute("currentFilter", filter);
        request.getRequestDispatcher("listSale.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("listSale.jsp").forward(request, response);
    }

    private void viewSale(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("SaleServlet?action=list");
            return;
        }

        try {
            int saleId = Integer.parseInt(idStr);
            SaleDTO sale = saleController.getSaleById(saleId);
            if (sale != null) {
                List<SaleDetailDTO> details = saleController.getSaleDetails(saleId);
                request.setAttribute("sale", sale);
                request.setAttribute("details", details);
                request.getRequestDispatcher("viewSale.jsp").forward(request, response);
            } else {
                response.sendRedirect("SaleServlet?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("SaleServlet?action=list");
        }
    }

    private void addSale(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            // Validar parámetros requeridos
            if (request.getParameter("PATIENT_ID") == null || request.getParameter("EMPLOYEE_ID") == null) {
                request.setAttribute("error", "Faltan datos requeridos (Paciente o Empleado)");
                request.getRequestDispatcher("listSale.jsp").forward(request, response);
                return;
            }

            // Crear objeto SaleDTO
            SaleDTO sale = new SaleDTO();
            sale.setSALE_DATE(Date.valueOf(request.getParameter("SALE_DATE")));
            sale.setSALE_TOTAL(new BigDecimal(request.getParameter("SALE_TOTAL")));
            sale.setSALE_METHOD(request.getParameter("SALE_METHOD").charAt(0));
            sale.setSALE_STATUS('A'); // Por defecto activa

            // Manejar PATIENT_ID de forma segura
            String patientIdStr = request.getParameter("PATIENT_ID");
            if (patientIdStr == null || patientIdStr.isEmpty()) {
                throw new IllegalArgumentException("El ID del paciente es requerido");
            }
            sale.setPATIENT_ID(Integer.parseInt(patientIdStr));

            // Manejar EMPLOYEE_ID de forma segura
            String employeeIdStr = request.getParameter("EMPLOYEE_ID");
            if (employeeIdStr == null || employeeIdStr.isEmpty()) {
                throw new IllegalArgumentException("El ID del empleado es requerido");
            }
            sale.setEMPLOYEE_ID(Integer.parseInt(employeeIdStr));

            // Procesar detalles de la venta
            List<SaleDetailDTO> details = new ArrayList<>();
            String[] productIds = request.getParameterValues("PRODUCT_ID");
            String[] quantities = request.getParameterValues("SALE_DETAIL_QUANTITY");
            String[] prices = request.getParameterValues("SALE_DETAIL_PRICE");

            if (productIds != null && quantities != null && prices != null
                    && productIds.length == quantities.length
                    && quantities.length == prices.length) {

                for (int i = 0; i < productIds.length; i++) {
                    if (!productIds[i].isEmpty() && !quantities[i].isEmpty() && !prices[i].isEmpty()) {
                        SaleDetailDTO detail = new SaleDetailDTO();
                        detail.setPRODUCT_ID(Integer.parseInt(productIds[i]));
                        detail.setSALE_DETAIL_QUANTITY(Integer.parseInt(quantities[i]));
                        detail.setSALE_DETAIL_PRICE(new BigDecimal(prices[i]));

                        // Calcular subtotal
                        BigDecimal subtotal = new BigDecimal(prices[i])
                                .multiply(new BigDecimal(quantities[i]));
                        detail.setSALE_DETAIL_SUBTOTAL(subtotal);

                        details.add(detail);
                    }
                }
            }

            // Validar que haya al menos un detalle
            if (details.isEmpty()) {
                request.setAttribute("error", "Debe agregar al menos un producto");
                request.getRequestDispatcher("listSale.jsp").forward(request, response);
                return;
            }

            // Debug: Mostrar datos antes de registrar
            System.out.println("Datos de venta a registrar:");
            System.out.println("Fecha: " + sale.getSALE_DATE());
            System.out.println("Paciente ID: " + sale.getPATIENT_ID());
            System.out.println("Empleado ID: " + sale.getEMPLOYEE_ID());
            System.out.println("Total: " + sale.getSALE_TOTAL());
            System.out.println("Método: " + sale.getSALE_METHOD());
            System.out.println("Detalles: " + details.size());

            // Guardar la venta con sus detalles (transacción)
            boolean success = saleController.createSaleWithDetails(sale, details);

            if (success) {
                response.sendRedirect("SaleServlet?action=list");
            } else {
                request.setAttribute("error", "Error al registrar la venta");
                request.getRequestDispatcher("listSale.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Esto mostrará cualquier error en los logs
            request.setAttribute("error", "Error en los datos: " + e.getMessage());
            request.getRequestDispatcher("listSale.jsp").forward(request, response);
        }
    }

    private void cancelSale(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("SaleServlet?action=list");
            return;
        }

        try {
            int saleId = Integer.parseInt(idStr);
            boolean success = saleController.cancelSale(saleId);

            if (!success) {
                request.setAttribute("error", "No se pudo cancelar la venta. Puede que ya esté cancelada o no exista.");
            }

            listSales(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("SaleServlet?action=list");
        }
    }
}