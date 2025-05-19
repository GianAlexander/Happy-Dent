package pe.edu.vallegrande.crud.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class SupplierDTO {
    private int SUPPLIER_ID;          // ID del proveedor
    private String SUPPLIER_NAME;     // Nombre del proveedor
    private String SUPPLIER_RUC;      // RUC del proveedor
    private String SUPPLIER_EMAIL;    // Correo electrónico del proveedor
    private String SUPPLIER_PHONE;    // Teléfono del proveedor
    private String SUPPLIER_WEBSITE;  // Sitio web del proveedor
    private String SUPPLIER_ADDRESS;  // Dirección del proveedor
    private String SUPPLIER_TYPE;     // Tipo de proveedor (ej: Equipos dentales, Materiales dentales, etc.)
    private String SUPPLIER_STATUS;   // Estado del proveedor (A: Activo, I: Inactivo)
}