package pe.edu.vallegrande.crud.controller;

import pe.edu.vallegrande.crud.db.ConexionDB;
import pe.edu.vallegrande.crud.dto.SaleDTO;
import pe.edu.vallegrande.crud.dto.SaleDetailDTO;
import pe.edu.vallegrande.crud.dto.ProductDTO;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SaleController {
    private ProductController productController = new ProductController();

    public List<SaleDTO> listAllSales() {
        return listSalesByStatus(null);
    }

    public List<SaleDTO> listActiveSales() {
        return listSalesByStatus('A');
    }

    public List<SaleDTO> listCancelledSales() {
        return listSalesByStatus('C');
    }

    private List<SaleDTO> listSalesByStatus(Character status) {
        List<SaleDTO> saleList = new ArrayList<>();
        String query = "SELECT * FROM SALE";

        if (status != null) {
            query += " WHERE SALE_STATUS = ?";
        }
        query += " ORDER BY SALE_DATE DESC";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            if (status != null) {
                pstmt.setString(1, String.valueOf(status));
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                SaleDTO sale = new SaleDTO();
                sale.setSALE_ID(rs.getInt("SALE_ID"));
                sale.setSALE_DATE(rs.getDate("SALE_DATE"));
                sale.setSALE_TOTAL(rs.getBigDecimal("SALE_TOTAL"));
                sale.setSALE_METHOD(rs.getString("SALE_METHOD").charAt(0));
                sale.setSALE_STATUS(rs.getString("SALE_STATUS").charAt(0));
                sale.setPATIENT_ID(rs.getInt("PATIENT_ID"));
                sale.setEMPLOYEE_ID(rs.getInt("EMPLOYEE_ID"));

                saleList.add(sale);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar ventas.");
            e.printStackTrace();
        }
        return saleList;
    }

    public SaleDTO getSaleById(int id) {
        SaleDTO sale = null;
        String query = "SELECT * FROM SALE WHERE SALE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                sale = new SaleDTO();
                sale.setSALE_ID(rs.getInt("SALE_ID"));
                sale.setSALE_DATE(rs.getDate("SALE_DATE"));
                sale.setSALE_TOTAL(rs.getBigDecimal("SALE_TOTAL"));
                sale.setSALE_METHOD(rs.getString("SALE_METHOD").charAt(0));
                sale.setSALE_STATUS(rs.getString("SALE_STATUS").charAt(0));
                sale.setPATIENT_ID(rs.getInt("PATIENT_ID"));
                sale.setEMPLOYEE_ID(rs.getInt("EMPLOYEE_ID"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar venta por ID.");
            e.printStackTrace();
        }
        return sale;
    }

    public List<SaleDetailDTO> getSaleDetails(int saleId) {
        List<SaleDetailDTO> details = new ArrayList<>();
        String query = "SELECT * FROM SALE_DETAIL WHERE SALE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, saleId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                SaleDetailDTO detail = new SaleDetailDTO();
                detail.setSALE_DETAIL_ID(rs.getInt("SALE_DETAIL_ID"));
                detail.setSALE_ID(rs.getInt("SALE_ID"));
                detail.setPRODUCT_ID(rs.getInt("PRODUCT_ID"));
                detail.setSALE_DETAIL_QUANTITY(rs.getInt("SALE_DETAIL_QUANTITY"));
                detail.setSALE_DETAIL_PRICE(rs.getBigDecimal("SALE_DETAIL_PRICE"));
                detail.setSALE_DETAIL_SUBTOTAL(rs.getBigDecimal("SALE_DETAIL_SUBTOTAL"));

                // Opcional: Cargar el producto completo
                ProductDTO product = productController.getProductById(detail.getPRODUCT_ID());
                detail.setProduct(product);

                details.add(detail);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener detalles de venta.");
            e.printStackTrace();
        }
        return details;
    }

    public boolean createSaleWithDetails(SaleDTO sale, List<SaleDetailDTO> details) {
        Connection connection = null;
        boolean success = false;

        System.out.println("Iniciando creación de venta...");

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            System.out.println("Validando stock...");
            if (!validateStock(details)) {
                System.out.println("Error: Stock insuficiente para algunos productos");
                return false;
            }

            System.out.println("Insertando venta principal...");
            int saleId = createSaleInTransaction(connection, sale);
            System.out.println("ID de venta generado: " + saleId);

            if (saleId > 0) {
                System.out.println("Insertando detalles de venta...");
                boolean detailsSuccess = insertSaleDetailsInTransaction(connection, details, saleId);

                if (detailsSuccess) {
                    System.out.println("Actualizando stock...");
                    boolean stockUpdated = updateProductStockInTransaction(connection, details, false);

                    if (stockUpdated) {
                        connection.commit();
                        success = true;
                        System.out.println("Venta registrada exitosamente. ID: " + saleId);
                    } else {
                        connection.rollback();
                        System.out.println("Error al actualizar stock, se hizo rollback");
                    }
                } else {
                    connection.rollback();
                    System.out.println("Error al registrar detalles, se hizo rollback");
                }
            } else {
                connection.rollback();
                System.out.println("Error al registrar venta principal");
            }
        } catch (SQLException e) {
            System.out.println("Error SQL en la transacción: " + e.getMessage());
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                System.out.println("Error al hacer rollback: " + ex.getMessage());
            }
            e.printStackTrace();
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
        return success;
    }

    private boolean validateStock(List<SaleDetailDTO> details) {
        for (SaleDetailDTO detail : details) {
            ProductDTO product = productController.getProductById(detail.getPRODUCT_ID());
            if (product == null || product.getPRODUCT_STOCK() < detail.getSALE_DETAIL_QUANTITY()) {
                System.out.println("Stock insuficiente para el producto ID: " + detail.getPRODUCT_ID());
                return false;
            }
        }
        return true;
    }

    private int createSaleInTransaction(Connection connection, SaleDTO sale) throws SQLException {
        String query = "INSERT INTO SALE (SALE_DATE, SALE_TOTAL, SALE_METHOD, SALE_STATUS, PATIENT_ID, EMPLOYEE_ID) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setDate(1, new java.sql.Date(sale.getSALE_DATE().getTime()));
            pstmt.setBigDecimal(2, sale.getSALE_TOTAL());
            pstmt.setString(3, String.valueOf(sale.getSALE_METHOD()));
            pstmt.setString(4, String.valueOf(sale.getSALE_STATUS()));
            pstmt.setInt(5, sale.getPATIENT_ID());
            pstmt.setInt(6, sale.getEMPLOYEE_ID());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;
        }
    }

    private boolean insertSaleDetailsInTransaction(Connection connection, List<SaleDetailDTO> details, int saleId) throws SQLException {
        String query = "INSERT INTO SALE_DETAIL (SALE_DETAIL_QUANTITY, SALE_DETAIL_PRICE, " +
                "SALE_DETAIL_SUBTOTAL, SALE_ID, PRODUCT_ID) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            for (SaleDetailDTO detail : details) {
                // Calcular subtotal si no está definido
                if (detail.getSALE_DETAIL_SUBTOTAL() == null) {
                    BigDecimal subtotal = detail.getSALE_DETAIL_PRICE()
                            .multiply(new BigDecimal(detail.getSALE_DETAIL_QUANTITY()));
                    detail.setSALE_DETAIL_SUBTOTAL(subtotal);
                }

                pstmt.setInt(1, detail.getSALE_DETAIL_QUANTITY());
                pstmt.setBigDecimal(2, detail.getSALE_DETAIL_PRICE());
                pstmt.setBigDecimal(3, detail.getSALE_DETAIL_SUBTOTAL());
                pstmt.setInt(4, saleId);
                pstmt.setInt(5, detail.getPRODUCT_ID());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        }
    }

    private boolean updateProductStockInTransaction(Connection connection, List<SaleDetailDTO> details, boolean isCancellation) throws SQLException {
        String query = "UPDATE PRODUCT SET PRODUCT_STOCK = PRODUCT_STOCK " +
                (isCancellation ? "+" : "-") + " ? WHERE PRODUCT_ID = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            for (SaleDetailDTO detail : details) {
                pstmt.setInt(1, detail.getSALE_DETAIL_QUANTITY());
                pstmt.setInt(2, detail.getPRODUCT_ID());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        }
    }

    public boolean cancelSale(int saleId) {
        Connection connection = null;
        boolean success = false;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            // 1. Obtener los detalles de la venta
            List<SaleDetailDTO> details = getSaleDetails(saleId);

            // 2. Actualizar el estado de la venta a cancelado
            String updateSaleQuery = "UPDATE SALE SET SALE_STATUS = 'C' WHERE SALE_ID = ? AND SALE_STATUS = 'A'";
            try (PreparedStatement pstmt = connection.prepareStatement(updateSaleQuery)) {
                pstmt.setInt(1, saleId);
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    // 3. Revertir el stock (sumar las cantidades vendidas)
                    boolean stockUpdated = updateProductStockInTransaction(connection, details, true);

                    if (stockUpdated) {
                        connection.commit();
                        success = true;
                        System.out.println("Venta cancelada exitosamente. ID: " + saleId);
                    } else {
                        connection.rollback();
                        System.out.println("Error al revertir stock, se hizo rollback");
                    }
                } else {
                    connection.rollback();
                    System.out.println("No se encontró una venta activa con el ID especificado");
                }
            }
        } catch (SQLException e) {
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                System.out.println("Error al hacer rollback: " + ex.getMessage());
            }
            System.out.println("Error al cancelar la venta: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
        return success;
    }

}