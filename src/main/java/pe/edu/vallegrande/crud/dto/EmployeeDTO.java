package pe.edu.vallegrande.crud.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class EmployeeDTO {
    private int EMPLOYEE_ID;
    private String EMPLOYEE_FIRST_NAME;  // Nombre
    private String EMPLOYEE_LAST_NAME;  // Apellido
    private Date EMPLOYEE_BIRTH_DATE;  // Fecha de nacimiento como Date
    private String EMPLOYEE_DOC_TYPE;  // Tipo de documento
    private String EMPLOYEE_NRO_DOC;  // Número de documento
    private String EMPLOYEE_PHONE;  // Teléfono
    private String EMPLOYEE_EMAIL;  // Correo electrónico
    private String EMPLOYEE_STATUS;  // Estado
}