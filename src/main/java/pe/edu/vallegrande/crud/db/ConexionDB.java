package pe.edu.vallegrande.crud.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    public ConexionDB() {
    }

    public static Connection getConnection() throws SQLException {
        Connection cn = null;
        String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String bd = "jdbc:sqlserver://localhost:14033;databaseName=HAPPY_DENT;encrypt=true;trustServerCertificate=True;";
        String user = "SA";
        String pass = "MyPassword2023";

        try {
            Class.forName(driver).getDeclaredConstructor().newInstance();
            cn = DriverManager.getConnection(bd, user, pass);
        } catch (SQLException e) {
            throw e;
        } catch (ClassNotFoundException e) {
            throw new SQLException("No se encuentra el driver de la base de datos");
        } catch (Exception e) {
            throw new SQLException("No se puede establecer la conexion con la BD");
        }
        return cn;
    }
}
