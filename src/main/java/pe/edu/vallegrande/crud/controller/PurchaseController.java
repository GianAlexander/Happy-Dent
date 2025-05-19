package pe.edu.vallegrande.crud.controller;

import pe.edu.vallegrande.crud.db.ConexionDB;
import pe.edu.vallegrande.crud.dto.PurchaseDTO;
import pe.edu.vallegrande.crud.dto.PurchaseDetailDTO;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PurchaseController {

    public List<PurchaseDTO> listAllPurchases() {
        return listPurchasesByStatus(null);
    }

    public List<PurchaseDTO> listActivePurchases() {
        return listPurchasesByStatus('A');
    }

    public List<PurchaseDTO> listInactivePurchases() {
        return listPurchasesByStatus('I');
    }

    private List<PurchaseDTO> listPurchasesByStatus(Character status) {
        List<PurchaseDTO> purchaseList = new ArrayList<>();
        String query = "SELECT * FROM PURCHASE";

        if (status != null) {
            query += " WHERE PURCHASE_STATUS = ?";
        }
        query += " ORDER BY PURCHASE_DATE DESC";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            if (status != null) {
                pstmt.setString(1, String.valueOf(status));
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                PurchaseDTO purchase = new PurchaseDTO();
                purchase.setPURCHASE_ID(rs.getInt("PURCHASE_ID"));
                purchase.setPURCHASE_DATE(rs.getDate("PURCHASE_DATE"));
                purchase.setPURCHASE_TOTAL(rs.getBigDecimal("PURCHASE_TOTAL"));
                purchase.setPURCHASE_STATUS(rs.getString("PURCHASE_STATUS").charAt(0));
                purchase.setEMPLOYEE_ID(rs.getInt("EMPLOYEE_ID"));
                purchase.setSUPPLIER_ID(rs.getInt("SUPPLIER_ID"));

                purchaseList.add(purchase);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar compras.");
            e.printStackTrace();
        }
        return purchaseList;
    }

    public PurchaseDTO getPurchaseById(int id) {
        PurchaseDTO purchase = null;
        String query = "SELECT * FROM PURCHASE WHERE PURCHASE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                purchase = new PurchaseDTO();
                purchase.setPURCHASE_ID(rs.getInt("PURCHASE_ID"));
                purchase.setPURCHASE_DATE(rs.getDate("PURCHASE_DATE"));
                purchase.setPURCHASE_TOTAL(rs.getBigDecimal("PURCHASE_TOTAL"));
                purchase.setPURCHASE_STATUS(rs.getString("PURCHASE_STATUS").charAt(0));
                purchase.setEMPLOYEE_ID(rs.getInt("EMPLOYEE_ID"));
                purchase.setSUPPLIER_ID(rs.getInt("SUPPLIER_ID"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar compra por ID.");
            e.printStackTrace();
        }
        return purchase;
    }

    public int createPurchase(PurchaseDTO purchase) {
        String query = "INSERT INTO PURCHASE (PURCHASE_DATE, PURCHASE_TOTAL, PURCHASE_STATUS, EMPLOYEE_ID, SUPPLIER_ID) " +
                "VALUES (?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setDate(1, new java.sql.Date(purchase.getPURCHASE_DATE().getTime()));
            pstmt.setBigDecimal(2, purchase.getPURCHASE_TOTAL());
            pstmt.setString(3, String.valueOf(purchase.getPURCHASE_STATUS()));
            pstmt.setInt(4, purchase.getEMPLOYEE_ID());
            pstmt.setInt(5, purchase.getSUPPLIER_ID());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al crear la compra.");
            e.printStackTrace();
        }
        return generatedId;
    }

    public boolean updatePurchase(PurchaseDTO purchase) {
        String query = "UPDATE PURCHASE SET PURCHASE_DATE = ?, PURCHASE_TOTAL = ?, " +
                "PURCHASE_STATUS = ?, EMPLOYEE_ID = ?, SUPPLIER_ID = ? " +
                "WHERE PURCHASE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setDate(1, new java.sql.Date(purchase.getPURCHASE_DATE().getTime()));
            pstmt.setBigDecimal(2, purchase.getPURCHASE_TOTAL());
            pstmt.setString(3, String.valueOf(purchase.getPURCHASE_STATUS()));
            pstmt.setInt(4, purchase.getEMPLOYEE_ID());
            pstmt.setInt(5, purchase.getSUPPLIER_ID());
            pstmt.setInt(6, purchase.getPURCHASE_ID());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar la compra.");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePurchase(int id) {
        String query = "UPDATE PURCHASE SET PURCHASE_STATUS = 'I' WHERE PURCHASE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al eliminar la compra.");
            e.printStackTrace();
            return false;
        }
    }

    public boolean restorePurchase(int id) {
        String query = "UPDATE PURCHASE SET PURCHASE_STATUS = 'A' WHERE PURCHASE_ID = ? AND PURCHASE_STATUS = 'I'";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al restaurar la compra.");
            e.printStackTrace();
            return false;
        }
    }

    public List<PurchaseDetailDTO> getPurchaseDetails(int purchaseId) {
        List<PurchaseDetailDTO> details = new ArrayList<>();
        String query = "SELECT * FROM PURCHASE_DETAIL WHERE PURCHASE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, purchaseId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                PurchaseDetailDTO detail = new PurchaseDetailDTO();
                detail.setPURCHASE_DETAIL_ID(rs.getInt("PURCHASE_DETAIL_ID"));
                detail.setPURCHASE_DETAIL_QUANTITY(rs.getInt("PURCHASE_DETAIL_QUANTITY"));
                detail.setPURCHASE_DETAIL_PRICE(rs.getBigDecimal("PURCHASE_DETAIL_PRICE"));
                detail.setPURCHASE_DETAIL_SUBTOTAL(rs.getBigDecimal("PURCHASE_DETAIL_SUBTOTAL"));
                detail.setPURCHASE_ID(rs.getInt("PURCHASE_ID"));
                detail.setPRODUCT_ID(rs.getInt("PRODUCT_ID"));

                details.add(detail);
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener detalles de compra.");
            e.printStackTrace();
        }
        return details;
    }


    public boolean createPurchaseWithDetails(PurchaseDTO purchase, List<PurchaseDetailDTO> details) {
        Connection connection = null;
        boolean success = false;

        try {
            connection = ConexionDB.getConnection();
            connection.setAutoCommit(false);

            // 1. Insertar la compra principal
            int purchaseId = createPurchaseInTransaction(connection, purchase);

            if (purchaseId > 0 && details != null && !details.isEmpty()) {
                // 2. Insertar los detalles
                boolean detailsSuccess = insertDetailsInTransaction(connection, details, purchaseId);

                if (detailsSuccess) {
                    connection.commit();
                    success = true;
                    System.out.println("Compra y detalles registrados exitosamente. ID: " + purchaseId);
                } else {
                    connection.rollback();
                    System.out.println("Error al registrar detalles, se hizo rollback.");
                }
            } else {
                connection.rollback();
                System.out.println("Error: No se pudo obtener ID de compra o lista de detalles vacía");
            }
        } catch (SQLException e) {
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                System.out.println("Error al hacer rollback: " + ex.getMessage());
            }
            System.out.println("Error en la transacción de compra: " + e.getMessage());
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
    private int createPurchaseInTransaction(Connection connection, PurchaseDTO purchase) throws SQLException {
        String query = "INSERT INTO PURCHASE (PURCHASE_DATE, PURCHASE_TOTAL, PURCHASE_STATUS, EMPLOYEE_ID, SUPPLIER_ID) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setDate(1, new java.sql.Date(purchase.getPURCHASE_DATE().getTime()));
            pstmt.setBigDecimal(2, purchase.getPURCHASE_TOTAL());
            pstmt.setString(3, String.valueOf(purchase.getPURCHASE_STATUS()));
            pstmt.setInt(4, purchase.getEMPLOYEE_ID());
            pstmt.setInt(5, purchase.getSUPPLIER_ID());

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

    private boolean insertDetailsInTransaction(Connection connection, List<PurchaseDetailDTO> details, int purchaseId) throws SQLException {
        String query = "INSERT INTO PURCHASE_DETAIL (PURCHASE_DETAIL_QUANTITY, PURCHASE_DETAIL_PRICE, " +
                "PURCHASE_DETAIL_SUBTOTAL, PURCHASE_ID, PRODUCT_ID) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            System.out.println("Insertando " + details.size() + " detalles para compra ID: " + purchaseId);

            for (PurchaseDetailDTO detail : details) {
                System.out.println("Detalle: ProductoID=" + detail.getPRODUCT_ID() +
                        ", Cantidad=" + detail.getPURCHASE_DETAIL_QUANTITY() +
                        ", Precio=" + detail.getPURCHASE_DETAIL_PRICE());

                // Calcular subtotal si no está definido
                if (detail.getPURCHASE_DETAIL_SUBTOTAL() == null) {
                    BigDecimal subtotal = detail.getPURCHASE_DETAIL_PRICE()
                            .multiply(new BigDecimal(detail.getPURCHASE_DETAIL_QUANTITY()));
                    detail.setPURCHASE_DETAIL_SUBTOTAL(subtotal);
                }

                pstmt.setInt(1, detail.getPURCHASE_DETAIL_QUANTITY());
                pstmt.setBigDecimal(2, detail.getPURCHASE_DETAIL_PRICE());
                pstmt.setBigDecimal(3, detail.getPURCHASE_DETAIL_SUBTOTAL());
                pstmt.setInt(4, purchaseId);
                pstmt.setInt(5, detail.getPRODUCT_ID());
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            for (int i = 0; i < results.length; i++) {
                if (results[i] <= 0) {
                    System.out.println("Error al insertar detalle #" + (i+1));
                    return false;
                }
            }
            System.out.println("Todos los detalles insertados correctamente");
            return true;
        }
    }
}