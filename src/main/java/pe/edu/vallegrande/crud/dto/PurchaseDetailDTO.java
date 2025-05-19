package pe.edu.vallegrande.crud.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class PurchaseDetailDTO {
    private int PURCHASE_DETAIL_ID;
    private int PURCHASE_DETAIL_QUANTITY;
    private BigDecimal PURCHASE_DETAIL_PRICE;
    private BigDecimal PURCHASE_DETAIL_SUBTOTAL;
    private int PURCHASE_ID;
    private int PRODUCT_ID;
    private ProductDTO product;

}