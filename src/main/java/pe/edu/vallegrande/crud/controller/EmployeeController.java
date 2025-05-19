package pe.edu.vallegrande.crud.controller;

import pe.edu.vallegrande.crud.db.ConexionDB;
import pe.edu.vallegrande.crud.dto.EmployeeDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeController {

    public List<EmployeeDTO> listAll() {
        return listByStatus(null);
    }

    public List<EmployeeDTO> listActive() {
        return listByStatus('A');
    }

    public List<EmployeeDTO> listInactive() {
        return listByStatus('I');
    }

    private List<EmployeeDTO> listByStatus(Character status) {
        List<EmployeeDTO> employeeList = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM EMPLOYEE");

        if (status != null) {
            query.append(" WHERE EMPLOYEE_STATUS = ?");
        }
        query.append(" ORDER BY EMPLOYEE_ID DESC");

        System.out.println("Query: " + query.toString());

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query.toString())) {

            if (status != null) {
                pstmt.setString(1, String.valueOf(status));
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                EmployeeDTO employee = new EmployeeDTO(
                        rs.getInt("EMPLOYEE_ID"),
                        rs.getString("EMPLOYEE_FIRST_NAME"),
                        rs.getString("EMPLOYEE_LAST_NAME"),
                        rs.getDate("EMPLOYEE_BIRTH_DATE"),
                        rs.getString("EMPLOYEE_DOC_TYPE"),
                        rs.getString("EMPLOYEE_NRO_DOC"),
                        rs.getString("EMPLOYEE_PHONE"),
                        rs.getString("EMPLOYEE_EMAIL"),
                        rs.getString("EMPLOYEE_STATUS")
                );
                employeeList.add(employee);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar empleados.");
            e.printStackTrace();
        }

        System.out.println("Número de empleados encontrados: " + employeeList.size());
        return employeeList;
    }

    public void addEmployee(EmployeeDTO employee) {
        String query = "INSERT INTO EMPLOYEE (EMPLOYEE_FIRST_NAME, EMPLOYEE_LAST_NAME, EMPLOYEE_BIRTH_DATE, "
                + "EMPLOYEE_DOC_TYPE, EMPLOYEE_NRO_DOC, EMPLOYEE_PHONE, EMPLOYEE_EMAIL, EMPLOYEE_STATUS) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'A')";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, employee.getEMPLOYEE_FIRST_NAME());
            pstmt.setString(2, employee.getEMPLOYEE_LAST_NAME());
            pstmt.setDate(3, new java.sql.Date(employee.getEMPLOYEE_BIRTH_DATE().getTime()));
            pstmt.setString(4, employee.getEMPLOYEE_DOC_TYPE());
            pstmt.setString(5, employee.getEMPLOYEE_NRO_DOC());
            pstmt.setString(6, employee.getEMPLOYEE_PHONE());
            pstmt.setString(7, employee.getEMPLOYEE_EMAIL());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Empleado agregado exitosamente.");
            } else {
                System.out.println("No se pudo agregar el empleado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al agregar el empleado: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateEmployee(EmployeeDTO employee) {
        String query = "UPDATE EMPLOYEE SET EMPLOYEE_FIRST_NAME = ?, EMPLOYEE_LAST_NAME = ?, "
                + "EMPLOYEE_BIRTH_DATE = ?, EMPLOYEE_DOC_TYPE = ?, EMPLOYEE_NRO_DOC = ?, "
                + "EMPLOYEE_PHONE = ?, EMPLOYEE_EMAIL = ?, EMPLOYEE_STATUS = ? "
                + "WHERE EMPLOYEE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, employee.getEMPLOYEE_FIRST_NAME());
            pstmt.setString(2, employee.getEMPLOYEE_LAST_NAME());
            pstmt.setDate(3, new java.sql.Date(employee.getEMPLOYEE_BIRTH_DATE().getTime()));
            pstmt.setString(4, employee.getEMPLOYEE_DOC_TYPE());
            pstmt.setString(5, employee.getEMPLOYEE_NRO_DOC());
            pstmt.setString(6, employee.getEMPLOYEE_PHONE());
            pstmt.setString(7, employee.getEMPLOYEE_EMAIL());
            pstmt.setString(8, employee.getEMPLOYEE_STATUS());
            pstmt.setInt(9, employee.getEMPLOYEE_ID());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Empleado actualizado exitosamente.");
            } else {
                System.out.println("No se encontró un empleado con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el empleado.");
            e.printStackTrace();
        }
    }

    public EmployeeDTO getEmployeeById(int id) {
        EmployeeDTO employee = null;
        String query = "SELECT * FROM EMPLOYEE WHERE EMPLOYEE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                employee = new EmployeeDTO(
                        rs.getInt("EMPLOYEE_ID"),
                        rs.getString("EMPLOYEE_FIRST_NAME"),
                        rs.getString("EMPLOYEE_LAST_NAME"),
                        rs.getDate("EMPLOYEE_BIRTH_DATE"),
                        rs.getString("EMPLOYEE_DOC_TYPE"),
                        rs.getString("EMPLOYEE_NRO_DOC"),
                        rs.getString("EMPLOYEE_PHONE"),
                        rs.getString("EMPLOYEE_EMAIL"),
                        rs.getString("EMPLOYEE_STATUS")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar empleado por ID.");
            e.printStackTrace();
        }
        return employee;
    }

    public void deleteEmployee(int id) {
        String query = "UPDATE EMPLOYEE SET EMPLOYEE_STATUS = 'I' WHERE EMPLOYEE_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Empleado marcado como inactivo exitosamente.");
            } else {
                System.out.println("No se encontró un empleado con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar marcar el empleado como inactivo.");
            e.printStackTrace();
        }
    }

    public void restoreEmployee(int id) {
        String query = "UPDATE EMPLOYEE SET EMPLOYEE_STATUS = 'A' WHERE EMPLOYEE_ID = ? AND EMPLOYEE_STATUS = 'I'";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Empleado restaurado exitosamente.");
            } else {
                System.out.println("No se encontró un empleado inactivo con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar restaurar el empleado.");
            e.printStackTrace();
        }
    }
}