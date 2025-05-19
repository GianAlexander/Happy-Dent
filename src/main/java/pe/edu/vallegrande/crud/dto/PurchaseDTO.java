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
public class PurchaseDTO {
    private int PURCHASE_ID;
    private Date PURCHASE_DATE;
    private BigDecimal PURCHASE_TOTAL;
    private char PURCHASE_STATUS;
    private int EMPLOYEE_ID;
    private int SUPPLIER_ID;

}
