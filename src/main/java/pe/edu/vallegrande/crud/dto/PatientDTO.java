package pe.edu.vallegrande.crud.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;  // Import para el tipo Date

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class PatientDTO {
    private int PATIENT_ID;
    private String PATIENT_FIRST_NAME;  // Nombre
    private String PATIENT_LAST_NAME;  // Apellido
    private Date PATIENT_BIRTH_DATE;  // Fecha de nacimiento como Date
    private String PATIENT_DOC_TYPE;  // Tipo de documento
    private String PATIENT_NRO_DOC;  // Número de documento
    private String PATIENT_PHONE;  // Teléfono
    private String PATIENT_ADDRESS;  // Dirección
    private String PATIENT_OCCUPATION;  // Ocupación
    private String PATIENT_REASON;  // Motivo de consulta
    private String PATIENT_RISK_CONDITION;  // Condición de riesgo
    private String PATIENT_DETAILS;  // Detalles adicionales
    private String PATIENT_STATUS;  // Estado
}
