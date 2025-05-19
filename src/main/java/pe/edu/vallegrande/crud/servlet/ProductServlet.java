package pe.edu.vallegrande.crud.servlet;

import jakarta.servlet.annotation.WebServlet;
import pe.edu.vallegrande.crud.controller.ProductController;
import pe.edu.vallegrande.crud.dto.ProductDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final String ACTION_LIST = "list";
    private static final String ACTION_ADD = "add";
    private static final String ACTION_EDIT = "edit";
    private static final String ACTION_UPDATE = "update";
    private static final String ACTION_DELETE = "delete";
    private static final String ACTION_RESTORE = "restore";
    private static final String ACTION_VIEW = "view";

    private ProductController productController = new ProductController();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : ACTION_LIST) {
            case ACTION_LIST:
                listProducts(request, response);
                break;
            case ACTION_EDIT:
                showEditForm(request, response);
                break;
            case ACTION_DELETE:
                deleteProduct(request, response);
                break;
            case ACTION_VIEW:
                viewProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case ACTION_ADD:
                addProduct(request, response);
                break;
            case ACTION_UPDATE:
                updateProduct(request, response);
                break;
            case ACTION_RESTORE:
                restoreProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para visualizar.");
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
            return;
        }

        ProductDTO product = productController.getProductById(productId);
        if (product != null) {
            request.setAttribute("product", product);
            request.getRequestDispatcher("viewProduct.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ProductDTO> products = productController.listAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("listProducts.jsp").forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            ProductDTO newProduct = new ProductDTO();
            newProduct.setPRODUCT_NAME(request.getParameter("PRODUCT_NAME"));
            newProduct.setPRODUCT_BRAND(request.getParameter("PRODUCT_BRAND"));
            newProduct.setPRODUCT_PRESENTATION(request.getParameter("PRODUCT_PRESENTATION"));

            // Convertir String a int para el stock
            try {
                newProduct.setPRODUCT_STOCK(Integer.parseInt(request.getParameter("PRODUCT_STOCK")));
            } catch (NumberFormatException e) {
                newProduct.setPRODUCT_STOCK(0);
            }

            // Convertir String a double para el precio
            try {
                newProduct.setPRODUCT_PRICE(Double.parseDouble(request.getParameter("PRODUCT_PRICE")));
            } catch (NumberFormatException e) {
                newProduct.setPRODUCT_PRICE(0.0);
            }

            // Convertir String a Date para la fecha de expiración
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expirationDate = sdf.parse(request.getParameter("PRODUCT_EXPIRATION_DATE"));
            newProduct.setPRODUCT_EXPIRATION_DATE(expirationDate);

            newProduct.setPRODUCT_BATCH(request.getParameter("PRODUCT_BATCH"));
            newProduct.setPRODUCT_DESCRIPTION(request.getParameter("PRODUCT_DESCRIPTION"));
            newProduct.setPRODUCT_STATUS("A"); // Por defecto, activo

            productController.addProduct(newProduct);
            response.sendRedirect("ProductServlet?action=list");
        } catch (ParseException e) {
            System.out.println("Error al parsear fecha: " + e.getMessage());
            response.sendRedirect("ProductServlet?action=list&error=Formato de fecha incorrecto");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para editar.");
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
            return;
        }

        ProductDTO product = productController.getProductById(productId);
        if (product != null) {
            request.setAttribute("product", product);
            request.getRequestDispatcher("editProduct.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("PRODUCT_ID");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para actualizar.");
            response.sendRedirect("ProductServlet?action=list");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("ProductServlet?action=list");
            return;
        }

        try {
            ProductDTO updatedProduct = new ProductDTO();
            updatedProduct.setPRODUCT_ID(productId);
            updatedProduct.setPRODUCT_NAME(request.getParameter("PRODUCT_NAME"));
            updatedProduct.setPRODUCT_BRAND(request.getParameter("PRODUCT_BRAND"));
            updatedProduct.setPRODUCT_PRESENTATION(request.getParameter("PRODUCT_PRESENTATION"));

            // Convertir String a int para el stock
            try {
                updatedProduct.setPRODUCT_STOCK(Integer.parseInt(request.getParameter("PRODUCT_STOCK")));
            } catch (NumberFormatException e) {
                updatedProduct.setPRODUCT_STOCK(0);
            }

            // Convertir String a double para el precio
            try {
                updatedProduct.setPRODUCT_PRICE(Double.parseDouble(request.getParameter("PRODUCT_PRICE")));
            } catch (NumberFormatException e) {
                updatedProduct.setPRODUCT_PRICE(0.0);
            }

            // Convertir String a Date para la fecha de expiración
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date expirationDate = sdf.parse(request.getParameter("PRODUCT_EXPIRATION_DATE"));
            updatedProduct.setPRODUCT_EXPIRATION_DATE(expirationDate);

            updatedProduct.setPRODUCT_BATCH(request.getParameter("PRODUCT_BATCH"));
            updatedProduct.setPRODUCT_DESCRIPTION(request.getParameter("PRODUCT_DESCRIPTION"));
            updatedProduct.setPRODUCT_STATUS(request.getParameter("PRODUCT_STATUS"));

            productController.updateProduct(updatedProduct);
            response.sendRedirect("ProductServlet?action=list");
        } catch (ParseException e) {
            System.out.println("Error al parsear fecha: " + e.getMessage());
            response.sendRedirect("ProductServlet?action=list&error=Formato de fecha incorrecto");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para eliminar.");
            response.sendRedirect("ProductServlet?action=list");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("ProductServlet?action=list");
            return;
        }

        productController.deleteProduct(productId);
        response.sendRedirect("ProductServlet?action=list");
    }

    private void restoreProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("ID no proporcionado para restaurar.");
            response.sendRedirect("ProductServlet?action=list");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("ID no válido: " + idStr);
            response.sendRedirect("ProductServlet?action=list");
            return;
        }

        productController.restoreProduct(productId);
        response.sendRedirect("ProductServlet?action=list");
    }
}