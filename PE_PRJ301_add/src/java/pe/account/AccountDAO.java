package pe.account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import pe.utils.DBUtils;

public class AccountDAO {

    //your code here
    public AccountDTO login(String account, String pass) {
        String sql = "SELECT * FROM Account WHERE account = ? AND pass = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, account);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new AccountDTO(rs.getString("account"),
                        rs.getString("pass"),
                        rs.getString("roleDB"),
                        rs.getString("fullName"),
                        rs.getString("gender"),
                        rs.getDate("birthDay"),
                        rs.getString("phone"),
                        rs.getString("addr"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
