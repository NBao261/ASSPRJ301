package dao;

import dto.UserDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.DBUtils;

public class UserDAO implements IDAO<UserDTO, String> {

    @Override
    public UserDTO readById(String id) {
        String sql = "SELECT [userID], [fullName], [roleID], [password], [gmail], [sdt], [avatar_url] "
                + "FROM [tblUsers] WHERE userID = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(
                            rs.getString("userID"),
                            rs.getString("fullName"),
                            rs.getString("roleID"),
                            rs.getString("password"),
                            rs.getString("gmail"),
                            rs.getString("sdt"),
                            rs.getString("avatar_url")
                    );
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public boolean create(UserDTO user) {
        boolean success = false;
        String sql = "INSERT INTO tblUsers (userID, fullName, roleID, password, gmail, sdt, avatar_url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUserID());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getRoleID());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getGmail());
            ps.setString(6, user.getSdt());
            ps.setString(7, user.getAvatarUrl());

            success = ps.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return success;
    }

    @Override
    public boolean update(UserDTO user) {
        boolean success = false;
        String sql = "UPDATE tblUsers SET fullName = ?, roleID = ?, gmail = ?, sdt = ?, avatar_url = ? WHERE userID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getRoleID()); 
            ps.setString(3, user.getGmail());
            ps.setString(4, user.getSdt());
            ps.setString(5, user.getAvatarUrl());
            ps.setString(6, user.getUserID());

            success = ps.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return success;
    }

    @Override
    public boolean delete(String id) {
        boolean success = false;
        String sql = "DELETE FROM tblUsers WHERE userID = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            success = ps.executeUpdate() > 0;
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return success;
    }

    @Override
    public List<UserDTO> search(String searchTerm) {
        return null; // Chưa triển khai
    }

    @Override
    public List<UserDTO> readAll() {
        List<UserDTO> userList = new ArrayList<>();
        String sql = "SELECT [userID], [fullName], [roleID], [password], [gmail], [sdt], [avatar_url] "
                + "FROM [tblUsers]";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserDTO user = new UserDTO(
                        rs.getString("userID"),
                        rs.getString("fullName"),
                        rs.getString("roleID"),
                        rs.getString("password"),
                        rs.getString("gmail"),
                        rs.getString("sdt"),
                        rs.getString("avatar_url")
                );
                userList.add(user);
            }
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return userList;
    }
}