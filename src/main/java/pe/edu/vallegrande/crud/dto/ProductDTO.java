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
public class ProductDTO {
    private int PRODUCT_ID;
    private String PRODUCT_NAME;  // Nombre
    private String PRODUCT_BRAND;  // Marca
    private String PRODUCT_PRESENTATION;  // Presentación
    private int PRODUCT_STOCK;  // Stock
    private double PRODUCT_PRICE;  // Precio
    private Date PRODUCT_EXPIRATION_DATE;  // Fecha de expiración
    private String PRODUCT_BATCH;  // Lote
    private String PRODUCT_DESCRIPTION;  // Descripción
    private String PRODUCT_STATUS;  // Estado
}
