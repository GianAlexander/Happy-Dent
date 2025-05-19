package pe.edu.vallegrande.crud.controller;

import pe.edu.vallegrande.crud.db.ConexionDB;
import pe.edu.vallegrande.crud.dto.ProductDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductController {

    public List<ProductDTO> listAll() {
        return listByStatus(null);
    }

    public List<ProductDTO> listActive() {
        return listByStatus("A");
    }

    public List<ProductDTO> listInactive() {
        return listByStatus("I");
    }

    private List<ProductDTO> listByStatus(String status) {
        List<ProductDTO> productList = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM PRODUCT");

        if (status != null) {
            query.append(" WHERE PRODUCT_STATUS = ?");
        }
        query.append(" ORDER BY PRODUCT_ID DESC");

        System.out.println("Query: " + query.toString());

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query.toString())) {

            if (status != null) {
                pstmt.setString(1, status);
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                        rs.getInt("PRODUCT_ID"),
                        rs.getString("PRODUCT_NAME"),
                        rs.getString("PRODUCT_BRAND"),
                        rs.getString("PRODUCT_PRESENTATION"),
                        rs.getInt("PRODUCT_STOCK"),
                        rs.getDouble("PRODUCT_PRICE"),
                        rs.getDate("PRODUCT_EXPIRATION_DATE"),
                        rs.getString("PRODUCT_BATCH"),
                        rs.getString("PRODUCT_DESCRIPTION"),
                        rs.getString("PRODUCT_STATUS")
                );
                productList.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar productos.");
            e.printStackTrace();
        }

        System.out.println("Número de productos encontrados: " + productList.size());
        return productList;
    }

    public void addProduct(ProductDTO product) {
        String query = "INSERT INTO PRODUCT (PRODUCT_NAME, PRODUCT_BRAND, PRODUCT_PRESENTATION, " +
                "PRODUCT_STOCK, PRODUCT_PRICE, PRODUCT_EXPIRATION_DATE, PRODUCT_BATCH, " +
                "PRODUCT_DESCRIPTION, PRODUCT_STATUS) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'A')";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, product.getPRODUCT_NAME());
            pstmt.setString(2, product.getPRODUCT_BRAND());
            pstmt.setString(3, product.getPRODUCT_PRESENTATION());
            pstmt.setInt(4, product.getPRODUCT_STOCK());
            pstmt.setDouble(5, product.getPRODUCT_PRICE());
            pstmt.setDate(6, new java.sql.Date(product.getPRODUCT_EXPIRATION_DATE().getTime()));
            pstmt.setString(7, product.getPRODUCT_BATCH());
            pstmt.setString(8, product.getPRODUCT_DESCRIPTION());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Producto agregado exitosamente.");
            } else {
                System.out.println("No se pudo agregar el producto.");
            }
        } catch (SQLException e) {
            System.out.println("Error al agregar el producto: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateProduct(ProductDTO product) {
        String query = "UPDATE PRODUCT SET PRODUCT_NAME = ?, PRODUCT_BRAND = ?, " +
                "PRODUCT_PRESENTATION = ?, PRODUCT_STOCK = ?, PRODUCT_PRICE = ?, " +
                "PRODUCT_EXPIRATION_DATE = ?, PRODUCT_BATCH = ?, PRODUCT_DESCRIPTION = ?, " +
                "PRODUCT_STATUS = ? WHERE PRODUCT_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, product.getPRODUCT_NAME());
            pstmt.setString(2, product.getPRODUCT_BRAND());
            pstmt.setString(3, product.getPRODUCT_PRESENTATION());
            pstmt.setInt(4, product.getPRODUCT_STOCK());
            pstmt.setDouble(5, product.getPRODUCT_PRICE());
            pstmt.setDate(6, new java.sql.Date(product.getPRODUCT_EXPIRATION_DATE().getTime()));
            pstmt.setString(7, product.getPRODUCT_BATCH());
            pstmt.setString(8, product.getPRODUCT_DESCRIPTION());
            pstmt.setString(9, product.getPRODUCT_STATUS());
            pstmt.setInt(10, product.getPRODUCT_ID());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Producto actualizado exitosamente.");
            } else {
                System.out.println("No se encontró un producto con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el producto.");
            e.printStackTrace();
        }
    }

    public ProductDTO getProductById(int id) {
        ProductDTO product = null;
        String query = "SELECT * FROM PRODUCT WHERE PRODUCT_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                product = new ProductDTO(
                        rs.getInt("PRODUCT_ID"),
                        rs.getString("PRODUCT_NAME"),
                        rs.getString("PRODUCT_BRAND"),
                        rs.getString("PRODUCT_PRESENTATION"),
                        rs.getInt("PRODUCT_STOCK"),
                        rs.getDouble("PRODUCT_PRICE"),
                        rs.getDate("PRODUCT_EXPIRATION_DATE"),
                        rs.getString("PRODUCT_BATCH"),
                        rs.getString("PRODUCT_DESCRIPTION"),
                        rs.getString("PRODUCT_STATUS")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar producto por ID.");
            e.printStackTrace();
        }
        return product;
    }

    public void deleteProduct(int id) {
        String query = "UPDATE PRODUCT SET PRODUCT_STATUS = 'I' WHERE PRODUCT_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Producto marcado como inactivo exitosamente.");
            } else {
                System.out.println("No se encontró un producto con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar marcar el producto como inactivo.");
            e.printStackTrace();
        }
    }

    public void restoreProduct(int id) {
        String query = "UPDATE PRODUCT SET PRODUCT_STATUS = 'A' WHERE PRODUCT_ID = ? AND PRODUCT_STATUS = 'I'";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Producto restaurado exitosamente.");
            } else {
                System.out.println("No se encontró un producto inactivo con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar restaurar el producto.");
            e.printStackTrace();
        }
    }
}