package pe.edu.vallegrande.crud.controller;

import pe.edu.vallegrande.crud.db.ConexionDB;
import pe.edu.vallegrande.crud.dto.PatientDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientController {

    public List<PatientDTO> listAll() {
        return listByStatus(null);
    }

    public List<PatientDTO> listActive() {
        return listByStatus('A');
    }

    public List<PatientDTO> listInactive() {
        return listByStatus('I');
    }

    private List<PatientDTO> listByStatus(Character status) {
        List<PatientDTO> patientList = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM PATIENT");

        if (status != null) {
            query.append(" WHERE PATIENT_STATUS = ?");
        }
        query.append(" ORDER BY PATIENT_LAST_NAME, PATIENT_FIRST_NAME");

        System.out.println("Query final: " + query.toString());

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query.toString())) {

            if (status != null) {
                pstmt.setString(1, String.valueOf(status));
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                PatientDTO patient = new PatientDTO(
                        rs.getInt("PATIENT_ID"),
                        rs.getString("PATIENT_FIRST_NAME"),
                        rs.getString("PATIENT_LAST_NAME"),
                        rs.getDate("PATIENT_BIRTH_DATE"),
                        rs.getString("PATIENT_DOC_TYPE"),
                        rs.getString("PATIENT_NRO_DOC"),
                        rs.getString("PATIENT_PHONE"),
                        rs.getString("PATIENT_ADDRESS"),
                        rs.getString("PATIENT_OCCUPATION"),
                        rs.getString("PATIENT_REASON"),
                        rs.getString("PATIENT_RISK_CONDITION"),
                        rs.getString("PATIENT_DETAILS"),
                        rs.getString("PATIENT_STATUS")
                );
                patientList.add(patient);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar pacientes.");
            e.printStackTrace();
        }

        System.out.println("Número de pacientes encontrados: " + patientList.size());
        return patientList;
    }

    public void addPatient(PatientDTO patient) {
        String query = "INSERT INTO PATIENT (PATIENT_FIRST_NAME, PATIENT_LAST_NAME, PATIENT_BIRTH_DATE, " +
                "PATIENT_DOC_TYPE, PATIENT_NRO_DOC, PATIENT_PHONE, PATIENT_ADDRESS, " +
                "PATIENT_OCCUPATION, PATIENT_REASON, PATIENT_RISK_CONDITION, PATIENT_DETAILS, PATIENT_STATUS) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'A')";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, patient.getPATIENT_FIRST_NAME());
            pstmt.setString(2, patient.getPATIENT_LAST_NAME());
            pstmt.setDate(3, new java.sql.Date(patient.getPATIENT_BIRTH_DATE().getTime()));
            pstmt.setString(4, patient.getPATIENT_DOC_TYPE());
            pstmt.setString(5, patient.getPATIENT_NRO_DOC());
            pstmt.setString(6, patient.getPATIENT_PHONE());
            pstmt.setString(7, patient.getPATIENT_ADDRESS());
            pstmt.setString(8, patient.getPATIENT_OCCUPATION());
            pstmt.setString(9, patient.getPATIENT_REASON());
            pstmt.setString(10, patient.getPATIENT_RISK_CONDITION());
            pstmt.setString(11, patient.getPATIENT_DETAILS());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Paciente agregado exitosamente.");
            } else {
                System.out.println("No se pudo agregar el paciente.");
            }
        } catch (SQLException e) {
            System.out.println("Error al agregar el paciente: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updatePatient(PatientDTO patient) {
        String query = "UPDATE PATIENT SET PATIENT_FIRST_NAME = ?, PATIENT_LAST_NAME = ?, " +
                "PATIENT_BIRTH_DATE = ?, PATIENT_DOC_TYPE = ?, PATIENT_NRO_DOC = ?, " +
                "PATIENT_PHONE = ?, PATIENT_ADDRESS = ?, PATIENT_OCCUPATION = ?, " +
                "PATIENT_REASON = ?, PATIENT_RISK_CONDITION = ?, PATIENT_DETAILS = ?, " +
                "PATIENT_STATUS = ? WHERE PATIENT_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, patient.getPATIENT_FIRST_NAME());
            pstmt.setString(2, patient.getPATIENT_LAST_NAME());
            pstmt.setDate(3, new java.sql.Date(patient.getPATIENT_BIRTH_DATE().getTime()));
            pstmt.setString(4, patient.getPATIENT_DOC_TYPE());
            pstmt.setString(5, patient.getPATIENT_NRO_DOC());
            pstmt.setString(6, patient.getPATIENT_PHONE());
            pstmt.setString(7, patient.getPATIENT_ADDRESS());
            pstmt.setString(8, patient.getPATIENT_OCCUPATION());
            pstmt.setString(9, patient.getPATIENT_REASON());
            pstmt.setString(10, patient.getPATIENT_RISK_CONDITION());
            pstmt.setString(11, patient.getPATIENT_DETAILS());
            pstmt.setString(12, patient.getPATIENT_STATUS());
            pstmt.setInt(13, patient.getPATIENT_ID());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Paciente actualizado exitosamente.");
            } else {
                System.out.println("No se encontró un paciente con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al actualizar el paciente.");
            e.printStackTrace();
        }
    }

    public PatientDTO getPatientById(int id) {
        PatientDTO patient = null;
        String query = "SELECT * FROM PATIENT WHERE PATIENT_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                patient = new PatientDTO(
                        rs.getInt("PATIENT_ID"),
                        rs.getString("PATIENT_FIRST_NAME"),
                        rs.getString("PATIENT_LAST_NAME"),
                        rs.getDate("PATIENT_BIRTH_DATE"),
                        rs.getString("PATIENT_DOC_TYPE"),
                        rs.getString("PATIENT_NRO_DOC"),
                        rs.getString("PATIENT_PHONE"),
                        rs.getString("PATIENT_ADDRESS"),
                        rs.getString("PATIENT_OCCUPATION"),
                        rs.getString("PATIENT_REASON"),
                        rs.getString("PATIENT_RISK_CONDITION"),
                        rs.getString("PATIENT_DETAILS"),
                        rs.getString("PATIENT_STATUS")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error al buscar paciente por ID.");
            e.printStackTrace();
        }
        return patient;
    }

    public void deletePatient(int id) {
        String query = "UPDATE PATIENT SET PATIENT_STATUS = 'I' WHERE PATIENT_ID = ?";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Paciente marcado como inactivo exitosamente.");
            } else {
                System.out.println("No se encontró un paciente con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar marcar el paciente como inactivo.");
            e.printStackTrace();
        }
    }

    public void restorePatient(int id) {
        String query = "UPDATE PATIENT SET PATIENT_STATUS = 'A' WHERE PATIENT_ID = ? AND PATIENT_STATUS = 'I'";

        try (Connection connection = ConexionDB.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setInt(1, id);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Paciente restaurado exitosamente.");
            } else {
                System.out.println("No se encontró un paciente inactivo con el ID especificado.");
            }
        } catch (SQLException e) {
            System.out.println("Error al intentar restaurar el paciente.");
            e.printStackTrace();
        }
    }
}