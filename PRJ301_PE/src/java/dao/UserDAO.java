/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dto.UserDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import sample.utils.DBUtils;

/**
 *
 * @author cbao
 */
public class UserDAO {

    public UserDTO login(String userID, String password) {
        String sql = "SELECT * FROM tblUsers WHERE userID = ? AND password = ?";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, userID);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                return new UserDTO(rs.getString("userID"),
                        rs.getString("fullName"),
                        rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
