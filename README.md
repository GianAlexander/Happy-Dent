# 📦 Sistema de Gestión de Inventarios para Botica "Happy-Dent"

Este sistema ha sido desarrollado para gestionar eficientemente el inventario de una botica, abarcando funcionalidades esenciales como el registro de productos, control de stock, y operaciones de compra y venta. El objetivo es optimizar los procesos internos y facilitar la administración diaria del negocio.

---

# 🔧 Tecnologías Utilizadas

- **Java EE** con Servlets
- **JSP (JavaServer Pages)** para la capa de presentación
- **Maven** como herramienta de construcción y gestión de dependencias
- **MVC** como patrón de diseño arquitectónico
- **SQL Server** como sistema de gestión de base de datos

---

## 📁 Estructura del Proyecto

```plaintext
Happy-Dent [CRUD]
│
├── .idea/                  # Archivos de configuración del IDE
├── .mvn/                   # Configuración de Maven Wrapper
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── pe.edu.vallegrande.crud/
│   │   │       ├── controller/   # Controladores del sistema (Servlets)
│   │   │       ├── db/           # Conexión a la base de datos y consultas SQL
│   │   │       ├── dto/          # Objetos de Transferencia de Datos (DTOs)
│   │   │       ├── servlet/      # Implementación de Servlets
│   │   │       └── test/         # Pruebas unitarias o de integración
│   │   ├── resources/            # Archivos de configuración y recursos
│   │   └── webapp/               # Archivos JSP (Vistas)
│   └── test/                     
├── target/                      # Archivos generados por la compilación
├── .gitignore                  
├── pom.xml                      # Archivo de configuración de Maven
├── README.md                    # Documentación del proyecto
```

---

# 🧱 Arquitectura del Proyecto (MVC)

```plaintext
📦 Modelo (Model)
├── dto/ → Clases que representan entidades (Producto, Categoría, etc.)
├── db/ → Lógica de acceso y gestión de datos

🎮 Controlador (Controller)
├── controller/ → Lógica de negocio y enrutamiento de solicitudes
├── servlet/ → Implementación de Servlets HTTP

🖥 Vista (View)
├── webapp/ → Páginas JSP que presentan la interfaz al usuario
```

---

# 📌 Funcionalidades Principales

- ✅ Registrar nuevos productos
- 🔍 Consultar productos existentes
- 🖥 Consultar proveedores
- ✏️ Actualizar información de productos
- ❌ Eliminar productos
- 📦 Gestión del stock y control de inventario
- 💰 Gestión de operaciones de compra y venta
- 🩺 Visualización de la ficha médica de los pacientes

---

# 🗃️ Ejemplo de Flujo CRUD

1. Usuario accede a la página JSP de productos
2. Formulario HTML envía solicitud POST al Servlet correspondiente
3. El Servlet invoca al controlador que procesa los datos
4. El controlador utiliza las clases en `db/` para interactuar con la base de datos
5. La vista JSP muestra los resultados actualizados

---

# 🔒 Seguridad y Validaciones

- Validación de entradas desde formularios JSP
- Manejo de errores y excepciones en Servlets
- Conexión segura con la base de datos

---

# 🚀 Instrucciones para Ejecutar

1. Clonar el repositorio
2. Importar el proyecto como proyecto Maven en IntelliJ o Eclipse
3. Configurar y ejecutar el servidor Apache Tomcat
4. Acceder a `http://localhost:8080/Happy-Dent` desde el navegador

---
