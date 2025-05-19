package pe.edu.vallegrande.crud.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class SaleDTO {
    private int SALE_ID;
    private BigDecimal SALE_TOTAL;
    private Date SALE_DATE;
    private char SALE_METHOD;
    private char SALE_STATUS;
    private int PATIENT_ID;
    private int EMPLOYEE_ID;
}