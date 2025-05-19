package pe.edu.vallegrande.crud.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.edu.vallegrande.crud.controller.PurchaseController;
import pe.edu.vallegrande.crud.dto.PurchaseDTO;
import pe.edu.vallegrande.crud.dto.PurchaseDetailDTO;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PurchaseServlet")
public class PurchaseServlet extends HttpServlet {
    private static final String ACTION_LIST = "list";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_EDIT = "edit";
    private static final String ACTION_UPDATE = "update";
    private static final String ACTION_DELETE = "delete";
    private static final String ACTION_RESTORE = "restore";
    private static final String ACTION_VIEW = "view";
    private static final String ACTION_NEW = "new";

    private PurchaseController purchaseController = new PurchaseController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : ACTION_LIST) {
            case ACTION_LIST:
                listPurchases(request, response);
                break;
            case ACTION_NEW:
                showNewForm(request, response);
                break;
            case ACTION_ADD:
                showNewForm(request, response);
                break;
            case ACTION_EDIT:
                showEditForm(request, response);
                break;
            case ACTION_VIEW:
                viewPurchase(request, response);
                break;
            case ACTION_DELETE:
                deletePurchase(request, response);
                break;
            case ACTION_RESTORE:
                restorePurchase(request, response);
                break;
            default:
                listPurchases(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case ACTION_ADD:
                addPurchase(request, response);
                break;
            case ACTION_UPDATE:
                updatePurchase(request, response);
                break;
            default:
                listPurchases(request, response);
                break;
        }
    }

    private void listPurchases(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<PurchaseDTO> purchases = purchaseController.listAllPurchases();
        request.setAttribute("purchases", purchases);
        request.getRequestDispatcher("listPurchase.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("purchaseForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("PurchaseServlet?action=list");
            return;
        }

        try {
            int purchaseId = Integer.parseInt(idStr);
            PurchaseDTO purchase = purchaseController.getPurchaseById(purchaseId);
            if (purchase != null) {
                List<PurchaseDetailDTO> details = purchaseController.getPurchaseDetails(purchaseId);
                request.setAttribute("purchase", purchase);
                request.setAttribute("details", details);
                request.getRequestDispatcher("editPurchase.jsp").forward(request, response);
            } else {
                response.sendRedirect("PurchaseServlet?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("PurchaseServlet?action=list");
        }
    }

    private void viewPurchase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("PurchaseServlet?action=list");
            return;
        }

        try {
            int purchaseId = Integer.parseInt(idStr);
            PurchaseDTO purchase = purchaseController.getPurchaseById(purchaseId);
            if (purchase != null) {
                List<PurchaseDetailDTO> details = purchaseController.getPurchaseDetails(purchaseId);
                request.setAttribute("purchase", purchase);
                request.setAttribute("details", details);
                request.getRequestDispatcher("viewPurchase.jsp").forward(request, response);
            } else {
                response.sendRedirect("PurchaseServlet?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("PurchaseServlet?action=list");
        }
    }

    private void addPurchase(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            // Crear objeto PurchaseDTO
            PurchaseDTO purchase = new PurchaseDTO();
            purchase.setPURCHASE_DATE(Date.valueOf(request.getParameter("PURCHASE_DATE")));
            purchase.setPURCHASE_TOTAL(new BigDecimal(request.getParameter("PURCHASE_TOTAL")));
            purchase.setPURCHASE_STATUS('A');
            purchase.setEMPLOYEE_ID(Integer.parseInt(request.getParameter("EMPLOYEE_ID")));
            purchase.setSUPPLIER_ID(Integer.parseInt(request.getParameter("SUPPLIER_ID")));

            // Procesar detalles de la compra
            List<PurchaseDetailDTO> details = new ArrayList<>();
            String[] productIds = request.getParameterValues("PRODUCT_ID");
            String[] quantities = request.getParameterValues("PURCHASE_DETAIL_QUANTITY"); // Cambiado de QUANTITY
            String[] prices = request.getParameterValues("PURCHASE_DETAIL_PRICE"); // Cambiado de PRICE

            if (productIds != null && quantities != null && prices != null
                    && productIds.length == quantities.length
                    && quantities.length == prices.length) {

                for (int i = 0; i < productIds.length; i++) {
                    if (!productIds[i].isEmpty() && !quantities[i].isEmpty() && !prices[i].isEmpty()) {
                        PurchaseDetailDTO detail = new PurchaseDetailDTO();
                        detail.setPRODUCT_ID(Integer.parseInt(productIds[i]));
                        detail.setPURCHASE_DETAIL_QUANTITY(Integer.parseInt(quantities[i]));
                        detail.setPURCHASE_DETAIL_PRICE(new BigDecimal(prices[i]));

                        // Calcular subtotal
                        BigDecimal subtotal = new BigDecimal(prices[i])
                                .multiply(new BigDecimal(quantities[i]));
                        detail.setPURCHASE_DETAIL_SUBTOTAL(subtotal);

                        details.add(detail);
                    }
                }
            }

            // Validar que haya al menos un detalle
            if (details.isEmpty()) {
                request.setAttribute("error", "Debe agregar al menos un producto");
                request.getRequestDispatcher("purchaseForm.jsp").forward(request, response);
                return;
            }

            // Guardar la compra con sus detalles (transacción)
            boolean success = purchaseController.createPurchaseWithDetails(purchase, details);

            if (success) {
                response.sendRedirect("PurchaseServlet?action=list");
            } else {
                request.setAttribute("error", "Error al registrar la compra");
                request.getRequestDispatcher("purchaseForm.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error en los datos: " + e.getMessage());
            request.getRequestDispatcher("purchaseForm.jsp").forward(request, response);
        }
    }

    private void updatePurchase(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idStr = request.getParameter("PURCHASE_ID");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("PurchaseServlet?action=list");
            return;
        }

        try {
            // Actualizar datos principales de la compra
            PurchaseDTO purchase = new PurchaseDTO();
            purchase.setPURCHASE_ID(Integer.parseInt(idStr));
            purchase.setPURCHASE_DATE(Date.valueOf(request.getParameter("PURCHASE_DATE")));
            purchase.setPURCHASE_TOTAL(new BigDecimal(request.getParameter("PURCHASE_TOTAL")));
            purchase.setPURCHASE_STATUS(request.getParameter("PURCHASE_STATUS").charAt(0));
            purchase.setEMPLOYEE_ID(Integer.parseInt(request.getParameter("EMPLOYEE_ID")));
            purchase.setSUPPLIER_ID(Integer.parseInt(request.getParameter("SUPPLIER_ID")));

            // Actualizar la compra
            boolean success = purchaseController.updatePurchase(purchase);

            if (success) {
                response.sendRedirect("PurchaseServlet?action=list");
            } else {
                request.setAttribute("error", "Error al actualizar la compra");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error en los datos: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deletePurchase(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("PurchaseServlet?action=list");
            return;
        }

        try {
            int purchaseId = Integer.parseInt(idStr);
            purchaseController.deletePurchase(purchaseId);
            response.sendRedirect("PurchaseServlet?action=list");
        } catch (NumberFormatException e) {
            response.sendRedirect("PurchaseServlet?action=list");
        }
    }

    private void restorePurchase(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("PurchaseServlet?action=list");
            return;
        }

        try {
            int purchaseId = Integer.parseInt(idStr);
            purchaseController.restorePurchase(purchaseId);
            response.sendRedirect("PurchaseServlet?action=list");
        } catch (NumberFormatException e) {
            response.sendRedirect("PurchaseServlet?action=list");
        }
    }
}