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
public class SaleDetailDTO {
    private int SALE_DETAIL_ID;
    private int SALE_ID;
    private int PRODUCT_ID;
    private int SALE_DETAIL_QUANTITY;
    private BigDecimal SALE_DETAIL_PRICE;
    private BigDecimal SALE_DETAIL_SUBTOTAL;
    private ProductDTO product;
}