package pe.edu.vallegrande.crud.controller;

import pe.edu.vallegrande.crud.db.ConexionDB;
import pe.edu.vallegrande.crud.dto.SupplierDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierController {

    public List<SupplierDTO> listAll() {
        return listByStatus(null);
    }

    public List<SupplierDTO> listActive() {
        return listByStatus('A');
    }

    public List<SupplierDTO> listInactive() {
        return listByStatus('I');
    }

    private List<SupplierDTO> listByStatus(Character status) {
        List<SupplierDTO> supplierList = new ArrayList<>();
        String query = "SELECT * FROM SUPPLIER ORDER BY SUPPLIER_ID DESC";

        if (status != null) {
            query += " WHERE SUPPLIER_STATUS = ?";
        }

        System.out.println("Query: " + query);

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            if (status != null) {
                pstmt.setString(1, String.valueOf(status));
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                SupplierDTO supplier = new SupplierDTO();
                supplier.setSUPPLIER_ID(rs.getInt("SUPPLIER_ID"));
                supplier.setSUPPLIER_NAME(rs.getString("SUPPLIER_NAME"));
                supplier.setSUPPLIER_RUC(rs.getString("SUPPLIER_RUC"));
                supplier.setSUPPLIER_EMAIL(rs.getString("SUPPLIER_EMAIL"));
                supplier.setSUPPLIER_PHONE(rs.getString("SUPPLIER_PHONE"));
                supplier.setSUPPLIER_WEBSITE(rs.getString("SUPPLIER_WEBSITE"));
                supplier.setSUPPLIER_ADDRESS(rs.getString("SUPPLIER_ADDRESS"));
                supplier.setSUPPLIER_TYPE(rs.getString("SUPPLIER_TYPE"));
                supplier.setSUPPLIER_STATUS(rs.getString("SUPPLIER_STATUS"));

                supplierList.add(supplier);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar proveedores.");
            e.printStackTrace();
        }

        System.out.println("Número de proveedores encontrados: " + supplierList.size());
        return supplierList;
    }

    public void addSupplier(SupplierDTO supplier) {
        String query = "INSERT INTO SUPPLIER (SUPPLIER_NAME, SUPPLIER_RUC, SUPPLIER_EMAIL, " +
                "SUPPLIER_PHONE, SUPPLIER_WEBSITE, SUPPLIER_ADDRESS, SUPPLIER_TYPE, SUPPLIER_STATUS) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'A')";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, supplier.getSUPPLIER_NAME());
            pstmt.setString(2, supplier.getSUPPLIER_RUC());
            pstmt.setString(3, supplier.getSUPPLIER_EMAIL());
            pstmt.setString(4, supplier.getSUPPLIER_PHONE());
            pstmt.setString(5, supplier.getSUPPLIER_WEBSITE());
            pstmt.setString(6, supplier.getSUPPLIER_ADDRESS());
            pstmt.setString(7, supplier.getSUPPLIER_TYPE());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Proveedor agregado exitosamente.");
            } else {
                System.out.println("No se pudo agregar el proveedor.");
            }
        } catch (SQLException e) {
            System.out.println("Error al agregar el proveedor: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateSupplier(SupplierDTO supplier) {
        String query = "UPDATE SUPPLIER SET SUPPLIER_NAME = ?, SUPPLIER_RUC = ?, " +
                "SUPPLIER_EMAIL = ?, SUPPLIER_PHONE = ?, SUPPLIER_WEBSITE = ?, " +
                "SUPPLIER_ADDRESS = ?, SUPPLIER_TYPE = ?, SUPPLIER_STATUS = ? " +
                "WHERE SUPPLIER_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, supplier.getSUPPLIER_NAME());
            pstmt.setString(2, supplier.getSUPPLIER_RUC());
            pstmt.setString(3, supplier.getSUPPLIER_EMAIL());
            pstmt.setString(4, supplier.getSUPPLIER_PHONE());
            pstmt.setString(5, supplier.getSUPPLIER_WEBSITE());
            pstmt.setString(6, supplier.getSUPPLIER_ADDRESS());
            pstmt.setString(7, supplier.getSUPPLIER_TYPE());
            pstmt.setString(8, supplier.getSUPPLIER_STATUS());
            pstmt.setInt(9, supplier.getSUPPLIER_ID());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Proveedor actualizado exitosamente.");
            } else {
                System.out.println("No se encontró un proveedor con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el proveedor.");
            e.printStackTrace();
        }
    }

    public SupplierDTO getSupplierById(int id) {
        SupplierDTO supplier = null;
        String query = "SELECT * FROM SUPPLIER WHERE SUPPLIER_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                supplier = new SupplierDTO();
                supplier.setSUPPLIER_ID(rs.getInt("SUPPLIER_ID"));
                supplier.setSUPPLIER_NAME(rs.getString("SUPPLIER_NAME"));
                supplier.setSUPPLIER_RUC(rs.getString("SUPPLIER_RUC"));
                supplier.setSUPPLIER_EMAIL(rs.getString("SUPPLIER_EMAIL"));
                supplier.setSUPPLIER_PHONE(rs.getString("SUPPLIER_PHONE"));
                supplier.setSUPPLIER_WEBSITE(rs.getString("SUPPLIER_WEBSITE"));
                supplier.setSUPPLIER_ADDRESS(rs.getString("SUPPLIER_ADDRESS"));
                supplier.setSUPPLIER_TYPE(rs.getString("SUPPLIER_TYPE"));
                supplier.setSUPPLIER_STATUS(rs.getString("SUPPLIER_STATUS"));
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar proveedor por ID.");
            e.printStackTrace();
        }
        return supplier;
    }

    public void deleteSupplier(int id) {
        String query = "UPDATE SUPPLIER SET SUPPLIER_STATUS = 'I' WHERE SUPPLIER_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Proveedor marcado como inactivo exitosamente.");
            } else {
                System.out.println("No se encontró un proveedor con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar marcar el proveedor como inactivo.");
            e.printStackTrace();
        }
    }

    public void restoreSupplier(int id) {
        String query = "UPDATE SUPPLIER SET SUPPLIER_STATUS = 'A' WHERE SUPPLIER_ID = ? AND SUPPLIER_STATUS = 'I'";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Proveedor restaurado exitosamente.");
            } else {
                System.out.println("No se encontró un proveedor inactivo con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar restaurar el proveedor.");
            e.printStackTrace();
        }
    }
}