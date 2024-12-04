import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Formatter;
import java.util.Scanner;

public class ProjectManagementApp {
    private Connection connection;
    private Statement statement;
    private ResultSet resultSet;

    public String printMenu(String option) {
        Scanner input = new Scanner(System.in);
        do {
            System.out.println("""
                    Welcome to Project Management DataBase! 
                    Choose a command to be executed!
                    MENU:
                    1. SELECT
                    2. INSERT
                    3. DELETE
                    4. EXIT
                    """);
            option = input.next();
        } while (!option.equals("SELECT") && !option.equals("INSERT")
                && !option.equals("UPDATE") && !option.equals("DELETE")
                && !option.equals("EXIT"));

        return option;
    }

    public void execute(String option) {
        String statement = ""; this.openConnection();
        switch (option) {
            case "SELECT": {
                statement = option + " * FROM FN3MI0700022.USERS";
                this.select(statement, 4);
                break;
            } case "INSERT": {
                Scanner input = new Scanner(System.in);
                String mail = input.next();
                String username = input.next();
                String pass = input.next();

                statement = option + " INTO FN3MI0700022.USERS (EMAIL, USERNAME, PASSWORD)"
                        + " VALUES ('" + mail + "','" +
                        username + "','" + pass + "')";
                this.insert(statement);
            } case "DELETE": {
                Scanner input = new Scanner(System.in);
                String username = input.next();
                statement = option + " FROM FN3MI0700022.USERS WHERE FN3MI0700022.USERS.USERNAME = '"
                        + username + "'";
                this.delete(statement);
            } case "EXIT": default: System.exit(0);
        } this.closeConnection();
    }

    public void openConnection(){
        try {
            DriverManager.registerDriver(new com.ibm.db2.jcc.DB2Driver());
        } catch(Exception cnfex) {
            System.out.println("Problem in loading or registering IBM DB2 JDBC driver.");
            cnfex.printStackTrace();
        }

        try {
            connection = DriverManager.getConnection("jdbc:db2://62.44.108.24:50000/SAMPLE",
                    "db2admin", "db2admin");
            statement = connection.createStatement();
        } catch(SQLException s){
            s.printStackTrace();
        }
    }

    public void closeConnection(){
        try {
            if(connection != null) {
                resultSet.close();
                statement.close();
                connection.close();
            }
        } catch (SQLException s) {
            s.printStackTrace();
        }
    }

    public void select(String stmnt, int column) {
        try{
            resultSet = statement.executeQuery(stmnt);
            String result = "";
            Formatter fmt = new Formatter();
            while(resultSet.next()) {
                for (int i = 1; i <= column; i++) {
                    result += resultSet.getString(i);
                    if (i == column) {
                        result += "\n";
                    } else {
                        result += "\t\t\t";
                    }
                }
            }
            fmt.format("%s", result);
            System.out.print(fmt);
        } catch (SQLException s) {
            s.printStackTrace();
        }
    }

    public void insert(String stmnt) {
        try{
            statement.execute(stmnt);
        } catch (SQLException s) {
            s.printStackTrace();
        }

        System.out.println("Successfully inserted!");
    }

    public void delete(String stmnt) {
        try{
            statement.execute(stmnt);
        } catch (SQLException s) {
            s.printStackTrace();
        }

        System.out.println("Successfully deleted!");
    }

    public static void main(String[] args) {
        ProjectManagementApp db2Obj = new ProjectManagementApp();
        String option = "";
        db2Obj.execute(db2Obj.printMenu(option));
    }
}