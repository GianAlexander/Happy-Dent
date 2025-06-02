-- Cambiar el contexto a la base de datos master
USE master;
GO

-- Verificar si la base de datos ya existe, si es así, eliminarla
IF DB_ID('HAPPY_DENT') IS NOT NULL
BEGIN
    DECLARE @sql NVARCHAR(MAX) = '';
    SELECT @sql += 'ALTER DATABASE HAPPY_DENT SET SINGLE_USER WITH ROLLBACK IMMEDIATE;'
    EXEC sp_executesql @sql;
    DROP DATABASE HAPPY_DENT;
END
GO

-- Crear la base de datos nuevamente
CREATE DATABASE HAPPY_DENT;
GO

-- Cambiar el contexto a la base de datos HAPPY_DENT
USE HAPPY_DENT;
GO

-- Crear las tablas


-- Table: PATIENT
CREATE TABLE PATIENT (
    PATIENT_ID INT IDENTITY(1,1) PRIMARY KEY,
    PATIENT_FIRST_NAME VARCHAR(60) NOT NULL CHECK (LEN(PATIENT_FIRST_NAME) > 0),
    PATIENT_LAST_NAME VARCHAR(90) NOT NULL CHECK (LEN(PATIENT_LAST_NAME) > 0),
    PATIENT_BIRTH_DATE DATE NOT NULL CHECK (PATIENT_BIRTH_DATE <= GETDATE() AND PATIENT_BIRTH_DATE >= DATEADD(YEAR, -120, GETDATE())),
    PATIENT_DOC_TYPE CHAR(3) NOT NULL CHECK (PATIENT_DOC_TYPE IN ('DNI', 'CNE')),
    PATIENT_NRO_DOC VARCHAR(12) NOT NULL UNIQUE,
    PATIENT_PHONE VARCHAR(9) NOT NULL CHECK (PATIENT_PHONE LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    PATIENT_ADDRESS VARCHAR(100) NULL,
    PATIENT_OCCUPATION VARCHAR(50) NULL,
    PATIENT_REASON VARCHAR(255) NULL,
    PATIENT_RISK_CONDITION VARCHAR(255) NULL,
    PATIENT_DETAILS VARCHAR(255) NULL,
    PATIENT_STATUS CHAR(1) DEFAULT 'A' CHECK (PATIENT_STATUS IN ('A', 'I'))
);
GO
CREATE OR ALTER TRIGGER TRG_VALIDATE_PATIENT_DOC
ON PATIENT
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM INSERTED
        WHERE (PATIENT_DOC_TYPE = 'DNI' AND PATIENT_NRO_DOC NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
        OR (PATIENT_DOC_TYPE = 'CNE' AND (LEN(PATIENT_NRO_DOC) < 8 OR LEN(PATIENT_NRO_DOC) > 12))
    )
    BEGIN
        RAISERROR ('El número de documento no corresponde con el tipo de documento', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO



-- Table: EMPLOYEE
CREATE TABLE EMPLOYEE (
    EMPLOYEE_ID INT IDENTITY(1,1) PRIMARY KEY,
    EMPLOYEE_FIRST_NAME VARCHAR(60) NOT NULL CHECK (LEN(EMPLOYEE_FIRST_NAME) > 0),
    EMPLOYEE_LAST_NAME VARCHAR(90) NOT NULL CHECK (LEN(EMPLOYEE_LAST_NAME) > 0),
    EMPLOYEE_BIRTH_DATE DATE NOT NULL CHECK (EMPLOYEE_BIRTH_DATE <= DATEADD(YEAR, -18, GETDATE())),
    EMPLOYEE_DOC_TYPE CHAR(3) NOT NULL CHECK (EMPLOYEE_DOC_TYPE IN ('DNI', 'CNE', 'PAS')),
    EMPLOYEE_NRO_DOC VARCHAR(20) UNIQUE ,
    EMPLOYEE_PHONE VARCHAR(9) NOT NULL CHECK (EMPLOYEE_PHONE LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    EMPLOYEE_EMAIL VARCHAR(80) NOT NULL UNIQUE CHECK (EMPLOYEE_EMAIL LIKE '%_@_%._%'),
    EMPLOYEE_STATUS CHAR(1) NOT NULL DEFAULT 'A' CHECK (EMPLOYEE_STATUS IN ('A', 'I'))
);
GO

CREATE TRIGGER TRG_VALIDATE_EMPLOYEE_DOC
ON EMPLOYEE
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM INSERTED
        WHERE 
            (EMPLOYEE_DOC_TYPE = 'DNI' AND (PATINDEX('%[^0-9]%', EMPLOYEE_NRO_DOC) > 0 OR LEN(EMPLOYEE_NRO_DOC) <> 8))
        OR (EMPLOYEE_DOC_TYPE = 'CNE' AND (LEN(EMPLOYEE_DOC_TYPE) < 8 OR LEN(EMPLOYEE_DOC_TYPE) > 12))
    )
    BEGIN
        RAISERROR ('El número de documento no corresponde con el tipo de documento', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- Table: SALE
CREATE TABLE SALE (
    SALE_ID INT IDENTITY(1,1) PRIMARY KEY,
    SALE_TOTAL DECIMAL(8,2) NOT NULL CHECK (SALE_TOTAL > 0),
    SALE_DATE DATE NOT NULL DEFAULT GETDATE(),
    SALE_METHOD CHAR(1) NOT NULL CHECK (SALE_METHOD IN ('C', 'D', 'T')),
    SALE_STATUS CHAR(1) NOT NULL CHECK (SALE_STATUS IN ('A', 'C')),
    PATIENT_ID INT NOT NULL,
    EMPLOYEE_ID INT NOT NULL,
    FOREIGN KEY (PATIENT_ID) REFERENCES PATIENT (PATIENT_ID),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE (EMPLOYEE_ID)
);
GO

CREATE TABLE SUPPLIER (
    SUPPLIER_ID INT IDENTITY(1,1) PRIMARY KEY,
    SUPPLIER_NAME VARCHAR(100) NOT NULL,
    SUPPLIER_RUC CHAR(11) NOT NULL UNIQUE CHECK (PATINDEX('%[^0-9]%', SUPPLIER_RUC) = 0 AND LEN(SUPPLIER_RUC) = 11),
    SUPPLIER_EMAIL VARCHAR(50) NOT NULL UNIQUE CHECK (SUPPLIER_EMAIL LIKE '%_@_%._%'),
    SUPPLIER_PHONE VARCHAR(9) NOT NULL CHECK (SUPPLIER_PHONE LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    SUPPLIER_WEBSITE VARCHAR(200),  -- Nuevo campo para el sitio web
    SUPPLIER_ADDRESS VARCHAR(200),  -- Nuevo campo para la dirección
    SUPPLIER_TYPE VARCHAR(50),      -- Nuevo campo para el tipo de proveedor
    SUPPLIER_STATUS CHAR(1) NOT NULL CHECK (SUPPLIER_STATUS IN ('A', 'I'))
);
GO

-- Table: PRODUCT
CREATE TABLE PRODUCT (
    PRODUCT_ID INT IDENTITY(1,1) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(50) NOT NULL,
    PRODUCT_BRAND VARCHAR(50) NOT NULL,
    PRODUCT_PRESENTATION VARCHAR(20) NULL,
    PRODUCT_STOCK INT NOT NULL CHECK (PRODUCT_STOCK >= 0),
    PRODUCT_PRICE DECIMAL(8,2) NOT NULL CHECK (PRODUCT_PRICE >= 0), -- Permitir precio 0 en promociones
    PRODUCT_EXPIRATION_DATE DATE NULL ,
    PRODUCT_BATCH VARCHAR(30) NULL,
    PRODUCT_DESCRIPTION VARCHAR(255) NOT NULL,
    PRODUCT_STATUS CHAR(1) DEFAULT 'A' CHECK (PRODUCT_STATUS IN ('A', 'I'))
);
GO

-- Table: SALE_DETAIL
CREATE TABLE SALE_DETAIL (
    SALE_DETAIL_ID INT IDENTITY(1,1) PRIMARY KEY,
    SALE_ID INT NOT NULL,
    PRODUCT_ID INT NOT NULL,
    SALE_DETAIL_QUANTITY INT NOT NULL CHECK (SALE_DETAIL_QUANTITY > 0),
    SALE_DETAIL_PRICE DECIMAL(8,2) NOT NULL CHECK (SALE_DETAIL_PRICE > 0),
    SALE_DETAIL_SUBTOTAL DECIMAL(8,2) NOT NULL CHECK (SALE_DETAIL_SUBTOTAL > 0),
    FOREIGN KEY (SALE_ID) REFERENCES SALE (SALE_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID)
);
GO

-- Tabla: PURCHASE
CREATE TABLE PURCHASE (
    PURCHASE_ID int IDENTITY(1,1) PRIMARY KEY,
    PURCHASE_DATE date NOT NULL,
    PURCHASE_TOTAL decimal(10,2) CHECK (PURCHASE_TOTAL > 0),
    PURCHASE_STATUS char(1) NOT NULL CHECK (PURCHASE_STATUS IN ('A', 'I')),
    EMPLOYEE_ID int NOT NULL,
    SUPPLIER_ID int NOT NULL,
    CONSTRAINT PURCHASE_EMPLOYEE FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE (EMPLOYEE_ID),
    CONSTRAINT PURCHASE_SUPPLIER FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIER (SUPPLIER_ID)
);

-- Tabla: PURCHASE_DETAIL
CREATE TABLE PURCHASE_DETAIL (
    PURCHASE_DETAIL_ID int IDENTITY(1,1) PRIMARY KEY,
    PURCHASE_DETAIL_QUANTITY int NOT NULL CHECK (PURCHASE_DETAIL_QUANTITY > 0),
    PURCHASE_DETAIL_PRICE decimal(10,2) NOT NULL CHECK (PURCHASE_DETAIL_PRICE >= 0),
    PURCHASE_DETAIL_SUBTOTAL decimal(10,2) NOT NULL,
    PURCHASE_ID int NOT NULL,
    PRODUCT_ID int NOT NULL,
    CONSTRAINT PURCHASE_DETAIL_PURCHASE FOREIGN KEY (PURCHASE_ID) REFERENCES PURCHASE (PURCHASE_ID),
    CONSTRAINT PURCHASE_DETAIL_PRODUCT FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (PRODUCT_ID)
);
GO


INSERT INTO PATIENT (PATIENT_FIRST_NAME, PATIENT_LAST_NAME, PATIENT_BIRTH_DATE, PATIENT_DOC_TYPE, PATIENT_NRO_DOC, PATIENT_PHONE, PATIENT_ADDRESS, PATIENT_OCCUPATION, PATIENT_REASON, PATIENT_RISK_CONDITION, PATIENT_DETAILS)
VALUES
('Juan', 'Pérez', '1985-05-15', 'DNI', '12345678', '987654321', 'Av. Lima 123', 'Ingeniero', 'Consulta', 'Ninguna', 'Revisión general'),
('María', 'Gómez', '1990-08-22', 'DNI', '87654321', '987123456', 'Calle Libertad 456', 'Doctora', 'Consulta', 'Alergia a penicilina', 'Dolor molar'),
('Carlos', 'López', '1978-12-10', 'DNI', '56781234', '987654123', 'Jr. Tacna 789', 'Abogado', 'Consulta', 'Hipertensión', 'Sensibilidad dental'),
('Ana', 'Martínez', '1995-03-25', 'DNI', '43218765', '987321654', 'Av. Arequipa 321', 'Estudiante', 'Consulta', 'Asma', 'Mal aliento persistente'),
('Luis', 'Rodríguez', '1982-07-18', 'DNI', '65432187', '987456321', 'Calle Bolívar 654', 'Arquitecto', 'Consulta', 'Ninguna', 'Encías inflamadas'),
('Sofía', 'Hernández', '1998-11-30', 'DNI', '78912345', '987654987', 'Av. Brasil 987', 'Diseñadora', 'Consulta', 'Diabetes', 'Revisión rutinaria'),
('Pedro', 'Díaz', '2000-09-12', 'DNI', '32165498', '987321987', 'Jr. Ayacucho 321', 'Estudiante', 'Brackets', 'Ninguna', 'Primera evaluación ortodoncia'),
('Lucía', 'Torres', '2002-04-05', 'DNI', '98765432', '987654321', 'Av. Venezuela 654', 'Estudiante', 'Brackets', 'Ninguna', 'Control mensual brackets'),
('Jorge', 'Flores', '1999-06-20', 'DNI', '12398765', '987123987', 'Calle Huancavelica 123', 'Chef', 'Brackets', 'Ninguna', 'Ajuste de arcos'),
('Carmen', 'Vargas', '2001-02-14', 'DNI', '45678912', '987456987', 'Av. Argentina 456', 'Estudiante', 'Brackets', 'Ninguna', 'Colocación de brackets'),
('Roberto', 'Castro', '1997-10-08', 'DNI', '78945612', '987789123', 'Jr. Cusco 789', 'Ingeniero', 'Brackets', 'Ninguna', 'Retiro de brackets'),
('Elena', 'Ruiz', '1996-07-03', 'DNI', '32198765', '987321654', 'Av. Colombia 321', 'Abogada', 'Brackets', 'Ninguna', 'Control post-tratamiento'),
('Fernando', 'Mendoza', '1987-12-19', 'DNI', '65412378', '987654123', 'Calle Trujillo 654', 'Médico', 'Control', 'Ninguna', 'Control post-operatorio'),
('Isabel', 'Guerrero', '1996-05-28', 'DNI', '98712345', '987987654', 'Av. México 987', 'Estudiante', 'Control', 'Ninguna', 'Control de limpieza'),
('Ricardo', 'Ortiz', '1984-09-15', 'DNI', '12345698', '987123456', 'Jr. Piura 123', 'Ingeniero', 'Control', 'Ninguna', 'Control de caries'),
('Patricia', 'Silva', '1975-11-22', 'DNI', '45612378', '987456123', 'Av. Bolivia 456', 'Profesora', 'Control', 'Hipertensión', 'Control periodontal'),
('Oscar', 'Ramírez', '1992-03-10', 'DNI', '78945632', '987789456', 'Jr. Amazonas 789', 'Contador', 'Control', 'Ninguna', 'Control de prótesis'),
('Gabriela', 'Morales', '1989-08-17', 'DNI', '32165478', '987321789', 'Av. Paraguay 321', 'Psicóloga', 'Control', 'Embarazada', 'Control preventivo'),
('Daniel', 'Suárez', '1970-10-08', 'DNI', '65478912', '987654789', 'Jr. Loreto 654', 'Jubilado', 'Extracción', 'Diabetes', 'Extracción molar'),
('Valeria', 'Cruz', '2003-12-25', 'DNI', '98732145', '987987321', 'Av. Madre de Dios 987', 'Estudiante', 'Extracción', 'Ninguna', 'Extracción cordal'),
('Hugo', 'Rojas', '1980-07-30', 'DNI', '12378965', '987123789', 'Calle Moquegua 123', 'Carpintero', 'Extracción', 'Ninguna', 'Extracción premolar'),
('Claudia', 'Paredes', '1978-04-12', 'DNI', '45632178', '987456321', 'Av. Tacna 456', 'Enfermera', 'Extracción', 'Asma', 'Extracción complicada'),
('Raúl', 'Vega', '1995-01-18', 'DNI', '78912356', '987789123', 'Jr. Tumbes 789', 'Estudiante', 'Extracción', 'Ninguna', 'Extracción simple'),
('Natalia', 'Guzmán', '1987-06-05', 'DNI', '32145687', '987321456', 'Av. Ucayali 321', 'Diseñadora', 'Extracción', 'Ninguna', 'Extracción de raíces'),
('Mario', 'Salas', '1983-09-20', 'DNI', '65498712', '987654987', 'Calle Apurímac 654', 'Ingeniero', 'Endodoncia', 'Ninguna', 'Endodoncia molar'),
('Carolina', 'Delgado', '1991-02-14', 'DNI', '98765413', '987987654', 'Av. Cajamarca 987', 'Arquitecta', 'Endodoncia', 'Ninguna', 'Endodoncia premolar'),
('Pablo', 'Castillo', '1976-11-08', 'DNI', '12345679', '987123654', 'Jr. Huánuco 123', 'Abogado', 'Endodoncia', 'Problemas cardíacos', 'Endodoncia complicada'),
('Diana', 'Romero', '1988-07-22', 'DNI', '45678913', '987456654', 'Av. Pasco 456', 'Doctora', 'Endodoncia', 'Ninguna', 'Reendodoncia'),
('Gustavo', 'Peña', '1994-04-30', 'DNI', '78912346', '987789654', 'Jr. Ayacucho 789', 'Contador', 'Endodoncia', 'Ninguna', 'Endodoncia incisivo'),
('Rosa', 'Medina', '1965-08-15', 'DNI', '32165479', '987321123', 'Av. Junín 321', 'Jubilada', 'Prótesis', 'Osteoporosis', 'Prótesis completa'),
('Javier', 'Herrera', '1958-12-03', 'DNI', '65412379', '987654456', 'Calle San Martín 654', 'Jubilado', 'Prótesis', 'Diabetes', 'Prótesis parcial'),
('Silvia', 'Córdova', '1972-05-28', 'DNI', '98745613', '987987789', 'Av. Libertador 987', 'Profesora', 'Prótesis', 'Ninguna', 'Corona dental'),
('Renato', 'Quispe', '1968-10-10', 'DNI', '12378946', '987123987', 'Jr. Independencia 123', 'Comerciante', 'Prótesis', 'Hipertensión', 'Puente dental'),
('Lourdes', 'Arias', '1955-07-17', 'DNI', '45612379', '987456789', 'Av. Revolución 456', 'Jubilada', 'Prótesis', 'Artritis', 'Reparación prótesis'),
('Alejandro', 'Fernández', '2015-03-10', 'DNI', '78945613', '987789321', 'Jr. Esperanza 789', 'Estudiante', 'Odontopediatría', 'Ninguna', 'Primera consulta niño'),
('Valentina', 'Mendoza', '2016-08-22', 'DNI', '32198746', '987321456', 'Av. Alegría 321', 'Estudiante', 'Odontopediatría', 'Asma', 'Caries en dientes de leche'),
('Diego', 'Paz', '2017-11-05', 'DNI', '65478913', '987654123', 'Calle Juegos 654', 'Estudiante', 'Odontopediatría', 'Ninguna', 'Sellantes dentales'),
('Camila', 'Ríos', '2014-09-18', 'DNI', '98712346', '987987123', 'Av. Diversión 987', 'Estudiante', 'Odontopediatría', 'Ninguna', 'Ortodoncia interceptiva'),
('Mateo', 'Soto', '2018-04-30', 'DNI', '12345680', '987123321', 'Jr. Sonrisas 123', 'Estudiante', 'Odontopediatría', 'Ninguna', 'Traumatismo dental'),
('Lucía', 'Chávez', '2019-01-15', 'DNI', '45678914', '987456123', 'Av. Infantil 456', 'Estudiante', 'Odontopediatría', 'Ninguna', 'Fluorización');
GO

INSERT INTO EMPLOYEE (EMPLOYEE_FIRST_NAME, EMPLOYEE_LAST_NAME, EMPLOYEE_BIRTH_DATE, EMPLOYEE_DOC_TYPE, EMPLOYEE_NRO_DOC, EMPLOYEE_PHONE, EMPLOYEE_EMAIL, EMPLOYEE_STATUS)
VALUES
('Carlos', 'García', '1985-03-10', 'DNI', '12345678', '987644321', 'carlos.garcia@happy-dent.com', 'A'),
('Ana', 'López', '1990-07-22', 'DNI', '87654321', '987123456', 'ana.lopez@happy-dent.com', 'A'),
('Luis', 'Martínez', '1982-11-15', 'DNI', '56781234', '987654123', 'luis.martinez@happy-dent.com', 'A'),
('Sofía', 'Rodríguez', '1995-05-18', 'DNI', '43218765', '987321654', 'sofia.rodriguez@happy-dent.com', 'A'),
('Pedro', 'Hernández', '1978-09-30', 'DNI', '65432187', '987456321', 'pedro.hernandez@happy-dent.com', 'A'),
('Lucía', 'Díaz', '1989-12-05', 'DNI', '78912345', '987654987', 'lucia.diaz@happy-dent.com', 'A'),
('Jorge', 'Torres', '1993-04-20', 'DNI', '32165498', '987321987', 'jorge.torres@happy-dent.com', 'A'),
('Carmen', 'Flores', '1980-08-14', 'DNI', '98765432', '987652212', 'carmen.flores@happy-dent.com', 'A'),
('Roberto', 'Vargas', '1970-02-08', 'DNI', '12398765', '987123987', 'roberto.vargas@happy-dent.com', 'A'),
('Elena', 'Castro', '1992-07-03', 'DNI', '45678912', '987456987', 'elena.castro@happy-dent.com', 'A'),
('Fernando', 'Ruiz', '1987-12-19', 'DNI', '78945612', '987789123', 'fernando.ruiz@happy-dent.com', 'A'),
('Isabel', 'Mendoza', '1996-05-28', 'DNI', '32198765', '987321654', 'isabel.mendoza@happy-dent.com', 'A'),
('Ricardo', 'Guerrero', '1984-09-15', 'DNI', '65412378', '987654123', 'ricardo.guerrero@happy-dent.com', 'A'),
('María', 'Ortiz', '1998-03-25', 'DNI', '98712345', '987987654', 'maria.ortiz@happy-dent.com', 'A'),
('Juan', 'Pérez', '1985-06-12', 'DNI', '12385698', '987123456', 'juan.perez@happy-dent.com', 'A');
GO

INSERT INTO SUPPLIER (SUPPLIER_NAME, SUPPLIER_RUC, SUPPLIER_EMAIL, SUPPLIER_PHONE, SUPPLIER_WEBSITE, SUPPLIER_ADDRESS, SUPPLIER_TYPE, SUPPLIER_STATUS)
VALUES
('DentalPro', '12345678901', 'info@dentalpro.com', '987654321', 'www.dentalpro.com', 'Av. Dental 123, Lima', 'Equipos dentales', 'A'),
('OralCare', '23456789012', 'contact@oralcare.com', '987123456', 'www.oralcare.com', 'Calle Sonrisa 456, Arequipa', 'Materiales dentales', 'A'),
('SmileSupplies', '34567890123', 'sales@smilesupplies.com', '987654123', 'www.smilesupplies.com', 'Jr. Molar 789, Trujillo', 'Insumos dentales', 'A'),
('ToothTech', '45678901234', 'support@toothtech.com', '987321654', 'www.toothtech.com', 'Av. Diente 321, Chiclayo', 'Tecnología dental', 'A'),
('Dentix', '56789012345', 'info@dentix.com', '987456321', 'www.dentix.com', 'Calle Ortodoncia 654, Piura', 'Ortodoncia', 'A'),
('BrightSmile', '67890123456', 'contact@brightsmile.com', '987654987', 'www.brightsmile.com', 'Av. Blanqueamiento 987, Ica', 'Blanqueamiento dental', 'A'),
('HealthyTeeth', '78901234567', 'sales@healthyteeth.com', '987321987', 'www.healthyteeth.com', 'Jr. Caries 123, Cusco', 'Prevención dental', 'A'),
('DentalPlus', '89012345678', 'info@dentalplus.com', '987656421', 'www.dentalplus.com', 'Av. Implante 456, Huancayo', 'Implantes dentales', 'A'),
('ToothCare', '90123456789', 'contact@toothcare.com', '987123987', 'www.toothcare.com', 'Calle Endodoncia 789, Tacna', 'Endodoncia', 'A'),
('SmileDent', '01234567890', 'sales@smiledent.com', '987456987', 'www.smiledent.com', 'Av. Prótesis 321, Puno', 'Prótesis dentales', 'A'),
('DentalWorld', '12345098765', 'info@dentalworld.com', '987789123', 'www.dentalworld.com', 'Jr. Estética 654, Tarapoto', 'Estética dental', 'A'),
('OralHealth', '23456109876', 'contact@oralhealth.com', '987321654', 'www.oralhealth.com', 'Av. Higiene 987, Iquitos', 'Higiene dental', 'A'),
('ToothSolutions', '34567210987', 'sales@toothsolutions.com', '987654123', 'www.toothsolutions.com', 'Calle Tratamiento 123, Cajamarca', 'Tratamientos dentales', 'A'),
('DentalCare', '45678321098', 'info@dentalcare.com', '987987654', 'www.dentalcare.com', 'Av. Cirugía 456, Ayacucho', 'Cirugía dental', 'A'),
('SmilePlus', '56789432109', 'contact@smileplus.com', '987123456', 'www.smileplus.com', 'Jr. Alineación 789, Huánuco', 'Ortodoncia invisible', 'A');
GO

INSERT INTO PRODUCT (PRODUCT_NAME, PRODUCT_BRAND, PRODUCT_PRESENTATION, PRODUCT_STOCK, PRODUCT_PRICE, PRODUCT_EXPIRATION_DATE, PRODUCT_BATCH, PRODUCT_DESCRIPTION, PRODUCT_STATUS)
VALUES
('Cepillo Dental', 'Oral-B', 'Unidad', 100, 5.99, '2025-12-31', 'BATCH001', 'Cepillo de cerdas suaves', 'A'),
('Pasta Dental', 'Colgate', 'Tubo 100g', 200, 3.50, '2024-06-30', 'BATCH002', 'Pasta dental con flúor', 'A'),
('Hilo Dental', 'Sensodyne', 'Caja 50m', 150, 4.99, '2025-03-31', 'BATCH003', 'Hilo dental resistente', 'A'),
('Cera Ortodóntica', 'GUM', 'Caja 10g', 120, 2.99, '2025-05-31', 'BATCH007', 'Cera para brackets', 'A'),
('Gel Anestésico', 'Orajel', 'Tubo 10g', 70, 9.99, '2024-11-30', 'BATCH010', 'Gel para aliviar el dolor', 'A'),
('Cepillo Interdental', 'TePe', 'Caja 10 unidades', 110, 5.50, '2025-07-31', 'BATCH011', 'Cepillo para espacios interdentales', 'A'),
('Kit de Ortodoncia', '3M', 'Kit', 40, 29.99, '2026-03-31', 'BATCH012', 'Kit para cuidado de brackets', 'A'),
('Explorador Dental N°5', 'Hu-Friedy', 'Unidad', 50, 12.99, NULL, 'EXP2023-001', 'Explorador dental de acero inoxidable, punta afilada', 'A'),
('Explorador N°23', 'GDC', 'Unidad', 45, 10.50, NULL, 'EXP2023-002', 'Explorador periodontal de doble punta', 'A'),
('Explorador OMS', 'Aesculap', 'Unidad', 60, 11.75, NULL, 'EXP2023-003', 'Explorador estándar OMS', 'A'),
('Explorador Cowhorn', 'Karl Schumacher', 'Unidad', 40, 14.20, NULL, 'EXP2023-004', 'Explorador con punta en forma de cuerno', 'A'),
('Espejo Bucal N°4', 'Hu-Friedy', 'Unidad', 80, 8.99, NULL, 'ESP2023-001', 'Espejo bucal frontal con mango', 'A'),
('Espejo Dental N°5', 'GDC', 'Unidad', 75, 7.50, NULL, 'ESP2023-002', 'Espejo bucal de alta calidad', 'A'),
('Espejo Concavo', 'Aesculap', 'Unidad', 65, 9.25, NULL, 'ESP2023-003', 'Espejo cóncavo para mejor visibilidad', 'A'),
('Espejo Bucal Desechable', 'DentalEZ', 'Paquete 10', 120, 15.99, '2025-12-31', 'ESP2023-004', 'Espejos bucales desechables esterilizados', 'A'),
('Pinza Algodon N°17', 'Hu-Friedy', 'Unidad', 55, 18.99, NULL, 'PIN2023-001', 'Pinza para algodón de acero inoxidable', 'A'),
('Pinza Hemostática N°5', 'GDC', 'Unidad', 50, 22.50, NULL, 'PIN2023-002', 'Pinza hemostática para extracciones', 'A'),
('Pinza Adson', 'Aesculap', 'Unidad', 45, 20.75, NULL, 'PIN2023-003', 'Pinza Adson con dientes', 'A'),
('Pinza Rochester-Pean', 'Karl Schumacher', 'Unidad', 40, 25.20, NULL, 'PIN2023-004', 'Pinza hemostática curva', 'A'),
('Tijera Iris', 'Hu-Friedy', 'Unidad', 30, 28.99, NULL, 'TIJ2023-001', 'Tijera Iris curva para cirugía', 'A'),
('Elevador Periotomo', 'GDC', 'Unidad', 35, 32.50, NULL, 'ELE2023-001', 'Elevador periotomo para extracciones', 'A'),
('Cureta Gracey N°5-6', 'Aesculap', 'Unidad', 40, 29.75, NULL, 'CUR2023-001', 'Cureta periodontal Gracey', 'A'),
('Bisturí Dental N°15', 'Swann-Morton', 'Paquete 10', 100, 12.99, '2026-06-30', 'BIS2023-001', 'Hojas de bisturí N°15 esterilizadas', 'A'),
('Porta Amalgama N°1', 'GDC', 'Unidad', 60, 15.50, NULL, 'POR2023-001', 'Porta amalgama de acero inoxidable', 'A'),
('Condensador de Amalgama', 'Hu-Friedy', 'Unidad', 55, 17.99, NULL, 'CON2023-001', 'Condensador para amalgama', 'A'),
('Espatula Doble', 'Aesculap', 'Unidad', 50, 12.75, NULL, 'ESP2023-005', 'Espátula doble para materiales', 'A'),
('Aplicador de Cemento', 'Karl Schumacher', 'Unidad', 45, 9.20, NULL, 'APL2023-001', 'Aplicador para cementos dentales', 'A'),
('Lima K N°15', 'Dentsply', 'Paquete 6', 120, 18.99, '2025-12-31', 'LIM2023-001', 'Limas K para endodoncia', 'A'),
('Localizador Apical', 'VDW', 'Unidad', 15, 450.00, NULL, 'LOC2023-001', 'Localizador electrónico de ápice', 'A'),
('Extensor de Goma', 'GDC', 'Paquete 10', 200, 8.50, NULL, 'EXT2023-001', 'Extensores de goma para dique', 'A'),
('Porta Limas', 'Hu-Friedy', 'Unidad', 40, 22.99, NULL, 'POR2023-002', 'Porta limas para endodoncia', 'A'),
('Separador Elástico', '3M', 'Paquete 100', 500, 25.99, '2026-03-31', 'SEP2023-001', 'Separadores elásticos para ortodoncia', 'A'),
('Pinza Weingart', 'GDC', 'Unidad', 35, 38.50, NULL, 'PIN2023-005', 'Pinza Weingart para arcos', 'A'),
('Cortador de Ligadura', 'Hu-Friedy', 'Unidad', 40, 42.75, NULL, 'COR2023-001', 'Cortador de ligaduras metálicas', 'A'),
('Bandeador Molar', 'Aesculap', 'Unidad', 30, 55.20, NULL, 'BAN2023-001', 'Bandeador para bandas molares', 'A'),
('Fresa Redonda N°2', 'Komet', 'Paquete 10', 300, 14.99, NULL, 'FRE2023-001', 'Fresa redonda para alta velocidad', 'A'),
('Fresa Fissura N°701', 'Komet', 'Paquete 10', 280, 16.50, NULL, 'FRE2023-002', 'Fresa para preparación de cavidades', 'A'),
('Contra Ángulo', 'NSK', 'Unidad', 25, 220.00, NULL, 'CON2023-002', 'Contra ángulo para pieza de mano', 'A'),
('Porta Fresa', 'Dentsply', 'Unidad', 50, 18.75, NULL, 'POR2023-003', 'Porta fresa para baja velocidad', 'A'),
('Cucharilla Impresión N°2', 'GDC', 'Unidad', 40, 32.99, NULL, 'CUC2023-001', 'Cucharilla para impresiones superiores', 'A'),
('Espátula Alginato', 'Zhermack', 'Unidad', 60, 15.20, NULL, 'ESP2023-006', 'Espátula para mezcla de alginato', 'A'),
('Pistola Silicona', '3M', 'Unidad', 30, 85.00, NULL, 'PIS2023-001', 'Pistola para materiales de impresión', 'A'),
('Bandeja Impresión Niño', 'Aesculap', 'Unidad', 35, 28.75, NULL, 'BAN2023-002', 'Bandeja para impresiones pediátricas', 'A'),
('Sonda Periodontal', 'Hu-Friedy', 'Unidad', 45, 24.99, NULL, 'SON2023-001', 'Sonda periodontal milimetrada', 'A'),
('Cureta Universal', 'GDC', 'Unidad', 50, 29.50, NULL, 'CUR2023-002', 'Cureta universal para raspado', 'A'),
('Scaler Sickle', 'Aesculap', 'Unidad', 40, 26.75, NULL, 'SCA2023-001', 'Scaler para cálculo supragingival', 'A'),
('Tijera Gingival', 'Karl Schumacher', 'Unidad', 35, 45.20, NULL, 'TIJ2023-002', 'Tijera para tejido gingival', 'A'),
('Mascarilla N95', '3M', 'Paquete 10', 200, 25.99, '2024-12-31', 'MAS2023-001', 'Mascarilla de protección N95', 'A'),
('Protector Facial', 'DentalEZ', 'Unidad', 150, 8.50, NULL, 'PRO2023-001', 'Protector facial transparente', 'A'),
('Guantes Nitrilo T/M', 'Ansell', 'Caja 100', 500, 32.75, '2025-06-30', 'GUA2023-001', 'Guantes de nitrilo talla mediana', 'A'),
('Bata Desechable', 'Henry Schein', 'Paquete 10', 120, 18.20, NULL, 'BAT2023-001', 'Bata desechable para consultorio', 'A');
GO

INSERT INTO SALE (SALE_TOTAL, SALE_DATE, SALE_METHOD, SALE_STATUS, PATIENT_ID, EMPLOYEE_ID)
VALUES
(116.46, '2024-10-28', 'T', 'A', 1, 1),
(379.6, '2024-10-05', 'C', 'A', 2, 2),
(308.58, '2024-11-07', 'T', 'A', 3, 3),
(262.16, '2024-11-06', 'T', 'A', 4, 4),
(307.26, '2024-10-21', 'C', 'A', 5, 5),
(37.2, '2024-11-10', 'C', 'A', 6, 6),
(119.25, '2024-11-07', 'T', 'A', 7, 7),
(411.12, '2024-11-04', 'T', 'A', 8, 8),
(122.92, '2024-11-19', 'C', 'A', 9, 9),
(69.62, '2024-10-22', 'C', 'A', 10, 10),
(59.55, '2024-10-18', 'C', 'A', 1, 1),
(142.1, '2024-11-02', 'T', 'A', 2, 2),
(61.62, '2024-11-06', 'C', 'A', 3, 3),
(309.31, '2024-10-10', 'C', 'A', 4, 4),
(186.84, '2024-10-10', 'T', 'A', 5, 5),
(147.78, '2024-10-29', 'C', 'A', 6, 6),
(101.47, '2024-10-10', 'T', 'A', 7, 7),
(14.64, '2024-10-10', 'C', 'A', 8, 8),
(367.04, '2024-11-01', 'C', 'A', 9, 9),
(60.96, '2024-10-16', 'T', 'A', 10, 10),
(143.95, '2024-10-30', 'T', 'A', 1, 1),
(150.68, '2024-11-16', 'T', 'A', 2, 2),
(308.23, '2024-11-03', 'C', 'A', 3, 3),
(487.43, '2024-10-28', 'C', 'A', 4, 4),
(14.92, '2024-10-13', 'C', 'A', 5, 5),
(58.27, '2024-10-10', 'C', 'A', 6, 6),
(114.44, '2024-10-16', 'C', 'A', 7, 7),
(334.29, '2024-10-27', 'C', 'A', 8, 8),
(379.63, '2024-11-12', 'T', 'A', 9, 9),
(358.38, '2024-11-09', 'C', 'A', 10, 10),
(192.58, '2024-10-24', 'C', 'A', 1, 1),
(66.05, '2024-10-12', 'T', 'A', 2, 2),
(238.43, '2024-10-07', 'C', 'A', 3, 3),
(125.01, '2024-10-21', 'C', 'A', 4, 4),
(176.85, '2024-10-28', 'C', 'A', 5, 5),
(399.73, '2024-10-19', 'C', 'A', 6, 6),
(180.92, '2024-10-27', 'C', 'A', 7, 7),
(197.76, '2024-10-31', 'T', 'A', 8, 8),
(273.28, '2024-11-07', 'T', 'A', 9, 9),
(124.22, '2024-10-27', 'C', 'A', 10, 10),
(156.82, '2024-11-03', 'T', 'A', 1, 1),
(17.9, '2024-11-14', 'T', 'A', 2, 2),
(207.55, '2024-10-11', 'T', 'A', 3, 3),
(80.04, '2024-10-31', 'C', 'A', 4, 4),
(161.6, '2024-10-18', 'C', 'A', 5, 5),
(157.62, '2024-11-14', 'C', 'A', 6, 6),
(160.33, '2024-10-16', 'C', 'A', 7, 7),
(163.6, '2024-11-04', 'T', 'A', 8, 8),
(66.46, '2024-10-02', 'T', 'A', 9, 9),
(177.63, '2024-11-19', 'C', 'A', 10, 10);
GO


INSERT INTO SALE_DETAIL (SALE_ID, PRODUCT_ID, SALE_DETAIL_QUANTITY, SALE_DETAIL_PRICE, SALE_DETAIL_SUBTOTAL)
VALUES
(1, 12, 4, 20.48, 81.92),
(1, 15, 2, 17.27, 34.54),
(2, 8, 4, 44.2, 176.8),
(2, 20, 5, 40.56, 202.8),
(3, 2, 4, 44.32, 177.28),
(3, 13, 4, 4.22, 16.88),
(3, 12, 3, 38.14, 114.42),
(4, 15, 3, 8.12, 24.36),
(4, 17, 5, 47.56, 237.8),
(5, 1, 4, 24.26, 97.04),
(5, 6, 2, 16.25, 32.5),
(5, 4, 4, 21.08, 84.32),
(5, 5, 5, 18.68, 93.4),
(6, 11, 4, 9.3, 37.2),
(7, 14, 1, 31.33, 31.33),
(7, 13, 2, 33.43, 66.86),
(7, 3, 3, 7.02, 21.06),
(8, 8, 4, 47.04, 188.16),
(8, 13, 2, 49.59, 99.18),
(8, 18, 3, 41.26, 123.78),
(9, 3, 2, 16.53, 33.06),
(9, 6, 2, 44.93, 89.86),
(10, 17, 2, 34.81, 69.62),
(11, 10, 3, 19.85, 59.55),
(12, 11, 5, 28.42, 142.1),
(13, 19, 2, 19.95, 39.9),
(13, 10, 3, 7.24, 21.72),
(14, 14, 4, 43.38, 173.52),
(14, 2, 3, 31.53, 94.59),
(14, 10, 2, 20.6, 41.2),
(15, 11, 2, 29.1, 58.2),
(15, 3, 3, 23.48, 70.44),
(15, 2, 3, 17.98, 53.94),
(15, 13, 1, 4.26, 4.26),
(16, 13, 3, 49.26, 147.78),
(17, 16, 1, 3.11, 3.11),
(17, 3, 4, 24.59, 98.36),
(18, 17, 4, 3.66, 14.64),
(19, 9, 3, 36.08, 108.24),
(19, 7, 5, 21.36, 106.8),
(19, 3, 5, 30.4, 152.0),
(20, 16, 2, 30.48, 60.96),
(21, 3, 2, 49.52, 99.04),
(21, 9, 2, 2.57, 5.14),
(21, 19, 1, 39.77, 39.77),
(22, 17, 2, 31.27, 62.54),
(22, 20, 2, 5.57, 11.14),
(22, 13, 4, 19.25, 77.0),
(23, 10, 5, 45.75, 228.75),
(23, 15, 4, 19.87, 79.48),
(24, 8, 5, 41.12, 205.6),
(24, 1, 2, 30.06, 60.12),
(24, 14, 4, 49.07, 196.28),
(24, 3, 1, 25.43, 25.43),
(25, 4, 4, 3.73, 14.92),
(26, 3, 1, 2.02, 2.02),
(26, 18, 5, 11.25, 56.25),
(27, 18, 5, 16.96, 84.8),
(27, 13, 4, 7.41, 29.64),
(28, 7, 4, 36.31, 145.24),
(28, 17, 3, 41.93, 125.79),
(28, 8, 2, 24.99, 49.98),
(28, 5, 2, 6.64, 13.28),
(29, 4, 4, 48.5, 194.0),
(29, 7, 5, 32.15, 160.75),
(29, 16, 4, 6.22, 24.88),
(30, 9, 4, 15.67, 62.68),
(30, 4, 5, 32.12, 160.6),
(30, 19, 5, 27.02, 135.1),
(31, 20, 1, 18.38, 18.38),
(31, 15, 5, 32.67, 163.35),
(31, 1, 5, 2.17, 10.85),
(32, 12, 1, 18.05, 18.05),
(32, 7, 2, 24.0, 48.0),
(33, 4, 4, 47.28, 189.12),
(33, 1, 1, 49.31, 49.31),
(34, 2, 2, 41.94, 83.88),
(34, 19, 3, 13.71, 41.13),
(35, 4, 5, 35.37, 176.85),
(36, 16, 1, 44.25, 44.25),
(36, 8, 4, 32.02, 128.08),
(36, 20, 3, 26.89, 80.67),
(36, 7, 3, 48.91, 146.73),
(37, 13, 4, 45.23, 180.92),
(38, 13, 4, 49.44, 197.76),
(39, 1, 4, 27.22, 108.88),
(39, 2, 4, 41.1, 164.4),
(40, 17, 5, 15.48, 77.4),
(40, 18, 1, 46.82, 46.82),
(41, 16, 1, 26.83, 26.83),
(41, 6, 3, 27.55, 82.65),
(41, 8, 1, 47.34, 47.34),
(42, 1, 5, 3.58, 17.9),
(43, 9, 3, 5.27, 15.81),
(43, 7, 3, 16.21, 48.63),
(43, 16, 2, 8.38, 16.76),
(43, 18, 5, 25.27, 126.35),
(44, 4, 3, 26.68, 80.04),
(45, 5, 4, 40.4, 161.6),
(46, 1, 2, 21.11, 42.22),
(46, 13, 3, 34.75, 104.25),
(46, 11, 1, 11.15, 11.15),
(47, 7, 1, 18.45, 18.45),
(47, 8, 1, 37.42, 37.42),
(47, 16, 2, 21.15, 42.3),
(47, 3, 3, 20.72, 62.16),
(48, 9, 3, 6.82, 20.46),
(48, 8, 5, 9.0, 45.0),
(48, 13, 1, 32.56, 32.56),
(48, 15, 3, 21.86, 65.58),
(49, 17, 1, 32.26, 32.26),
(49, 14, 4, 8.55, 34.2),
(50, 20, 3, 18.29, 54.87),
(50, 12, 3, 40.92, 122.76);
GO


INSERT INTO PURCHASE (PURCHASE_DATE, PURCHASE_TOTAL, PURCHASE_STATUS, EMPLOYEE_ID, SUPPLIER_ID)
VALUES
('2024-10-01', 100.00, 'A', 1, 1),
('2024-10-02', 200.00, 'A', 2, 2),
('2024-10-03', 150.00, 'A', 3, 3),
('2024-10-04', 300.00, 'A', 4, 4),
('2024-10-05', 250.00, 'A', 5, 5),
('2024-10-06', 120.00, 'A', 6, 6),
('2024-10-07', 180.00, 'A', 7, 7),
('2024-10-08', 90.00, 'A', 8, 8),
('2024-10-09', 60.00, 'A', 9, 9),
('2024-10-10', 80.00, 'A', 10, 10),
('2024-10-11', 320.50, 'A', 1, 3),
('2024-10-12', 180.75, 'A', 2, 4),
('2024-10-13', 420.30, 'A', 3, 5),
('2024-10-14', 150.20, 'A', 4, 6),
('2024-10-15', 275.90, 'A', 5, 7),
('2024-10-16', 195.60, 'A', 6, 8),
('2024-10-17', 380.25, 'A', 7, 9),
('2024-10-18', 210.40, 'A', 8, 10),
('2024-10-19', 335.70, 'A', 9, 11),
('2024-10-20', 165.80, 'A', 10, 12),
('2024-10-21', 290.35, 'A', 1, 13),
('2024-10-22', 230.45, 'A', 2, 14),
('2024-10-23', 410.20, 'A', 3, 1),
('2024-10-24', 175.90, 'A', 4, 2),
('2024-10-25', 325.60, 'A', 5, 3),
('2024-10-26', 205.75, 'A', 6, 4),
('2024-10-27', 395.30, 'A', 7, 5),
('2024-10-28', 225.40, 'A', 8, 6),
('2024-10-29', 310.50, 'A', 9, 7),
('2024-10-30', 185.65, 'A', 10, 8),
('2024-10-31', 340.25, 'A', 1, 9),
('2024-11-01', 240.70, 'A', 2, 10),
('2024-11-02', 400.15, 'A', 3, 11),
('2024-11-03', 190.80, 'A', 4, 12),
('2024-11-04', 315.40, 'A', 5, 13),
('2024-11-05', 215.95, 'A', 6, 14),
('2024-11-06', 385.20, 'A', 7, 1),
('2024-11-07', 235.30, 'A', 8, 2),
('2024-11-08', 305.60, 'A', 9, 3),
('2024-11-09', 195.75, 'A', 10, 4),
('2024-11-10', 330.85, 'A', 1, 5),
('2024-11-11', 250.40, 'A', 2, 6),
('2024-11-12', 390.10, 'A', 3, 7),
('2024-11-13', 200.65, 'A', 4, 8),
('2024-11-14', 300.20, 'A', 5, 9),
('2024-11-15', 225.85, 'A', 6, 10),
('2024-11-16', 375.30, 'A', 7, 11),
('2024-11-17', 245.45, 'A', 8, 12),
('2024-11-18', 295.70, 'A', 9, 13),
('2024-11-19', 205.90, 'A', 10, 14);
GO

INSERT INTO PURCHASE_DETAIL (PURCHASE_DETAIL_QUANTITY, PURCHASE_DETAIL_PRICE, PURCHASE_DETAIL_SUBTOTAL, PURCHASE_ID, PRODUCT_ID)
VALUES
(10, 5.99, 59.90, 1, 1),
(20, 3.50, 70.00, 2, 2),
(15, 4.99, 74.85, 3, 3),
(30, 7.99, 239.70, 4, 4),
(25, 12.99, 324.75, 5, 5),
(12, 8.99, 107.88, 6, 6),
(18, 2.99, 53.82, 7, 7),
(9, 6.50, 58.50, 8, 8),
(6, 9.99, 59.94, 9, 9),
(8, 3.99, 31.92, 10, 10),
(5, 12.99, 64.95, 11, 8),
(10, 8.99, 89.90, 11, 12),
(15, 11.75, 176.25, 11, 10),
(8, 22.50, 180.00, 12, 17),
(12, 0.20, 2.40, 12, 16), 
(3, 450.00, 1350.00, 13, 30),
(5, 25.20, 126.00, 13, 19),
(10, 15.99, 159.90, 13, 15),
(2, 85.00, 170.00, 13, 42),
(20, 3.50, 70.00, 14, 2),
(15, 4.99, 74.85, 14, 3),
(10, 2.99, 29.90, 14, 7),
(5, 29.75, 148.75, 15, 22),
(8, 32.50, 260.00, 15, 21),
(10, 5.50, 55.00, 16, 6),
(5, 9.20, 46.00, 16, 27),
(8, 12.75, 102.00, 16, 26),
(3, 18.75, 56.25, 16, 41),
(6, 28.99, 173.94, 17, 20),
(4, 32.99, 131.96, 17, 40),
(2, 55.20, 110.40, 17, 36),
(12, 7.50, 90.00, 18, 13),
(8, 9.25, 74.00, 18, 14),
(5, 17.99, 89.95, 19, 25),
(10, 15.50, 155.00, 19, 24),
(3, 22.99, 68.97, 19, 31),
(2, 38.50, 77.00, 19, 33),
(15, 5.99, 89.85, 20, 1),
(10, 3.50, 35.00, 20, 2),
(5, 4.99, 24.95, 20, 3),
(8, 12.99, 103.92, 21, 8),
(6, 14.20, 85.20, 21, 11),
(4, 25.99, 103.96, 22, 46),
(5, 8.50, 42.50, 22, 47),
(3, 32.75, 98.25, 22, 48),
(2, 18.20, 36.40, 22, 49),
(7, 20.75, 145.25, 23, 18),
(5, 18.99, 94.95, 23, 28),
(3, 24.99, 74.97, 23, 44),
(10, 9.99, 99.90, 24, 10),
(8, 11.75, 94.00, 24, 10),
(6, 16.50, 99.00, 25, 38),
(4, 12.99, 51.96, 25, 8),
(3, 22.50, 67.50, 25, 17),
(2, 28.75, 57.50, 25, 43),
(5, 29.50, 147.50, 26, 45),
(4, 26.75, 107.00, 26, 46),
(3, 45.20, 135.60, 26, 47),
(8, 15.20, 121.60, 27, 42),
(6, 25.20, 151.20, 27, 19),
(10, 5.50, 55.00, 28, 6),
(5, 9.99, 49.95, 28, 5),
(3, 12.99, 38.97, 28, 8),
(2, 18.99, 37.98, 28, 16),
(7, 7.50, 52.50, 29, 13),
(5, 9.25, 46.25, 29, 14),
(4, 11.75, 47.00, 29, 10),
(12, 3.50, 42.00, 30, 2),
(10, 4.99, 49.90, 30, 3),
(6, 28.99, 173.94, 31, 20),
(4, 32.50, 130.00, 31, 21),
(3, 29.75, 89.25, 31, 22),
(2, 32.99, 65.98, 31, 40),
(8, 15.99, 127.92, 32, 15),
(6, 12.75, 76.50, 32, 26),
(4, 18.75, 75.00, 32, 41),
(10, 22.99, 229.90, 33, 31),
(8, 38.50, 308.00, 33, 33),
(5, 17.99, 89.95, 34, 25),
(4, 15.50, 62.00, 34, 24),
(3, 22.50, 67.50, 34, 17),
(2, 28.99, 57.98, 34, 20),
(7, 8.99, 62.93, 35, 12),
(5, 11.75, 58.75, 35, 10),
(4, 14.20, 56.80, 35, 11),
(9, 5.99, 53.91, 36, 1),
(8, 3.50, 28.00, 36, 2),
(6, 25.99, 155.94, 37, 46),
(5, 8.50, 42.50, 37, 47),
(4, 32.75, 131.00, 37, 48),
(3, 18.20, 54.60, 37, 49),
(8, 20.75, 166.00, 38, 18),
(6, 18.99, 113.94, 38, 28),
(4, 24.99, 99.96, 38, 44),
(10, 9.99, 99.90, 39, 5),
(8, 11.75, 94.00, 39, 10),
(7, 16.50, 115.50, 40, 38),
(5, 12.99, 64.95, 40, 8),
(4, 22.50, 90.00, 40, 17),
(3, 28.75, 86.25, 40, 43),
(5, 12.99, 64.95, 41, 8),
(4, 11.75, 47.00, 41, 10),
(6, 14.20, 85.20, 42, 11),
(3, 22.50, 67.50, 42, 17),
(5, 9.25, 46.25, 43, 14),
(4, 15.99, 63.96, 43, 15),
(3, 12.75, 38.25, 44, 26),
(2, 18.75, 37.50, 44, 41),
(6, 5.50, 33.00, 45, 6),
(3, 9.99, 29.97, 45, 5),
(4, 8.99, 35.96, 46, 12),
(2, 11.75, 23.50, 46, 10),
(5, 3.50, 17.50, 47, 2),
(3, 4.99, 14.97, 47, 3),
(7, 22.99, 160.93, 48, 31),
(5, 38.50, 192.50, 48, 33),
(6, 8.50, 51.00, 49, 47),
(4, 32.75, 131.00, 49, 48),
(10, 5.99, 59.90, 50, 1);
GO

SELECT * FROM PATIENT
SELECT * FROM EMPLOYEE
SELECT * FROM PRODUCT
SELECT * FROM SUPPLIER
SELECT * FROM SALE
SELECT * FROM SALE_DETAIL
SELECT * FROM PURCHASE
SELECT * FROM PURCHASE_DETAIL
GO
